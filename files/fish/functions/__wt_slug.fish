function __wt_slug -a path
  string replace -a / - (string sub -s 2 $path)
end
