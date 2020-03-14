FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["GodSlayer/GodSlayer.csproj", "GodSlayer/"]
RUN dotnet restore "GodSlayer/GodSlayer.csproj"
COPY . .
WORKDIR "/src/GodSlayer"
RUN dotnet build "GodSlayer.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "GodSlayer.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "GodSlayer.dll"]
