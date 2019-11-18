FROM mcr.microsoft.com/windows:1903

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# SQL Server Developer
ENV MSSQL_URI https://go.microsoft.com/fwlink/?linkid=866662
ENV MSSQL_DATADIR C:\\sqldata
ENV MSSQL_TMP C:\\sqltmp

RUN mkdir $env:MSSQL_TMP; \
    mkdir $env:MSSQL_DATADIR;

WORKDIR ${MSSQL_TMP}
COPY "./scripts/Setup.*" ./

RUN Invoke-WebRequest -Uri $env:MSSQL_URI -OutFile "mssql-server.exe"; \
    Start-Process -FilePath "\"mssql-server.exe\"" -NoNewWindow -Wait -ArgumentList \
        "\"/ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /QUIET /INSTALLPATH=$env:MSSQL_DATADIR /MEDIAPATH=$env:MSSQL_TMP /HIDEPROGRESSBAR\"";

RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted;
RUN Invoke-Sqlcmd -InputFile "Setup.sql"; \
    .\\Setup.ps1

WORKDIR "C:\\"
RUN Remove-Item -Recurse -Force $env:MSSQL_TMP;

EXPOSE 1433

ENTRYPOINT [ "powershell.exe" ]
