# 15-Day Vibe-Coding Internship — Project Ideas

> **Program:** 15-day internship for 57 CS students (14 teams: 13×4 + 1×5)
> **Theme:** Vibe-coding — building alongside AI, not manual coding
> **Platform:** LaaS GPU Desktop (Selkies WebRTC)
> **Data Input:** All projects use **pre-recorded uploads or URL ingestion** — no live webcam, no live microphone, no live telemetry

---

## Resource Constraints

### Per-Team Allocation

| Instance | Count | Specs | Role |
|---|---|---|---|
| **Blaze** | 1 per group | 4 vCPU, 8 GB RAM, **4 GB VRAM**, 17% SM | Integration node — runs heavier models, aggregates all modules |
| **Spark** | 3 per group | 2 vCPU, 4 GB RAM, **2 GB VRAM**, 8% SM | Development nodes — each member builds their module |

### Data Input Methods (No Live Telemetry)

All data enters the GPU container via:

| Method | How It Works |
|---|---|
| **File Upload** | Student records on phone/laptop → uploads via LaaS web UI → stored in `/home/ubuntu` (15 GB ZFS) |
| **URL Ingestion** | Container downloads from public URLs (YouTube via `yt-dlp`, RTSP streams, public datasets) |
| **Text Input** | Student types directly into apps running in the Selkies desktop |
| **Pre-loaded Datasets** | Container downloads public datasets (COCO, KITTI, etc.) during setup |

### GPU Model Menu

**Models that fit in 2 GB VRAM (Spark):**

| Model | VRAM | Use Case |
|---|---|---|
| Whisper Base/Small | ~1–2 GB | Speech-to-text |
| YOLOv8 Nano/Small | ~1–1.5 GB | Object/person/defect detection |
| all-MiniLM-L6-v2 | ~300 MB | Text embeddings, semantic search |
| Depth Anything V2 Small | ~500 MB | Single-image depth estimation |
| Real-ESRGAN x4 | ~500 MB | Image super-resolution |
| DeOldify | ~100 MB | B&W photo colorization |
| MobileNetV3 | ~100 MB | Image classification |
| Fast Neural Style Transfer | ~1 GB | Artistic style transfer |
| TinySAM | ~500 MB | Image segmentation, background removal |
| PaddleOCR | ~1 GB | Text detection + recognition |
| MediaPipe Pose/Hands | ~300 MB | Body/hand pose estimation |
| Qwen2-1.5B (Q4 quantized) | ~1.1 GB | Text generation, reasoning |
| CLIP ViT-B/32 (quantized) | ~400 MB | Image-text matching, visual embeddings |
| ChromaDB (in-process) | RAM only | Vector database for embeddings |

**Additional models for 4 GB VRAM (Blaze):**

| Model | VRAM | Use Case |
|---|---|---|
| Stable Diffusion 1.5 (optimized) | ~3.5 GB | Image generation from text |
| MusicGen Small | ~2.5 GB | Music generation from text |
| YOLOv8 Medium | ~2.5 GB | Better detection accuracy |
| Depth Anything V2 Base | ~1 GB | Better depth estimation |
| Whisper Small (comfortable) | ~2 GB | Fast, accurate transcription |

---

## The 14 Projects

### Difficulty Legend

- **Standard** — Achievable by all teams with average skill level
- **Challenging** — Requires stronger engineering, more integration work
- **Advanced** — Hackathon-grade, maximum wow-factor, for top teams

---

## 1. PixelRevive — AI Photo Restoration Studio

**Difficulty:** Standard

**One-liner:** Upload a damaged, old, black-and-white family photo → get back a restored, colorized, 4K version.

**Demo moment:** Show a torn 1970s family photo → watch AI fix scratches, add color, upscale to HD. Before/after reveal.

