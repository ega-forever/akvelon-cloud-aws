terraform destroy -var="function_name=my_app_function" \
  -var="function_handler=index.helloWorld" \
  -var="function_source_dir=../app" \
  -var="api_gateway_stage=dev"
