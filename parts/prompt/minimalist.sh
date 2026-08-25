__prompt() {
    local -r res="$1";
    local -r time_run="$2";

    local str="";

    if [[ "$res" == "0" ]]; then
        str+="\[${CLR_R}\]$ ";
    else
        str+="\[${CLR_1}\]\$\[${CLR_R}\] ";
    fi

    PS1="$str";
}