**Data input:** Student uploads photo via LaaS web UI

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Scratch Removal** | 1 | U-Net-small (~800 MB) | Inpainting model to fill scratches, tears, water damage |
| **Colorization** | 2 | DeOldify (~100 MB) | Auto-colorize B&W photos with plausible colors |
| **Super-Resolution** | 3 | Real-ESRGAN x4 (~500 MB) | Upscale restored photo to 4K quality |
| **Web Studio + AI Agent** | 4 | Embeddings + ChromaDB (~300 MB) | Upload UI, side-by-side comparison, batch processing, AI describes what was fixed |

**Key libraries:** `rembg`, `deoldify`, `real-esrgan`, `sentence-transformers`, `chromadb`

**Why it stands out:** Every family has old damaged photos. The before/after is universally emotional. Runs 3 different GPU models in a pipeline.

---

## 2. SnapChef — Fridge-to-Recipe AI

**Difficulty:** Standard

**One-liner:** Snap a photo of your fridge → AI identifies every ingredient → generates a personalized recipe.

**Demo moment:** Open a fridge, take a photo, upload it → watch ingredients get detected with bounding boxes → full recipe appears.

**Data input:** Student uploads fridge/pantry photo

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Ingredient Detection** | 1 | YOLOv8 Small (~1.5 GB) | Fine-tune to detect 50+ common food items |
| **Recipe Generation** | 2 | Qwen2-1.5B-Q4 on Blaze (~1.1 GB) | Generate recipes from detected ingredients |
| **Nutrition + Preferences** | 3 | Embeddings + ChromaDB (~300 MB) | Dietary filters, allergy checks, nutrition scoring |
| **Cook-Along UI** | 4 | — (frontend) | Step-by-step interface, timer, ingredient checklist |

**Key libraries:** `ultralytics`, `transformers`, `sentence-transformers`, `chromadb`

---

## 3. SoundForge — AI Music & Beat Generator

**Difficulty:** Standard

**One-liner:** Describe a mood in text → AI generates original music. Layer tracks, add beats, export.

**Demo moment:** Type "chill lo-fi with Tamil folk influence" → music starts playing. Layer a beat. Export the mix.

**Data input:** Text description (typed in desktop)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Music Generation** | 1 | MusicGen Small on Blaze (~2.5 GB) | Text-to-music, genre/mood conditioning |
| **Beat Detection & Mixing** | 2 | Audio DSP + PyTorch (~500 MB) | BPM detection, beat alignment, audio mixing |
| **Audio Effects** | 3 | Neural audio effects (~400 MB) | Reverb, EQ, style transfer on audio |
| **Studio UI** | 4 | — (frontend, Web Audio API) | Multi-track editor, waveform viz, export to MP3 |

**Key libraries:** `transformers` (MusicGen), `librosa`, `pydub`, `soundfile`

**Why it stands out:** Music AI is the most defensible category (per a16z). Nobody else will have audio generation.

---

## 4. FormCheck — AI Exercise Form Analyzer

**Difficulty:** Standard

**One-liner:** Upload a video of yourself exercising → AI tracks your pose → generates a form report with corrections.

**Demo moment:** Upload a squat video → watch skeleton overlay → "knee angle: 72° (should be 90°)" at timestamps → AI tips.

**Data input:** Student uploads exercise video (recorded on phone)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Video Processing** | 1 | — (OpenCV frame extraction) | Extract frames, manage video pipeline |
| **Pose Estimation** | 2 | MediaPipe Pose (~300 MB) | Real-time 33-point body tracking on GPU |
| **Form Analysis** | 3 | Custom angle classifier (~200 MB) | Joint angles, correct-form comparison, rep counting |
| **Report UI** | 4 | — (frontend) | Video playback + skeleton overlay, angle graphs, AI tips |

**Key libraries:** `mediapipe`, `opencv-python`, `numpy`, `scipy`

---

## 5. HawkEye — AI Video Intelligence Engine

**Difficulty:** Standard

**One-liner:** Paste a YouTube URL or upload video → AI detects objects, counts people, finds anomalies → searchable event timeline.

**Demo moment:** Paste a traffic camera YouTube URL → container pulls the stream → real-time detection overlay → searchable timeline with screenshots.

