function psef
  set -l exclude \
    "/System" \
    "/Applications" \
    "/usr/libexec" \
    "/usr/sbin" \
    "/sbin" \
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
    "Core Audio Driver" \
    "/CleverFiles" \
    "/com.tunabelly" \
    "com.1password" \
    "cc-telemetry" \
    "grafana" \
    "/nvim"
  ps -ef | grep -Ev (string join '|' $exclude) | awk '
    { if (NR == 1) print "\033[1m" $0 "\033[0m"
      else if (NR % 2 == 0) print "\033[36m" $0 "\033[0m"
      else print "\033[34m" $0 "\033[0m" }'
end
