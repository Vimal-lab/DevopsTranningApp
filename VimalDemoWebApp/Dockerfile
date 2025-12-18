FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

# Copy prebuilt output (source code is not present in this repo)
COPY VimalDemoWebApp/bin/Debug/net8.0/ ./

# Ensure there is a wwwroot (repo may only contain compiled artifacts)
COPY VimalDemoWebApp/wwwroot/ ./wwwroot/

COPY VimalDemoWebApp/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]

