clear;
echo -e "${CLR_F}# Script tools quick guide"

echo -e "\n${CLR_B}## General tools:\n"

echo -e "${CLR_F}💻 ${CLR_C}help"
echo -e "${CLR_8} ↳ ${CLR_7}Results in this help command list."

echo -e "${CLR_F}💻 ${CLR_C}set_global_env <key> <value> [profile]"
echo -e "${CLR_8} ↳ ${CLR_7}Creates or updates an environment variable set with \`export\` keyword on [profile] or default one if not given."

echo -e "${CLR_F}💻 ${CLR_C}dl <url> <path>"
echo -e "${CLR_8} ↳ ${CLR_7}Download from <url> and output it to <path> (with automatic path creation)."

echo -e "${CLR_F}💻 ${CLR_C}xt <file> <path>"
echo -e "${CLR_8} ↳ ${CLR_7}Extracts <file> on <path>. Supports zip and tar.gz for now."

echo -e "${CLR_F}💻 ${CLR_C}clean"
echo -e "${CLR_8} ↳ ${CLR_7}Clears terminal and does a reload of your .bashrc."

echo -e "${CLR_F}💻 ${CLR_C}lastcommit"
echo -e "${CLR_8} ↳ ${CLR_7}Gets the last commit message of the current git repository, if in a valid folder."

echo -e "${CLR_F}💻 ${CLR_C}amend"
echo -e "${CLR_8} ↳ ${CLR_7}Quickly does a commit --amend --no-edit."

echo -e "${CLR_F}💻 ${CLR_C}pychk [path]"
echo -e "${CLR_8} ↳ ${CLR_7}Useful Python Check function that calls common tools for standardization: black, pylint, mypy, and flake8."

echo -e "${CLR_F}💻 ${CLR_C}search"
echo -e "${CLR_8} ↳ ${CLR_7}A wrapper over \`history\` command to find a line in your history like grep."

echo -e "${CLR_F}💻 ${CLR_C}pipi [packages...]"
echo -e "${CLR_8} ↳ ${CLR_7}Easier way to do pip/pipenv install. If no arguments, it'll try using requirements.txt in your folder."

echo -e "${CLR_F}💻 ${CLR_C}edit_project"
echo -e "${CLR_8} ↳ ${CLR_7}Opens this script path in VS Code. It expects \`code\` command to be aliased correctly to VS Code."

echo -e "${CLR_F}💻 ${CLR_C}ms [<tool> [...]]"
echo -e "${CLR_8} ↳ ${CLR_7}Multi Script caller, useful for calling fancier functionality in this project. The arguments are one to many, depending on the tool being called."

echo -e "${CLR_F}💻 ${CLR_C}update"
echo -e "${CLR_8} ↳ ${CLR_7}Attempts to do a git pull in this project to get the newest features."

echo -e "\n${CLR_B}## Profiles tools:\n"

echo -e "${CLR_F}💻 ${CLR_C}edit_profile [profile]"
echo -e "${CLR_8} ↳ ${CLR_7}Opens in nano the [profile] environment file or the current one."

echo -e "${CLR_F}💻 ${CLR_C}remove_profile <profile>"
echo -e "${CLR_8} ↳ ${CLR_7}Moves the <profile> to a trash folder in the environments folder (\$SETTINGS_PATH/.trashbin)."

echo -e "${CLR_F}💻 ${CLR_C}set_profile <profile>"
echo -e "${CLR_8} ↳ ${CLR_7}Sets (and creates if needed) <profile> as the current profile and reloads the terminal."

echo -e "${CLR_F}💻 ${CLR_C}list_profiles"
echo -e "${CLR_8} ↳ ${CLR_7}Gives a list of all profiles created available in the environments folder."

echo -e "${CLR_F}💻 ${CLR_C}unset_profile"
echo -e "${CLR_8} ↳ ${CLR_7}Goes back to default profile."

echo -e "\n${CLR_B}## Python tools:\n"

echo -e "${CLR_F}💻 ${CLR_C}install_python_venv <custom_path>"
echo -e "${CLR_8} ↳ ${CLR_7}Creates/loads a global venv Python environment in <custom_path>. If no parameter is given, it first tries PYTHON_VENV_BASE_PATH as the path, and if it is not set, it fallbacks to a py_venv in your home directory."

echo -e "${CLR_F}💻 ${CLR_C}install_python_pipenv <custom_name>"
echo -e "${CLR_8} ↳ ${CLR_7}Creates/loads a pipenv instance in your home folder under .virtualenvs. Defaults name to \`pipenv\`"

echo -e "${CLR_F}💻 ${CLR_C}uninstall_python_virtual"
echo -e "${CLR_8} ↳ ${CLR_7}Disables venv/pipenv automatic global stuff."

echo -e "\n${CLR_B}## Custom prompts:\n"

echo -e "${CLR_F}💻 ${CLR_C}set_prompt <prompt>"
echo -e "${CLR_8} ↳ ${CLR_7}Apply one of the listed prompts available."

echo -e "${CLR_F}💻 ${CLR_C}list_prompts"
echo -e "${CLR_8} ↳ ${CLR_7}Shows the prompts installed in this project."