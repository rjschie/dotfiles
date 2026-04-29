function psef
  argparse 'c/claude' -- $argv
  or return

  set -l exclude \
    "/System" \
    "/Applications" \
    "/usr/libexec" \
    "/usr/sbin" \
    "/sbin" \
    "/Library/Developer" \
    "/Steam.AppBundle" \
    "automountd" \
    "endpointsecurityd" \
    "autofsd" \
    "aslmanager" \
    "cloudphotod" \
    "trustevaluationagent" \
    "/usr/bin/login" \
    "/bin/fish" \
    "fish" \
    "ps -ef" \
    # for the awk line we use
    "if \(NR == 1\)" \
    "Core Audio Driver" \
    "/CleverFiles" \
    "/com.tunabelly" \
    "com.1password" \
    "cc-telemetry" \
    "grafana" \
    "/nvim"

  if not set -ql _flag_claude
    set -a exclude \
      "claude" \
      "typescript-language-server" \
      "/node_modules/typescript" \
      "chrome-devtools"
  end

  ps -ef | grep -Ev (string join '|' $exclude) | awk '
    { if (NR == 1) print "\033[1m" $0 "\033[0m"
      else if (NR % 2 == 0) print "\033[36m" $0 "\033[0m"
      else print "\033[34m" $0 "\033[0m" }'
end
