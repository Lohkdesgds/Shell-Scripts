export SETTINGS_PATH="$VIRTUAL_HOME/${CFG_ENVIRONMENTS_PATH:-.environments}";
export SETTINGS_CFG_NAME="default";
export SETTINGS_FILE="$SETTINGS_PATH/$SETTINGS_CFG_NAME.sh";

source "$SETTINGS_FILE";

set_global_env() {
    local -r key="${1:-}";
    local -r value="${2:-}";
    local -r file="${3:-$SETTINGS_FILE}"

    if [[ -z "$key" ]]; then
        echo "Usage: <command> <key> <value> [profile]";
        return 1;
    fi

    mkdir -p "$SETTINGS_PATH"

    local escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&|\\]/\\&/g')

    # Replace existing export line or append if non-existent
    if grep -qE "^[[:space:]]*export[[:space:]]+${key}=" "$file" 2>/dev/null; then
        sed -i "s|^[[:space:]]*export[[:space:]]\+${key}=.*|export ${key}=\"${escaped_value}\"|" "$file"
    else
        # Ensure target file ends with a newline before appending
        [ -s "$file" ] && [ -n "$(tail -c 1 "$file")" ] && echo >> "$file"
        printf 'export %s="%s"\n' "$key" "$value" >> "$file"
    fi

    export "$key=$value";
}

dl() {
    local -r url="$1";
    local -r path="$2";

    mkdir -p "$(dirname "$path")";
    curl --output "$path" -L --ssl-revoke-best-effort "$url" "--progress-bar";
}

xt() {
    local -r file="$1";
    local -r path="$2";

    if [[ "${file,,}" =~ \.(zip)$ ]]; then
        unzip -o "$file" -d "$path";
    elif [[ "${file,,}" =~ \.(tar.gz)$  ]]; then
        tar -xf "$file" -C "$path";
    else
        printf "${CLR_1}[!]${CLR_R} Error: file is not '.zip' or '.tar.gz'\n";
        return 1;
    fi
}

clean() {
    /usr/bin/clear;
    source ~/.bashrc;
}

lastcommit() {
    printf "${CLR_B}[✔]${CLR_R} Last commit: '$(git log -1 --pretty=%B)'\n";
}

amend() {
    printf "${CLR_3}[@]${CLR_R} Working: 'git commit --amend --no-edit'\n";
    git commit --amend --no-edit;
    printf "${CLR_B}[✔]${CLR_R} Done.\n";
}

pychk() {
    local path="${1:-_python_scripts}";

    if [[ ! -d "$path" ]]; then
        path="$(find . -name _python_scripts -type d | head -n1)";
        if [[ ! -d "$path" ]]; then
            printf "${CLR_1}[!]${CLR_R} Error: Could not find _python_scripts folder or invalid folder.\n";
        fi
    fi
    
    printf "${CLR_3}[@]${CLR_R} Running common Python check tools at '$path'...\n";

    printf "${CLR_3}[@]${CLR_R} Working: 'Black'\n";
    black "$path";
    
    printf "${CLR_3}[@]${CLR_R} Working: 'PyLint'\n";
    pylint "$path";

    printf "${CLR_3}[@]${CLR_R} Working: 'MyPy'\n";
    mypy "$path";

    printf "${CLR_3}[@]${CLR_R} Working: 'Flake8'\n";
    flake8 "$path";

    printf "${CLR_B}[✔]${CLR_R} Ran commands. Check output now.\n";
}

search() {
    history | grep -i -- "$*" | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//';
}

pipi() {
    if [[ "$PIPENV_ACTIVE" == "1" ]]; then
        if [[ $# -gt 0 ]]; then
            pipenv install "$@";
        else
            pipenv install -r requirements.txt;
        fi
    elif [[ -n "$VIRTUAL_ENV" ]]; then 
        if [[ $# -gt 0 ]]; then
            pip install "$@";
        else
            pip install -r requirements.txt;
        fi
    fi
}

edit_project() {
    code "$SCRIPT_DIR" &
}

ms() {    
    local -r opt="$1";
    local match=false;

    local scripts=();

    for path in "$SCRIPT_DIR/parts/scripts/"*.sh; do
        local name="${path##*/}"
        name="${name%.sh}";

        [[ "$name" == _* ]] && continue;
        scripts+=("$name");

        if [[ "$opt" == "$name" ]]; then
            match=true;
        fi
    done

    if $match; then
        printf "${CLR_B}[✔]${CLR_R} Calling '%s %s'...\n" "${opt}" "${*:2}";
        chmod +x "$SCRIPT_DIR/parts/scripts/${opt}.sh";
        "$SCRIPT_DIR/parts/scripts/${opt}.sh" "${@:2}";
    else
        printf "${CLR_1}[!]${CLR_R} Invalid option.\n";
        printf "${CLR_B}[@]${CLR_R} Installed scripts: ${CLR_6}%s${CLR_R}.\n" "${scripts[*]}";
    fi
}

update() {
    printf "${CLR_B}[✔]${CLR_R} Attempting to update scripts...\n";

    local -r current_path=$(pwd);
    cd "$SCRIPT_DIR";
    local -r response=$(git pull 2>&1);
    cd "$current_path";

    if [[ "$response" == "Already up to date." ]]; then
        printf "${CLR_B}[✔]${CLR_R} Up to date!\n";
    else
        printf "${CLR_1}[!]${CLR_R} Got update or something:\n%s\n" "$response";
        printf "${CLR_B}[✔]${CLR_R} Possibly use ${CLR_C}clean${CLR_R} to apply changes, if any.\n";
    fi
}