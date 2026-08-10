__load_python_virtual_env() {
    [[ -z "${PYTHON_VENV_PATH:-}" ]] && return 0;
    
    if declare -f deactivate > /dev/null; then
        deactivate 2>&1 /dev/null;
    fi

    if [[ "${PYTHON_VENV_SEL:-}" == "venv" ]]; then
        source "$PYTHON_VENV_SEL";        
    elif [[ "${PYTHON_VENV_SEL:-}" == "pipenv" ]]; then
        WORKON_HOME="$HOME/.virtualenvs" PIPENV_CUSTOM_VENV_NAME="$PYTHON_VENV_SEL" pipenv shell;
        clear;
    fi

    unset __load_python_virtual_env;
}

__load_python_virtual_env;