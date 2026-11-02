#!/usr/bin/env bash
# Bootstrap this configuration on Ubuntu 24.04+; run as your regular user.
set -Eeuo pipefail
trap 'printf "\nSetup failed at line %s. Fix the error above and rerun ./configure.sh.\n" "$LINENO" >&2' ERR

usage() {
  cat <<'EOF'
Usage: ./configure.sh [--dry-run] [--skip-tex] [--skip-font] [--nvim PATH]

Installs Ubuntu packages (using sudo), user-local tools, plugins, Mason tools,
Tree-sitter parsers and a Nerd Font. Safe to rerun: existing tools are reused.
Run from a clone located at ${XDG_CONFIG_HOME:-$HOME/.config}/nvim.

  --dry-run    Show the plan without downloads or changes.
  --skip-tex   Skip latexmk and TeX Live (the largest system dependencies).
  --skip-font  Skip installing JetBrainsMono Nerd Font.
  --nvim PATH  Use an existing Neovim >= 0.11 executable, including an AppImage.
  -h, --help   Show this help.

Tools are installed under ~/.local/bin and ~/.local/opt. Plugins use Neovim's
XDG data directory. Internet access and sudo access are required. No PPAs are
added. Terminal font selection is manual. Existing shell aliases are preserved.
EOF
}
log() { printf '\n==> %s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
DRY_RUN=0
SKIP_TEX=0
SKIP_FONT=0
NVIM_EXECUTABLE=''
while (($#)); do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --skip-tex) SKIP_TEX=1 ;;
    --skip-font) SKIP_FONT=1 ;;
    --nvim)
      (($# >= 2)) || die '--nvim requires a path.'
      NVIM_EXECUTABLE=$2
      shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown argument: $1 (see --help)." ;;
  esac
  shift
done

# shellcheck source=/dev/null
source /etc/os-release
[[ ${ID:-} == ubuntu ]] || die 'This script supports Ubuntu only.'
dpkg --compare-versions "${VERSION_ID:-0}" ge 24.04 || die 'Ubuntu 24.04 or newer is required.'
case $(uname -m) in
  x86_64) NVIM_ARCH=x86_64; NODE_ARCH=x64; YAZI_ARCH=x86_64; LAZYGIT_ARCH=x86_64 ;;
  aarch64|arm64) NVIM_ARCH=arm64; NODE_ARCH=arm64; YAZI_ARCH=aarch64; LAZYGIT_ARCH=arm64 ;;
  *) die 'Only x86-64 and ARM64 are supported.' ;;
esac

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/nvim
[[ -d $CONFIG_DIR && $(realpath -- "$CONFIG_DIR") == "$REPO_DIR" ]] ||
  die "Clone this repository into $CONFIG_DIR before running the script. Existing configurations are never replaced."
[[ ${NVIM_APPNAME:-nvim} == nvim ]] || die 'Unset NVIM_APPNAME to configure the standard nvim profile.'

PACKAGES=(
  ca-certificates curl git build-essential cmake pkg-config unzip zip xz-utils
  python3 python3-pip python3-venv gdb cppcheck php-cli composer
  ripgrep fd-find xclip wl-clipboard xdg-utils libfuse2t64
  zathura zathura-pdf-poppler firefox fontconfig
  ffmpeg 7zip jq poppler-utils imagemagick fzf file
)
if (( ! SKIP_TEX )); then
  PACKAGES+=(latexmk texlive-latex-extra texlive-science texlive-fonts-recommended texlive-bibtex-extra biber)
fi

log "Ubuntu $VERSION_ID: system packages"
printf '  %s\n' "${PACKAGES[*]}"
log 'User tools: Neovim >= 0.11, Node.js >= 22, Yazi, lazygit, fd'
log 'Neovim: locked plugins, Markdown preview, Mason tools, Tree-sitter parsers'
if (( ! SKIP_FONT )); then log 'Font: JetBrainsMono Nerd Font'; fi
if (( DRY_RUN )); then
  printf '\nDry run complete. No files were changed and nothing was downloaded.\n'
  exit 0
