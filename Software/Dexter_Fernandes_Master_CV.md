# Master CV: Software Engineering

Reference document. Not for sending. Cut a 2 page version from this per application.

**Cutting rules**
1. Pick one summary variant from Section 1, edit the last line to name the company's domain.
2. Per role, take 4 to 6 bullets max. Lead with the theme the job description leads with.
3. Recent roles get more bullets than old ones, except where the old role holds the strongest evidence. For backend jobs, LivNSense outranks Esbaar.
4. Projects: 2 or 3 only. Drop the rest.
5. Skills: 5 or 6 lines, only what the job description touches. Never paste all of Section 6.
6. Every bullet needs a verb, a technology, and an outcome. If one is missing, it gets cut first.

---

## 0. Header

Dexter Fernandes
Bristol, UK
+44 7436 007369
dexterfernandes11@gmail.com
linkedin.com/in/dexterferns
github.com/Dexter-Fernandes

Title line, pick one to match the job:
- Software Engineer
- Backend Software Engineer
- Machine Learning Engineer
- Computer Vision Engineer
- Robotics Software Engineer

---

## 1. Summary variants

**A. Generalist software engineer**
Software engineer with 3+ years building and operating production systems, from C++17 edge inference to containerised Python services on Azure. Comfortable owning a service end to end: design, tests, deployment, monitoring, and the 2am failure. MSc Robotics, University of Bristol. Based in Bristol.

**B. Backend and platform**
Backend engineer with 3+ years shipping Python and C++ services in production. Built containerised inference microservices on Azure with queue-based async processing, owned the PostgreSQL schema behind operational reporting, and cut live pipeline crashes by 67% through health checks, retries and structured observability. MSc Robotics, University of Bristol.

**C. Machine learning engineer**
ML engineer with 3+ years owning the full lifecycle on deployed systems: data curation, training, quantisation, deployment and field validation. Improved F1 by 15% on 24/7 industrial perception, halved model size through INT8 and pruning, and processed 3.6 million records through Airflow, MLflow and DVC pipelines. MSc Robotics, University of Bristol.

**D. Computer vision and edge**
Computer vision engineer with 3+ years building real-time perception for 24/7 field operation. NVIDIA DeepStream and GStreamer video pipelines, custom TensorRT plugins in CUDA C++, and asynchronous OpenVINO inference on Intel VPUs. Took one pipeline from 5 to 15 FPS while halving model size. MSc Robotics, University of Bristol.

**E. Robotics**
Robotics software engineer with 3+ years in production perception and an MSc in Robotics from Bristol. Built a real-time LiDAR SLAM system in C++17 and ROS2 on a Clearpath Husky, benchmarked RTAB-Map, LIO-SAM and Cartographer under a single evaluation protocol, and shipped real-time CV to industrial sites in Oman, Texas and South Africa.

---

## 2. Work experience

### GrowthStage, Remote. May 2026 to Present
**Technical Screening Engineer (Contract)**

Retitle note: the current CV says "Recruiter". On a software CV that reads like a career change away from engineering. "Technical Screening Engineer" or "Technical Interviewer (Contract)" is accurate and does not fight the rest of the document.

- Assess candidate technical depth across perception, SLAM and deployment, running hands-on robotics and computer vision screens.
- Write and calibrate evaluation rubrics for robotics engineering candidates.

### Taco Bell, Bristol. Sep 2024 to Present
**Service Champion / Team Trainer**

- Progressed to Team Trainer, onboarding new staff and handling customer escalations in a fast-paced customer-facing environment.

Note: keep this to a single line, or drop it entirely once the career break section carries real content. It explains the timeline but adds nothing to a software application.

### Career break / independent engineering, Sep 2024 to Apr 2026

This section is currently a placeholder in the CV and it is the biggest single problem with the document. An 18 month gap with "[Enter relevant info here]" under it invites the worst assumption. Fill it with the project work you actually did, which is substantial. Suggested framing:

- Self-directed engineering programme covering modern detection architectures, edge deployment, retrieval systems and agent evaluation, delivered as eight open-source projects with published benchmarks.
- Rebuilt and benchmarked current detector families (YOLOv8 through YOLO26, RT-DETR, EfficientViT) against production criteria: mAP, latency, model size and export path.
- Shipped a DeepStream 9.0 multi-stream RTSP pipeline and a RAG evaluation harness, both public on GitHub.

