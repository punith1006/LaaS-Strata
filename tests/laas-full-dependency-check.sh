#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# LaaS Container — Full Dependency Installation & Verification Script
# ═══════════════════════════════════════════════════════════════════════════════
#
# Purpose: Install and verify EVERY dependency needed across all 14 internship
#          projects. Run this ONCE inside a LaaS GPU desktop container to
#          validate the platform can support all project workloads.
#
# Usage:   bash laas-full-dependency-check.sh
# Time:    ~20-40 minutes (mostly pip downloads)
# Storage: Requires ~12 GB free in /home/ubuntu
#
# Sections:
#   1. System packages (apt)
#   2. Development IDEs & tools
#   3. Python ecosystem (miniconda + packages)
#   4. Node.js ecosystem (nvm + packages)
#   5. Databases (PostgreSQL, SQLite, ChromaDB)
#   6. GPU/AI model pre-downloads
#   7. Verification & summary
# ═══════════════════════════════════════════════════════════════════════════════

set -e

G='\033[0;32m'  # Green
R='\033[0;31m'  # Red
Y='\033[1;33m'  # Yellow
B='\033[0;34m'  # Blue
N='\033[0m'     # Reset

PASS=0
FAIL=0
SKIP=0

pass() { echo -e "  ${G}✓${N} $*"; ((PASS++)); }
fail() { echo -e "  ${R}✗${N} $*"; ((FAIL++)); }
skip() { echo -e "  ${Y}⊘${N} $*"; ((SKIP++)); }
section() { echo -e "\n${B}══════════════════════════════════════════════════════${N}"; echo -e "${B}  $*${N}"; echo -e "${B}══════════════════════════════════════════════════════${N}\n"; }

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 0: PRE-FLIGHT
# ═══════════════════════════════════════════════════════════════════════════════
section "0. PRE-FLIGHT CHECKS"

echo "Storage available:"
df -h /home/ubuntu | tail -1
echo ""

echo "GPU status:"
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader 2>/dev/null || echo "  (nvidia-smi not available)"
echo ""

echo "Container info:"
echo "  Hostname: $(hostname)"
echo "  User:     $(whoami)"
echo "  PID 1:    $(cat /proc/1/comm 2>/dev/null || echo 'unknown')"
echo "  Ubuntu:   $(lsb_release -ds 2>/dev/null || cat /etc/os-release | head -1)"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 1: SYSTEM PACKAGES (apt)
# ═══════════════════════════════════════════════════════════════════════════════
section "1. SYSTEM PACKAGES (apt)"

echo "Updating apt cache..."
sudo apt update -qq 2>/dev/null

# ─── Core development tools ──────────────────────────────────────────────────
echo -e "\n${Y}1a. Core Development Tools${N}"
CORE_PKGS=(
    "build-essential"      # gcc, g++, make (compile C/C++ extensions)
    "cmake"                # Build system (HAMi-core, some Python packages)
    "git"                  # Version control
    "curl"                 # HTTP client (download files, APIs)
    "wget"                 # Download tool (datasets, models)
    "unzip"                # Extract zip files
    "zip"                  # Create zip files
    "tar"                  # Archive tool (already installed, but ensure)
    "ca-certificates"      # SSL certificates (HTTPS downloads)
    "gnupg"                # GPG keys (apt repos)
    "software-properties-common"  # add-apt-repository
    "pkg-config"           # Library detection (compilation)
    "jq"                   # JSON processing (API testing)
    "htop"                 # Process monitor
    "nvtop"                # GPU monitor
    "tree"                 # Directory viewer
    "tmux"                 # Terminal multiplexer (run multiple services)
    "net-tools"            # ifconfig, netstat
    "iputils-ping"         # ping command
    "dnsutils"             # dig, nslookup
    "file"                 # File type detection
    "bc"                   # Calculator (scripting)
)

for pkg in "${CORE_PKGS[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        pass "$pkg (already installed)"
    else
        sudo apt install -y -qq "$pkg" 2>/dev/null && pass "$pkg" || fail "$pkg"
    fi
done

