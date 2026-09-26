# Dexter Fernandes -- Master CV

Bristol, UK | +44 7436 007369 | dexterfernandes11@gmail.com | linkedin.com/in/dexterferns | github.com/Dexter-Fernandes

**How to use this file:** the single source of truth for every track (CV, Robotics, LLM, SLAM, Software, PLC). Every bullet below is deduplicated, under 200 characters, and drop-in ready. To tailor, pick bullets from the tagged groups rather than rewriting. Nothing here needs shortening.

**Title line, pick one to match the job:** Computer Vision Engineer, Machine Learning Engineer, Robotics Software Engineer, Software Engineer, Backend Software Engineer

---

## SUMMARY VARIANTS (pick one, all under 450 characters)

**A. Production / edge CV (default)**
Computer Vision Engineer with 3+ years building and deploying real-time vision systems on edge hardware. Owned production pipelines end to end on NVIDIA DeepStream and OpenVINO for oil and gas and construction safety clients, from data curation and training through quantisation, deployment and on-site validation. MSc Robotics (Merit), University of Bristol.

**B. Robotics / perception**
Robotics and perception engineer with an MSc in Robotics (Merit) and 3+ years of commercial computer vision experience. Built LiDAR SLAM systems in C++17 and ROS2 on a Clearpath Husky, and shipped real-time multi-camera perception to industrial sites. Comfortable across sensor calibration, point cloud processing and deterministic real-time inference.

**C. ML engineering / applied science**
Machine learning engineer with 3+ years delivering computer vision models into 24/7 production. Work spans detector training and adaptation in PyTorch, quantisation and pruning for edge targets, multivariate time-series classification over 91 sensor channels, and the experiment tracking and benchmarking that supports model selection. MSc Robotics (Merit).

**D. Generalist software engineer**
Software engineer with 3+ years building and operating production systems, from C++17 edge inference to containerised Python services on Azure. Comfortable owning a service end to end: design, tests, deployment, monitoring, and the 2am failure. MSc Robotics, University of Bristol. Based in Bristol.

**E. Backend and platform**
Backend engineer with 3+ years shipping Python and C++ services in production. Built containerised inference microservices on Azure with REST endpoints and queue-based async processing, owned the PostgreSQL schema behind operational reporting, and cut live pipeline crashes by 67% through health checks, retries and structured observability. MSc Robotics, University of Bristol.

---

## RELEVANT EXPERIENCE

### Esbaar -- AI Engineer (01/2023 - 08/2023, Muscat, Oman)

**Deployment and reliability**
- Developed and maintained NVIDIA DeepStream 6.x and FFmpeg video pipelines for 24/7 perception on BP drilling rigs, covering camera ingestion, inference and field diagnostics in desert conditions.
- Hardened deployed services with Dockerised microservices, Kafka messaging, health checks and safe restarts, cutting live video pipeline crashes by 67% and enabling recovery without site visits.
- Built a watchdog application that detected and restarted failed services on edge devices, removing the need for site visits to recover pipelines.
- Designed and wrote the watchdog's REST API, exposing service health and restart control so operators and other services could act on failures remotely.
- Used multiprocessing to isolate capture from inference on shared edge hardware, keeping one stalled stream from blocking the rest of the pipeline.
- Added observability with structured logs, metrics, timeouts, retries and message validation, cutting root-cause analysis time on live deployments.
- Introduced pytest, unittest and linting into CI for edge inference modules, improving release consistency across hardware targets.
- Wrote a regression test reproducing each production failure before fixing it, turning field incidents into a permanent suite and stopping repeat crashes across deployments.

**Modelling and optimisation**
- Owned the end-to-end ML lifecycle for real-time perception on BP rigs, from data curation and training through deployment and on-site validation, improving F1 by 15% under 24/7 operation.
- Designed adversarial-condition training experiments (occlusion, lighting variation, motion artefacts), benchmarking robustness on F1 and failure rate to reach a 15% F1 gain in 3 months.
- Adapted YOLOv5 detectors in PyTorch, replacing backbone and neck layers and retraining for rig-specific classes, with Optuna sweeps and Weights & Biases tracking across runs.
- Benchmarked YOLOv5 against EfficientDet on a repeatable harness, quantifying accuracy, latency and stability pre and post optimisation to catch regressions before release.
- Ran TIDE error analysis on COCO-format production data to split live detector failures by error type, directing dataset fixes and threshold tuning at the dominant one.
- Defined a repeatable baseline to FP16 to validation workflow with acceptance thresholds, giving consistent latency, memory and stability outcomes across deployments.
- Applied image preprocessing and artefact detection with OpenCV and scikit-image to catch mud and sand contamination on camera feeds, reducing false positives by 13%.
- Generated synthetic images and augmentation routines with OpenCV and scikit-image to cover edge cases in harsh industrial conditions, improving robustness on contaminated feeds.
- Debugged training dynamics and convergence, balancing model complexity, augmentation and validation strategy to improve generalisation under lighting variation, occlusion and motion blur.
- Applied Bayesian optimisation, ablation studies, hypothesis testing and confidence intervals in Jupyter to support model selection, threshold tuning and failure analysis.

