function ghnewrepo
  if ! test $argv[1]
    echo "No repo name specified."
    return
  end

  set -f name $argv[1]
  if test $name = "."
    echo "Using current dir name..."
    set -f name $(basename (git rev-parse --show-toplevel))
  end

  gh repo create $name --private --source=. --remote=origin
end
