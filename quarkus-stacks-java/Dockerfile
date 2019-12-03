FROM registry.access.redhat.com/codeready-workspaces/stacks-java-rhel8:1.2

USER root

RUN yum install gcc glibc-devel zlib-devel skopeo podman buildah -y && yum clean all -y

#RUN wget -O /usr/local/bin/odo https://github.com/redhat-developer/odo/releases/download/v0.0.20/odo-linux-amd64 && chmod a+x /usr/local/bin/odo

RUN wget -O /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.2/linux/oc.tar.gz && cd /usr/bin && tar -xvzf /tmp/oc.tar.gz && chmod a+x /usr/bin/oc && rm -f /tmp/oc.tar.gz

RUN wget -O /tmp/graalvm.tar.gz https://github.com/oracle/graal/releases/download/vm-19.2.1/graalvm-ce-linux-amd64-19.2.1.tar.gz && cd /usr/local && tar -xvzf /tmp/graalvm.tar.gz && rm -rf /tmp/graalvm.tar.gz

ENV GRAALVM_HOME="/usr/local/graalvm-ce-19.2.1"

RUN ${GRAALVM_HOME}/bin/gu install native-image

RUN wget -O /tmp/mvn.tar.gz http://apache.mirror.anlx.net/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz

RUN tar -xzf /tmp/mvn.tar.gz && rm -rf /tmp/mvn.tar.gz && mkdir /usr/local/maven && mv apache-maven-3.6.3/ /usr/local/maven/ && alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.6.3/bin/mvn 1

ENV PATH="/usr/local/maven/apache-maven-3.6.3/bin:${PATH}"

ENV MAVEN_OPTS="-Xmx1024M -Xss128M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=1024M -XX:+CMSClassUnloadingEnabled"
