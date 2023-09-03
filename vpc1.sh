#!/bin/bash



# Create a VPC
vpc_info=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16)

# store the VPC ID to verify
vpc_id=$(echo "$vpc_info" | grep -o '"VpcId": "[^"]*' | awk -F'": "' '{print $2}')

echo "The VPC has been created"
echo "The VPC ID: $vpc_id"
echo ""
echo ""

# Create Public Subnet 1 in the First Availability Zone
subnet_info=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.0.0/24 --availability-zone us-west-2a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public Subnet 1}]')

# extract the Subnet ID and store it in a variable
subnet_id=$(echo "$subnet_info" | grep -o '"SubnetId": "[^"]*' | awk -F'": "' '{print $2}')

# Print the Subnet ID to verify
echo "The subnet has been created"
echo "Public Subnet 1 ID: $subnet_id"
echo ""
echo ""


# Create Private Subnet 1 in the First Availability Zone

subnet_info2=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 --availability-zone us-west-2a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private Subnet 1}]')
# extract the Subnet ID and store it in a variable
subnet_id2=$(echo "$subnet_info2" | grep -o '"SubnetId": "[^"]*' | awk -F'": "' '{print $2}')
# Print the Subnet ID to verify

# Print the Subnet ID to verify
echo "The subnet has been created"
echo "Private Subnet 1 ID: $subnet_id2"
echo ""
echo ""

# Create Public Subnet 2 in the seconed Availability Zone
subnet_info3=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 --availability-zone us-west-2b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public Subnet 2}]')
# extract the Subnet ID and store it in a variable
subnet_id3=$(echo "$subnet_info3" | grep -o '"SubnetId": "[^"]*' | awk -F'": "' '{print $2}')
# Print the Subnet ID to verify

# Print the Subnet ID to verify
echo "The subnet has been created"
echo "Public Subnet 2 ID: $subnet_id3"
echo ""
echo ""

# Create Private Subnet 2 in the seconed Availability Zone
subnet_info4=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.3.0/24 --availability-zone us-west-2b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private Subnet 2}]')
# extract the Subnet ID and store it in a variable
subnet_id4=$(echo "$subnet_info4" | grep -o '"SubnetId": "[^"]*' | awk -F'": "' '{print $2}')
# Print the Subnet ID to verify
echo "The subnet has been created"
echo "Private Subnet 2 ID: $subnet_id4"
echo ""
echo ""


#Create a Public Route-table
route_table_public=$(aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=Public route table}]'
)
route_table_public_id=$(echo "$route_table_public" | grep -o '"RouteTableId": "[^"]*' | awk -F'": "' '{print $2}')
echo "The route table public has been created"
echo "The route table public ID: $route_table_public_id"
echo ""
echo ""


#Create a Private Route-table
route_table_private=$(aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=Private route table}]'
)
route_table_private_id=$(echo "$route_table_private" | grep -o '"RouteTableId": "[^"]*' | awk -F'": "' '{print $2}')
echo "The route table private has been created"
echo "The route table private ID: $route_table_private_id"
echo ""
echo ""


# Associate Public Subnet 1 in the first availability zone with public-route-table
$(aws ec2 associate-route-table --subnet-id "$subnet_id" --route-table-id "$route_table_public_id")
echo "Public Subnet 1 Associated to the Public route table"
# Associate Private Subnet 1 in the first availability zone with public-route-table
$(aws ec2 associate-route-table --route-table-id "$route_table_private_id" --subnet-id "$subnet_id2")
echo "Private Subnet 1 Associated to the Private route table"
# Associate Public Subnet 2 in the second availability zone with private-route-table
$(aws ec2 associate-route-table --subnet-id "$subnet_id3" --route-table-id "$route_table_public_id")
echo "Public Subnet 2 Associated to the Public route table"
# Associate Private Subnet 2 in the second availability zone with private-route-table
$(aws ec2 associate-route-table --route-table-id "$route_table_private_id" --subnet-id "$subnet_id4")
echo "Private Subnet 2 Associated to the Private route table"

#Create an IGW
igw=$(aws ec2 create-internet-gateway)
igw_id=$(echo "$igw" | grep -o '"InternetGatewayId": "[^"]*' | awk -F'": "' '{print $2}')
echo "The internet gate away has been created"
echo "The internet gate away ID: $igw_id"
echo ""
echo ""
# Attach the Internet Gateway to Your VPC
$(aws ec2 attach-internet-gateway --internet-gateway-id $igw_id --vpc-id $vpc_id)
echo "The Internet Gateway has been attached to the VPC"




