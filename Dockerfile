FROM mcr.microsoft.com/windows:1903

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Write-Host 'Enabling TLS 1.2 (https://githubengineering.com/crypto-removal-notice/) ...'; \
	$tls12RegBase = 'HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2'; \
	if (Test-Path $tls12RegBase) { throw ('"{0}" already exists!' -f $tls12RegBase) }; \
	New-Item -Path ('{0}/Client' -f $tls12RegBase) -Force; \
	New-Item -Path ('{0}/Server' -f $tls12RegBase) -Force; \
	New-ItemProperty -Path ('{0}/Client' -f $tls12RegBase) -Name 'DisabledByDefault' -PropertyType DWORD -Value 0 -Force; \
	New-ItemProperty -Path ('{0}/Client' -f $tls12RegBase) -Name 'Enabled' -PropertyType DWORD -Value 1 -Force; \
	New-ItemProperty -Path ('{0}/Server' -f $tls12RegBase) -Name 'DisabledByDefault' -PropertyType DWORD -Value 0 -Force; \
	New-ItemProperty -Path ('{0}/Server' -f $tls12RegBase) -Name 'Enabled' -PropertyType DWORD -Value 1 -Force

ENV JAVA_HOME C:\\openjdk-13
RUN $newPath = ('{0}\bin;{1}' -f $env:JAVA_HOME, $env:PATH); \
	Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath

ENV JAVA_VERSION 13.0.1
ENV JAVA_URL https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_windows-x64_bin.zip
ENV JAVA_SHA256 438a6920f1851b1eeb6f09f05d9f91c4423c6586f7a1a7ccbb19df76ea5901ee

RUN Write-Host ('Downloading {0} ...' -f $env:JAVA_URL); \
	Invoke-WebRequest -Uri $env:JAVA_URL -OutFile 'openjdk.zip'; \
	Write-Host ('Verifying sha256 ({0}) ...' -f $env:JAVA_SHA256); \
	if ((Get-FileHash openjdk.zip -Algorithm sha256).Hash -ne $env:JAVA_SHA256) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	\
	Write-Host 'Expanding ...'; \
	New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	Expand-Archive openjdk.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination $env:JAVA_HOME; \
	Remove-Item C:\temp; \
	\
	Write-Host 'Verifying install ...'; \
	Write-Host '  java --version'; java --version; \
	Write-Host '  javac --version'; javac --version; \
	\
	Write-Host 'Removing ...'; \
	Remove-Item openjdk.zip -Force; \
	\
	Write-Host 'Complete.'

CMD ["powershell"]
CMD ["jshell"]