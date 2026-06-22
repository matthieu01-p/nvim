#!/usr/bin/env bash
# Réinstalle les dépendances système de cette config Neovim sur un nouveau PC.
# Usage : cloner le repo dans ~/.config/nvim puis lancer ./bootstrap.sh
# (lazy.nvim + les plugins s'installent tout seuls au 1er lancement de nvim)
set -euo pipefail

# Outils via apt (compilation parsers, telescope, LSP node, etc.)
sudo apt update
# nodejs/npm déjà fournis par NodeSource (node 24) -> on ne les réinstalle pas
# (le paquet npm d'Ubuntu entre en conflit avec le nodejs NodeSource)
sudo apt install -y git curl gcc unzip ripgrep fd-find

mkdir -p ~/.local/bin

# fd : apt l'installe sous le nom `fdfind` ; telescope cherche `fd`
[ -e ~/.local/bin/fd ] || ln -s "$(command -v fdfind)" ~/.local/bin/fd

# Neovim (tarball officiel nightly) -> /opt/nvim, symlink dans /usr/local/bin
if ! command -v nvim >/dev/null; then
  curl -fsSL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo mv /opt/nvim-linux-x86_64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
fi

# tree-sitter CLI (>=0.26.1) -> ~/.local/bin (apt est trop vieux)
if ! command -v tree-sitter >/dev/null; then
  curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz -o /tmp/ts.gz
  gunzip -f /tmp/ts.gz && install -m755 /tmp/ts ~/.local/bin/tree-sitter
fi

# lazygit -> ~/.local/bin (requis par lazygit.nvim, absent d'apt sur Ubuntu)
if ! command -v lazygit >/dev/null; then
  lg_ver=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -oP '"tag_name": "v\K[^"]+')
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lg_ver}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz
  tar -xzf /tmp/lazygit.tar.gz -C ~/.local/bin lazygit && chmod +x ~/.local/bin/lazygit
fi

# --- Support notebooks .ipynb (jupytext + molten) ---
# ImageMagick : requis par image.nvim (processeur magick_cli) pour les plots inline
sudo apt install -y imagemagick python3-venv

# Venv hôte FIXE de Neovim : pynvim + jupyter_client pour molten, + jupytext.
# Pointé par vim.g.python3_host_prog (cf. lua/core/options.lua).
NVIM_VENV="$HOME/.local/share/nvim-host-venv"
if [ ! -d "$NVIM_VENV" ]; then python3 -m venv "$NVIM_VENV"; fi
"$NVIM_VENV/bin/pip" install -q --upgrade pip
"$NVIM_VENV/bin/pip" install -q pynvim jupyter_client jupytext ipykernel nbformat cairosvg pillow
# jupytext.nvim appelle `jupytext` en dur depuis le PATH -> symlink vers le venv hôte
ln -sf "$NVIM_VENV/bin/jupytext" ~/.local/bin/jupytext
# Enregistre molten comme remote plugin (sinon :Molten* indisponibles)
nvim --headless "+UpdateRemotePlugins" +qa 2>/dev/null || true

echo "OK — lance 'nvim' : lazy.nvim et les plugins s'installeront automatiquement."
echo "Notebooks : pour exécuter des cellules, installe ipykernel dans le venv du projet :"
echo "  pip install ipykernel && python -m ipykernel install --user --name <projet>"