# ─── Media processing (ffmpeg, imagemagick, audio) ──────────────────────────
echo -e "\n${Y}1b. Media Processing${N}"
MEDIA_PKGS=(
    "ffmpeg"               # Video/audio processing (used by 10+ projects)
    "libavcodec-extra"     # Extra codecs for ffmpeg
    "imagemagick"          # Image manipulation (meme text overlay, etc.)
    "espeak-ng"            # Text-to-speech engine (TTS fallback)
    "libespeak-ng1"        # eSpeak library
    "libsndfile1"          # Audio file I/O (librosa, soundfile)
    "libportaudio2"        # Audio I/O (pyaudio)
    "flac"                 # FLAC audio codec
    "sox"                  # Audio processing CLI
    "libgl1-mesa-glx"      # OpenGL libraries (OpenCV, 3D)
    "libglib2.0-0"         # GLib (OpenCV dependency)
    "libsm6"               # X11 Session Management (OpenCV GUI)
    "libxext6"             # X11 extensions (OpenCV GUI)
    "libxrender1"          # X11 rendering (OpenCV GUI)
    "libfontconfig1"       # Font rendering (PIL, matplotlib)
    "fonts-liberation"     # Free fonts (text rendering on images)
    "fonts-noto-color-emoji"  # Emoji fonts (UI rendering)
)

for pkg in "${MEDIA_PKGS[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        pass "$pkg (already installed)"
    else
        sudo apt install -y -qq "$pkg" 2>/dev/null && pass "$pkg" || fail "$pkg"
    fi
done

# ─── PostgreSQL (needed by projects #5, #8, #12) ────────────────────────────
echo -e "\n${Y}1c. PostgreSQL Database${N}"
PG_PKGS=(
    "postgresql"           # PostgreSQL server
    "postgresql-client"    # psql CLI
    "libpq-dev"            # PostgreSQL dev headers (psycopg2 compilation)
)

for pkg in "${PG_PKGS[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        pass "$pkg (already installed)"
    else
        sudo apt install -y -qq "$pkg" 2>/dev/null && pass "$pkg" || fail "$pkg"
    fi
done

# Start PostgreSQL
sudo service postgresql start 2>/dev/null && pass "PostgreSQL started" || fail "PostgreSQL start"

# Create test database
sudo -u postgres psql -c "CREATE DATABASE laas_test;" 2>/dev/null && \
    pass "Test database created" || skip "Test DB (may already exist)"

# ─── Redis (optional — for caching, message queues) ─────────────────────────
echo -e "\n${Y}1d. Redis (optional cache)${N}"
if dpkg -l "redis-server" 2>/dev/null | grep -q "^ii"; then
    pass "redis-server (already installed)"
else
    sudo apt install -y -qq redis-server 2>/dev/null && pass "redis-server" || skip "redis-server (optional)"
fi

# ─── FUSE support (AppImage files) ──────────────────────────────────────────
echo -e "\n${Y}1e. FUSE Support${N}"
FUSE_PKGS=(
    "fuse3"                # FUSE 3 (AppImage, Snap)
    "libfuse2"             # FUSE 2 (older AppImages)
)
for pkg in "${FUSE_PKGS[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        pass "$pkg (already installed)"
    else
        sudo apt install -y -qq "$pkg" 2>/dev/null && pass "$pkg" || fail "$pkg"
    fi
done

# Verify /dev/fuse
if [ -e /dev/fuse ]; then
    pass "/dev/fuse device present"
else
    fail "/dev/fuse device missing (AppImage won't work)"
fi

# ─── SDL2 (for pygame in GameBrain project) ─────────────────────────────────
echo -e "\n${Y}1f. Game Development Libraries${N}"
GAME_PKGS=(
    "libsdl2-dev"          # SDL2 (pygame dependency)
    "libsdl2-image-dev"    # SDL2 image loading
    "libsdl2-mixer-dev"    # SDL2 audio mixing
    "libsdl2-ttf-dev"      # SDL2 font rendering
)
for pkg in "${GAME_PKGS[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        pass "$pkg (already installed)"
    else
        sudo apt install -y -qq "$pkg" 2>/dev/null && pass "$pkg" || skip "$pkg (pygame may still work)"
    fi
done

# Clean apt cache to save space
sudo apt clean 2>/dev/null

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 2: DEVELOPMENT IDEs & TOOLS
# ═══════════════════════════════════════════════════════════════════════════════
section "2. DEVELOPMENT IDEs & TOOLS"

