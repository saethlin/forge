FROM centos:6

RUN yum update -y
RUN yum install curl gcc gcc-c++ git zip unzip zlib-devel libffi-devel -y
RUN curl -LO https://www.openssl.org/source/openssl-1.0.2t.tar.gz
RUN curl -LO https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz

RUN tar -xf openssl-1.0.2t.tar.gz && \
    cd openssl-1.0.2t && \
    ./config -fPIC && \
    make install && \
    cd .. && \
    rm -rf openssl-1.0.2t openssl-1.0.2t.tar.gz

RUN tar -xf Python-3.9.0.tgz && \
    cd Python-3.9.0 && \
    ./configure --with-openssl=/usr/local/ssl && \
    make install && \
    cd .. && \
    rm -rf Python-3.9.0 Python-3.9.0.tgz

RUN python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip install setuptools auditwheel

RUN curl -LO http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/p/patchelf-0.9-10.el6.x86_64.rpm && \
    yum install patchelf-0.9-10.el6.x86_64.rpm -y && \
    rm -f patchelf-0.9-10.el6.x86_64.rpm

RUN curl -sSf https://sh.rustup.rs | bash -s -- -y --profile=minimal && \
    /root/.cargo/bin/cargo install cbindgen && \
    mv /root/.cargo/bin/cbindgen /usr/local/bin/ && \
    /root/.cargo/bin/rustup self uninstall -y

RUN rm -rf /root/.cache

RUN yum erase gcc-c++ zip unzip zlib-devel -y

RUN yum clean all
