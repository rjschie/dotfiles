function ccp --wrap="cp" -d "Make dir then copy"
  mkdir -p (dirname $argv[2])
  cp $argv
end
