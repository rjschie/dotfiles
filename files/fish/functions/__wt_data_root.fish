function __wt_data_root
  if set -q XDG_DATA_HOME; and test -n "$XDG_DATA_HOME"
    echo $XDG_DATA_HOME/wt
  else
    echo $HOME/.local/share/wt
  end
end