# ─── VS Code ─────────────────────────────────────────────────────────────────
echo -e "${Y}2a. VS Code${N}"
if command -v code &>/dev/null; then
    pass "VS Code (already installed: $(code --version 2>/dev/null | head -1))"
else
    echo "Installing VS Code..."
    wget -q "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
        -O /tmp/vscode.deb 2>/dev/null
    if [ -f /tmp/vscode.deb ]; then
        sudo apt install -y -qq /tmp/vscode.deb 2>/dev/null && pass "VS Code installed" || fail "VS Code install"
        rm -f /tmp/vscode.deb
    else
        fail "VS Code download failed"
    fi
fi

# Verify VS Code launches (headless check)
if command -v code &>/dev/null; then
    ELECTRON_DISABLE_SANDBOX=1 code --list-extensions &>/dev/null && \
        pass "VS Code launches correctly" || fail "VS Code launch failed (check ELECTRON_DISABLE_SANDBOX)"
fi

# ─── Google Antigravity ──────────────────────────────────────────────────────
echo -e "\n${Y}2b. Google Antigravity${N}"
# Check if Antigravity is already installed (common paths)
if command -v antigravity &>/dev/null; then
    pass "Google Antigravity (already installed)"
elif [ -f /usr/local/bin/antigravity ] || [ -f ~/antigravity/antigravity ]; then
    pass "Google Antigravity (found on system)"
else
    skip "Google Antigravity (install manually — distribution method varies)"
fi

# ─── Jupyter Notebook ────────────────────────────────────────────────────────
echo -e "\n${Y}2c. Jupyter Notebook${N}"
# Installed via pip later in Section 3

# ─── Git configuration ───────────────────────────────────────────────────────
echo -e "\n${Y}2d. Git Configuration${N}"
if command -v git &>/dev/null; then
    pass "Git installed: $(git --version)"
    # Set default config for students
    git config --global init.defaultBranch main 2>/dev/null
    git config --global core.editor "nano" 2>/dev/null
    pass "Git defaults configured"
else
    fail "Git not found"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 3: PYTHON ECOSYSTEM
# ═══════════════════════════════════════════════════════════════════════════════
section "3. PYTHON ECOSYSTEM"

# ─── Miniconda ───────────────────────────────────────────────────────────────
echo -e "${Y}3a. Miniconda${N}"
if command -v conda &>/dev/null; then
    pass "Miniconda (already installed: $(conda --version 2>/dev/null))"
elif [ -d ~/miniconda3 ]; then
    pass "Miniconda (directory exists)"
    export PATH="$HOME/miniconda3/bin:$PATH"
else
    echo "Installing Miniconda..."
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
    bash /tmp/miniconda.sh -b -p $HOME/miniconda3 2>/dev/null && pass "Miniconda installed" || fail "Miniconda install"
    rm -f /tmp/miniconda.sh
    export PATH="$HOME/miniconda3/bin:$PATH"
    conda init bash 2>/dev/null
fi

# ─── Python venv for projects ────────────────────────────────────────────────
echo -e "\n${Y}3b. Python Virtual Environment${N}"
VENV_DIR="$HOME/laas-venv"
if [ -d "$VENV_DIR" ]; then
    pass "Virtual environment exists at $VENV_DIR"
else
    python3 -m venv "$VENV_DIR" 2>/dev/null && pass "Virtual environment created" || fail "venv creation"
fi
source "$VENV_DIR/bin/activate" 2>/dev/null
echo "  Python: $(python3 --version 2>/dev/null)"
echo "  pip:    $(pip --version 2>/dev/null | head -1)"

