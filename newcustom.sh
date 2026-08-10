__BEGIN_SCRIPT_MS="$(( ${EPOCHREALTIME//[!0-9]/} / 1000 ))";

export SCRIPT_ORIGIN="${BASH_SOURCE[0]}";
export SCRIPT_DIR="$(dirname "$SCRIPT_ORIGIN")"

shopt -s nullglob nocaseglob
set -o pipefail

for script in "$SCRIPT_DIR"/parts/*.sh; do
    #echo "Loading module: $script";
    source "$script";
done


shopt -u nocaseglob

__END_SCRIPT_MS="$(( ${EPOCHREALTIME//[!0-9]/} / 1000 ))";
__DELTA=$(($__END_SCRIPT_MS - $__BEGIN_SCRIPT_MS));

printf "${CLR_E}[✔]${CLR_R} ⏱️ Time taken to load: ${CLR_6}%s ms${CLR_R}.\n" "$__DELTA";

if [[ -n "${PROFILE_LOADED:-}" ]]; then
    printf "${CLR_E}[✔]${CLR_R} 💻 Loaded profile: ${CLR_6}%s${CLR_R}.\n" "$PROFILE_LOADED";
fi

unset __BEGIN_SCRIPT_MS;
unset __END_SCRIPT_MS;
unset __DELTA;