**Data input:** Paste URL (container downloads via `yt-dlp`) **or** upload .mp4

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Video Ingestion** | 1 | — (`yt-dlp` + OpenCV) | URL download, frame extraction, video management |
| **Frame Detection** | 2 | YOLOv8 Nano (~1 GB) | Per-frame object/person/vehicle detection on GPU |
| **Event Intelligence** | 3 | Embeddings + clustering (~300 MB) | Anomaly detection, object tracking, event classification |
| **Timeline Dashboard** | 4 | — (frontend) | Searchable event log, video scrubber with AI annotations, export |

**Key libraries:** `yt-dlp`, `ultralytics`, `sentence-transformers`, `chromadb`, `opencv-python`

---

## 6. GameBrain — AI That Learns to Play Classic Games

**Difficulty:** Challenging

**One-liner:** Pick a game (Snake, Pong, Flappy Bird) → watch AI train from zero to superhuman in real-time.

**Demo moment:** Start training on Snake → AI crashes into walls → 2 minutes later it plays perfectly. AI vs. Human challenge mode.

**Data input:** Internal (no external input — game runs inside the container)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **RL Training Engine** | 1 | DQN/PPO on GPU (~800 MB) | Train agents with Deep Q-Learning on GPU |
| **Game Environments** | 2 | PyTorch + Gymnasium (~500 MB) | GPU-accelerated Snake, Pong, Flappy Bird |
| **Visualization** | 3 | Embeddings for state analysis (~300 MB) | Neural net viz, learning curves, state-action heatmaps |
| **Arena UI** | 4 | — (frontend, Canvas/WebGL) | Game viewer, training controls, leaderboard, AI vs. Human |

**Key libraries:** `gymnasium`, `stable-baselines3`, `torch`, `pygame`, `matplotlib`

**Why it stands out:** Watching AI learn is genuinely exciting. RL training is GPU-intensive. The audience cheers when the AI gets smart.

---

## 7. ArtForge — AI Art & Style Studio

**Difficulty:** Standard

**One-liner:** Upload any photo → apply 10+ artistic styles (Van Gogh, Picasso, anime) → adjust intensity → export.

**Demo moment:** Upload a selfie → click through 10 styles → each renders in <2 seconds → drag intensity slider → export.

**Data input:** Student uploads photo

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Style Transfer Engine** | 1 | Fast Neural Style (~1 GB) | 10+ pre-trained style models on GPU |
| **Batch Processing** | 2 | GPU pipeline (~500 MB) | Multi-style simultaneously, adjustable intensity |
| **AI Art Curation** | 3 | Embeddings (~300 MB) | "Find similar styles," gallery, style recommendation |
| **Studio UI** | 4 | — (frontend) | Drag-drop upload, style gallery, intensity slider, before/after, export |

**Key libraries:** `torch`, `torchvision` (neural style models), `sentence-transformers`, `Pillow`

---

## 8. EchoScribe — AI Video Transcription & Study Platform

**Difficulty:** Standard

**One-liner:** Upload a lecture video or paste YouTube URL → AI transcribes, generates chapters, flashcards, and quizzes.

**Demo moment:** Paste a YouTube lecture URL → real-time transcription → chapters auto-generate → click any chapter → get AI flashcards.

**Data input:** Upload video **or** paste YouTube URL (container downloads via `yt-dlp`)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Transcription** | 1 | Whisper Small (~2 GB) | Speech-to-text with timestamps + speaker diarization |
| **Intelligence Layer** | 2 | Embeddings + ChromaDB (~300 MB) | Topic segmentation, chapter detection, key moments |
| **Study Tools** | 3 | Quantized LLM on Blaze (~1.1 GB) | Flashcards, summaries, quiz questions from transcript |
| **Video Player UI** | 4 | — (frontend) | Synced video + transcript, chapter sidebar, flashcard viewer |

**Key libraries:** `faster-whisper`, `yt-dlp`, `sentence-transformers`, `chromadb`, `transformers`

---

## 9. VoxLingua — Voice Translator

**Difficulty:** Standard

