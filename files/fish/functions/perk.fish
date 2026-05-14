function perk -d "Run caffeinate for a duration (perk 1, 5h, 30m, 60s; perk 0 stops)"
  if test (count $argv) -ne 1
    echo "usage: perk <duration>[s|m|h]  (perk 0 stops; default unit: hours)" >&2
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
