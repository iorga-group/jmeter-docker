# FROM openjdk:8u151-jre-alpine3.7
#FROM openjdk:8-jre-alpine
# FROM openjdk:9.0.1-11-jre-slim-sid
FROM openjdk:9-jre-slim

# Inspired by https://github.com/justb4/docker-jmeter/blob/master/Dockerfile
#   and https://github.com/docker-library/httpd/blob/17166574dea6a8c574443fc3a06bdb5a8bc97743/2.4/alpine/Dockerfile

ARG JMETER_VERSION="4.0"
ARG JMETER_SHA512=eee7d68bd1f7e7b269fabaf8f09821697165518b112a979a25c5f128c4de8ca6ad12d3b20cd9380a2b53ca52762b4c4979e564a8c2ff37196692fbd217f1e343
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN  ${JMETER_HOME}/bin
ENV APACHE_DIST_URLS \
# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
	https://www.apache.org/dyn/closer.cgi?action=download&filename= \
# if the version is outdated (or we're grabbing the .asc file), we might have to pull from the dist/archive :/
	https://www-eu.apache.org/dist/ \
	https://www-us.apache.org/dist/ \
	https://www.apache.org/dist/ \
	https://archive.apache.org/dist/
ENV	JMETER_DOWNLOAD_URL ${APACHE_DIST_URLS}/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

RUN set -eux; \
  apt-get update && apt-get install -y wget gnupg; \
  mkdir -p /opt; cd /opt; \
	ddist() { \
		local f="$1"; shift; \
		local distFile="$1"; shift; \
		local success=; \
		local distUrl=; \
		for distUrl in $APACHE_DIST_URLS; do \
			if wget -O "$f" "$distUrl$distFile"; then \
				success=1; \
				break; \
			fi; \
		done; \
		[ -n "$success" ]; \
	}; \
	ddist 'jmeter.tgz' "jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"; \
	ddist 'jmeter.tgz.asc' "jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz.asc"; \
  export GNUPGHOME="$(mktemp -d)"; \
# Thanks to http://www.apache.org/info/verification.html
#	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C4923F9ABFB2F1A06F08E88BAC214CAA0612B399; \
  while ! gpg --keyserver pgpkeys.mit.edu --recv-key C4923F9ABFB2F1A06F08E88BAC214CAA0612B399; do sleep 1; done; \
	gpg --batch --verify jmeter.tgz.asc jmeter.tgz; \
	rm -rf "$GNUPGHOME" jmeter.tgz.asc; \
	\
	tar -xzf jmeter.tgz; \
	rm jmeter.tgz; \
	\
  mkdir -p /workdir;

RUN cp -ar ${JMETER_HOME} ${JMETER_HOME}.orig

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /usr/local/bin/

WORKDIR	/workdir

ENTRYPOINT ["entrypoint.sh"]
