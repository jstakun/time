# Base the image on the standard C++ stack
FROM registry.access.redhat.com/codeready-workspaces/stacks-java

ENV CAMEL_K_CLIENT=camel-k-client-0.3.3-linux-64bit.tar.gz \
    CAMEL_K_VERSION=0.3.3 \
    OC4_CLIENT=openshift-client-linux-4.1.0-rc.5.tar.gz

ENV CAMEL_K_PATH=https://github.com/apache/camel-k/releases/download/${CAMEL_K_VERSION}/${CAMEL_K_CLIENT} \
    OC4_PATH=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/${OC4_CLIENT}

# Basic system hygiene
RUN sudo yum -y update --skip-broken && \
    sudo yum clean all && \

# Now create a directory, get the cmake code and install it
    echo $CAMEL_K_PATH && \
    cd /usr/local/bin && \
    sudo curl -O -L $CAMEL_K_PATH && \
    sudo tar -xf ${CAMEL_K_CLIENT} && \
    sudo rm ${CAMEL_K_CLIENT} && \
    sudo curl -O -L ${OC4_PATH} && \ 
    sudo tar -xf ${OC4_CLIENT} && \
    sudo rm ${OC4_CLIENT} kubectl && \
    sudo mv oc oc4

# Put a symlink to the executable in the PATH
#   sudo ln -s /usr/local/bin/camel-k-client-0.3.3-linux-64/bin/kamel /usr/local/bin/kamel 

# IMPORTANT: The Dockerfile has to end with a non-terminating CMD. This works
# as well as any....
CMD tail -f /dev/null 
