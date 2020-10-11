terraform apply -var="vpc_id=vpc-e816318f" \
  -var="ec2_keypair_name=akvelon_keypair" \
  -var="loggroup_name=my_app_lg" \
  -var="logstream_name=my_app_stream"
