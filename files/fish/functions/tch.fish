function tch -d "Make dir and touch file"
  mkdir -p (dirname $argv)
  touch $argv
end