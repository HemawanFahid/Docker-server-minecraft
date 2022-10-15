ADD file ... in /

CMD ["bash"]

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
/bin/sh -c apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl wget ca-certificates fontconfig locales binutils && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*


ENV JAVA_VERSION=jdk-17.0.4.1+1
/bin/sh -c set -eux;     ARCH="$(dpkg --print-architecture)";     case "${ARCH}" in        aarch64|arm64)          ESUM='2e4137529319cd7935f74e1289025b7b4c794c0fb47a3d138adffbd1bbc0ea58';          BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jre_aarch64_linux_hotspot_17.0.4.1_1.tar.gz';          ;;        armhf|arm)          ESUM='b63f532cb8b30e4d0bd18d52f08c1933e3cf66aeb373180d002274b6d94b4a25';          BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jre_arm_linux_hotspot_17.0.4.1_1.tar.gz';          ;;        ppc64el|powerpc:common64)          ESUM='02947997297742ac5a7064fc5414042071fb96d0260d3756100abb281eff3cde';          BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jre_ppc64le_linux_hotspot_17.0.4.1_1.tar.gz';          ;;        s390x|s390:64-bit)          ESUM='f594458bbf42d1d43f7fb5880d0b09d5f9ac11e8eea0de8756419228a823d21c';          BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jre_s390x_linux_hotspot_17.0.4.1_1.tar.gz';          ;;        amd64|i386:x86-64)          ESUM='e96814ee145a599397d91e16831d2dddc3c6b8e8517a8527e28e727649aaa2d1';          BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jre_x64_linux_hotspot_17.0.4.1_1.tar.gz';          ;;        *)          echo "Unsupported arch: ${ARCH}";          exit 1;          ;;     esac; 	  wget -O /tmp/openjdk.tar.gz ${BINARY_URL}; 	  echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; 	  mkdir -p "$JAVA_HOME"; 	  tar --extract 	      --file /tmp/openjdk.tar.gz 	      --directory "$JAVA_HOME" 	      --strip-components 1 	      --no-same-owner 	  ;     rm /tmp/openjdk.tar.gz;     find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf;     ldconfig;     java -Xshare:dump;
/bin/sh -c echo Verifying install ...     && fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; [ "$fileEncoding" = 'UTF-8' ]; rm -rf ~/.java     && echo java --version && java --version     && echo Complete.

ARG BUILD_FILES_REV=1

RUN |1 BUILD_FILES_REV= /bin/sh -c REV=${BUILD_FILES_REV} /build/run.sh install-packages # buildkit
RUN |1 BUILD_FILES_REV= /bin/sh -c REV=${BUILD_FILES_REV} /build/run.sh setup-user # buildkit

COPY files/sudoers* /etc/sudoers.d # buildkit

EXPOSE map[25565/tcp:{} 25575/tcp:{}]

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG EASY_ADD_VER=0.7.1
ADD https://github.com/itzg/easy-add/releases/download/0.7.1/easy-add_linux_amd64 /usr/bin/easy-add # buildkit

RUN |5 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 /bin/sh -c chmod +x /usr/bin/easy-add # buildkit
RUN |5 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 /bin/sh -c easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT}   --var version=1.2.0 --var app=restify --file {{.app}}   --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz # buildkit
RUN |5 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 /bin/sh -c easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT}   --var version=1.6.0 --var app=rcon-cli --file {{.app}}   --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz # buildkit
RUN |5 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 /bin/sh -c easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT}   --var version=0.11.0 --var app=mc-monitor --file {{.app}}   --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz # buildkit
RUN |5 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 /bin/sh -c easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT}   --var version=1.8.1 --var app=mc-server-runner --file {{.app}}   --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz # buildkit
RUN |5 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 /bin/sh -c easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT}   --var version=0.1.1 --var app=maven-metadata-release --file {{.app}}   --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz # buildkit

ARG MC_HELPER_VERSION=1.22.7
ARG MC_HELPER_RELEASE=v1.22.7
ARG MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/v1.22.7

RUN |8 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 MC_HELPER_VERSION=1.22.7 MC_HELPER_RELEASE=v1.22.7 MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/v1.22.7 /bin/sh -c curl -fsSL ${MC_HELPER_BASE_URL}/mc-image-helper-${MC_HELPER_VERSION}.tgz   | tar -C /usr/share -zxf -   && ln -s /usr/share/mc-image-helper-${MC_HELPER_VERSION}/bin/mc-image-helper /usr/bin # buildkit
VOLUME [/data]

WORKDIR /data

STOPSIGNAL SIGTERM
ENV TYPE=VANILLA VERSION=LATEST EULA= UID=1000


COPY scripts/start* / # buildkit


COPY bin/ /usr/local/bin/ # buildkit
COPY bin/mc-health /health.sh # buildkit
COPY files/log4j2.xml /image/log4j2.xml # buildkit
COPY files/auto /auto # buildkit

RUN |8 BUILD_FILES_REV= TARGETOS=linux TARGETARCH=amd64 TARGETVARIANT= EASY_ADD_VER=0.7.1 MC_HELPER_VERSION=1.22.7 MC_HELPER_RELEASE=v1.22.7 MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/v1.22.7 /bin/sh -c dos2unix /start* /auto/* # buildkit

ENTRYPOINT ["/start"]
HEALTHCHECK &{["CMD-SHELL" "mc-health"] "5s" "0s" "1m0s" '\x18'}
