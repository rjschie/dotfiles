function psef
  ps -ef | grep -v -e "/System" -e "/Applications" -e "/usr/libexec" -e "/usr/sbin" -e "/usr/bin/login" -e "/bin/fish"
end