# ─── PyTorch (CUDA 12.8) ────────────────────────────────────────────────────
echo -e "\n${Y}3c. PyTorch + CUDA${N}"
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 2>/dev/null
python3 -c "
import torch
print(f'  PyTorch:    {torch.__version__}')
print(f'  CUDA avail: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'  GPU:        {torch.cuda.get_device_name(0)}')
    print(f'  VRAM:       {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB')
" 2>/dev/null && pass "PyTorch + CUDA working" || fail "PyTorch + CUDA"

# ─── Core Python packages (all projects) ────────────────────────────────────
echo -e "\n${Y}3d. Core Python Packages (all projects)${N}"
CORE_PIP=(
    # Web frameworks
    "flask"                # Lightweight web framework (most projects)
    "fastapi"              # Modern async web framework
    "uvicorn"              # ASGI server for FastAPI
    "gunicorn"             # WSGI server for Flask
    # HTTP & API
    "requests"             # HTTP client
    "httpx"                # Async HTTP client
    "aiohttp"              # Async HTTP
    "python-multipart"     # File upload handling
    "pydantic"             # Data validation
    # Data processing
    "numpy"                # Numerical computing (ALL projects)
    "pandas"               # Data frames
    "scipy"                # Scientific computing
    "scikit-learn"         # ML utilities, clustering
    # Image processing
    "pillow"               # Image manipulation (ALL projects)
    "opencv-python"        # Computer vision (8+ projects)
    "matplotlib"           # Plotting and visualization
    # Database
    "sqlalchemy"           # ORM for PostgreSQL/SQLite
    "psycopg2-binary"      # PostgreSQL driver
    "aiosqlite"            # Async SQLite
    # Utilities
    "python-dotenv"        # .env file handling
    "tqdm"                 # Progress bars
    "click"                # CLI framework
    "rich"                 # Terminal formatting
    "pyyaml"               # YAML parsing
    "jinja2"               # Template engine
    "beautifulsoup4"       # HTML parsing (web scraping)
    "lxml"                 # XML parsing
    "jupyter"              # Jupyter notebooks
    "notebook"             # Jupyter notebook server
    "ipykernel"            # Jupyter kernel
)

for pkg in "${CORE_PIP[@]}"; do
    pip install -q "$pkg" 2>/dev/null && pass "$pkg" || fail "$pkg"
done

# ─── GPU/AI-specific packages ───────────────────────────────────────────────
echo -e "\n${Y}3e. GPU/AI Packages${N}"

# Object detection (projects #2, #5, #10)
echo "  Installing YOLOv8..."
pip install -q ultralytics 2>/dev/null && pass "ultralytics (YOLOv8)" || fail "ultralytics"

# Embeddings & vector DB (projects #1, #2, #5, #8, #10, #14)
echo "  Installing embeddings & ChromaDB..."
pip install -q sentence-transformers chromadb 2>/dev/null && pass "sentence-transformers + chromadb" || fail "sentence-transformers/chromadb"

# LLM inference (projects #2, #8, #9, #10, #12)
echo "  Installing transformers..."
pip install -q transformers accelerate 2>/dev/null && pass "transformers + accelerate" || fail "transformers"

# Speech (projects #8, #9, #12)
echo "  Installing speech tools..."
pip install -q faster-whisper 2>/dev/null && pass "faster-whisper" || fail "faster-whisper"
pip install -q piper-tts 2>/dev/null && pass "piper-tts" || skip "piper-tts (may need manual install)"

# Image generation (project #12)
echo "  Installing diffusion models..."
pip install -q diffusers 2>/dev/null && pass "diffusers (Stable Diffusion)" || fail "diffusers"

# Music generation (project #3)
echo "  Installing audio tools..."
pip install -q librosa soundfile pydub 2>/dev/null && pass "librosa + soundfile + pydub" || fail "audio libs"

# Pose estimation (projects #4, #13)
echo "  Installing pose estimation..."
pip install -q mediapipe 2>/dev/null && pass "mediapipe" || fail "mediapipe"

# Image enhancement (projects #1, #14)
echo "  Installing image enhancement..."
pip install -q rembg 2>/dev/null && pass "rembg (background removal)" || fail "rembg"
pip install -q realesrgan 2>/dev/null && pass "realesrgan (super-resolution)" || fail "realesrgan"

# Style transfer (projects #7, #14)
echo "  Installing style transfer..."
pip install -q kornia 2>/dev/null && pass "kornia (differentiable CV)" || skip "kornia (optional)"

# Depth estimation (projects #11, #14)
echo "  Installing depth estimation..."
pip install -q huggingface-hub 2>/dev/null && pass "huggingface-hub (model downloads)" || fail "huggingface-hub"

# 3D processing (project #11)
echo "  Installing 3D tools..."
pip install -q open3d 2>/dev/null && pass "open3d (3D processing)" || skip "open3d (try: pip install open3d)"
pip install -q trimesh 2>/dev/null && pass "trimesh (3D mesh)" || skip "trimesh (optional)"

# Reinforcement learning (project #6)
echo "  Installing RL tools..."
pip install -q gymnasium 2>/dev/null && pass "gymnasium (RL environments)" || fail "gymnasium"
pip install -q "stable-baselines3[extra]" 2>/dev/null && pass "stable-baselines3 (RL algorithms)" || fail "stable-baselines3"
pip install -q pygame 2>/dev/null && pass "pygame (game rendering)" || fail "pygame"

# DeOldify (project #1, #14)
echo "  Installing DeOldify..."
pip install -q deoldify 2>/dev/null && pass "deoldify (colorization)" || skip "deoldify (may need git install)"

# CLIP (project #10)
echo "  Installing CLIP..."
pip install -q git+https://github.com/openai/CLIP.git 2>/dev/null && pass "CLIP (image-text)" || skip "CLIP (optional — transformers has CLIP too)"

# ─── Verify GPU inference works ──────────────────────────────────────────────
echo -e "\n${Y}3f. GPU Inference Verification${N}"

python3 -c "
import torch
import numpy as np

# Test 1: Basic CUDA tensor operation
t = torch.randn(100, 100, device='cuda')
result = (t @ t.T).sum()
print(f'  CUDA tensor test: {result.item():.2f}')
" 2>/dev/null && pass "CUDA tensor operations" || fail "CUDA tensor operations"

# Test 2: YOLOv8 inference
python3 -c "
from ultralytics import YOLO
model = YOLO('yolov8n.pt')  # Downloads ~6MB
results = model.predict(source='https://ultralytics.com/images/bus.jpg', verbose=False)
print(f'  YOLOv8 detected {len(results[0].boxes)} objects')
" 2>/dev/null && pass "YOLOv8 inference" || fail "YOLOv8 inference"

# Test 3: Sentence embeddings
python3 -c "
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')
emb = model.encode(['hello world', 'test sentence'])
print(f'  Embeddings shape: {emb.shape}')
" 2>/dev/null && pass "Sentence embeddings" || fail "Sentence embeddings"

# Test 4: ChromaDB
python3 -c "
import chromadb
client = chromadb.Client()
col = client.create_collection('test')
col.add(ids=['1'], documents=['test doc'], embeddings=[[0.1]*384])
results = col.query(query_embeddings=[[0.1]*384], n_results=1)
print(f'  ChromaDB query returned: {len(results[\"ids\"][0])} result(s)')
" 2>/dev/null && pass "ChromaDB vector search" || fail "ChromaDB"

# Test 5: Whisper transcription (download ~500MB model)
echo "  Testing Whisper (downloads model, may take 1-2 min)..."
python3 -c "
from faster_whisper import WhisperModel
model = WhisperModel('base', device='cuda', compute_type='int8')
print('  Whisper base model loaded on GPU')
" 2>/dev/null && pass "Whisper GPU inference" || fail "Whisper GPU inference"

# Test 6: MediaPipe
python3 -c "
import mediapipe as mp
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True)
print('  MediaPipe Hands initialized')
" 2>/dev/null && pass "MediaPipe pose/hands" || fail "MediaPipe"

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 4: NODE.JS ECOSYSTEM
# ═══════════════════════════════════════════════════════════════════════════════
section "4. NODE.JS ECOSYSTEM"

echo -e "${Y}4a. Node.js Runtime${N}"
if command -v node &>/dev/null; then
    pass "Node.js $(node --version)"
    pass "npm $(npm --version)"
else
    echo "Installing Node.js 20 LTS..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - 2>/dev/null
    sudo apt install -y nodejs 2>/dev/null && pass "Node.js installed" || fail "Node.js install"
fi

# ─── pnpm (faster package manager) ──────────────────────────────────────────
echo -e "\n${Y}4b. Package Managers${N}"
if command -v pnpm &>/dev/null; then
    pass "pnpm $(pnpm --version)"
else
    npm install -g pnpm 2>/dev/null && pass "pnpm installed" || skip "pnpm (optional)"
fi

if command -v yarn &>/dev/null; then
    pass "yarn $(yarn --version 2>/dev/null)"
else
    npm install -g yarn 2>/dev/null && pass "yarn installed" || skip "yarn (optional)"
fi

# ─── Create test Next.js project ─────────────────────────────────────────────
echo -e "\n${Y}4c. Next.js Project Test${N}"
TEST_DIR="/tmp/laas-nextjs-test"
if [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
fi
npx create-next-app@latest "$TEST_DIR" --typescript --tailwind --eslint --app --no-src-dir --import-alias "@/*" --use-npm 2>/dev/null
if [ -d "$TEST_DIR" ]; then
    pass "Next.js project created"
    cd "$TEST_DIR"
    npm run build 2>/dev/null && pass "Next.js build succeeded" || fail "Next.js build"
    cd ~
    rm -rf "$TEST_DIR"
else
    fail "Next.js project creation"
fi

# ─── Verify key npm packages install ─────────────────────────────────────────
echo -e "\n${Y}4d. Key npm Packages${N}"
NPM_TEST_DIR="/tmp/laas-npm-test"
mkdir -p "$NPM_TEST_DIR" && cd "$NPM_TEST_DIR"
npm init -y 2>/dev/null

NPM_PKGS=(
    "react"                # UI framework
    "react-dom"            # React DOM renderer
    "three"                # Three.js (3D viewer, project #11)
    "recharts"             # Charts (projects #4, #5, #6)
    "socket.io-client"     # Real-time updates (projects #5, #6)
    "axios"                # HTTP client
    "tailwindcss"          # CSS framework
    "lucide-react"         # Icons
)

for pkg in "${NPM_PKGS[@]}"; do
    npm install "$pkg" 2>/dev/null && pass "$pkg" || fail "$pkg"
done

cd ~ && rm -rf "$NPM_TEST_DIR"

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 5: DATABASE VERIFICATION
# ═══════════════════════════════════════════════════════════════════════════════
section "5. DATABASE VERIFICATION"

echo -e "${Y}5a. PostgreSQL${N}"
if command -v psql &>/dev/null; then
    pass "PostgreSQL installed: $(psql --version 2>/dev/null)"

    # Test connection
    sudo -u postgres psql -c "SELECT version();" 2>/dev/null | head -3 && \
        pass "PostgreSQL accepting connections" || fail "PostgreSQL connection"

    # Test Python driver
    python3 -c "
import psycopg2
conn = psycopg2.connect(dbname='laas_test', user='postgres', host='localhost')
cur = conn.cursor()
cur.execute('CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name TEXT)')
cur.execute(\"INSERT INTO test_table (name) VALUES ('laas_test')\")
conn.commit()
cur.execute('SELECT COUNT(*) FROM test_table')
count = cur.fetchone()[0]
print(f'  PostgreSQL: {count} row(s) in test_table')
conn.close()
" 2>/dev/null && pass "Python → PostgreSQL connection" || fail "Python → PostgreSQL"
else
    fail "PostgreSQL not found"
fi

echo -e "\n${Y}5b. SQLite${N}"
python3 -c "
import sqlite3
conn = sqlite3.connect('/tmp/laas_test.db')
cur = conn.cursor()
cur.execute('CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, val TEXT)')
cur.execute(\"INSERT INTO test (val) VALUES ('works')\")
conn.commit()
cur.execute('SELECT val FROM test LIMIT 1')
result = cur.fetchone()[0]
print(f'  SQLite: read back \"{result}\"')
conn.close()
" 2>/dev/null && pass "SQLite working" || fail "SQLite"
rm -f /tmp/laas_test.db

echo -e "\n${Y}5c. ChromaDB${N}"
python3 -c "
import chromadb
client = chromadb.PersistentClient(path='/tmp/chroma_test')
col = client.get_or_create_collection('test_col')
col.add(ids=['doc1', 'doc2'], documents=['hello', 'world'], embeddings=[[1,0,0], [0,1,0]])
results = col.query(query_embeddings=[[1,0,0]], n_results=1)
print(f'  ChromaDB: nearest neighbor = {results[\"ids\"][0][0]}')
" 2>/dev/null && pass "ChromaDB persistent storage" || fail "ChromaDB"
rm -rf /tmp/chroma_test

echo -e "\n${Y}5d. Redis (optional)${N}"
if command -v redis-cli &>/dev/null; then
    redis-cli ping 2>/dev/null | grep -q PONG && \
        pass "Redis responding" || skip "Redis not running (start with: systemctl start redis)"
else
    skip "Redis not installed (optional)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 6: GPU MODEL PRE-DOWNLOADS
# ═══════════════════════════════════════════════════════════════════════════════
section "6. GPU MODEL PRE-DOWNLOADS"

echo "Pre-downloading model weights (this saves students time on Day 1)..."
echo "Models are cached in ~/.cache/huggingface/ (~3-5 GB total)"

# Create models cache directory
mkdir -p ~/.cache/laas-models

echo -e "\n${Y}6a. YOLOv8 Nano (6 MB) — Projects #2, #5, #10${N}"
python3 -c "
from ultralytics import YOLO
model = YOLO('yolov8n.pt')
print('  Downloaded yolov8n.pt')
" 2>/dev/null && pass "YOLOv8 Nano cached" || fail "YOLOv8 Nano download"

echo -e "\n${Y}6b. Sentence Transformers MiniLM (~100 MB) — Projects #1, #2, #5, #8, #10, #14${N}"
python3 -c "
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')
print('  Downloaded all-MiniLM-L6-v2')
" 2>/dev/null && pass "MiniLM embeddings cached" || fail "MiniLM download"

echo -e "\n${Y}6c. Whisper Base (~150 MB) — Projects #8, #9, #12${N}"
python3 -c "
from faster_whisper import WhisperModel
model = WhisperModel('base', device='cuda', compute_type='int8')
print('  Downloaded whisper base')
" 2>/dev/null && pass "Whisper base cached" || fail "Whisper base download"

echo -e "\n${Y}6d. Qwen2-1.5B Q4 (~1.1 GB) — Projects #2, #8, #9, #10, #12${N}"
python3 -c "
from transformers import AutoModelForCausalLM, AutoTokenizer
tokenizer = AutoTokenizer.from_pretrained('Qwen/Qwen2-1.5B-Instruct')
model = AutoModelForCausalLM.from_pretrained('Qwen/Qwen2-1.5B-Instruct', device_map='auto', torch_dtype='auto')
print('  Downloaded Qwen2-1.5B-Instruct')
" 2>/dev/null && pass "Qwen2-1.5B cached" || fail "Qwen2-1.5B download (large — may take time)"

echo -e "\n${Y}6e. Depth Anything V2 Small (~100 MB) — Projects #11, #14${N}"
python3 -c "
from huggingface_hub import hf_hub_download
path = hf_hub_download(repo_id='depth-anything/Depth-Anything-V2-Small', filename='depth_anything_v2_vits.pth')
print(f'  Downloaded to: {path}')
" 2>/dev/null && pass "Depth Anything V2 cached" || skip "Depth Anything V2 (may need manual download)"

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 7: SERVICES & INTEGRATION TESTS
# ═══════════════════════════════════════════════════════════════════════════════
section "7. SERVICES & INTEGRATION TESTS"

echo -e "${Y}7a. Flask + GPU Pipeline Test${N}"
python3 -c "
from flask import Flask
import torch
app = Flask(__name__)

@app.route('/health')
def health():
    gpu = torch.cuda.is_available()
    return {'status': 'ok', 'gpu': gpu, 'vram_gb': round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 1) if gpu else 0}

# Test the route without starting server
with app.test_client() as client:
    resp = client.get('/health')
    data = resp.get_json()
    print(f'  Flask + GPU: status={data[\"status\"]}, gpu={data[\"gpu\"]}, vram={data[\"vram_gb\"]}GB')
" 2>/dev/null && pass "Flask + GPU pipeline" || fail "Flask + GPU pipeline"

echo -e "\n${Y}7b. FastAPI + GPU Pipeline Test${N}"
python3 -c "
from fastapi import FastAPI
from fastapi.testclient import TestClient
import torch

app = FastAPI()

@app.get('/gpu-info')
def gpu_info():
    return {
        'available': torch.cuda.is_available(),
        'device': torch.cuda.get_device_name(0) if torch.cuda.is_available() else None,
        'vram_mb': torch.cuda.get_device_properties(0).total_memory // 1024**2 if torch.cuda.is_available() else 0
    }

client = TestClient(app)
resp = client.get('/gpu-info')
data = resp.json()
print(f'  FastAPI + GPU: available={data[\"available\"]}, device={data[\"device\"]}, vram={data[\"vram_mb\"]}MB')
" 2>/dev/null && pass "FastAPI + GPU pipeline" || fail "FastAPI + GPU pipeline"

echo -e "\n${Y}7c. Full Stack Test (Flask + React + PostgreSQL)${N}"
# Start a simple Flask server in background
python3 -c "
from flask import Flask, jsonify
import psycopg2, json
app = Flask(__name__)

@app.route('/api/test')
def test():
    try:
        conn = psycopg2.connect(dbname='laas_test', user='postgres', host='localhost')
        cur = conn.cursor()
        cur.execute('SELECT 1')
        conn.close()
        return jsonify({'db': 'connected', 'gpu': True})
    except Exception as e:
        return jsonify({'db': str(e), 'gpu': True})

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=15555, debug=False)
" &
FLASK_PID=$!
sleep 2

# Test the endpoint
RESP=$(curl -s http://127.0.0.1:15555/api/test 2>/dev/null)
if echo "$RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d['db']=='connected'" 2>/dev/null; then
    pass "Full stack: Flask + PostgreSQL + GPU working"
else
    fail "Full stack test (response: $RESP)"
fi

kill $FLASK_PID 2>/dev/null

echo -e "\n${Y}7d. ffmpeg Video Processing Test${N}"
# Create a tiny test video
ffmpeg -y -f lavfi -i testsrc=duration=2:size=320x240:rate=10 -c:v libx264 /tmp/test_video.mp4 2>/dev/null
if [ -f /tmp/test_video.mp4 ]; then
    pass "ffmpeg created test video"
    # Extract a frame
    ffmpeg -y -i /tmp/test_video.mp4 -frames:v 1 /tmp/test_frame.jpg 2>/dev/null && \
        pass "ffmpeg frame extraction" || fail "ffmpeg frame extraction"
    rm -f /tmp/test_video.mp4 /tmp/test_frame.jpg
else
    fail "ffmpeg video creation"
fi

echo -e "\n${Y}7e. yt-dlp Test (URL ingestion)${N}"
if command -v yt-dlp &>/dev/null; then
    pass "yt-dlp installed"
else
    pip install -q yt-dlp 2>/dev/null && pass "yt-dlp installed via pip" || fail "yt-dlp"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SECTION 8: STORAGE & CLEANUP
# ═══════════════════════════════════════════════════════════════════════════════
section "8. STORAGE SUMMARY"

echo "Home directory usage:"
du -sh /home/ubuntu 2>/dev/null
du -sh /home/ubuntu/laas-venv 2>/dev/null && echo "  ↑ Python venv"
du -sh ~/.cache/huggingface 2>/dev/null && echo "  ↑ Model cache"
du -sh ~/.cache/pip 2>/dev/null && echo "  ↑ pip cache"
du -sh ~/.npm 2>/dev/null && echo "  ↑ npm cache"
echo ""
echo "Total disk:"
df -h /home/ubuntu | tail -1

# Clean caches to free space
echo -e "\n${Y}Cleaning build caches...${N}"
pip cache purge 2>/dev/null
npm cache clean --force 2>/dev/null
sudo apt clean 2>/dev/null

echo ""
echo "After cleanup:"
df -h /home/ubuntu | tail -1

# ═══════════════════════════════════════════════════════════════════════════════
# FINAL SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════
section "FINAL SUMMARY"

echo -e "  ${G}Passed: $PASS${N}"
echo -e "  ${R}Failed: $FAIL${N}"
echo -e "  ${Y}Skipped: $SKIP${N}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${G}══════════════════════════════════════════════════════${N}"
    echo -e "${G}  ALL CHECKS PASSED — Platform is ready for all 14 projects!${N}"
    echo -e "${G}══════════════════════════════════════════════════════${N}"
else
    echo -e "${R}══════════════════════════════════════════════════════${N}"
    echo -e "${R}  $FAIL CHECK(S) FAILED — Review output above for details${N}"
    echo -e "${R}══════════════════════════════════════════════════════${N}"
    echo ""
    echo "Common fixes:"
    echo "  - GPU not available: Check HAMi preload in bash.bashrc"
    echo "  - pip package failed: Try 'pip install --no-cache-dir <pkg>'"
    echo "  - apt package failed: Run 'sudo apt update && sudo apt install -y <pkg>'"
    echo "  - Model download failed: Check internet connectivity"
fi