### Esbaar, Muscat, Oman. Jan 2023 to Aug 2023
**AI Engineer**

*Reliability and service ownership*
- Hardened deployed services with Dockerised microservices, Kafka messaging, health checks and safe restarts, cutting live video pipeline crashes by 67% and enabling recovery without site visits.
- Implemented reliability patterns across the service layer using timeouts, retries and message validation, with structured logs and metrics for root cause analysis under load.
- Developed a watchdog application that detected and restarted failed services on edge devices autonomously, removing the need for engineer callouts.
- Owned production monitoring and post-deployment validation for deployed vision systems, using observability tooling and drift tracking to catch issues before they reached operators.
- Documented failure modes, recovery procedures and deployment guardrails for the engineers supporting fielded systems.
- Diagnosed and resolved production failures through on-site analysis and structured validation checklists.

*Machine learning lifecycle*
- Owned the end-to-end ML lifecycle for real-time perception on BP drilling rigs, covering data curation, training, deployment and on-site validation, improving F1 by 15% under 24/7 operation.
- Built ingestion and validation pipelines across image, video and sensor data with Airflow, MLflow, DVC and CVAT, processing 3.6 million records and cutting rollout from 3 days to under 24 hours.
- Designed adversarial-condition training and validation experiments covering occlusion, lighting variation and motion artefacts, benchmarking robustness via F1 and failure rate and improving F1 by 15% within 3 months.
- Adapted YOLOv5 detectors in PyTorch, replacing backbone and neck layers and retraining for rig-specific classes, with Optuna sweeps and Weights & Biases tracking across runs.
- Built benchmarking harnesses comparing YOLOv5 and EfficientDet on accuracy, latency and stability before and after optimisation, catching regressions before release.
- Applied Bayesian optimisation, ablation studies, hypothesis testing and confidence intervals in Jupyter to support model selection, threshold tuning and failure analysis.
- Built an activity classification workstream over 91 sensor channels using gradient boosting, random forests and MultiRocket for multivariate time-series classification and forecasting.

*Edge inference and video pipelines*
- Developed and maintained NVIDIA DeepStream 6.x video inference pipelines for 24/7 industrial perception, covering camera ingestion, model inference and field diagnostics in harsh desert environments.
- Built a repeatable optimisation workflow from baseline to FP16 to validation, with defined acceptance thresholds for latency, memory and stability across hardware targets.
- Built synthetic image generation and augmentation with OpenCV and scikit-image, and artefact detection for mud and sand contamination on camera feeds, reducing false positives by 13%.

*Testing, quality and tooling*
- Developed Python inference services test-first, writing tests before implementation and running them locally and through GitHub Actions to verify behaviour before release.
- Used pytest, unittest and linting in CI for edge inference modules to check changes before deployment.
- Led formal peer code reviews and quality assurance within each sprint, improving maintainability and reducing defects.

*Frontend and internal tooling*
- Built a Django and Bootstrap internal dashboard surfacing inference outputs, system health and performance metrics, cutting debugging time for engineers supporting fielded systems.
- Designed the dashboard layout and responsive components in Bootstrap, building the views, templates and forms that let operators inspect live camera feeds and inference results without engineer involvement.

*Field and stakeholder work*
- Led field validation on BP oil rig deployments, diagnosing model failures under lighting, motion and environmental stressors and turning findings into fixes for live operation.
- Presented performance findings, failure modes and deployment trade-offs to leadership, client stakeholders and rig operators, translating production signals into rollout decisions.
- Delivered in Agile and Scrum sprints with project managers and rig operators, planning deliverables across multidisciplinary teams.

### LivNSense Technologies, Bengaluru, India. May 2020 to Dec 2022
**Lead Software Engineer, AI**

*Leadership*
- Led four engineers delivering a two-stage detection and helmet-colour classification system for construction safety in Texas, coordinating task allocation, code reviews, releases and production support; the system cut false positives by 33% within latency and power budgets.
- Set experimentation standards, reviewed model performance and guided optimisation strategy for production deployments.
- Mentored junior engineers and worked with hardware, software and QA teams to integrate perception modules into deployed systems.

