function mmv --wrap="mv" -d "Make dir then move"
  mkdir -p (dirname $argv[2])
  mv $argv
end
