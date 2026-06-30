

# LaaS Platform Validation Notes & Technical Learnings

## Platform Architecture

The platform is a containerized Linux Desktop-as-a-Service environment.

Characteristics:

* Ubuntu desktop delivered through Selkies containers.
* User desktops are browser-accessible.
* Compute and storage are separated.
* Containers are ephemeral compute.
* User storage is persistent and NFS-backed.
* Users can attach the same datastore to different compute configurations.
* Users can move between instance types without losing project state.
* Multiple users can work simultaneously on isolated compute resources.

---

## Persistence Behavior

Verified persistent:

* `/home/ubuntu`
* User project files
* Git repositories
* Conda installations
* Conda environments
* Downloaded models
* HuggingFace cache
* Chroma cache
* VSCode installations stored in user space
* Jupyter notebooks
* Python packages installed inside persistent Conda environments

Not guaranteed persistent:

* Container root filesystem modifications
* Packages installed directly into container layers
* Runtime-only filesystem changes outside persistent storage

Design assumption:

> Any important asset should live under user-owned persistent storage.

---

## Compute Resource Model

Available instance classes use sliced resources from a larger host GPU.

Observed behavior:

* CPU limits enforced.
* RAM limits enforced.
* VRAM limits enforced.
* GPU virtualization functioning correctly.
* CUDA accessible inside containers.
* PyTorch recognizes allocated GPU memory rather than host GPU capacity.

---

## GPU Virtualization Findings

HAMi Core + MPS virtualization stack is functioning.

Observed:

* VRAM partitioning works.
* Containers receive isolated GPU allocations.
* Concurrent GPU workloads remain usable.
* One container saturating its VRAM did not noticeably degrade another container's responsiveness.
* PyTorch workloads execute correctly.
* CUDA inference works correctly.

Important observation:

`nvidia-smi` may report host GPU specifications.

Actual usable VRAM should be determined through PyTorch APIs.

---

## AI Framework Validation

Successfully validated:

* PyTorch CUDA
* TorchVision
* Transformers
* Diffusers
* Accelerate
* Sentence Transformers
* ChromaDB
* OpenCV
* Ultralytics
* MediaPipe
* Whisper
* Piper
* Open3D
* Stable Baselines3
* Gymnasium
* Depth Anything imports
* Rembg
* ONNX Runtime workloads

General conclusion:

Modern AI inference workflows are fully feasible.

---

## Development Toolchain Validation

Successfully validated:

* Python
* Miniconda
* JupyterLab
* VSCode
* Git
* GitHub SSH
* NodeJS
* NextJS
* FastAPI
* Streamlit
* PostgreSQL client tooling
* GCC
* G++
* Make
* CMake
* OpenJDK 21
* FFmpeg

General conclusion:

Full-stack AI application development is supported.

---

## Model Storage Behavior

Verified:

* HuggingFace models persist.
* SentenceTransformer models persist.
* Chroma ONNX models persist.
* YOLO weights persist.
* Downloaded checkpoints persist.

Models downloaded once remain available across restarts because storage is persistent.

Implication:

The platform benefits from model caching and reuse.

---

## Networking & Download Observations

Verified:

* HuggingFace downloads function correctly.
* PyPI downloads function correctly.
* GitHub downloads function correctly.

Observed:

* Some package installations may appear stalled while downloading large wheel dependencies.
* Package installation progress is not always obvious from terminal output.

Design assumption:

> Long install times do not necessarily indicate failure.

---

## Container Environment Characteristics

Observed:

* Certain traditional Linux desktop assumptions do not always hold.
* Some system services may be unavailable.
* Some desktop packages may behave differently from bare-metal Ubuntu.
* Some applications expect services that do not exist inside containers.

Implication:

Projects should prefer user-space tooling and Python ecosystems over deep system-level customization.

---

## AI Workload Characteristics

Validated workload categories:

### Computer Vision

Working:

* Object Detection
* Segmentation
* Pose Estimation
* Background Removal
* OCR Pipelines
* Depth Estimation

---

### Audio

Working:

* Speech Recognition
* Speech Synthesis
* Audio Processing
* Audio Feature Extraction

---

### NLP

Working:

* Embeddings
* RAG
* Summarization
* Translation
* Question Answering
* Semantic Search

---

### Image Generation

Working:

* Diffusion Pipelines
* Image Editing
* Style Transfer
* Image Enhancement

---

### Reinforcement Learning

Working:

* Gymnasium Environments
* Stable Baselines3
* Agent Training

---

### 3D

Working:

* Open3D
* Point Clouds
* Depth-Based Reconstruction

---

## Resource Planning Considerations

The largest practical constraints are not compute.

The largest practical constraints are:

1. Storage growth from models.
2. Storage growth from datasets.
3. Storage growth from generated media.
4. Repeated model downloads.
5. Poor team coordination.
6. Improper use of persistent storage.

---

## Multi-User Platform Findings

Observed:

* Multiple concurrent users are feasible.
* GPU isolation appears effective.
* Resource slicing behaves as expected.
* Individual workloads remain usable during neighboring GPU activity.

Implication:

Collaborative internship environments are practical.

---

## Educational Platform Suitability

The platform has been validated for:

* AI application development
* Full-stack development
* RAG systems
* Computer vision applications
* Audio applications
* Generative AI applications
* Interactive AI products
* Agent-based systems
* Data science workflows
* ML experimentation
* Prototype deployment

---

## Important Design Principle

The platform is strongest when used for:

* AI product engineering
* AI application development
* System integration
* Model orchestration
* Rapid prototyping

The platform should be viewed as a production-oriented AI development environment rather than a large-scale model training cluster.

---

## Overall Assessment

Based on validation:

* Development workflow: Verified
* AI inference workflow: Verified
* Persistence model: Verified
* GPU access: Verified
* Model caching: Verified
* Multi-user operation: Verified
* Full-stack development: Verified

Overall platform readiness for AI-focused student teams:

**High confidence.**

No architectural blockers were discovered during validation. The remaining concerns are operational (storage management, onboarding, team workflow, and resource utilization) rather than technical feasibility.