**Data and pipelines**
- Built ingestion and validation pipelines across image, video and sensor data with Airflow, MLflow, DVC and CVAT, processing 3.6 million records and cutting rollout from 72h to under 24h.
- Built an activity classification workstream over 91 sensor channels using MultiRocket, gradient boosting and random forests for multivariate time-series classification.

**Field validation and communication**
- Led on-site validation on BP rig deployments, diagnosing model failures under lighting, motion and environmental stressors and turning findings into fixes for live operation.
- Owned post-deployment monitoring and drift tracking for fielded vision systems, catching regressions early and feeding failure analysis back into retraining.
- Built an internal Django and Bootstrap dashboard surfacing inference outputs, system health and performance metrics, cutting debugging time on deployed systems.
- Built the dashboard's Django views, templates and forms and responsive Bootstrap layout, letting operators inspect live feeds and inference results without an engineer.
- Documented failure modes, recovery procedures and deployment guardrails for engineers supporting fielded systems.
- Presented performance findings to leadership, project managers and rig operators, turning production signals into rollout and optimisation decisions.
- Ran formal peer code reviews and QA activities inside each Agile sprint, improving maintainability and reducing defects.

### LivNSense Technologies -- Lead Software Engineer, AI (05/2020 - 12/2022, Bengaluru, India)

**Leadership and ownership**
- Led four engineers building a two-stage detector feeding helmet-colour classification for construction safety in Texas, cutting false positives by 33% within latency and power budgets.
- Set experimentation standards, reviewed model performance and mentored junior engineers, guiding optimisation strategy for production deployments.
- Established test-first practice across the four-engineer team, requiring a failing test with each ticket and reviewing test coverage in code review.
- Owned production ML pipelines end to end, from ingestion and labelling through training, optimisation, deployment, monitoring and field validation for industrial safety systems.

**C++ and edge inference**
- Built asynchronous C++17 perception pipelines on OpenVINO across Intel Movidius VPUs and Core i7 industrial edge boxes (VTC7252-7C4IP), raising throughput from 5 to 15 FPS under real-time constraints.
- Overlapped preprocessing, inference and post-processing in the C++ inference path to cut end-to-end latency and raise pipeline utilisation.
- Profiled C++ inference and pre/post-processing hotspots with Intel VTune, targeting fixes in the CNN inference pipeline.
- Wrote gtest unit tests and documented interfaces for the C++ inference path, catching regressions before deployment.
- Integrated Boost C++ libraries into production pipelines, resolving dependency and build issues to keep deployments reproducible.

**Model optimisation**
- Optimised architectures with quantisation-aware training, structured pruning and layer fusion in Keras and OpenVINO, cutting model size by 50% while holding production accuracy.
- Deployed quantised models with FP16/INT8, benchmarking accuracy, latency and memory trade-offs against real-time constraints on Intel edge targets.

**Vision systems**
- Built a real-time multi-camera perception pipeline on a moving construction vehicle, synchronising streams and running incident detection under edge compute constraints.
- Added ByteTrack multi-object tracking over detections to hold worker and vehicle identities across frames, cutting duplicate incident alerts from the moving-vehicle feeds.
- Implemented optical flow based ego-motion estimation feeding CNN classifiers in PyTorch to infer vehicle state, supporting collision avoidance on moving vehicles.
- Built YOLOv5 visual quality inspection for John Deere engine paintjobs on a conveyor line, detecting paint defects, contamination and colour inconsistency.
- Tuned camera and ISP settings to keep models reliable on RGB and IR streams across 24/7 operation, cutting false positives on IR and reducing manual recalibration.
- Ran adversarial-condition training and validation simulating occlusion, lighting variation and motion artefacts, cutting performance variance by 25%.
- Used confusion-matrix failure clustering and TIDE error analysis on COCO-format production data to diagnose recurring detector failures and prioritise dataset fixes across camera feeds.
- Evaluated DeepLabv3+, Mask R-CNN, U-Net and SegFormer for annotation review, foreground separation and failure analysis on industrial camera feeds.

