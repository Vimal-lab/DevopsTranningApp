#!/usr/bin/env sh
set -eu

# This repo contains compiled output that was built on a different machine.
# The static web assets manifest can contain absolute Windows paths and crash the app on Linux.
# Safest approach: remove the manifest so ASP.NET Core serves static content from /app/wwwroot normally.
rm -f /app/*.staticwebassets.runtime.json /app/*.staticwebassets.endpoints.json || true

exec dotnet /app/VimalDemoWebApp.dll

