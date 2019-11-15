#I am running this command for apply

apply: check_args set_env build_docker_container generate_kubeconfig
	@echo ">> Running terraform apply"
	@echo "===> Passing the following ENV to the terraform container ${PASSED_ENVS}"

	@echo "===> terraform init"
	@docker run -it --rm -v ${current_dir}:${current_dir} -w ${current_dir} ${DOCKER_ENV} \
		terraform_with_eks_tools.local:latest terraform init -input=false \
			-backend-config "region=${BACKEND_CONFIG_BUCKET_REGION}" \
			-backend-config "dynamodb_table=terraform_locks" \
			-backend-config "bucket=${BACKEND_CONFIG_BUCKET}" \
			-backend-config "key=${CLIENT}/${BACKEND_CONFIG_TFSTATE_FILE_KEY}" \
			-backend-config "role_arn=${BACKEND_CONFIG_ROLE_ARN}"

	@echo "===> terraform apply"
	@docker run -it --rm -v ${current_dir}:${current_dir} -w ${current_dir} ${DOCKER_ENV} \
		terraform_with_eks_tools.local:latest terraform apply -input=false -auto-approve \
			-var target_account_id=${AWS_ACCOUNT_ID} \
			-var backend_config_bucket_region=${BACKEND_CONFIG_BUCKET_REGION} \
			-var backend_config_bucket=${BACKEND_CONFIG_BUCKET} \
			-var backend_config_role_arn=${BACKEND_CONFIG_ROLE_ARN} \
			-var backend_config_tfstate_file_key=${BACKEND_CONFIG_TFSTATE_FILE_KEY} \
			-var name=${CLIENT} \
			-var-file=tfvars/${CLIENT}.tfvars

	@echo "===> Cleaning up..."
	@docker run -it --rm -v ${current_dir}:${current_dir} -w ${current_dir} \
		busybox:latest rm -rf .terraform

