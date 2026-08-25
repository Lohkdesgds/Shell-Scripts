export VIRTUAL_ENV_DISABLE_PROMPT=1;
bind 'set enable-bracketed-paste on';

__get_python_prompt() {
    [[ -n "${VIRTUAL_ENV:-}" ]] && printf '%s' "$(basename "$VIRTUAL_ENV")";
    [[ -n "${CONDA_DEFAULT_ENV:-}" ]] && printf '%s' "$(basename "$CONDA_DEFAULT_ENV")";
    [[ -n "${PYENV_VERSION:-}" ]] && printf '%s' "$PYENV_VERSION";
    printf "";
}

__get_git_prompt() {
    local gh="";
    
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        gh=$(git symbolic-ref --short HEAD 2>/dev/null);
        if [[ -z "$gh" ]]; then
            gh=$(git describe --tags --exact-match 2>/dev/null);
            [[ -z "$gh" ]] && gh=$(git rev-parse --short HEAD);
        fi
    fi

    printf '%s' "$gh";
}

__get_path_prompt() {
    local full_path="$(pwd)";    

    if [[ "${full_path,,}" == "${HOME,,}" ]]; then
        full_path="~${full_path:${#HOME}}";
    elif [[ "${full_path,,}" == "c:/" ]]; then # fellow Windows users
        full_path="/c${full_path:2}";
    fi

    printf '%s' "$full_path";
}

__get_profile() {
    printf '%s' "${PROFILE_LOADED:-}";
}


__preexec() {
    [[ "$BASH_COMMAND" == "${PROMPT_COMMAND:-}" ]] && return;

    local -r t="$EPOCHREALTIME"
    CMD_START="${t//[!0-9]/}";
}

__precmd() {
    local -r res=$?;
    local now="$EPOCHREALTIME";
    now="${now//[!0-9]/}";

    local -r ms=$(( (now - CMD_START) / 1000 ));
    local -r sec=$(( (now - CMD_START) / 1000000 ));

    local time_str="";

    if [[ "$ms" -lt 60000 ]]; then
        time_str="${ms} ms";
    else
        time_str="${sec} s";
    fi

    if declare -f __prompt > /dev/null; then
        __prompt "$res" "$time_str";
    fi
}

_enable_prompt_features() {
    trap 'printf "${CLR_1}[!]${CLR_R} Exited error-like: at #$LINENO; command: $BASH_COMMAND\n"' ERR

    [[ -z "$PROMPT_SELECTED" ]] && set_global_env "PROMPT_SELECTED" "full"

    if declare -f __prompt > /dev/null; then
        unset __prompt;
    fi

    source "$SCRIPT_DIR/parts/prompt/${PROMPT_SELECTED:-}.sh"

    trap '__preexec' DEBUG;
    PROMPT_COMMAND=__precmd;

    unset _enable_prompt_features;
}

set_prompt() {
    local -r opt="$1";
    local match=false;

    local prompts=();
    local -r prompts_path="$SCRIPT_DIR/parts/prompt";

    for path in "$prompts_path"/*.sh; do
        local name="${path##*/}"
        name="${name%.sh}";

        [[ "$name" == _* ]] && continue;
        prompts+=("$name");

        if [[ "$opt" == "$name" ]]; then
            match=true;
        fi
    done

    if $match; then
        printf "${CLR_B}[✔]${CLR_R} Setting prompt to '${opt}'...\n";
        set_global_env "PROMPT_SELECTED" "$opt";
        
        if declare -f __prompt > /dev/null; then
            unset __prompt;
        fi

        source "$SCRIPT_DIR/parts/prompt/${PROMPT_SELECTED}.sh";
    else
        printf "${CLR_1}[!]${CLR_R} Invalid option.\n";
        printf "${CLR_B}[@]${CLR_R} Installed prompts: ${CLR_6}%s${CLR_R}.\n" "${prompts[*]}";
        printf "${CLR_B}[@]${CLR_R} Currently using ${PROMPT_SELECTED}";
    fi
}

list_prompts() {
    local prompts=();
    local -r prompts_path="$SCRIPT_DIR/parts/prompt";

    for path in "$prompts_path"/*.sh; do
        local name="${path##*/}"
        name="${name%.sh}";

        [[ "$name" == _* ]] && continue;
        prompts+=("$name");
    done
    
    printf "${CLR_B}[✔]${CLR_R} List of prompts: ${CLR_6}%s${CLR_R}.\n" "${prompts[*]}";
}

_enable_prompt_features