source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

setopt autocd
setopt longlistjobs
setopt nobeep

# Environment

export PATH="${PATH}:/sbin:/usr/sbin:/usr/local/sbin:${HOME}/.local/bin"
export PROMPT='%F{blue}%B%~%b%f %F{green}#%f '
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export FZF_DEFAULT_OPTS='-i --height=100%'
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export MANROFFOPT="-c"

export FZF_CTRL_T_OPTS="--preview='batcat -n --color always {}'"

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

cdParentKey() {
  pushd ..
  zle      reset-prompt
  print
  zle       reset-prompt
}

zle -N cdParentKey

# Functions

help() {
    "$@" --help 2>&1 | batcat --style=plain --language=help
}

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

fmnt () {
	uid="$(id -u)"
	fstypes="fuse,fuseblk,ext2,ext3,ext4,vfat,iso9660,udf"

	cd "$({ find /run/user/${uid}/gvfs -mindepth 1 -maxdepth 1 -type d; findmnt -n -l -o target -t ${fstypes}; bookmarks.rb } | fzf)"
}

# Aliases

alias rscopy="rsync --human-readable --progress --recursive --links --hard-links --perms --acls --xattrs --owner --group --protect-args"

alias df="duf -hide special"
alias h="tldr"
alias ch="cheat"
alias ds="du -sh"

alias ls="ls --color=auto"
alias grep="grep --color=auto"

alias l="eza -a"
alias ll="eza -lh --icons"
alias b="batcat --style=plain --color always"

alias t2b="trans -t be"
alias t2e="trans -t en"
alias t2r="trans -t ru"

alias x="xdg-open"
alias x.="xdg-open ."

alias rrf="rm -rf"
alias srrf="sudo rm -rf"
alias ax="aunpack"

alias gi="grep -i"
alias p="batcat --style=plain --color always"
alias -g P="| p"
alias -g G="| ug --color=always -i --no-line-number --pager='batcat --style=plain --color always'"

alias a2="aria2c"

alias se="sudoedit"

#alias add="sudo nice -n 7 eatmydata -- apt install"
#alias del="sudo nice -n 7 eatmydata -- apt purge"
#alias show="apt show"
#alias search="apt search"

#alias pls="apt list"
#alias plsi="apt list -i"
#alias dls="dpkg -L"

alias add="sudo nice -n 7 eatmydata -- nala install"
alias del="sudo nice -n 7 eatmydata -- nala purge"
alias show="nala show"
alias search="nala search"

alias pls="nala list"
alias plsi="nala list -i"
alias dls="dpkg -L"

alias dfe="sudoedit /var/lib/debfoster/keepers"
alias dfa="sudo debfoster"
alias dfc="sudo sed -i '/^-/d' /var/lib/debfoster/keepers"
alias dfn="sudo debfoster --force"

alias rdep="apt-cache rdepends"

alias si="sudo upd"

alias shrm="sudo shred -u"

alias fh="free -h"

alias fd="fdfind"
alias fdh="fdfind -H"

alias g="/usr/local/bin/nohupgeany.sh"
alias nq="/usr/local/bin/nohupnqq.sh"
alias s="subl"

alias cx="chmod +x"
alias md="mkdir"

alias gia="git add -A"
alias gcm="git commit"
alias gc="git clone"

alias yt="yt-dlp --continue --file-access-retries infinite --fragment-retries infinite -R infinite"
alias ytf="yt-dlp -F"

alias ytm="ytfzf --audio-only -n 50 -u mpva"
alias ytdm="yt -f140"
alias ytdv="yt -f22"

alias ytrenp="rename -v -n 's/ \[[^]]+\]//' *(mp4|m4a|mp3)"
alias ytren="rename -v 's/ \[[^]]+\]//' *(mp4|m4a|mp3)"

alias adetoxp="rename -v -n 's/[_-]+/ /g' *(mp4|m4a|mp3)"
alias adetox="rename -v 's/[_-]+/ /g' *(mp4|m4a|mp3)"

alias cnf="command-not-found"

alias pi="ping"
alias pi5="ping 192.168.58.5"

alias k9="kill -9"
alias sk9="sudo kill -9"

alias lsimg="find -type f \( -iname '*png' -o -iname '*jpg' \) | sort | sed 's:^:![](:;s:$:):'"

alias ced="vi ~/.zshrc"

alias s.="s ."

alias dws="sudo dwstop"

alias st="grc stat"

alias m="man"

# Keybindings

bindkey -s '\el' '^ull^M'
bindkey -s '\eд' '^ull^M'

bindkey -s '\eh' '^ucd^M'
bindkey -s '\eр' '^ucd^M'

bindkey -s '\e/' '^ucd /^M'
bindkey -s '\e.' '^ucd /^M'

bindkey -s '\ed' '^llfcd^M'
bindkey -s '\eв' '^llfcd^M'

bindkey -s '\em' '^lfmnt^M'
bindkey -s '\eь' '^lfmnt^M'

bindkey -s '\ez' '^lxdg-open .^M'
bindkey -s '\eя' '^lxdg-open .^M'

bindkey '^[[1;3A' cdParentKey
bindkey -s '^[[1;3D' '^lcd -^M' 
