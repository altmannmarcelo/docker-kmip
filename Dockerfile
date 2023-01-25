# Pull base image.
FROM ubuntu:focal

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install git pip python3 python3-pip

RUN python3 -m pip install pykmip cryptography pycrypto

RUN git clone https://github.com/OpenKMIP/PyKMIP.git /opt/PyKMIP

RUN mkdir /opt/certs /opt/polices

RUN cp /opt/PyKMIP/examples/policy.json /opt/polices

RUN cd /opt/certs && \
    python3 /opt/PyKMIP/bin/create_certificates.py

RUN echo "[server]\n\
hostname=0.0.0.0\n\
port=5696\n\
certificate_path=/opt/certs/server_certificate.pem\n\
key_path=/opt/certs/server_key.pem\n\
ca_path=/opt/certs/root_certificate.pem\n\
policy_path=/opt/polices\n\
logging_level=DEBUG\n\
auth_suite=TLS1.2\n\
enable_tls_client_auth=True" | tee /opt/PyKMIP/server.conf

RUN cat /opt/PyKMIP/server.conf

EXPOSE 5696

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]
