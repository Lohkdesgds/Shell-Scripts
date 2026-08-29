__load_python_virtual_env() {    
    if declare -f deactivate > /dev/null; then
        deactivate 2>&1 /dev/null;
    fi

    [[ -z "${PYTHON_VENV_PATH:-}" ]] && return 0;

    if [[ "${PYTHON_VENV_SEL:-}" == "venv" ]]; then
        source "$PYTHON_VENV_PATH/bin/activate";        
    elif [[ "${PYTHON_VENV_SEL:-}" == "pipenv" ]]; then
        WORKON_HOME="$PYTHON_VENV_PATH" PIPENV_CUSTOM_VENV_NAME="$PYTHON_PIPENV_ENV" pipenv shell;
        clear;
    fi

    unset __load_python_virtual_env;
}

__load_python_virtual_env;

install_python_venv() {
    local -r path="${1:-${PYTHON_VENV_BASE_PATH:-$VIRTUAL_HOME/py_venv}}"
    local -r exec="${path}/bin/activate"

    python -m venv "$path";

    set_global_env "PYTHON_VENV_PATH" "$path";
    set_global_env "PYTHON_VENV_SEL" "venv";
    set_global_env "PYTHON_PIPENV_ENV" "";

    clean;
}

install_python_pipenv() {
    local -r name="${1:-pipenv}"

    set_global_env "PYTHON_VENV_PATH" "$VIRTUAL_HOME/.virtualenvs";
    set_global_env "PYTHON_VENV_SEL" "pipenv";
    set_global_env "PYTHON_PIPENV_ENV" "$name";
    clean;
}

uninstall_python_virtual() {
    set_global_env "PYTHON_VENV_PATH" "";
    set_global_env "PYTHON_VENV_SEL" "";
    set_global_env "PYTHON_PIPENV_ENV" "";
    clean;
}