**Data and labelling**
- Automated labelling by repurposing existing detection models and added dataset versioning with DVC, cutting manual labelling effort by 80% on large real-world datasets.
- Built synthetic-data tooling to improve edge-case coverage, reducing manual labelling time by 60%.

**Cloud and backend**
- Deployed containerised ML inference microservices on Azure with REST endpoints and queue-based async processing, owning autoscaling, monitoring and cost-per-inference.
- Built a watchdog application for the edge deployments with a REST API for service health and restart control, so failed inference services recovered without an engineer on site.
- Used multiprocessing to parallelise capture, inference and post-processing across cores on edge devices, keeping camera streams from blocking each other.
- Evaluated edge against cloud inference to minimise bandwidth, latency and operational cost while holding safety-critical performance targets.
- Designed the PostgreSQL schema routing real-time incidents into downstream analytics, writing the joins and CTEs behind operational reporting.
- Designed data handling and retention practices aligned with GDPR principles, including data minimisation and controlled access.

**Additional delivery**
- Built a low-latency computer vision PoC for a zinc ore refining plant in South Africa and a user-facing hazard detection application for an Oman-based client.
- Worked with hardware, software and QA teams to integrate perception modules into deployed systems and shape rollout decisions.

---

## PROJECTS

### DeepStream RTSP Pipeline (06/2026) -- github.com/Dexter-Fernandes/deepstream-rtsp-pipeline
- Built an end-to-end DeepStream 9.0 and GStreamer RTSP pipeline running YOLO detection and NvDCF tracking across 3 concurrent feeds, with metadata extraction, anonymisation and re-streamed output.
- Converted YOLO26n to a dynamic-batch TensorRT FP16 engine on 6GB VRAM Turing hardware, validating FP16 against FP32 accuracy and profiling p99 latency to sustain 29.7 FPS per stream live.
- Implemented a C++ and CUDA TensorRT decode plugin with IPluginV2DynamicExt, moving post-processing into the inference engine to support custom-layer deployment.
- Benchmarked IoU, NvDCF and NvSORT trackers on MOTA, IDF1, ID switches, fragmentation, FPS and VRAM impact to guide tracker selection.
- Designed a geometry-first cross-camera (MTMC) identity layer over per-camera DeepStream trackers, lifting pooled IDF1 from 0.198 to 0.245 on WildTrack.
- Fit uncertainty-aware ground-plane homographies per camera with a held-out quality gate (median <0.10m, p90 <0.30m), propagating foot-point pixel uncertainty into projection.
- Built a CPU-testable MTMC association core using constrained union-find clustering and mutual-nearest-neighbour matching, reaching 100% online/offline agreement across 10,608 rows.
- Added an optional DeepStream ReID SGIE for sparse appearance fusion; a 28% throughput hit for only 0.002 F1 gain over geometry-only led me to ship geometry as the default.
- Hardened cross-camera fusion for real deployments: derived NTP-based timestamps across RTSP sources, gated fusion on clock skew, and incremented reconnect generations to stop stale tracker-ID reuse.
- Instrumented the pipeline with structured JSON-line logging and a per-sensor health monitor tracking liveness, FPS vs expected and time-since-last-detection, flagging stalled streams in real time.
- Wrote a failure-mode playbook for stuck streams, silent detector degradation, OOM and silent reconnects, grounded in real logged events including a genuine nvtracker association bug.
- Built an automated model-promotion gate checking match-rate and mean-IoU against a signed SHA-256 manifest, and wired GPU smoke plus MOT17 integration tests into GitHub Actions CI.
- Ran an O(1)-inference confidence-threshold sweep against WildTrack ground truth, lifting operating-point F1 from 0.218 to 0.591 and logging results to Weights & Biases.
- Hardened the RTSP source path with TCP transport and NTP-synced clocks, cutting batched-push timeout from 4s to about one frame interval so one stalled source can't stall the shared batch.