**One-liner:** Upload audio in Tamil → AI transcribes, translates to English, and speaks it back.

**Demo moment:** Upload a Tamil voice recording → see transcription appear → see English translation → hear it spoken aloud.

**Data input:** Student uploads audio file (.wav/.mp3, recorded on phone)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Speech-to-Text** | 1 | Whisper Small (~2 GB) | Tamil + English + Hindi transcription on GPU |
| **Translation Engine** | 2 | Quantized LLM on Blaze (~1.1 GB) | Context-aware translation |
| **Text-to-Speech** | 3 | Piper TTS (GPU, ~500 MB) | Natural voice output in target language |
| **Conversation UI** | 4 | — (frontend) | Audio player, transcript view, translation panel, playback |

**Key libraries:** `faster-whisper`, `transformers`, `piper-tts`, `pydub`

---

## 10. MemeForge — Context-Aware AI Meme Generator

**Difficulty:** Standard

**One-liner:** Upload any image → AI understands the context → generates genuinely funny captions.

**Demo moment:** Upload a photo of the professor → AI generates a meme about assignments. The room erupts.

**Data input:** Student uploads image **or** picks from trending templates

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Image Understanding** | 1 | CLIP ViT-B/32 (~400 MB) + YOLOv8 Nano (~1 GB) | Detect objects, scene context in image |
| **Caption Generation** | 2 | Quantized LLM on Blaze (~1.1 GB) | Contextually relevant, funny captions |
| **Template Engine** | 3 | Embeddings for matching (~300 MB) | Match image to meme templates, text placement |
| **Meme Studio UI** | 4 | — (frontend, Canvas) | Upload/template picker, caption editor, text drag-drop, share |

**Key libraries:** `transformers` (CLIP), `ultralytics`, `sentence-transformers`, `Pillow`, `canvas` (frontend)

**Why it stands out:** It's FUN. The demo makes people laugh. "AI actually understood the image" is surprising and delightful.

---

## 11. Scene3D — Single-Image 3D Depth Scanner

**Difficulty:** Challenging

**One-liner:** Upload any photo → AI estimates depth for every pixel → generates a 3D point cloud you can rotate and fly through.

**Demo moment:** Upload a landscape photo → watch it transform into a rotating 3D scene. Fly through the depth.

**Data input:** Student uploads photo

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Depth Estimation** | 1 | Depth Anything V2 Small (~500 MB) | Per-pixel depth prediction from single image |
| **3D Point Cloud** | 2 | PyTorch3D + GPU (~500 MB) | Depth map → 3D point cloud, mesh generation |
| **Scene Enhancement** | 3 | Real-ESRGAN (~500 MB) + embeddings | Upscale input for better depth, semantic understanding |
| **3D Viewer UI** | 4 | — (frontend, Three.js) | Interactive 3D viewer, orbit/fly controls, depth slider, export |

**Key libraries:** `depth-anything-v2`, `pytorch3d`, `real-esrgan`, `three.js` (frontend)

**Why it stands out:** The 3D viewer is unlike anything other teams will have. "Flat photo → 3D world" is magical.

---

## 12. StoryQuest — AI Interactive Adventure Game

**Difficulty:** Challenging

**One-liner:** An AI Dungeon Master that creates interactive adventures with voice narration AND generates an image for every scene.

**Demo moment:** "You're in a dark forest. Which way?" → choose left → AI narrates → generates scene image → next choice. Audience plays along.

**Data input:** Text choices (typed in desktop)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Story Engine** | 1 | Quantized LLM on Blaze (~1.1 GB) | Dynamic story, branching narratives, character consistency |
| **Scene Illustration** | 2 | SD 1.5 optimized on Blaze (~3.5 GB) | Generate image for each scene description |
| **Voice Narration** | 3 | Whisper Base (~1 GB) + Piper TTS | Voice input for choices + AI narration |
| **Game UI** | 4 | — (frontend) | Text adventure, scene illustrations, choice buttons, story map |

**Key libraries:** `transformers`, `diffusers` (Stable Diffusion), `piper-tts`, `faster-whisper`

