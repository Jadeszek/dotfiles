
#
# .zsh/prompt
#

autoload -Uz vcs_info

# color definition {{{
local reset white green red
reset="%{${reset_color}%}"
white="%{$fg[white]%}"
green="%{$fg[green]%}"
red="%{$fg[red]%}"
yellow="%{$fg[yellow]%}"
blue="%{$fg[blue]%}"
magenta="%{$fg[magenta]%}"
#}}}
# Configure vcs_info {{{
# only enable those four
zstyle ':vcs_info:*' enable bzr git hg svn
# standard format
zstyle ':vcs_info:*' actionformats \
    "${magenta}(${reset}%s${magenta}) ${yellow}- ${magenta}[ ${green}%b ${yellow}| ${red}%a ${magenta}]${reset} "
zstyle ':vcs_info:*' formats \
    "${magenta}(${reset}%s${magenta}) ${yellow}- ${magenta}[ ${green}%b ${magenta}]${reset} "
# git specific format
zstyle ':vcs_info:git*:*' actionformats \
    "${magenta}(${reset}%s${magenta})${yellow} - ${reset}%b %c%u ${yellow}| ${red}%a${reset} "
zstyle ':vcs_info:git*:*' formats \
    "${magenta}(${reset}%s${magenta})${yellow} - ${reset}%b %c%u "
# git specific settings
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:git*:*' stagedstr "${green}S${reset}"
zstyle ':vcs_info:git*:*' unstagedstr "${red}U${reset}"
# gather info about remote branches
zstyle ':vcs_info:git*+set-message:*' hooks git-st
# format for svn branches
zstyle ':vcs_info:svn:*' branchformat "%b${red}:${yellow}%r"
# }}}
# +vi-git-st() Author: Seth House <seth@eseth.com> {{{
# https://github.com/whiteinge/dotfiles/blob/master/.zsh_shouse_prompt#L76
# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( "${green}+${ahead}${reset}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "${red}-${behind}${reset}" )

        hook_com[branch]="${hook_com[branch]} ${magenta}[${reset}${remote} ${(j:/:)gitstatus}${magenta}]${reset}"
    fi
} # }}}
# {{{ setprompt()
function setprompt() {
    local -a lines # array of all lines
    local infoline # first line

    # host
    infoline+="%B%m%b$reset "
    # return code if != 0
    infoline+="%(?..[$red%B%?%b$reset] )"
    # number of running jobs if any
    [[ -n $(jobs) ]] && infoline+="{%j} "
    # pwd
    infoline+="$blue%B%~%b$reset"

    lines+=( " $infoline" )

    # add vcs line only if we're in a directory under version control
    if [[ -n ${vcs_info_msg_0_} ]]; then
        lines+=(" ${vcs_info_msg_0_}")
    fi

    # show a red # if we're root and > else
    lines+=(" %B%0(#.$red#.$reset%B>)%b ")

    # form a string out of the array and set it as prompt
    PROMPT=${(F)lines}
} # }}}

precmd() {
    vcs_info
    setprompt
    # Set urgent on complete
    echo -ne '\a'
}

# vim:set sw=4 foldmethod=marker ft=zsh:
