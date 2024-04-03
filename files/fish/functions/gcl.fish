# function _gcl_getFolder
#   # set - git_path "$(echo $1 | cut -d"@" -f 2 | sed -e 's_https://__' -e 's/\.git//g' -e 's_:_/_g' )"

#   # [[ $2 = "0" || $2 = "1"  ]] && local iter="" || local iter=$2

#   # set -l folder_base ${3-$(echo $L_GIT_PATH | cut -d"/" -f1 | xargs ssh -tt -G | awk '$1 == "hostname" {print $2 }' )}
#   # set -l folder_path $(echo $L_GIT_PATH | cut -d"/" -f2-)
#   # set -l folder "$HOME/code/$L_FOLDER_BASE/${L_FOLDER_PATH}${L_ITER}"

#   echo -n "$folder"
#   return
# end

function gcl
  set -l repo $argv[1]
  set -l folder "no destination yet"

  echo "WIP function"

  if test -z $repo
    echo "No repo given."
    return
  end

  # printn "Cloning Repo: %s%s%s
  #   into dir: %s%s%s" \
  #       (set_color green) $repo (set_color normal) \
  #       (set_color green) $folder (set_color normal)

  # printn "%sSkipping%s: already cloned." (set_color yellow) (set_color normal)

  # if not test -d $folder
  # #   git clone $1 $L_FOLDER;
  # else
  #   # echo "(set_color yellow)Skipping(set_color normal): already cloned."
  # end
end

# function gclcd
#   (gcl $argv); or return;
#   cd $(_gcl_getFolder $argv)
#   echo "PWD: ${COLOR_CYAN}$PWD${COLOR_RESET}"
# end

#### BACKUP

# _gcl_getFolder() {
#   local L_GIT_PATH="$(echo $1 | cut -d"@" -f 2 | sed -e 's_https://__' -e 's/\.git//g' -e 's_:_/_g' )"
#   [[ $2 = "0" || $2 = "1"  ]] && local L_ITER="" || local L_ITER=$2
#   local L_FOLDER_BASE=${3-$(echo $L_GIT_PATH | cut -d"/" -f1 | xargs ssh -tt -G | awk '$1 == "hostname" {print $2 }' )}
#   local L_FOLDER_PATH=$(echo $L_GIT_PATH | cut -d"/" -f2-)
#   local L_FOLDER="$HOME/code/$L_FOLDER_BASE/${L_FOLDER_PATH}${L_ITER}"

#   echo -n "$L_FOLDER"
# }
# gcl () {
#   local L_FOLDER="$(_gcl_getFolder $@)"

#   echo "
# Cloning Repo: ${COLOR_GREEN}$1${COLOR_RESET}
#           to: ${COLOR_GREEN}$L_FOLDER${COLOR_RESET}\n";

#   if [ ! -d $L_FOLDER ]; then
#     git clone $1 $L_FOLDER;
#   else
#     echo "${COLOR_YELLOW}Skipping${COLOR_RESET}: already cloned.";
#   fi
# }
# gclcd () {
#   (gcl $@) || return;
#   cd $(_gcl_getFolder $@)
#   echo "PWD: ${COLOR_CYAN}$PWD${COLOR_RESET}"
# }
