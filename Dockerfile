FROM	hashicorp/terraform:0.12.12

RUN	apk add bash
RUN	wget -qO /usr/local/bin/kubectl 'https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl' && \
	chmod 755 /usr/local/bin/kubectl && \
	wget -qO /usr/local/bin/aws-iam-authenticator 'https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.4.0/aws-iam-authenticator_0.4.0_linux_amd64' && \
	chmod 755 /usr/local/bin/aws-iam-authenticator

ENTRYPOINT [""]
