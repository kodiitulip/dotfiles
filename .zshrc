# Created by newuser for 5.9
#                 __
#     ____  _____/ /_  __________
#    /_  / / ___/ __ \/ ___/ ___/
#   _ / /_(__  ) / / / /  / /__
#  (_)___/____/_/ /_/_/   \___/

# ---------------------------------------------------------------------------- #
#                                 UTILITY FUNC                                 #
# ---------------------------------------------------------------------------- #

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

# ---------------------------------------------------------------------------- #
#                                     PATH                                     #
# ---------------------------------------------------------------------------- #

export PATH="/usr/lib/ccache/bin/:$PATH"
export PATH="$HOME/Scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$HOME/.spicetify:$PATH"
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

# ---------------------------------------------------------------------------- #
#                                 ENV VARIABLES                                #
# ---------------------------------------------------------------------------- #

export VISUAL=/usr/bin/nvim
export EDITOR="$VISUAL"
export MOZ_ENABLE_WAYLAND=1
export RUSTC_WRAPPER=sccache
export TAPLO_CONFIG="$HOME/.config/.taplo.toml"

# ---------------------------------------------------------------------------- #
#                                     ZINIT                                    #
# ---------------------------------------------------------------------------- #

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light olets/zsh-transient-prompt

# Add in snippets
zinit snippet OMZP::sudo

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# History
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=$HOME/.zsh_history
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#232136,hl:#ea9a97
	--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
	--color=border:#44415a,header:#3e8fb0,gutter:#232136
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --group-directories-first $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# ---------------------------------------------------------------------------- #
#                                      GIT                                     #
# ---------------------------------------------------------------------------- #

alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gb="git branch"
alias gsw="git switch"
alias gd="git diff"
alias gcl="git clone"
source /usr/share/doc/git-extras/git-extras-completion.zsh
source $HOME/.config/zsh/completions/supabase.zsh
source $HOME/.config/zsh/completions/uv.zsh
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias ly='/usr/bin/lazygit --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# ---------------------------------------------------------------------------- #
#                                   SHORTCUTS                                  #
# ---------------------------------------------------------------------------- #

alias e="exit"
alias c="clear"
alias cf="clear & fastfetch"
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first"
alias lt="eza --tree --level=1 --icons --group-directories-first"
alias lg="lazygit"
alias wifi="nmtui connect"
alias clock="peaclock"
alias confzsh="$EDITOR $HOME/.zshrc"
alias confnu="z $HOME/.config/nushell && $EDITOR ./config.nu"
alias reload="source $HOME/.zshrc"
alias gw="./gradlew"
alias cr="cargo run"
alias crq="cr --quiet"
alias cb="cargo build"
alias cbq="cb --quiet"
alias ct="cargo test"
alias ctq="ct --quiet"
alias ..="z .."
alias ...="z ../.."
alias 3..="z ../../.."
alias 4..="z ../../../.."
alias 5..="z ../../../../.."

most() {
  history 1 | awk '{for (i=2; i<=NF; i++) {if ($i=="sudo" && (i+1)<=NF) CMD[$(i+1)]++; else if (i==2) CMD[$i]++; count++}} END {for (a in CMD) print CMD[a], CMD[a]/count*100 "%", a}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

# ---------------------------------------------------------------------------- #
#                                    PACMAN                                    #
# ---------------------------------------------------------------------------- #

AURHELPER="paru"

alias pacman="sudo pacman"

pkglist() {
  if [[ $# -eq 0 ]]; then
    pacman -Qq | fzf --preview '$AURHELPER -Qi {}' --layout=reverse
  elif [[ $# -gt 0 ]] && [[ $1 == '-e' ]]; then
    pacman -Qqe | fzf --preview '"$AURHELPER" -Qi {}' --layout=reverse
  else
    echo "[ERROR] Unknown argument: $1"
    return 1
  fi
}

pkgcount() {
  if [[ $# -eq 0 ]]; then
    pacman -Qq | wc -l
  elif [[ $# -gt 0 ]] && [[ $1 == '-e' ]]; then
    pacman -Qqe | wc -l
  else
    echo "[ERROR] Unknown argument: $1"
    return 1
  fi
}

pkgsearch() {
  if [[ $# -eq 0 ]]; then
    pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse --bind 'enter:execute(sudo pacman -S {})'
  elif [[ $# -gt 0 ]] && [[ $1 == '-a' ]]; then
    "$AURHELPER" -Slqa | fzf --preview '"$AURHELPER" -Si {}' --layout=reverse --bind 'enter:execute("$AURHELPER" -S {})'
  else
    echo "[ERROR] Unknown argument: $1"
    return 1
  fi
}


# ---------------------------------------------------------------------------- #
#                              SHELL INTEGRATIONS                              #
# ---------------------------------------------------------------------------- #

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# pnpm
export PNPM_HOME="/home/kodie/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/kodie/.bun/_bun" ] && source "/home/kodie/.bun/_bun"

# ---------------------------------------------------------------------------- #
#                              CUSTOM PROMPTS                                  #
# ---------------------------------------------------------------------------- #

# OHMYPOSH
# export OMP_CONFIG=$HOME/.config/omp/rose-pine.omp.toml
# eval "$(oh-my-posh init zsh -c $OMP_CONFIG)"

# STARSHIP
eval "$(starship init zsh)"

TRANSIENT_PROMPT_PROMPT='$(/usr/bin/starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(/usr/bin/starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT" --profile transient)'
