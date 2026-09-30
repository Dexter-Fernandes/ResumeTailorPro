#!/usr/bin/env python3
"""Claude Code hooks for the resume-tailor skill.

pre:   template edits are denied. Master CV edits need the user's approval, and are
       denied once the workflow has reached Step 5 (strategy approved). The
       cv-html-builder agent may only be dispatched after that point.
post:  after a write to */Resumes/HTML/*.html, run the Step 11 mechanical checks.
audit: the same checks on a named file, for use outside a hook.
"""
import html, json, re, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MASTER = ROOT / "Dexter_Fernandes_Master_CV.md"
TEMPLATE = ROOT / "Dexter_Fernandes_Resume_template.html"
BUILDER = "cv-html-builder"
PLACEHOLDERS = ["Full Name", "Company Name", "Job Title", "MM/YYYY", "Category",
                "Comma-separated", "example.com", 'href="#"']


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
        if last_step(event.get("transcript_path", "")) >= 5:
            return None
        decision, reason = "deny", (f"{BUILDER} is dispatched only by the resume-tailor "
                                    "skill, after the strategy is approved.")
    elif path == TEMPLATE:
        decision, reason = "deny", "The CV template is fixed. Populate a copy in Resumes/HTML/."
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


def audit(text):
    """Step 11 mechanical checks. Returns (problems, word count)."""
    problems = []
    if "—" in text:
        problems.append(f"{text.count(chr(0x2014))} em dash(es)")
    problems += [f"placeholder {p!r}" for p in PLACEHOLDERS if p in text]
    if text.count("<strong>") != text.count("</strong>"):
        problems.append("unbalanced <strong> tags")
    body = re.sub(r"<(script|style).*?</\1>", "", text, flags=re.S)
    words = len(html.unescape(re.sub(r"<[^>]+>", " ", body)).split())
    return problems, words


def post(event):
    path = Path(event.get("tool_input", {}).get("file_path", ""))
    if path.suffix != ".html" or path.parent.name != "HTML" or path.parent.parent.name != "Resumes":
        return None
    try:
        problems, words = audit(path.read_text(encoding="utf-8"))
    except OSError:
        return None
    note = f"CV word count: {words} (target 1,100 to 1,400)."
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
    assert audit("<p>a <strong>b</strong> c</p>") == ([], 3)
    problems, _ = audit("<p>Full Name — <strong>x</p>")
    assert len(problems) == 3, problems
    print("guard.py selftest ok")


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else ""
    if mode == "selftest":
        selftest()
    elif mode == "audit" and len(sys.argv) == 3:
        problems, words = audit(Path(sys.argv[2]).read_text(encoding="utf-8"))
        print("\n".join(problems + [f"words: {words} (target 1,100 to 1,400)"]))
        sys.exit(1 if problems else 0)
    elif mode in ("pre", "post"):
        result = (pre if mode == "pre" else post)(json.load(sys.stdin))
        if result:
            print(json.dumps(result))
    else:
        sys.exit("usage: guard.py pre|post|selftest|audit FILE")