**Why it stands out:** Interactive fiction with AI images + voice is the most immersive demo possible. Audience plays during demo.

---

## 13. SignReader — Video Sign Language Translator

**Difficulty:** Challenging

**One-liner:** Upload a video of someone signing → AI tracks hand poses → translates gestures to text → speaks the translation.

**Demo moment:** Upload a 30-second signing video → watch hand tracking overlay → see words appear as subtitles → hear spoken translation.

**Data input:** Student uploads signing video (recorded on phone)

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Video Processing** | 1 | — (OpenCV frame extraction) | Extract frames, manage video pipeline |
| **Hand Tracking** | 2 | MediaPipe Hands (~300 MB) | Real-time 21-point hand landmark detection on GPU |
| **Gesture Recognition** | 3 | LSTM on pose sequences (~500 MB) | Classify gesture sequences into words/phrases |
| **Translation UI** | 4 | — (frontend) | Video player + synced translation, vocabulary lookup, TTS |

**Key libraries:** `mediapipe`, `opencv-python`, `torch` (LSTM), `piper-tts`

---

## 14. PixelPlayground — Creative AI Toolkit *(5-person team)*

**Difficulty:** Standard+

**One-liner:** A Swiss Army knife of AI visual tools: background remover, style transfer, upscaler, colorizer, depth mapper — all in one app.

**Demo moment:** Upload photo → remove background (1 click) → apply Van Gogh style (1 click) → upscale to 4K (1 click) → see depth map (1 click). Each tool = different GPU model.

**Data input:** Student uploads photos

| Module | Member | GPU Model (VRAM) | What They Build |
|---|---|---|---|
| **Background Removal** | 1 | TinySAM (~500 MB) + rembg | One-click bg removal, object cutout, bg swap |
| **Style Transfer + Filters** | 2 | Fast Neural Style (~1 GB) | 10+ art styles, adjustable intensity, real-time preview |
| **Super-Res + Colorization** | 3 | Real-ESRGAN (~500 MB) + DeOldify (~100 MB) | 4x upscaling, B&W colorization, photo enhancement |
| **Depth + 3D Preview** | 4 | Depth Anything V2 (~500 MB) | Depth map, 3D parallax effect, depth-based blur |
| **Unified UI + AI Agent** | 5 | Embeddings (~300 MB) | Drag-drop canvas, tool palette, batch processing, AI suggests tools |

**Key libraries:** `tiny-sam`, `rembg`, `torchvision` (style models), `real-esrgan`, `deoldify`, `depth-anything-v2`, `sentence-transformers`

**Why it stands out:** 6 GPU models in one app. Each member owns a real AI tool. Looks like a professional product.

---

## GPU Diversity Matrix

| GPU Category | Models Used | Projects |
|---|---|---|
| **Object Detection** | YOLOv8 Nano/Small | #2, #5, #10 |
| **Speech Recognition** | Whisper Base/Small | #8, #9, #12, #13 |
| **Image Generation** | SD 1.5, MusicGen | #3, #12 |
| **Image Enhancement** | Real-ESRGAN, DeOldify | #1, #11, #14 |
| **Style Transfer** | Fast Neural Style | #7, #14 |
| **Depth Estimation** | Depth Anything V2 | #11, #14 |
| **Pose Estimation** | MediaPipe Pose/Hands | #4, #13 |
| **Segmentation** | TinySAM, rembg | #1, #14 |
| **Embeddings/Search** | MiniLM + ChromaDB | #1, #2, #5, #8, #10, #14 |
| **Text Generation** | Qwen2-1.5B-Q4 | #2, #8, #9, #10, #12 |
| **Reinforcement Learning** | DQN/PPO | #6 |
| **Music/Audio** | MusicGen, Piper TTS | #3, #9, #12 |
| **Image-Text Matching** | CLIP ViT-B/32 | #10 |
| **3D Processing** | PyTorch3D | #11 |

No two projects share the same GPU model stack.

---

## Difficulty & Wow-Factor Summary

