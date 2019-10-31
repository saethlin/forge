FROM centos:6

RUN yum update -y
RUN yum install curl gcc git zip unzip zlib-devel libffi-devel -y
RUN curl -sSf https://sh.rustup.rs > rustup-init
RUN sh rustup-init --profile minimal -y
RUN curl -LO https://www.openssl.org/source/openssl-1.0.2t.tar.gz
RUN curl -LO https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
RUN curl -LO http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/p/patchelf-0.9-10.el6.x86_64.rpm

RUN tar -xf openssl-1.0.2t.tar.gz
WORKDIR openssl-1.0.2t
RUN ./config -fPIC
RUN make install
WORKDIR ..
RUN rm -rf openssl-1.0.2t
RUN rm -f openssl-1.0.2t.tar.gz

RUN tar -xf Python-3.7.4.tgz
WORKDIR Python-3.7.4
RUN ./configure --with-openssl=/usr/local/ssl
RUN make -j4 install
WORKDIR ..
RUN rm -rf Python-3.7.4
RUN rm -f Python-3.7.4.tgz

RUN yum install patchelf-0.9-10.el6.x86_64.rpm -y
RUN rm -f patchelf-0.9-10.el6.x86_64.rpm

RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install setuptools auditwheel

ENV PATH=/root/.cargo/bin:$PATH
RUN cargo install cbindgen
