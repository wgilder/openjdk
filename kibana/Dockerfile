FROM wgilder/openjdk:1903

ENV KIBANA_HOME C:\\kibana
ENV KB_URL https://artifacts.elastic.co/downloads/kibana/kibana-6.8.4-windows-x86_64.zip
ENV KB_SHA512 4f664ea92a1e2026db270f2c02870bdd4c0754a474f14fb7c5d3846c0c1c26c29428108ece5694740c7f317f09548f2dcd5e603d68ead4dfe25b3386afb9b9b8

RUN Write-Host ('Downloading {0} ...' -f $env:KB_URL); \
	Invoke-WebRequest -Uri $env:KB_URL -OutFile 'kibana.zip'; \
	Write-Host ('Verifying sha512 ({0}) ...' -f $env:KB_SHA256); \
	if ((Get-FileHash kibana.zip -Algorithm sha512).Hash -ne $env:KB_SHA512) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	\
	Write-Host 'Expanding ...'; \
	New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	Expand-Archive kibana.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination $env:KIBANA_HOME; \
	Remove-Item C:\temp; \
	\
	Write-Host 'Removing ...'; \
	Remove-Item kibana.zip -Force; \
	\
	Write-Host 'Complete.'

WORKDIR $KIBANA_HOME

EXPOSE 5601

ENTRYPOINT ./bin/kibana.bat
CMD [ "--elasticsearch", "http://172.16.1.10", "--host", "172.16.1.11"]