*Backend, cloud and data*
- Built the complete Keras inference code for an Azure microservice, using queue-based processing to classify helmets detected on edge devices by colour and support construction-site heatmaps.
- Designed PostgreSQL tables and relationships for image-level person, vehicle and helmet counts and PPE incidents, and wrote reporting queries for operational analysis.
- Improved PPE detection F1 by approximately 11% by choosing to separate a combined PPE and helmet-colour model into a six-class edge detector and an Azure-hosted helmet-colour classifier, prioritising PPE monitoring over secondary colour analysis.
- Designed data handling and retention practices aligned with GDPR principles, including data minimisation and controlled access.

Implementation note: the edge classes were person, vehicle, vest_on, vest_off, helmet_on and helmet_off. The F1 improvement is recalled as approximately 11%; confirm relative improvement versus percentage points before making that distinction explicit. Specific Azure services and database performance and integrity mechanisms are not recalled; avoid adding implementation details without verification.

*C++ and performance*
- Increased end-to-end C++17 video pipeline throughput from 5 to 15 FPS on the same hardware and model using threading, asynchronous OpenVINO inference and buffering across pre-processing, inference and post-processing on Intel Movidius VPUs.
- Profiled C++ inference and pre and post-processing hotspots with Intel VTune Profiler, driving targeted performance fixes in the CNN inference path.
- Integrated Boost C++ libraries into production pipelines, resolving dependency and build issues and keeping deployments reproducible.

*Testing and CI*
- Developed Python and C++ inference components test-first, writing tests before implementation and running them locally and through GitHub Actions to verify behaviour before release.
- Wrote gtest unit tests and documented interfaces for the C++ inference path to support regression checks before deployment.

*Model optimisation*
- Deployed quantised vision models using FP16 and INT8 optimisation, structured pruning and layer fusion, halving model size while preserving production accuracy targets.
- Ran systematic quantisation experiments benchmarking accuracy, latency and memory trade-offs against real-time constraints, using quantisation-aware training with Keras and Intel OpenVINO.

*Data and labelling*
- Automated labelling by repurposing existing detection models and added dataset versioning with DVC, cutting manual labelling effort by 80%.
- Developed synthetic-data tooling to improve edge-case coverage, cutting manual labelling time by a further 60%.
- Used confusion-matrix failure clustering to diagnose recurring model failures, prioritise dataset fixes and improve robustness across camera feeds.

*Computer vision delivery*
- Built and maintained edge perception pipelines across three cameras on a roller and loader operating at multiple construction sites around Austin, Texas, supporting 24/7 monitoring requirements.
- Used DeepSORT tracking to require persistent PPE violations across successive frames before recording incidents, filtering transient detection errors.
- Implemented optical flow based ego-motion estimation feeding motion representations into CNNs to classify vehicle state, supporting collision avoidance on moving vehicles.
- Built YOLOv5 visual quality inspection for John Deere engine paint jobs on a conveyor line, detecting paint defects, contamination and colour inconsistency.
- Developed adversarial-condition training simulating occlusion, lighting variation and motion artefacts, cutting performance variance by 25%.
- Tuned camera and ISP settings to keep models reliable on RGB and IR streams across 24/7 operation, cutting IR false positives and reducing manual recalibration.
- Explored DeepLabv3+, Mask R-CNN, U-Net and SegFormer for annotation review, foreground and background separation, and failure analysis on industrial camera feeds.
- Built a low-latency computer vision proof of concept for a zinc ore refining plant in South Africa and a user-facing hazard detection application for an Oman-based client.

---

## 3. Projects

Two or three per application. Match the project to the job, not to what you built most recently.

### FinanceBench RAG Evaluation Harness. Jun 2026
- Built an evaluation framework for FinanceBench measuring how well RAG and document-grounded QA systems answer using the right source evidence.
- Designed structured experiments across closed-book, oracle-context and dense RAG workflows to isolate whether failures came from retrieval, source selection or generation.
- Added LLM-as-judge scoring, evidence matching, citation checks, numeric matching and hallucination labels.
- Produced reproducible runs with automated tests, config-driven experiments, structured prediction outputs and Markdown reports, enabling regression checks between runs.

