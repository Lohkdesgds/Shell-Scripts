#!/bin/bash

# This is the custom stuff I made to link @ bashrc

set_prompt() {
    local res="$?"
    local venv=""
    local gitb=""
    local cwd=""
    local sep=" \[\e[90m\]﹥\[\e[0m\] "

    local status_color="\[\e[0m\]"
    if [ "$res" -ne 0 ]; then
        status_color="\[\e[31m\]"
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        venv="🐍\[\e[32m\]${VIRTUAL_ENV##*/}\[\e[0m\]"
    fi

    gitb=$(git branch 2>/dev/null | sed -n '/\* /s///p')
    if [ -n "$gitb" ]; then
        gitb="🌿\[\e[35m\]$gitb\[\e[0m\]"
    fi

    local path="$PWD"
    if [[ "$path" == "$HOME" ]]; then
        path="~"
    elif [[ "$path" == $HOME/* ]]; then
        path="~${path#$HOME}"
    fi

    cwd="📂\[\e[34m\]$path\[\e[0m\]"

    local prompt=""
    if [ -n "$venv" ]; then
        prompt+="$venv"
    fi
    if [ -n "$gitb" ]; then
        [ -n "$prompt" ] && prompt+="$sep"
        prompt+="$gitb"
    fi
    if [ -n "$cwd" ]; then
        [ -n "$prompt" ] && prompt+="$sep"
        prompt+="$cwd"
    fi

    PS1="\n${status_color}• ${prompt}\n\$ "
}

clean() {
    source ~/.bashrc
}

# Make Bash rebuild the prompt each time
PROMPT_COMMAND=set_prompt