fi
(( EUID != 0 )) || die 'Run as your regular user, not with sudo; the script invokes sudo for APT.'
command -v sudo >/dev/null || die 'sudo is required to install Ubuntu packages.'
sudo -v
sudo apt-get update
# Firefox uses Ubuntu's supported Snap-backed package on Ubuntu 24.04.
sudo apt-get install -y "${PACKAGES[@]}"

BIN_DIR=$HOME/.local/bin
OPT_DIR=$HOME/.local/opt
mkdir -p "$BIN_DIR" "$OPT_DIR"
export PATH="$BIN_DIR:$PATH"
WORK_DIR=$(mktemp -d -t nvim-configure.XXXXXXXX)
trap 'rm -rf -- "$WORK_DIR"' EXIT

fetch() { curl --fail --location --silent --show-error --retry 3 --connect-timeout 30 "$1" -o "$2"; }

# Select official GitHub assets by name, including releases that change casing.
# GitHub's SHA256 asset digest is checked when the release API supplies one.
release_asset() {
  local repo=$1 pattern=$2 destination=$3 metadata asset_url digest
  metadata="$WORK_DIR/${repo//\//-}.json"
  [[ -f $metadata ]] || fetch "https://api.github.com/repos/$repo/releases/latest" "$metadata"
  IFS=' ' read -r asset_url digest < <(python3 - "$metadata" "$pattern" <<'PY'
import fnmatch, json, sys
with open(sys.argv[1]) as stream:
    release = json.load(stream)
assets = [a for a in release['assets'] if fnmatch.fnmatchcase(a['name'].lower(), sys.argv[2].lower())]
if len(assets) != 1:
    sys.exit('Expected one release asset matching ' + sys.argv[2])
print(assets[0]['browser_download_url'], assets[0].get('digest') or '-')
PY
  ) || die "Cannot select $repo asset $pattern."
  [[ $asset_url == https://github.com/* ]] || die "Invalid release URL for $repo."
  fetch "$asset_url" "$destination"
  if [[ $digest == sha256:* ]]; then
    printf '%s  %s\n' "${digest#sha256:}" "$destination" | sha256sum --check --status
  fi
}

log 'Checking Node.js'
if ! command -v node >/dev/null || ! node -e 'process.exit(Number(process.versions.node.split(".")[0]) >= 22 ? 0 : 1)' || ! command -v npm >/dev/null; then
  # Install the official Node 24 LTS binary without replacing Ubuntu packages.
  fetch https://nodejs.org/dist/latest-v24.x/SHASUMS256.txt "$WORK_DIR/node-checksums"
  NODE_ARCHIVE=$(awk -v suffix="-linux-$NODE_ARCH.tar.xz" '$2 ~ (suffix "$") { print $2 }' "$WORK_DIR/node-checksums")
  [[ $NODE_ARCHIVE =~ ^node-v24\.[0-9]+\.[0-9]+-linux-(x64|arm64)\.tar\.xz$ ]] || die 'Cannot locate the Node.js archive.'
  fetch "https://nodejs.org/dist/latest-v24.x/$NODE_ARCHIVE" "$WORK_DIR/$NODE_ARCHIVE"
  (cd "$WORK_DIR" && awk -v archive="$NODE_ARCHIVE" '$2 == archive' node-checksums | sha256sum --check --status)
  tar -xJf "$WORK_DIR/$NODE_ARCHIVE" -C "$OPT_DIR"
  NODE_DIR=$OPT_DIR/${NODE_ARCHIVE%.tar.xz}
  for executable in node npm npx; do ln -sfn "$NODE_DIR/bin/$executable" "$BIN_DIR/$executable"; done
fi

compatible_nvim() {
  [[ -x $1 ]] && "$1" --clean --headless '+lua if vim.fn.has("nvim-0.11") == 0 then vim.cmd("cquit 1") end' '+qa!' >/dev/null 2>&1
}
log 'Checking Neovim'
if [[ -n $NVIM_EXECUTABLE ]]; then
  NVIM_EXECUTABLE=$(realpath -- "$NVIM_EXECUTABLE")
  compatible_nvim "$NVIM_EXECUTABLE" || die '--nvim must point to a working Neovim >= 0.11 executable.'
elif compatible_nvim "$(command -v nvim || true)"; then
  NVIM_EXECUTABLE=$(command -v nvim)
elif compatible_nvim "$HOME/Executables/nvim-linux-$NVIM_ARCH.appimage"; then
  NVIM_EXECUTABLE=$HOME/Executables/nvim-linux-$NVIM_ARCH.appimage
else
  release_asset neovim/neovim "nvim-linux-$NVIM_ARCH.tar.gz" "$WORK_DIR/nvim.tar.gz"
  tar -xzf "$WORK_DIR/nvim.tar.gz" -C "$OPT_DIR"
  NVIM_EXECUTABLE=$OPT_DIR/nvim-linux-$NVIM_ARCH/bin/nvim
  compatible_nvim "$NVIM_EXECUTABLE" || die 'Downloaded Neovim failed its version check.'
fi
# Use a PATH executable so other applications can launch the same Neovim.
if [[ $(realpath -- "$NVIM_EXECUTABLE") != "$(realpath -m -- "$BIN_DIR/nvim")" ]]; then
  ln -sfn "$NVIM_EXECUTABLE" "$BIN_DIR/nvim"
fi

log 'Checking Yazi and lazygit'
if ! command -v yazi >/dev/null; then
  release_asset sxyazi/yazi "yazi-$YAZI_ARCH-unknown-linux-musl.zip" "$WORK_DIR/yazi.zip"
  unzip -q "$WORK_DIR/yazi.zip" -d "$WORK_DIR/yazi"
  install -m 0755 "$WORK_DIR/yazi/yazi-$YAZI_ARCH-unknown-linux-musl/yazi" "$BIN_DIR/yazi"
  install -m 0755 "$WORK_DIR/yazi/yazi-$YAZI_ARCH-unknown-linux-musl/ya" "$BIN_DIR/ya"
fi
if ! command -v lazygit >/dev/null; then
  release_asset jesseduffield/lazygit "lazygit_*_linux_$LAZYGIT_ARCH.tar.gz" "$WORK_DIR/lazygit.tar.gz"
  tar -xzf "$WORK_DIR/lazygit.tar.gz" -C "$WORK_DIR" lazygit
  install -m 0755 "$WORK_DIR/lazygit" "$BIN_DIR/lazygit"
fi
if ! command -v fd >/dev/null && command -v fdfind >/dev/null; then
  ln -sfn "$(command -v fdfind)" "$BIN_DIR/fd"
fi

if (( ! SKIP_FONT )); then
  FONT_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerd
  if [[ ! -f $FONT_DIR/.configured ]]; then
    log 'Installing JetBrainsMono Nerd Font'
    release_asset ryanoasis/nerd-fonts JetBrainsMono.tar.xz "$WORK_DIR/font.tar.xz"
    mkdir -p "$WORK_DIR/fonts" "$FONT_DIR"
    tar -xJf "$WORK_DIR/font.tar.xz" -C "$WORK_DIR/fonts"
    find "$WORK_DIR/fonts" -type f -name '*.ttf' -exec install -m 0644 -t "$FONT_DIR" {} +
    fc-cache -f "$FONT_DIR"
    touch "$FONT_DIR/.configured"
  fi
fi

# Bash login and interactive shells both need access to the user-local tools.
# Preserve existing aliases, including any nvim AppImage alias.
for rc_file in "$HOME/.profile" "$HOME/.bashrc"; do
  if ! grep -qF '# nvim-configure: user tools' "$rc_file" 2>/dev/null; then
    cat >> "$rc_file" <<'EOF'

# nvim-configure: user tools
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF
  fi
done

log 'Installing Neovim plugins and development tools (this may take several minutes)'
export NVIM_CONFIGURE_DIR=$REPO_DIR
# Isolate provisioning from normal startup: automatic Mason/parser installs in
# the configuration would otherwise race the synchronous installers below.
"$NVIM_EXECUTABLE" --headless -u NONE -l "$REPO_DIR/scripts/bootstrap.lua"

log 'Configuration complete'
printf 'Neovim: %s\n' "$NVIM_EXECUTABLE"
printf '%s\n' \
  'Open a new terminal (or run: source ~/.bashrc).' \
  'Select JetBrainsMono Nerd Font in your terminal settings.' \
  'Start nvim and run :checkhealth to check desktop/session-specific features.' \
  'Existing shell aliases were preserved; an old nvim alias still takes precedence over PATH.'
