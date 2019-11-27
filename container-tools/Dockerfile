FROM registry.redhat.io/rhel7
MAINTAINER Jaroslaw Stakun jarek@redhat.com
RUN yum install skopeo podman buildah --disablerepo=* --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-extras-rpms -y && yum clean all -y
CMD echo "skopeo version" && skopeo -v && echo "podman version" && podman version && echo "buildah version" && buildah version
