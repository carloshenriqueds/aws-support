#!/bin/bash
ELB_NAME="ELB_NAME"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
aws elb deregister-instances-from-load-balancer --load-balancer-name $ELB_NAME  --instances $INSTANCE_ID