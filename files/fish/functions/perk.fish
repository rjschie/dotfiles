function perk -d "Run caffeinate for a duration (perk 1, 5h, 30m, 60s; perk 0 stops; perk shows time left)"
  if test (count $argv) -eq 0
    set -l pid (pgrep -u "$USER" -f "caffeinate -dimsu")
    if test -z "$pid"
      echo "perk: nothing running (usage: perk <duration>[s|m|h]; perk 0 stops; default unit: hours)"
      return 0
    end
    set pid $pid[1]
    set -l pargs (ps -o args= -p $pid)
    set -l tm (string match -r -- '-t +([0-9]+)' $pargs)
    set -l total $tm[2]
    set -l etime (ps -o etime= -p $pid | string trim)
    set -l parts (string split : -- $etime)
    set -l elapsed 0
    if test (count $parts) -eq 2
      set elapsed (math "$parts[1] * 60 + $parts[2]")
    else if test (count $parts) -eq 3
      set -l dh (string split - -- $parts[1])
      if test (count $dh) -eq 2
        set elapsed (math "$dh[1] * 86400 + $dh[2] * 3600 + $parts[2] * 60 + $parts[3]")
      else
        set elapsed (math "$parts[1] * 3600 + $parts[2] * 60 + $parts[3]")
      end
    end
    if test -z "$total"
      echo "perk: running (unable to determine remaining time)"
      return 0
    end
    set -l remaining (math $total - $elapsed)
    if test $remaining -le 0
      echo "perk: expiring"
      return 0
    end
    set -l h (math -s0 "$remaining / 3600")
    set -l m (math -s0 "($remaining % 3600) / 60")
    set -l s (math -s0 "$remaining % 60")
    set -l out
    test $h -gt 0; and set -a out "$h"h
    test $m -gt 0; and set -a out "$m"m
    test $s -gt 0 -o -z "$out"; and set -a out "$s"s
    echo "perk: $out left"
    return 0
  end

  if test (count $argv) -ne 1
    echo "usage: perk [<duration>[s|m|h]]  (no arg shows time left; perk 0 stops; default unit: hours)" >&2
    return 1
  end

  set -l input $argv[1]
  set -l num (string match -r '^[0-9]+(?:\.[0-9]+)?' -- $input)
  set -l unit (string match -r '[smh]$' -- $input)

  if test -z "$num"
    echo "perk: invalid duration: $input" >&2
    return 1
  end

  set -l existing (pgrep -u "$USER" -f "caffeinate -dimsu")
  if test -n "$existing"
    kill $existing 2>/dev/null
  end

  if string match -qr '^0+(\.0+)?$' -- $num
    if test -n "$existing"
      echo "perk: stopped"
    else
      echo "perk: nothing running"
    end
    return 0
  end

  if test -z "$unit"
    set unit h
  end

  set -l seconds
  switch $unit
    case s
      set seconds (math -s0 "$num")
    case m
      set seconds (math -s0 "$num * 60")
    case h
      set seconds (math -s0 "$num * 3600")
  end

  echo "perking for $num$unit"
  command caffeinate -dimsu -t $seconds &
  disown
end
