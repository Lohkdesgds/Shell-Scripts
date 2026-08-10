__load_python_virtual_env() {    
    if declare -f deactivate > /dev/null; then
        deactivate 2>&1 /dev/null;
    fi

    [[ -z "${PYTHON_VENV_PATH:-}" ]] && return 0;

    if [[ "${PYTHON_VENV_SEL:-}" == "venv" ]]; then
        source "$PYTHON_VENV_PATH";        
    elif [[ "${PYTHON_VENV_SEL:-}" == "pipenv" ]]; then
        WORKON_HOME="$HOME/.virtualenvs" PIPENV_CUSTOM_VENV_NAME="$PYTHON_VENV_SEL" pipenv shell;
        clear;
    fi

    unset __load_python_virtual_env;
}

__load_python_virtual_env;

install_python_venv() {
    local path="${1:-${PYTHON_VENV_PATH:-$HOME/py_venv}}"
    local exec="${path}/bin/activate"

    python -m venv "$path";

    set_global_env "PYTHON_VENV_PATH" "$exec";
    set_global_env "PYTHON_VENV_SEL" "venv";

    clean;
}

install_python_pipenv() {
    set_global_env "PYTHON_VENV_PATH" "";
    set_global_env "PYTHON_VENV_SEL" "pipenv";
    clean;
}

uninstall_python_virtual() {
    set_global_env "PYTHON_VENV_PATH" "";
    set_global_env "PYTHON_VENV_SEL" "";
    clean;
}