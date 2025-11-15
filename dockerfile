# Etapa 1: base (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Etapa 2: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Fiap.Web.Alunos.csproj", "./"]
RUN dotnet restore "./Fiap.Web.Alunos.csproj"
COPY . .
RUN dotnet build "./Fiap.Web.Alunos.csproj" -c Release -o /app/build

# Etapa 3: publish
FROM build AS publish
RUN dotnet publish "./Fiap.Web.Alunos.csproj" -c Release -o /app/publish

# Etapa 4: final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Fiap.Web.Alunos.dll"]
