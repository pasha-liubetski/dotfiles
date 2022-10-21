setopt autocd
setopt longlistjobs
setopt nobeep

# Environment

export PATH="${PATH}:/sbin:/usr/sbin:/usr/local/sbin:${HOME}/.local/bin"
export PROMPT='%F{blue}%B%~%b%f %F{green}#%f '
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export FZF_DEFAULT_OPTS='-i'

# History settings

HISTSIZE=50
SAVEHIST=20

# Keybindings Definition

bindkey -e

typeset -A key
key=(
    Home          "${terminfo[khome]}"
    End           "${terminfo[kend]}"
    Insert        "${terminfo[kich1]}"
    Backspace     "${terminfo[kbs]}"
    Delete        "${terminfo[kdch1]}"
    Up            "${terminfo[kcuu1]}"
    Down          "${terminfo[kcud1]}"
    Left          "${terminfo[kcub1]}"
    Right         "${terminfo[kcuf1]}"
    PageUp        "${terminfo[kpp]}"
    PageDown      "${terminfo[knp]}"
    Shift-Tab     "${terminfo[kcbt]}"
    Control-Left  "${terminfo[kLFT5]}"
    Control-Right "${terminfo[kRIT5]}"
)

bindkey -- "${key[Home]}"           beginning-of-line
bindkey -- "${key[End]}"            end-of-line
bindkey -- "${key[Insert]}"         overwrite-mode
bindkey -- "${key[Backspace]}"      backward-delete-char
bindkey -- "${key[Delete]}"         delete-char
bindkey -- "${key[Up]}"             up-line-or-history
bindkey -- "${key[Down]}"           down-line-or-history
bindkey -- "${key[Left]}"           backward-char
bindkey -- "${key[Right]}"          forward-char
bindkey -- "${key[PageUp]}"         beginning-of-buffer-or-history
bindkey -- "${key[PageDown]}"       end-of-buffer-or-history
bindkey -- "${key[Shift-Tab]}"      reverse-menu-complete
bindkey -- "${key[Control-Left]}"   backward-word
bindkey -- "${key[Control-Right]}"  forward-word

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Autocomplete options

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' rehash true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

autoload edit-command-line
zle -N edit-command-line

# File manager hotkeys

cdUndoKey() {
  popd
  zle       reset-prompt
  print
  zle       reset-prompt
}

zle -N cdUndoKey

cdParentKey() {
  pushd ..
  zle      reset-prompt
  print
  zle       reset-prompt
}

zle -N cdParentKey

# Functions

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

fcd () {
    cd "$(fd --type d -H | fzf)"
}

fvi () {
    vi "$(fd --type f | fzf)"
}

fmnt () {
    cd "$(findmnt -D -o TARGET | tail -n +2 | sort | uniq | fzf)"
}

gvfscd () {
    cd "/run/user/$(id -u)/gvfs"
}

# Aliases

alias rscopy="rsync --human-readable --progress --recursive --links --hard-links --perms --acls --xattrs --owner --group --protect-args"

alias df="duf -hide special"
alias h="tldr"
alias ds="du -sh"

alias ls="ls --color=auto"
alias grep="grep --color=auto"

alias l="exa -a"
alias ll="exa -l --icons"
alias b="batcat"

alias t2b="trans -t be"
alias t2e="trans -t en"
alias t2r="trans -t ru"

alias x="xdg-open"
alias x.="xdg-open ."

alias rrf="rm -rf"
alias srrf="sudo rm -rf"
alias ax="aunpack"

alias gi="grep -i"
alias p="most"

alias a2="aria2c"

alias se="sudoedit"

alias add="sudo nice -n 7 eatmydata -- apt install"
alias del="sudo nice -n 7 eatmydata -- apt purge"
alias show="apt show"
alias search="apt search"

alias pls="apt list"
alias plsi="apt list -i"
alias dls="dpkg -L"

alias dfe="sudoedit /var/lib/debfoster/keepers"
alias dfa="sudo debfoster"
alias dfc="sudo sed -i '/^-/d' /var/lib/debfoster/keepers"
alias dfn="sudo debfoster --force"

alias si="sudo upd"

alias shrm="shred -u"
alias shrm="sudo shred -u"
alias mclr="mat2 --inplace"

alias fh="free -h"

alias fd="fdfind"
alias fdh="fdfind -H"

alias vpnon="warp-cli connect"
alias vpnoff="warp-cli disconnect"

alias g="/usr/local/bin/nohupgeany.sh"

alias cx="chmod +x"
alias md="mkdir"

alias gia="git add -A"
alias gcm="git commit"
alias gc="git clone"

alias ytf="yt-dlp -F"
alias ytv="yt-dlp -f22"
alias ytm="yt-dlp -f140"

alias ym="ddgr -w youtube.com --url-handler=mpva"
alias ymj="ddgr -w youtube.com -j --url-handler=mpva"

alias qem="kvm -boot d -m 2G -cdrom"

alias dms="dmesg | tail"

alias cnf="command-not-found"

alias pi="ping"

# Keybindings

bindkey -s '\el' '^ull^M'
bindkey -s '\eд' '^ull^M'

bindkey -s '\eh' '^ucd^M'
bindkey -s '\eр' '^ucd^M'

bindkey -s '\ec' '^llfcd^M'
bindkey -s '\eс' '^llfcd^M'

bindkey -s '\ef' '^lfcd^M'
bindkey -s '\eа' '^lfcd^M'

bindkey -s '\ev' '^lfvi^M'
bindkey -s '\eм' '^lfvi^M'

bindkey -s '\em' '^lfmnt^M'
bindkey -s '\eь' '^lfmnt^M'

bindkey '^[[1;3A' cdParentKey
bindkey '^[[1;3D' cdUndoKey

bindkey '\ee' edit-command-line
