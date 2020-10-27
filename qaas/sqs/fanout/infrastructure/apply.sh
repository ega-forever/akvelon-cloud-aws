terraform apply -var="vpc_id=vpc-e816318f" \
  -var="ec2_keypair_name=akvelon_keypair" \
  -var="loggroup_name=my_app_lg" \
  -var="logstream_name=my_app_stream" \
  -var="first_queue=first_queue" \
  -var="second_queue=second_queue" \
  -var="sns_topic_name=fanout_topic"
