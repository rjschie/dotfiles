# Claude Code Telemetry Configuration
# Copy to ~/.config/fish/conf.d/cc-telemetry.fish

set -gx CLAUDE_CODE_ENABLE_TELEMETRY 1

set -gx OTEL_LOGS_EXPORTER otlp
set -gx OTEL_METRICS_EXPORTER otlp

set -gx OTEL_EXPORTER_OTLP_PROTOCOL http/json
set -gx OTEL_EXPORTER_OTLP_METRICS_PROTOCOL http/json

set -gx OTEL_EXPORTER_OTLP_ENDPOINT http://localhost:4318
