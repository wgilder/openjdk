FROM wgilder/openjdk:1903

ENV ES_HOME C:\\elasticsearch
ENV ES_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.4.zip
ENV ES_SHA512 0eb4d32f252c94fbb5dd25cb90e553c1b81d2f88a284d2e2100c5daa2ee0a1d3275b605e060b3c1ce4c08e2fa9cabf7f171ba83ddbf64f44b4cf74c0be897d21

RUN Write-Host ('Downloading {0} ...' -f $env:ES_URL); \
	Invoke-WebRequest -Uri $env:ES_URL -OutFile 'elasticsearch.zip'; \
	Write-Host ('Verifying sha512 ({0}) ...' -f $env:ES_SHA512); \
	if ((Get-FileHash elasticsearch.zip -Algorithm sha512).Hash -ne $env:ES_SHA512) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	\
	Write-Host 'Expanding ...'; \
	New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	Expand-Archive elasticsearch.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination $env:ES_HOME; \
	Remove-Item C:\temp; \
	\
	Write-Host 'Removing ...'; \
	Remove-Item elasticsearch.zip -Force; \
	\
	Write-Host 'Complete.'

WORKDIR $ES_HOME

EXPOSE 9200 9300

ENTRYPOINT ./bin/elasticsearch.bat
CMD [ "-E", "network.bind_host=0.0.0.0"]