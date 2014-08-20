
#
# .zsh/10-zle.zsh
# configure the behaviour of the zsh line editor
#

bindkey -v

WORDCHARS='*?_[]~=&;!#$%^(){}'

# quote pasted urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# open commandline in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M emacs '^Sv'  edit-command-line
bindkey -M emacs '^S^V' edit-command-line
bindkey -M vicmd 'v' edit-command-line

# get quick help for current command
if [[ -d $HELPDIR ]]; then
    unalias run-help
    autoload -U run-help
fi
bindkey -M vicmd 'K' run-help

# toggle sudo
autoload -U run-with-sudo
zle -N run-with-sudo
bindkey -M emacs '^Ss'  run-with-sudo
bindkey -M emacs '^S^S' run-with-sudo
bindkey -M vicmd '^S' run-with-sudo
bindkey -M viins '^S' run-with-sudo

# Expands ... to ../..
autoload -U expand-dot
zle -N expand-dot
bindkey -M emacs "." expand-dot
bindkey -M viins "." expand-dot
bindkey -M isearch "." self-insert

# jump after first word (to add switches)
autoload -U after-first-word
zle -N after-first-word
bindkey -M emacs '^S^A' after-first-word
bindkey -M emacs '^Sa'  after-first-word

# insert current date
function insert-date() { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-date
bindkey -M emacs '^Sd'  insert-date
bindkey -M emacs '^S^D' insert-date

# quickly put job to foreground
autoload -U grml-zsh-fg
zle -N grml-zsh-fg
bindkey -M emacs '^Z' grml-zsh-fg
bindkey -M vicmd '^Z' grml-zsh-fg
bindkey -M viins '^Z' grml-zsh-fg

#
# emacs
#

# clear ^S we'll use it as prefix
bindkey -rM emacs '^S'

# better than ^X^V
bindkey -M emacs '^[' vi-cmd-mode

# fixes
bindkey -M emacs '^X^R' redo
bindkey -M emacs '^[p'  history-beginning-search-backward
bindkey -M emacs '^[n'  history-beginning-search-forward
# use patterns for search
bindkey -M emacs '^R'  history-incremental-pattern-search-backward
bindkey -M emacs '^Sr' history-incremental-pattern-search-forward
# use ^E^U to kill the whole line
bindkey -M emacs '^U' backward-kill-line
# quick help
bindkey -M emacs '^Sh'  where-is
bindkey -M emacs '^S^H' describe-key-briefly
# comment out current line
bindkey -M emacs '^S#' pound-insert
# push everything on the stack
bindkey -M emacs '^Sq' push-input

#
# vi command mode
#

bindkey -M vicmd 'gg' beginning-of-history
bindkey -M vicmd 'G'  vi-fetch-history

# swap the search directions and add pattern search
bindkey -M vicmd '/'  history-incremental-pattern-search-backward
bindkey -M vicmd '?'  history-incremental-pattern-search-forward

# push the whole input into the buffer stack
vi-push-input() {
  zle .push-input
  zle .vi-insert
}
zle -N vi-push-input
bindkey -M vicmd 'q' vi-push-input

# vim-like undo
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^R' redo

# make Y consistent *sigh*
bindkey -M vicmd 'Y' vi-yank-eol
bindkey -M vicmd 'yy' vi-yank-whole-line

# quick history search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'gj' down-line-or-history
bindkey -M vicmd 'gk' up-line-or-history

# quick copy
bindkey -M vicmd 'gp' copy-prev-word
bindkey -M vicmd 'gP' copy-prev-shell-word

#
# vi insert mode
#

bindkey -M viins 'jk' vi-cmd-mode

# those are annoying
bindkey -rM viins "^[,"
bindkey -rM viins "^[/"
bindkey -rM viins "^[~"

# backspace over everything
bindkey -M viins "^?" backward-delete-char
bindkey -M viins "^H" backward-delete-char
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^U" backward-kill-line

# preserve some readline bindings
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line

# insert last word
bindkey -M viins '^K' insert-last-word

# help
bindkey -M viins '^_' describe-key-briefly

#
# menu navigation
#

bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
# insert, but accept further completions
bindkey -M menuselect 'i' accept-and-menu-complete
# insert, and show menu with further possible completions
# useful for cd-ing into nested directories
bindkey -M menuselect 'o' accept-and-infer-next-history
# undo
bindkey -M menuselect 'u' undo

# fix special keys
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
