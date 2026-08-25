unset __prompt;
__prompt() {
    local -r res="$1";
    local -r time_run="$2";

    local -r py_str=$(__get_python_prompt);
    local -r gh_str=$(__get_git_prompt);
    local -r pt_str=$(__get_path_prompt);
    local -r pf_str=$(__get_profile);

    local str="\n\[${CLR_8}\]┌";

    [[ -n "${pf_str:-}" ]] && str+="› 💻 \[${CLR_F}\]${pf_str} \[${CLR_8}\]"
    [[ -n "${py_str:-}" ]] && str+="› 🐍 \[${CLR_B}\]${py_str} \[${CLR_8}\]"
    [[ -n "${gh_str:-}" ]] && str+="› 🌿 \[${CLR_6}\]${gh_str} \[${CLR_8}\]"
    str+="› 📁 \[${CLR_3}\]${pt_str}"

    if [[ "$res" == "0" ]]; then
        str+="\n\[${CLR_8}\]└─ \[${CLR_R}\]$ ";
    else
        str+="\n\[${CLR_8}\]└─ \[${CLR_1}\]\$\[${CLR_R}\] ";
    fi

    PS1="$str";
}