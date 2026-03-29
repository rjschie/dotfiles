complete -c p -f

# -u flag: complete with github.com user dirs
complete -c p -s u -l user -rfa '(for d in $CODE/github.com/*/; basename $d; end)'

# project arg: complete based on -u value or default to rjschie
function __p_projects
  set -l cmd (commandline -poc)
  set -l user rjschie

  for i in (seq (count $cmd))
    if test "$cmd[$i]" = -u; or test "$cmd[$i]" = --user
      set -l next (math $i + 1)
      if test $next -le (count $cmd)
        set user $cmd[$next]
      end
    end
  end

  for d in $CODE/github.com/$user/*/
    basename $d
  end
end

complete -c p -n 'not __fish_seen_argument -s u -l user' -a '(__p_projects)'
complete -c p -n '__fish_seen_argument -s u -l user' -a '(__p_projects)'
