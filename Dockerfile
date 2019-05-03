FROM centos:latest

# MAINTAINER
MAINTAINER xiaow409@163.com

# put ../nginx-1.14.2.tar.gz into /usr/local/src and unpack nginx
ADD ./nginx-1.14.2.tar.gz /usr/local/src
# tar xvf nginx-1.14.2.tar.gz

ONBUILD VOLUME ["/data"]
# VOLUME [ "./volumes/data" ]

# running required command
RUN yum install -y gcc gcc-c++ glibc make autoconf openssl openssl-devel 
RUN yum install -y libxslt-devel -y gd gd-devel GeoIP GeoIP-devel pcre pcre-devel
RUN useradd -M -s /sbin/nologin nginx

WORKDIR /usr/local/src/nginx-1.14.2
# execute command to compile nginx
RUN ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-file-aio  --with-http_ssl_module  --with-http_realip_module    --with-http_addition_module    --with-http_xslt_module   --with-http_image_filter_module    --with-http_geoip_module  --with-http_sub_module  --with-http_dav_module --with-http_flv_module    --with-http_mp4_module --with-http_gunzip_module  --with-http_gzip_static_module  --with-http_auth_request_module  --with-http_random_index_module   --with-http_secure_link_module   --with-http_degradation_module   --with-http_stub_status_module && make && make install

# 执行PATH=/usr/local/nginx/sbin:$PATH，添加到了环境变量
ENV PATH /usr/local/nginx/sbin:$PATH
EXPOSE 80

# CMD, 当启动一个container时默认运行的命令，如果在启动container时赋予了command，那么
# 定义的CMD中的命令将不会被执行，而会去执行command的命令
# CMD /bin/sh -c 'nginx -g "daemon off;"'

# 当ENTRYPOINT和CMD连用时，CMD的命令是ENTRYPOINT命令的参数，两者连用相当于nginx -g "daemon off;"
# 而当一起连用的时候命令格式最好一致（这里选择的都是json格式的是成功的，如果都是sh模式可以试一下）
ENTRYPOINT ["nginx"]
# CMD ["-g","daemon on;"]
CMD ["-g"]
