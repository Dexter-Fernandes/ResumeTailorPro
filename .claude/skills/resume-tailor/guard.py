#!/usr/bin/env python3
"""Claude Code hooks for the resume-tailor skill.

pre:   template edits are denied. Master CV edits need the user's approval, and are
       denied once the workflow has reached Step 5 (strategy approved). The
       cv-html-builder agent may only be dispatched once a saved reply shows Step 4.
post:  after a write to */Resumes/HTML/*.html or */Cover Letters/HTML/*.html, run the
       Step 11 (CV) or Step 12 (cover letter) mechanical checks.
audit: the same checks on a named file, for use outside a hook.
"""
import html, json, re, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MASTER = ROOT / "Dexter_Fernandes_Master_CV.md"
TEMPLATE = ROOT / "Dexter_Fernandes_Resume_template.html"
LETTER_TEMPLATE = ROOT / "Dexter_Fernandes_Cover_Letter_template.html"
BUILDER = "cv-html-builder"
PLACEHOLDERS = ["Full Name", "Company Name", "Job Title", "MM/YYYY", "Category",
                "Comma-separated", "example.com", 'href="#"']
LETTER_PLACEHOLDERS = ["Company Name", "Job Title", "Parent Company", "City, Region",
                       "DD Month YYYY", "Salutation", "Paragraph text"]
TARGETS = {"cv": "900 to 1,050", "letter": "250 to 450"}


def last_step(transcript):
    """Latest `Step N/12` label in Claude's own replies; 0 if none."""
    step = 0
    try:
        lines = open(transcript, encoding="utf-8")
    except OSError:
        return step
    for line in lines:
        try:
            obj = json.loads(line)
        except ValueError:
            continue
        if obj.get("type") != "assistant":
            continue
        content = obj.get("message", {}).get("content", [])
        for block in content if isinstance(content, list) else []:
            if block.get("type") == "text":
                for n in re.findall(r"^Step (\d+)/12", block.get("text", ""), re.M):
                    step = int(n)
    return step


def pre(event):
    tool_input = event.get("tool_input", {})
    path = Path(tool_input.get("file_path", "")).resolve()
    if tool_input.get("subagent_type") == BUILDER:
        # Step 4, not 5: the transcript holds only finished messages, and fast and
        # ultrafast mode print Step 5 in the same message that dispatches the builder.
        if last_step(event.get("transcript_path", "")) >= 4:
            return None
        decision, reason = "deny", (f"{BUILDER} is dispatched only by the resume-tailor "
                                    "skill, after Step 4. The hook reads saved messages "
                                    "only: if Step 4 is in this reply, run the Step 10 "
                                    "filename check first, then dispatch again.")
    elif path in (TEMPLATE, LETTER_TEMPLATE):
        decision, reason = "deny", "Templates are fixed. Populate a copy in the track's HTML/ directory."
    elif path == MASTER:
        if last_step(event.get("transcript_path", "")) >= 5:
            decision, reason = "deny", ("Strategy approved: the master CV is frozen. Keep the "
                                        "fact as an in-session factual addition.")
        else:
            decision, reason = "ask", "Add a user-supplied fact to the master CV?"
    else:
        return None
    return {"hookSpecificOutput": {"hookEventName": "PreToolUse",
                                   "permissionDecision": decision,
                                   "permissionDecisionReason": reason}}


def kind_of(path):
    """'cv', 'letter' or None, from <Track>/<Resumes|Cover Letters>/HTML/*.html."""
    path = Path(path)
    if path.suffix != ".html" or path.parent.name != "HTML":
        return None
    return {"Resumes": "cv", "Cover Letters": "letter"}.get(path.parent.parent.name)


def audit(text, kind="cv"):
    """Step 11 / Step 12 mechanical checks. Returns (problems, word count)."""
    problems = []
    if "—" in text:
        problems.append(f"{text.count(chr(0x2014))} em dash(es)")
    placeholders = PLACEHOLDERS if kind == "cv" else LETTER_PLACEHOLDERS
    problems += [f"placeholder {p!r}" for p in placeholders if p in text]
    if kind == "letter":
        if re.search(r"<(ol|ul|li)\b", text):
            problems.append("list markup; the letter must be plain paragraphs")
        if re.search(r"<p[^>]*>\s*(\d+[.)]|\(\d+\))", text):
            problems.append("numbered paragraph")
    # ponytail: counts opens vs closes per tag, not nesting order; a real parser if misnesting slips through
    markup = re.sub(r"<!--.*?-->", "", text, flags=re.S)
    for tag in ("div", "p", "ul", "li", "span", "a", "strong"):
        if len(re.findall(rf"<{tag}\b", markup)) != markup.count(f"</{tag}>"):
            problems.append(f"unbalanced <{tag}> tags")
    body = re.sub(r"<(script|style).*?</\1>", "", text, flags=re.S)
    words = len(html.unescape(re.sub(r"<[^>]+>", " ", body)).split())
    return problems, words