### FinanceBench RAG Evaluation Harness (06/2026)
- Built an evaluation framework for FinanceBench measuring how well RAG and document-grounded QA systems answer using the right source evidence.
- Designed experiments across closed-book, oracle-context and dense RAG workflows to isolate whether failures came from retrieval, source selection or generation.
- Added LLM-as-judge scoring, evidence matching, citation checks, numeric matching and hallucination labels.
- Produced reproducible runs with automated tests, config-driven experiments, structured prediction outputs and Markdown reports, enabling regression checks between runs.

### ROS2 SLAM and Nav2 Simulation (02/2026) -- github.com/Dexter-Fernandes/ClutterBot-SLAM
- Built a simulation-based robotics stack in ROS2 Jazzy and Gazebo Harmonic to evaluate LiDAR-centric SLAM, LiDAR and RGB fusion SLAM, and autonomous navigation in structured scenarios.
- Benchmarked RTAB-Map, LIO-SAM, Cartographer and GLIM across 2D and 3D LiDAR configurations, comparing mapping and localisation behaviour to support system selection.
- Developed ROS2 nodes, launch files and parameterised configs in C++ and Python, using tf2, message synchronisation and timestamp alignment to debug transform timing issues.
- Implemented point cloud filtering, segmentation and registration with PCL and Open3D, and added an EKF localisation layer with robot_localization fusing wheel odometry and IMU.
- Containerised the stack with Docker on Linux and managed versioning in Git for reproducible builds across development environments.

### Modern Edge CV Benchmarking (03/2026) -- github.com/Dexter-Fernandes/Modern-Edge-CV-Benchmarking
- Benchmarked modern PyTorch detectors including YOLOv8, YOLOv10, YOLO26 and RT-DETR on accuracy, latency and model size to compare deployment suitability for edge targets.
- Extended the comparison to EfficientViT, Grounding DINO, MobileSAM and Depth Anything v2 to assess whether open-vocabulary, segmentation and depth models are viable at the edge.
- Evaluated Vision Transformer and foundation-model approaches across detection, segmentation, depth estimation and open-vocabulary understanding.
- Exported models to ONNX and tested OpenVINO deployment paths, comparing mAP, inference time and model size to support model selection for low-latency systems.

---

## EDUCATION

### University of Bristol -- MSc Robotics, Merit (09/2023 - 09/2024, Bristol, England)
Dissertation: Radiological SLAM with LiDAR Odometry
- Built real-time SLAM in C++17 and ROS2 Humble (rclcpp) on a Clearpath Husky, fusing Velodyne VLP-16 LiDAR, RealSense D435i depth and Symetrica VeriFinder gamma-ray detection for inspection mapping.
- Benchmarked RTAB-Map, LIO-SAM and Cartographer across matched rosbag2 sequences under a single evaluation protocol to compare mapping and localisation behaviour.
- Configured Ceres, g2o and GTSAM as solver backends and tuned RTAB-Map and ICP parameters across indoor high-detail and outdoor feature-scarce environments.
- Calibrated LiDAR extrinsics to the robot base and resolved transform timing with tf2 across a PCL point cloud pipeline, validating sensor placement for coverage.
- Ran the full SLAM and perception stack on an NVIDIA Jetson AGX Xavier under JetPack, working within the platform's compute and memory limits for on-robot operation.
- Simulated 2D and 3D SLAM and Nav2 waypoint traversal for the Husky in Gazebo, testing survey routes before running them on the robot.
- Ran the Husky in real industrial environments, navigating obstacles and locating radioactive sources in real time on the fused gamma-ray map.

### Visvesvaraya National Institute of Technology -- BTech Electrical and Electronics Engineering (07/2016 - 05/2020, Nagpur, India)
- Foundation in signals, systems, embedded hardware and control, which later supported work in real-time AI, sensor systems and robotics software.

---

## ADDITIONAL EXPERIENCE

### GrowthStage -- Technical Assessor, Computer Vision and Software Engineering (05/2026 - Present, Remote)
- Assesses candidate technical depth across perception, SLAM and deployment using hands-on robotics and computer vision knowledge.
- Writes and calibrates evaluation rubrics for robotics engineering candidates.

### Taco Bell -- Service Champion / Team Trainer (09/2024 - Present, Bristol, England)
- Progressed to Team Trainer in a customer-facing environment, onboarding new staff and handling escalations.

---

## CERTIFICATIONS AND AWARDS
- Building RAG Agents with LLMs, NVIDIA (06/2026)
- Deep Learning Specialisation, deeplearning.ai (07/2019)
- Best Speaker award, ABC Toastmasters Club (01/2020)

---

