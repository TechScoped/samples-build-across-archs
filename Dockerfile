
# using the dotnet 6 sdk image, create the app directory
# change to it, copy the csproj into it and, using restore,
# create the obj directory containing any any nuget project
# references needed by the application 
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /app
COPY *.csproj ./
RUN dotnet restore

# copy the rest of the project (except what's in .dockerignore)
# into the image's container directory and publish a release version
# of the app into the out directory
COPY . .
RUN dotnet publish -c Release -o out

# using the dotnet 6 aspnet runtime image, create the app directory
# change to it, copy everything from the build (sdk) image's out
# directory into the app directory and start the web app
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "AWebApp.dll"]