### DeepStream RTSP Pipeline. Jun 2026
github.com/Dexter-Fernandes/deepstream-rtsp-pipeline
- Built an end-to-end DeepStream 9.0 and GStreamer RTSP pipeline running YOLO detection and NvDCF tracking across 3 concurrent feeds, with metadata extraction, anonymisation and re-streamed output.
- Converted YOLO26n to a dynamic-batch TensorRT FP16 engine on 6GB VRAM Turing hardware, validating FP16 against FP32 accuracy and profiling p99 latency to sustain 29.7 FPS per stream live.
- Implemented a C++ and CUDA TensorRT decode plugin with IPluginV2DynamicExt, moving post-processing into the inference engine.
- Benchmarked IoU, NvDCF and NvSORT trackers on MOTA, IDF1, ID switches, fragmentation, FPS and VRAM to guide tracker selection.

### Modern Edge CV Benchmarking. Mar 2026
github.com/Dexter-Fernandes/Modern-Edge-CV-Benchmarking

Note: this appeared twice in the source CV with overlapping bullets. Merged here into one entry.
- Benchmarked YOLOv8, YOLOv10, YOLO26, RT-DETR, EfficientViT, Grounding DINO, MobileSAM and Depth Anything v2 on accuracy, latency, model size and deployment suitability.
- Assessed Vision Transformer and foundation-model approaches across detection, segmentation, depth estimation and open-vocabulary understanding.
- Exported models to ONNX and evaluated OpenVINO deployment paths against edge constraints.

### ROS2 SLAM and Nav2 Simulation. Feb 2026
- Built a simulation robotics stack in ROS2 Jazzy and Gazebo Harmonic to evaluate LiDAR-centric SLAM, LiDAR and RGB fusion SLAM, and autonomous navigation.
- Benchmarked RTAB-Map, LIO-SAM, Cartographer and GLIM across 2D and 3D LiDAR configurations.
- Developed ROS2 nodes, launch files and parameterised configurations in C++ and Python, using tf2, message synchronisation and timestamp alignment to debug transform timing issues.
- Implemented point cloud filtering, segmentation and registration with PCL and Open3D, plus an EKF localisation layer with robot_localization fusing wheel odometry and IMU.
- Containerised the stack with Docker and managed versioning in Git for reproducible builds.

---

## 4. Education

### MSc Robotics, Merit. University of Bristol, Sep 2023 to Sep 2024
Dissertation: Radiological SLAM with LiDAR Odometry

Note: this was listed twice in the source CV. Merged.
- Built a real-time SLAM system in C++17 and ROS2 (rclcpp) on a Clearpath Husky, fusing Velodyne VLP-16 LiDAR, Intel RealSense D435i depth and radiological sensing for inspection mapping.
- Benchmarked RTAB-Map, LIO-SAM and Cartographer across matched rosbag2 sequences under a single evaluation protocol.
- Configured Ceres, g2o and GTSAM as solver backends and tuned ICP parameters across environments.
- Calibrated LiDAR extrinsics to the robot base and resolved transform timing with tf2 across a PCL point cloud pipeline.

### BTech Electrical and Electronics Engineering. Visvesvaraya National Institute of Technology, Nagpur, Jul 2016 to May 2020

---

## 5. Certifications and awards

- Building RAG Agents with LLMs, NVIDIA, Jun 2026
- Deep Learning Specialisation, deeplearning.ai, Jul 2019
- Best Speaker award, ABC Toastmasters, Jan 2020

---

## 6. Skills

The source CV had 18 skill categories with PyTorch, Docker and Git each appearing three or four times. Consolidated to 8. Pick 5 or 6 lines per application.

**Languages**: Python, C++17, SQL, CUDA C++, Bash

**Backend and cloud**: FastAPI, Django (views, templates, forms), Bootstrap, REST API design, containerised microservices, Docker, Apache Kafka, Apache Airflow, PostgreSQL, Microsoft Azure, queue-based async processing, multiprocessing

**Testing, CI and operations**: test-driven development, pytest, unittest, gtest, linting, CI/CD, GitHub Actions, structured logging, health checks, observability, production monitoring, timeouts and retries, regression checks, failure-mode analysis, Linux, Git, CMake