## SKILLS (master pool, cut down per application)

**Languages:** Python, C++17, CUDA C++, Bash, SQL

**Computer vision and deep learning:** object detection, image classification, semantic and instance segmentation (Mask R-CNN, DeepLabv3+, U-Net, SegFormer), object tracking, optical flow, anomaly detection, defect detection, data augmentation, convolutional neural networks (CNNs), YOLO (v5/v8/v10/v26), RT-DETR, EfficientDet, EfficientViT, Grounding DINO, MobileSAM, Depth Anything v2, PyTorch, TensorFlow, Keras, OpenCV, scikit-image, torchvision, Pillow, NumPy, HuggingFace

**Edge inference and optimisation:** TensorRT (custom plugins, dynamic batching), OpenVINO, ONNX, quantisation-aware training, post-training quantisation, FP16/INT8, structured pruning, layer fusion, latency and throughput profiling, VRAM profiling, Intel VTune, Intel Movidius Myriad VPU, Intel Core i7 industrial edge (VTC7252-7C4IP), NVIDIA Jetson AGX Xavier, JetPack

**Video pipelines:** NVIDIA DeepStream 6.x/9.0, GStreamer, FFmpeg, RTSP, nvinfer, nvstreammux, nvtracker, nvdsosd, NvDCF, NvSORT, ByteTrack, multi-stream video analytics, multi-camera synchronisation, multi-target multi-camera (MTMC) tracking, homography calibration, ground-plane projection, union-find clustering, ISP and camera tuning (RGB and IR)

**Robotics and SLAM:** ROS2 (Robot Operating System 2) Humble and Jazzy, rclcpp, rclpy, tf2, rosbag2, Gazebo Harmonic, RTAB-Map, LIO-SAM, Cartographer, GLIM, Nav2, LiDAR SLAM, pose graph optimisation, ICP (Iterative Closest Point), scan matching, LiDAR extrinsics calibration, sensor fusion, PCL (Point Cloud Library), Open3D, Eigen, Ceres, g2o, GTSAM, robot_localization, EKF

**LLMs and retrieval:** RAG pipelines, dense and hybrid retrieval, FAISS, ChromaDB, BM25, cross-encoder reranking, reciprocal rank fusion, LangChain, LangGraph, LangSmith, LLM-as-judge, hallucination detection, structured outputs, Pydantic, MCP, fine-tuning, LoRA

**MLOps and experimentation:** MLflow, DVC (Data Version Control), Apache Airflow, Apache Kafka, Optuna, Weights & Biases, Jupyter, CVAT (Computer Vision Annotation Tool), automated labelling, dataset versioning, synthetic data generation, benchmarking harnesses, ablation studies, hypothesis testing, Bayesian optimisation, failure-mode analysis, drift tracking, Grad-CAM, TIDE (Toolbox for Identifying Detection Errors), COCO annotation format, model-promotion gates

**Production and cloud:** Docker, CI/CD, GitHub Actions, Git, CMake, test-driven development, pytest, unittest, gtest, linting, regression testing, Microsoft Azure (Container Apps, Blob Storage, queues), REST API design, FastAPI, containerised microservices, queue-based async processing, multiprocessing, autoscaling, cost-per-inference, PostgreSQL, Django (views, templates, forms), Bootstrap, structured logging, timeouts and retries, health monitoring, health checks, observability, production monitoring, Linux

**Time series and classical ML:** MultiRocket, gradient boosting, random forests, scikit-learn, Pandas, multivariate time-series classification

**Professional:** technical leadership, mentoring, Agile and Scrum, Jira, stakeholder communication, cross-functional delivery

---

## KNOWN GAPS (reference only, never CV content)

Nothing below may be claimed. Use it at Step 3 to mark requirements as Missing rather than stretching adjacent evidence.

- **AWS:** Azure only. Many UK backend listings name AWS and keyword screens filter on it.
- **Infrastructure as code:** no Terraform, CDK, CloudFormation or Ansible.
- **Backend breadth:** no evidence of auth, API versioning, schema migrations, rate limiting or high request load.
- **Frontend:** Django templates and Bootstrap are server-rendered UI. Enough for "built internal tooling", not for a full-stack or frontend role (React or Vue, TypeScript, client-side state).
- **Framing for generalist backend roles:** the evidence reads as CV-specialist. Lead with LivNSense Azure, PostgreSQL and C++ work, and Esbaar Kafka and reliability work, not YOLO.
