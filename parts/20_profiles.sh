unset ___LOADED_PROFILE_SET;
declare -g -A ___LOADED_PROFILE_SET;

__setup_profiles() {
    [[ -z "${CFG_PROFILE:-}" ]] && set_global_env "CFG_PROFILE" "default";

    local -r environments_path="$SETTINGS_PATH";
    mkdir -p "$environments_path";

    if [[ "${CFG_PROFILE:-}" == "default" ]] || import_profile "${CFG_PROFILE:-}"; then
        export PROFILE_LOADED="${CFG_PROFILE:-}";
    else
        unset PROFILE_LOADED;
    fi

    unset __setup_profiles;
}

_cleanup_vars() {
    local -r environments_path="$SETTINGS_PATH";

    for i in "${!___LOADED_PROFILE_SET[@]}"; do
        while IFS= read -r line ; do
            if [[ $line =~ ^export[[:space:]]+([A-Za-z_][A-Za-z0-9_]*) ]]; then
                local key="${BASH_REMATCH[1]}";
                # printf "${CLR_B}[✔]${CLR_R} Cleaned: '%s'.\n" "$key";
                unset "$key";
            fi
        done < "$environments_path/$i.sh";
    done
}


edit_profile() {
    local -r profile="${1:-${CFG_PROFILE:-}}"

    if [[ -z "$profile" ]]; then
        printf "${CLR_1}[!]${CLR_R} Profile not set nor given.\n";
        return 1;
    fi

    local -r environments_path="$SETTINGS_PATH";
    local -r profile_path="$environments_path/$profile.sh";

    touch "$profile_path";
    nano "$profile_path";
}

remove_profile() {
    local -r profile="${1:-${CFG_PROFILE:-}}"

    if [[ -z "$profile" ]]; then
        printf "${CLR_1}[!]${CLR_R} Profile not set nor given.\n";
        return 1;
    elif [[ "$profile" == "$SETTINGS_CFG_NAME" ]]; then
        printf "${CLR_1}[!]${CLR_R} You are not allowed to delete the default profile.\n";
        return 2;        
    fi

    local -r environments_path="$SETTINGS_PATH";
    local -r environments_trash_path="$SETTINGS_PATH/.trashbin";
    local -r profile_path="$environments_path/$profile.sh";

    mkdir -p "$environments_trash_path";

    [[ -f "$profile_path" ]] && mv "$profile_path" "$environments_trash_path/";
    printf "${CLR_B}[✔]${CLR_R} Trashed profile '$profile'.\n";
}

set_profile() {
    local -r profile="${1:-}";

    if [[ -z "$profile" ]]; then
        printf "${CLR_B}[✔]${CLR_R} Using default profile.\n";
        sleep 1;
        set_global_env "CFG_PROFILE" "default"; 
        unset ___LOADED_PROFILE_SET;
        clean;
    fi

    local -r environments_path="$SETTINGS_PATH";
    local -r profile_path="$environments_path/$profile.sh";

    touch "$profile_path";

    set_global_env "CFG_PROFILE" "$profile";
    unset ___LOADED_PROFILE_SET;
    clean;
}

list_profiles() {
    local profiles=();
    local -r environments_path="$SETTINGS_PATH";

    for path in "$environments_path"/*.sh; do
        local name="${path##*/}"
        name="${name%.sh}";

        [[ "$name" == _* ]] && continue;
        profiles+=("$name");
    done
    
    printf "${CLR_B}[✔]${CLR_R} List of profiles: ${CLR_6}%s${CLR_R}.\n" "${profiles[*]}";
}

import_profile() {
    local -r imported="$1"
    local -r environments_path="$SETTINGS_PATH";
    local -r current_env="$environments_path/$imported.sh"

    if [[ "$imported" == "default" ]]; then
        printf "${CLR_1}[!]${CLR_R} Attention: 'default' profile does not need to be imported, it is part of the program and it will always be loaded.\n";
        return 0;
    fi

    if [[ -n "$imported" && -f "$current_env" ]]; then
        if [[ -n "${___LOADED_PROFILE_SET[$imported]:-}" ]]; then
            printf "${CLR_1}[!]${CLR_R} Recursive import detected in profile: '$imported' imported at least twice!\n";
            return 1;
        fi

        ___LOADED_PROFILE_SET["$imported"]=1;
        source "$current_env";
        return 0;
    fi
    
    return 1;
}

unset_profile() {
    set_profile "";
}

__setup_profiles;