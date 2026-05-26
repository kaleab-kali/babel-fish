# Latency Notes

Babel Fish tracks perceived latency separately from provider latency.

## Initial target

The portfolio target is sub-200ms perceived latency for fixture-backed caption updates. Live provider latency will be measured separately and documented honestly.

## Measurements to capture

- Capture start time.
- Transcript availability time.
- Translation availability time.
- Caption render time.
- Total perceived latency.

## Reporting

Latency reports should identify the mode:

- Fixture mode.
- Mock provider mode.
- Live provider mode.
- On-device model mode.
