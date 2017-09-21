#!/bin/bash -eux

# set the session to be noninteractive
export DEBIAN_FRONTEND="noninteractive"

### set region
export AWS_REGION="us-east-1"

### list first VPC id
export BUILD_VPC_ID=$(aws ec2 describe-vpcs \
	--query 'Vpcs[0].[VpcId]' \
	--output text);
echo $BUILD_VPC_ID;

### list first subnet id, within VPC
export BUILD_SUBNET_ID=$(aws ec2 describe-subnets \
	--filters "Name=vpc-id,Values=$BUILD_VPC_ID" \
	--query 'Subnets[0].[SubnetId]' \
	--output text);
echo $BUILD_SUBNET_ID;

### build Packer AMI

packer validate packer.json

packer inspect packer.json

packer build packer.json

export BUILD_AMI_ID=$(jq '.builds[].artifact_id' -r manifest.json | cut -d':' -f2);
echo $BUILD_AMI_ID;
