# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape.emacs = "inherit"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "blink_block"
$env.config.use_kitty_protocol = true

$env.VISUAL = '/usr/bin/nvim'
$env.EDITOR = '/usr/bin/nvim'
$env.FZF_DEFAULT_OPTS = '
	--color=fg:#908caa,bg:#232136,hl:#ea9a97
	--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
	--color=border:#44415a,header:#3e8fb0,gutter:#232136
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa'
$env.RUSTC_WRAPPER = 'sccache'
$env.PATH ++= ['/home/kodie/.cargo/bin/']

$env.PATH = ($env.PATH | split row (char esep) | prepend "/home/kodie/.config/carapace/bin")

def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }


# ---------------------------------------------------------------------------- #
#                                      GIT                                     #
# ---------------------------------------------------------------------------- #

alias gs = git status
alias ga = git add
alias gc = git commit -m
alias gp = git push
alias gb = git branch
alias gsw = git switch
alias gd = git diff
alias gcl = git clone
alias dotfiles = /usr/bin/git --git-dir=($env.HOME)/dotfiles/ --work-tree=($env.HOME)
alias ly = /usr/bin/lazygit --git-dir=($env.HOME)/dotfiles/ --work-tree=($env.HOME)

# ---------------------------------------------------------------------------- #
#                                   SHORTCUTS                                  #
# ---------------------------------------------------------------------------- #

alias e = exit
alias c = clear
def cf [] {
  ^clear
  ^fastfetch
}
alias els = eza --icons --group-directories-first
alias ell = eza -l --icons --group-directories-first
alias elt = eza --tree --level=1 --icons --group-directories-first
alias lg = lazygit
alias wifi = nmtui connect
alias clock = peaclock
alias reload = exec nu
alias gw = ./gradlew
alias cr = cargo run
alias crq = cr --quiet
alias cb = cargo build
alias cbq = cb --quiet
alias ct = cargo test
alias ctq = ct --quiet
alias .. = z ..
alias ... = z ../..
alias 3.. = z ../../..
alias 4.. = z ../../../..
alias 5.. = z ../../../../..
alias pacman = sudo pacman

def config-completer [] {
{
    options: {
      case-sensitive: false,
      completion_algorithm: substring,
      sort: false,
    },
    completions: ['nu', 'zsh']
  }
}

def conf [shell: string@config-completer] {
  match $shell {
    nu => ( config nu ),
    zsh => ( nvim ~/.zshrc ),
  }
}

alias confnu = conf nu
alias confzsh = conf zsh

def nufzf [] {
  $in | each {|i| $i | to json --raw} | str join (char nl) | fzf  | from json
}

# ---------------------------------------------------------------------------- #
#                              SHELL INTEGRATIONS                              #
# ---------------------------------------------------------------------------- #

mkdir ($nu.data-dir | path join "vendor/autoload")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# ---------------------------------------------------------------------------- #
#                              CUSTOM PROMPTS                                  #
# ---------------------------------------------------------------------------- #

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

$env.TRANSIENT_PROMPT_COMMAND = ^starship prompt --profile transient
$env.TRANSIENT_PROMPT_INDICATOR = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ": "
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = "∙ "
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