def post(event):
    path = Path(event.get("tool_input", {}).get("file_path", ""))
    kind = kind_of(path)
    if not kind:
        return None
    try:
        problems, words = audit(path.read_text(encoding="utf-8"), kind)
    except OSError:
        return None
    label = "CV" if kind == "cv" else "Cover letter"
    note = f"{label} word count: {words} (target {TARGETS[kind]})."
    out = {"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": note}}
    if problems:
        out["decision"] = "block"
        out["reason"] = f"{path.name}: " + "; ".join(problems) + ". Fix before reporting DONE."
    return out


def selftest():
    with tempfile.NamedTemporaryFile("w", suffix=".jsonl", delete=False) as t:
        for step in (4, 5):
            t.write(json.dumps({"type": "assistant", "message": {"content": [
                {"type": "text", "text": f"Step {step}/12 -- x"}]}}) + "\n")
        t.write(json.dumps({"type": "user", "message": {"content": "Step 1/12 -- Setup"}}) + "\n")
    ev = lambda p: {"tool_input": {"file_path": str(p)}, "transcript_path": t.name}
    assert last_step(t.name) == 5
    assert pre(ev(MASTER))["hookSpecificOutput"]["permissionDecision"] == "deny"
    assert pre({**ev(MASTER), "transcript_path": "/nonexistent"})["hookSpecificOutput"]["permissionDecision"] == "ask"
    assert pre(ev(TEMPLATE))["hookSpecificOutput"]["permissionDecision"] == "deny"
    assert pre(ev(ROOT / "JDs" / "x.md")) is None
    agent = {"tool_input": {"subagent_type": BUILDER}, "transcript_path": t.name}
    assert pre(agent) is None
    assert pre({**agent, "transcript_path": "/nonexistent"})["hookSpecificOutput"]["permissionDecision"] == "deny"
    assert pre({"tool_input": {"subagent_type": "Explore"}, "transcript_path": "/nonexistent"}) is None
    with tempfile.NamedTemporaryFile("w", suffix=".jsonl", delete=False) as t4:
        t4.write(json.dumps({"type": "assistant", "message": {"content": [
            {"type": "text", "text": "Step 4/12 -- x"}]}}) + "\n")
    assert pre({**agent, "transcript_path": t4.name}) is None
    assert pre({**ev(MASTER), "transcript_path": t4.name})["hookSpecificOutput"]["permissionDecision"] == "ask"
    assert audit("<p>a <strong>b</strong> c</p>") == ([], 3)
    problems, _ = audit("<p>Full Name — <strong>x</p>")
    assert len(problems) == 3, problems
    assert audit('<div class="page"><div class="page"><p>x</p></div>') == (["unbalanced <div> tags"], 1)
    assert audit("<!-- One <p> per paragraph --><p>x</p>")[0] == []
    assert kind_of("/r/CV/Cover Letters/HTML/x.html") == "letter"
    assert kind_of("/r/CV/Resumes/HTML/x.html") == "cv"
    assert kind_of("/r/JDs/x.md") is None
    assert audit("<p>Dear Ms Smith,</p><p>Text here.</p>", "letter") == ([], 5)
    problems, _ = audit("<p>1. First</p><ol><li>x</li></ol><p>Paragraph text</p>", "letter")
    assert len(problems) == 3, problems
    assert pre(ev(LETTER_TEMPLATE))["hookSpecificOutput"]["permissionDecision"] == "deny"
    print("guard.py selftest ok")


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else ""
    if mode == "selftest":
        selftest()
    elif mode == "audit" and len(sys.argv) == 3:
        kind = kind_of(Path(sys.argv[2]).resolve()) or "cv"
        problems, words = audit(Path(sys.argv[2]).read_text(encoding="utf-8"), kind)
        print("\n".join(problems + [f"words: {words} (target {TARGETS[kind]})"]))
        sys.exit(1 if problems else 0)
    elif mode in ("pre", "post"):
        result = (pre if mode == "pre" else post)(json.load(sys.stdin))
        if result:
            print(json.dumps(result))
    else:
        sys.exit("usage: guard.py pre|post|selftest|audit FILE")
