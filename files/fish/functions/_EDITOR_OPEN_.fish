function _EDITOR_OPEN_ -d "My vim/nvim EDITOR opener"
  if not test $argv[1]
    $EDITOR
    return
  end

  set -f resolved_path "$(path resolve $argv[1])"

  if test -f $resolved_path
    set -f resolved_path $(path dirname $resolved_path)
  end

  # echo "INPUT: $argv[1]"
  # echo "EDITOR: $EDITOR"
  # echo "PATH: $resolved_path"
  # echo "CMD: $EDITOR $resolved_path --cmd \"cd $resolved_path\""

  $EDITOR $argv[1] --cmd "cd $resolved_path"
end
