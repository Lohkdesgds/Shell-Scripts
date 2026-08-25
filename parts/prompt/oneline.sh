__prompt() {
    local -r res="$1";
    local -r time_run="$2";

    local -r gh_str=$(__get_git_prompt);
    local -r pt_str=$(__get_path_prompt);

    local str="";

    [[ -n "${gh_str:-}" ]] && str+="\[${CLR_6}\]${gh_str} \[${CLR_8}\]› "
    str+="\[${CLR_3}\]${pt_str}"

    if [[ "$res" == "0" ]]; then
        str+="\[${CLR_R}\]: ";
    else
        str+="\[${CLR_1}\]:\[${CLR_R}\] ";
    fi

    PS1="$str";
}