**Machine learning and computer vision**: PyTorch, TensorFlow, Keras, scikit-learn, OpenCV, scikit-image, NumPy, Pandas, YOLO (v5 to v26), RT-DETR, EfficientDet, segmentation (Mask R-CNN, DeepLabv3+, SegFormer), object tracking (DeepSORT, ByteTrack, NvDCF, NvSORT), optical flow, anomaly detection, HuggingFace

**Edge inference and optimisation**: TensorRT with custom plugins, ONNX, OpenVINO, NVIDIA DeepStream 6.x and 9.0, GStreamer, FFmpeg, FP16 and INT8 quantisation, quantisation-aware training, structured pruning, layer fusion, dynamic batching, NVIDIA Jetson AGX Xavier, Intel Movidius VPU, Intel VTune, latency and VRAM profiling

**Robotics and SLAM**: ROS2 (rclcpp, rclpy), Nav2, Gazebo Harmonic, tf2, rosbag2, PCL, Open3D, LIO-SAM, RTAB-Map, Cartographer, GTSAM, Ceres, g2o, ICP and scan matching, pose graph optimisation, robot_localization, sensor fusion, LiDAR extrinsics calibration

**LLMs and retrieval**: RAG pipelines, dense and hybrid retrieval, FAISS, ChromaDB, BM25, cross-encoder reranking, reciprocal rank fusion, LangChain, LangGraph, LangSmith, LLM-as-judge, hallucination detection, structured outputs, Pydantic, MCP, fine-tuning, LoRA

**MLOps and experimentation**: MLflow, DVC, Weights & Biases, Optuna, CVAT, Bayesian optimisation, ablation studies, dataset versioning, synthetic data generation, Grad-CAM, TIDE, Agile and Scrum, Jira

---

## 7. Honest gaps for generalist software roles

These are the things that will come up. Worth knowing where you stand.

**AWS**: you have Azure, and a lot of UK backend job specs name AWS specifically. The concepts transfer and interviewers know that, but a CV with no AWS on it gets filtered by keyword screens. The cheapest fix is deploying one existing project to AWS (Lambda plus S3 plus ECS is enough) and putting it on the CV. The Solutions Architect Associate cert is a slower second option.

**Infrastructure as code**: nothing on the CV. No Terraform, no CDK, no CloudFormation, no Ansible. This appears in most platform job specs. One project with a Terraform module would close it.

**TDD**: confirmed at Esbaar and LivNSense: tests were written before implementation and run both locally and through GitHub Actions. Detailed test scenarios and their implementation still need verification before being added to application bullets or used as interview examples. Claims about requiring a failing test for every ticket, reproducing every production failure, and tests enabling the throughput refactor have been removed.

**Backend breadth**: FastAPI and Django are on there, but there is no evidence of auth, API versioning, schema migrations, rate limiting, or handling real request load. For a pure backend role this is the thinnest area. Counsel Copilot could carry more of this weight if you built it out.

**Event-driven systems**: you have Kafka at Esbaar and queue-based async on Azure, which is genuinely relevant and currently buried. Pull it up for anything mentioning distributed or event-driven architecture.

**Frontend**: partly covered, and worth being clear-eyed about how far. Django templates plus Bootstrap is server-rendered UI. It is real, it belongs on the CV, and it is enough to support "comfortable across the stack" or "built internal tooling" on a backend application. It is not enough for a role advertised as full-stack or frontend, where the expectation is React or Vue with TypeScript, a component model, client-side state and a build pipeline. Claiming Bootstrap as full-stack frontend is the kind of thing that surfaces badly in a technical screen. If you want that door open, one React and TypeScript project is the fix, and Counsel Copilot is the obvious candidate for a real interface.

**The framing problem**: right now the document reads as a computer vision specialist. For CV and ML roles that is a strength. For a generalist backend role it reads as someone applying outside their field, which is a harder sell than the actual evidence warrants. Summary variants A and B in Section 1 exist to fix that, but the bullet selection has to back them up. Lead with LivNSense's Azure, PostgreSQL and C++ work, not with YOLO.
