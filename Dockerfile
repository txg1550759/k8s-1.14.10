FROM centos:centos7

MAINTAINER idea77@qq.com

#RUN yum update -y \#

RUN yum install -y passwd openssh openssh-clients openssh-server \
    && yum clean all \
    && rm -rf /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''  \
    && ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
    && sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum install -y less zip vim unzip iproute wget tar curl net-tools telnet  openssh-server rsync  \
    && rm -rf /var/cache/yum/* \
    && yum clean all \
    &&  groupadd -g 1002 deploy \
    && useradd -u 1002 --create-home --shell /bin/bash --no-user-group deploy \
    && usermod -g deploy deploy \
    && mkdir -p /home/deploy/logs

#RUN yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
#    && yum --enablerepo=remi install redis  expect.x86_64 -y \
#    && yum install redis -y

RUN cd /home/ && wget https://dl.k8s.io/v1.14.10/kubernetes-server-linux-amd64.tar.gz
#ADD jdk-8u201-linux-x64.tar.gz /usr/local/
#ADD profile /etc/profile

#RUN groupadd -g 1002 deploy \
#    && useradd -u 1002 --create-home --shell /bin/bash --no-user-group deploy \
#    && usermod -g deploy deploy \
#    && mkdir -p /home/deploy/logs

#ADD docker-entrypoint.sh /tmp/

#ENV JAVA_HOME=/usr/local/jdk1.8.0_201 \
#    JRE_HOME=${JAVA_HOME}/jre \
#    CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib \
#    PATH=${JAVA_HOME}/bin:$PATH \
 #   LANG="en_US.UTF-8" \
#    LANGUAGE="en_US:en" \
 #   LC_ALL="en_US.UTF-8"


EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