| # | Project | Difficulty | Wow-Factor | Fun Factor | Resume Signal |
|---|---|---|---|---|---|
| 1 | PixelRevive | Standard | Very High | High | AI image pipeline |
| 2 | SnapChef | Standard | High | High | Vision + GenAI product |
| 3 | SoundForge | Standard | Very High | Very High | Audio AI (rare skill) |
| 4 | FormCheck | Standard | High | High | Pose estimation + CV |
| 5 | HawkEye | Standard | High | High | Video analytics system |
| 6 | GameBrain | Challenging | Extreme | Extreme | RL + systems programming |
| 7 | ArtForge | Standard | Very High | Very High | Real-time GPU rendering |
| 8 | EchoScribe | Standard | High | High | Full-stack AI product |
| 9 | VoxLingua | Standard | High | Very High | Speech AI pipeline |
| 10 | MemeForge | Standard | Very High | Extreme | Multimodal AI |
| 11 | Scene3D | Challenging | Extreme | High | 3D vision (rare skill) |
| 12 | StoryQuest | Challenging | Extreme | Extreme | GenAI product design |
| 13 | SignReader | Challenging | Extreme | High | Accessibility AI |
| 14 | PixelPlayground | Standard+ | Very High | Very High | 6-model AI toolkit |

---

## Team Role Template

| Role | Responsibility | Primary GPU Work |
|---|---|---|
| **Vision / Perception Lead** | Image/video AI models | PyTorch + CUDA inference |
| **NLP / Language Lead** | Text generation, translation, classification | LLM inference on GPU |
| **Embeddings / Search Lead** | Vector databases, similarity search, RAG | Embedding generation on GPU |
| **Product / Integration Lead** | UI, API, deployment, module aggregation | Vibe-coded frontend + Blaze integration |
| *(5th member)* | Audio / additional modality | TTS/STT or extra CV model |

---

## Data Flow Architecture

```
Student's Phone/Laptop                    LaaaS Node                        GPU Container (Selkies Desktop)
┌──────────────────┐                    ┌──────────────────┐                ┌──────────────────────────┐
│                  │                    │                  │                │                          │
│  Record video /  │── HTTPS upload ──▶│  LaaS Web UI    │── NFS/ZFS ──▶│  /home/ubuntu/            │
│  take photo /    │    (port 443)     │  (port 80/443)  │   mount       │    uploads/               │
│  record audio    │                    │                  │                │                          │
│                  │                    │                  │                │  Python script reads     │
│  OR paste URL    │── text input ────▶│  Selkies Desktop │── keyboard ──▶│    file → GPU processes  │
│  (YouTube etc.)  │    (port 81XX)    │  (port 81XX)    │   input        │    → result displayed    │
│                  │                    │                  │                │                          │
│                  │                    │                  │                │  OR: yt-dlp downloads    │
│                  │                    │                  │                │    from URL → GPU        │
│                  │                    │                  │                │    processes video       │
│                  │                    │                  │                │                          │
└──────────────────┘                    └──────────────────┘                └──────────────────────────┘
```

**No live webcam. No live microphone. No live telemetry.** All GPU processing happens on pre-recorded, uploaded, or URL-fetched media.

---

## Recommended Team Distribution

| Team | Project | Difficulty | Notes |
|---|---|---|---|
| 1 | PixelRevive | Standard | |
| 2 | SnapChef | Standard | |
| 3 | SoundForge | Standard | Music AI is unique differentiator |
| 4 | FormCheck | Standard | |
| 5 | HawkEye | Standard | |
| 6 | GameBrain | Challenging | Assign to stronger team |
| 7 | ArtForge | Standard | |
| 8 | EchoScribe | Standard | |
| 9 | VoxLingua | Standard | |
| 10 | MemeForge | Standard | Maximum fun factor |
| 11 | Scene3D | Challenging | Assign to stronger team |
| 12 | StoryQuest | Challenging | Assign to creative team |
| 13 | SignReader | Challenging | Assign to stronger team |
| 14 | PixelPlayground | Standard+ | **5-person team** (extra member) |
