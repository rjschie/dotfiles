function datediff -d "Diff two dates by seconds (s), minutes (m), hours (h), days (d)"
  argparse "help" "u/unit=" "d/days" "s/seconds" "h/hours" "m/minutes" -- $argv
  or return

  if set -ql _flag_help; or not set -q argv[1]
    echo -e "Usage:"
    echo -e "\tdatediff [-u|--unit=<unit>] <date-1> [<date-2>]\n"
    echo -e "Options:"
    echo -e "\t -u, --unit\tThe unit to show the difference in."
    echo -e "\t\t\tPossible values:"
    echo -e "\t\t\t\t$(string join "\n\t\t\t\t" "(d)ays" "(h)ours" "(m)inutes" "(s)econds")"
    echo -e "\nExample:"
    echo -e "\t#:datediff -u seconds now \"now + 1 second\""
    echo -e "\t->1 seconds"
    return 0
  end

  set -f DIVISOR_DAYS (math "24 * 60 * 60")
  set -f DIVISOR_HOURS (math "60 * 60")
  set -f DIVISOR_MINUTES 60
  set -f DIVISOR_SECONDS 1

  set -f unit "days"
  set -f divisor $DIVISOR_DAYS
  if set -ql _flag_unit
    switch $_flag_unit
      case d day days
        set -f unit "days"
        set -f divisor $DIVISOR_DAYS
      case h hour hours
        set -f unit "hours"
        set -f divisor $DIVISOR_HOURS
      case m minute minutes
        set -f unit "minutes"
        set -f divisor $DIVISOR_MINUTES
      case s second seconds
        set -f unit "seconds"
        set -f divisor $DIVISOR_SECONDS
      case "*"
        echo "Invalid unit:" $_flag_unit
        echo "Valid units are: (d)ays, (h)ours, (m)inutes, (s)econds"
        return 0
    end
  end

  if set -ql _flag_days
    set -f unit "days"
    set -f divisor $DIVISOR_DAYS
  end
  if set -ql _flag_hours
    set -f unit "hours"
    set -f divisor $DIVISOR_HOURS
  end
  if set -ql _flag_minutes
    set -f unit "minutes"
    set -f divisor $DIVISOR_MINUTES
  end
  if set -ql _flag_seconds
    set -f unit "seconds"
    set -f divisor $DIVISOR_SECONDS
  end

  if test -z $argv[2]
    set argv[2] $argv[1]
    set argv[1] 'now'
  end

  set -f d1 (date -d $argv[1] +"%s")
  or return

  set -f d2 (date -d $argv[2] +"%s")
  or return

  set -f secondsdiff (math "$d2 - $d1")

  echo (printf "%'d" (math "$secondsdiff / $divisor") 2>/dev/null) $unit
end
