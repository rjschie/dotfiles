
function condainit -d "Init and Activate Base Conda"
  if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
      eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
  else
      if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
          . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
      else
          set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
      end
  end
end
