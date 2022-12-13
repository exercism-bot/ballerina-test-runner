FROM ballerina/ballerina:2201.2.3

# install packages required to run the tests
USER root
RUN apk add --no-cache jq coreutils

# add ballerina libraries that would be pulled
RUN bal pull ballerina/io:1.2.2

WORKDIR /opt/test-runner

# copy shell script and json formatter
COPY bin/run.sh bin/run.sh
COPY bin/test-report-to-exercism-result bin/test-report-to-exercism-result
RUN bal build bin/test-report-to-exercism-result

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]