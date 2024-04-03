function printn --wrap printf -d "Add newline to printf"
  set -l format $argv[1]
  set -l rest $argv[2..]
  printf "$format\n" $rest
end