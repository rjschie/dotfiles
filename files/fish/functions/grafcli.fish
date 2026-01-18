function grafcli --wrap="grafana"
  /opt/homebrew/opt/grafana/bin/grafana cli --config /opt/homebrew/etc/grafana/grafana.ini --homepath /opt/homebrew/opt/grafana/share/grafana --pluginsDir "/opt/homebrew/var/lib/grafana/plugins" $argv
end
