**Day 27**

**Topics for today’s session**

* EFS  
* CloudFormation  
* Terraform

**CloudFormation Template Reference**

[AWS CloudFormation Sample Templates \- AWS GovCloud (US) region (amazon.com)](https://aws.amazon.com/cloudformation/resources/templates/govcloud-us/)

[CloudFormation Templates (amazon.com)](https://aws.amazon.com/cloudformation/resources/templates/)

**Cloudformation Resource Properties**

[AWS::EC2::Instance \- AWS CloudFormation (amazon.com)](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html?icmpid=docs\_cfn\_console\_designer)

**CloudFormation Script for Creating Multi Tier VPC Architecture**

*AWSTemplateFormatVersion: 2010-09-09*

*Description:  This template deploys a VPC, with a pair of public and private subnets spread*  
  *across two Availability Zones. It deploys an internet gateway, with a default*  
  *route on the public subnets. It deploys a pair of NAT gateways (one in each AZ),*  
  *and default routes for them in the private subnets.*

*Parameters:*  
  *EnvironmentName:*  
    *Description: An environment name that is prefixed to resource names*  
    *Type: String*

  *VpcCIDR:*  
    *Description: Please enter the IP range (CIDR notation) for this VPC*  
    *Type: String*  
    *Default: 10.192.0.0/16*

  *PublicSubnet1CIDR:*  
    *Description: Please enter the IP range (CIDR notation) for the public subnet in the first Availability Zone*  
    *Type: String*  
    *Default: 10.192.10.0/24*

  *PublicSubnet2CIDR:*  
    *Description: Please enter the IP range (CIDR notation) for the public subnet in the second Availability Zone*  
    *Type: String*  
    *Default: 10.192.11.0/24*

  *PrivateSubnet1CIDR:*  
    *Description: Please enter the IP range (CIDR notation) for the private subnet in the first Availability Zone*  
    *Type: String*  
    *Default: 10.192.20.0/24*

  *PrivateSubnet2CIDR:*  
    *Description: Please enter the IP range (CIDR notation) for the private subnet in the second Availability Zone*  
    *Type: String*  
    *Default: 10.192.21.0/24*

*Resources:*  
  *VPC:*  
    *Type: AWS::EC2::VPC*  
    *Properties:*  
      *CidrBlock: \!Ref VpcCIDR*  
      *EnableDnsSupport: true*  
      *EnableDnsHostnames: true*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Ref EnvironmentName*

  *InternetGateway:*  
    *Type: AWS::EC2::InternetGateway*  
    *Properties:*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Ref EnvironmentName*

  *InternetGatewayAttachment:*  
    *Type: AWS::EC2::VPCGatewayAttachment*  
    *Properties:*  
      *InternetGatewayId: \!Ref InternetGateway*  
      *VpcId: \!Ref VPC*

  *PublicSubnet1:*  
    *Type: AWS::EC2::Subnet*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *AvailabilityZone: \!Select \[ 0, \!GetAZs '' \]*  
      *CidrBlock: \!Ref PublicSubnet1CIDR*  
      *MapPublicIpOnLaunch: true*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Public Subnet (AZ1)*

  *PublicSubnet2:*  
    *Type: AWS::EC2::Subnet*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *AvailabilityZone: \!Select \[ 1, \!GetAZs  '' \]*  
      *CidrBlock: \!Ref PublicSubnet2CIDR*  
      *MapPublicIpOnLaunch: true*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Public Subnet (AZ2)*

  *PrivateSubnet1:*  
    *Type: AWS::EC2::Subnet*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *AvailabilityZone: \!Select \[ 0, \!GetAZs  '' \]*  
      *CidrBlock: \!Ref PrivateSubnet1CIDR*  
      *MapPublicIpOnLaunch: false*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Private Subnet (AZ1)*

  *PrivateSubnet2:*  
    *Type: AWS::EC2::Subnet*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *AvailabilityZone: \!Select \[ 1, \!GetAZs  '' \]*  
      *CidrBlock: \!Ref PrivateSubnet2CIDR*  
      *MapPublicIpOnLaunch: false*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Private Subnet (AZ2)*

  *NatGateway1EIP:*  
    *Type: AWS::EC2::EIP*  
    *DependsOn: InternetGatewayAttachment*  
    *Properties:*  
      *Domain: vpc*

  *NatGateway2EIP:*  
    *Type: AWS::EC2::EIP*  
    *DependsOn: InternetGatewayAttachment*  
    *Properties:*  
      *Domain: vpc*

  *NatGateway1:*  
    *Type: AWS::EC2::NatGateway*  
    *Properties:*  
      *AllocationId: \!GetAtt NatGateway1EIP.AllocationId*  
      *SubnetId: \!Ref PublicSubnet1*

  *NatGateway2:*  
    *Type: AWS::EC2::NatGateway*  
    *Properties:*  
      *AllocationId: \!GetAtt NatGateway2EIP.AllocationId*  
      *SubnetId: \!Ref PublicSubnet2*

  *PublicRouteTable:*  
    *Type: AWS::EC2::RouteTable*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Public Routes*

  *DefaultPublicRoute:*  
    *Type: AWS::EC2::Route*  
    *DependsOn: InternetGatewayAttachment*  
    *Properties:*  
      *RouteTableId: \!Ref PublicRouteTable*  
      *DestinationCidrBlock: 0.0.0.0/0*  
      *GatewayId: \!Ref InternetGateway*

  *PublicSubnet1RouteTableAssociation:*  
    *Type: AWS::EC2::SubnetRouteTableAssociation*  
    *Properties:*  
      *RouteTableId: \!Ref PublicRouteTable*  
      *SubnetId: \!Ref PublicSubnet1*

  *PublicSubnet2RouteTableAssociation:*  
    *Type: AWS::EC2::SubnetRouteTableAssociation*  
    *Properties:*  
      *RouteTableId: \!Ref PublicRouteTable*  
      *SubnetId: \!Ref PublicSubnet2*

  *PrivateRouteTable1:*  
    *Type: AWS::EC2::RouteTable*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Private Routes (AZ1)*

  *DefaultPrivateRoute1:*  
    *Type: AWS::EC2::Route*  
    *Properties:*  
      *RouteTableId: \!Ref PrivateRouteTable1*  
      *DestinationCidrBlock: 0.0.0.0/0*  
      *NatGatewayId: \!Ref NatGateway1*

  *PrivateSubnet1RouteTableAssociation:*  
    *Type: AWS::EC2::SubnetRouteTableAssociation*  
    *Properties:*  
      *RouteTableId: \!Ref PrivateRouteTable1*  
      *SubnetId: \!Ref PrivateSubnet1*

  *PrivateRouteTable2:*  
    *Type: AWS::EC2::RouteTable*  
    *Properties:*  
      *VpcId: \!Ref VPC*  
      *Tags:*  
        *\- Key: Name*  
          *Value: \!Sub ${EnvironmentName} Private Routes (AZ2)*

  *DefaultPrivateRoute2:*  
    *Type: AWS::EC2::Route*  
    *Properties:*  
      *RouteTableId: \!Ref PrivateRouteTable2*  
      *DestinationCidrBlock: 0.0.0.0/0*  
      *NatGatewayId: \!Ref NatGateway2*

  *PrivateSubnet2RouteTableAssociation:*  
    *Type: AWS::EC2::SubnetRouteTableAssociation*  
    *Properties:*  
      *RouteTableId: \!Ref PrivateRouteTable2*  
      *SubnetId: \!Ref PrivateSubnet2*

  *NoIngressSecurityGroup:*  
    *Type: AWS::EC2::SecurityGroup*  
    *Properties:*  
      *GroupName: "no-ingress-sg"*  
      *GroupDescription: "Security group with no ingress rule"*  
      *VpcId: \!Ref VPC*

*Outputs:*  
  *VPC:*  
    *Description: A reference to the created VPC*  
    *Value: \!Ref VPC*

  *PublicSubnets:*  
    *Description: A list of the public subnets*  
    *Value: \!Join \[ ",", \[ \!Ref PublicSubnet1, \!Ref PublicSubnet2 \]\]*

  *PrivateSubnets:*  
    *Description: A list of the private subnets*  
    *Value: \!Join \[ ",", \[ \!Ref PrivateSubnet1, \!Ref PrivateSubnet2 \]\]*

  *PublicSubnet1:*  
    *Description: A reference to the public subnet in the 1st Availability Zone*  
    *Value: \!Ref PublicSubnet1*

  *PublicSubnet2:*  
    *Description: A reference to the public subnet in the 2nd Availability Zone*  
    *Value: \!Ref PublicSubnet2*

  *PrivateSubnet1:*  
    *Description: A reference to the private subnet in the 1st Availability Zone*  
    *Value: \!Ref PrivateSubnet1*

  *PrivateSubnet2:*  
    *Description: A reference to the private subnet in the 2nd Availability Zone*  
    *Value: \!Ref PrivateSubnet2*

  *NoIngressSecurityGroup:*  
    *Description: Security group with no ingress rule*  
    *Value: \!Ref NoIngressSecurityGroup*

### 

### **Project : 19 August**

### **Project: Deploying a Multi-Tier Architecture Application using CloudFormation**

#### **Lab**

**Regions Allowed:** us-east-1, us-east-2, us-west-1, us-west-2

**Roles for EC2 granting full access to S3:** arn:aws:iam::************:role/EC2-S3-Role

#### **Project Objective:**

This project will test your ability to deploy a multi-tier architecture application using AWS CloudFormation. The deployment should include an EC2 instance, an S3 bucket, a MySQL DB instance in RDS, and a VPC, all within the specified constraints.

#### **Project Overview:**

You are required to design and deploy a multi-tier application using AWS CloudFormation. The architecture will include the following components:

1. **EC2 Instance**: Serve as the web server.  
2. **S3 Bucket**: Store static assets or configuration files.  
3. **RDS MySQL DB Instance**: Serve as the database backend.  
4. **VPC**: Ensure secure communication between the components.

#### **Specifications:**

* **EC2 Instance**: Use a `t2.micro` instance type, located in the public subnet, with SSH access allowed from a specific IP range.  
* **RDS MySQL DB Instance**: Use a `t3.micro` instance type, located in a private subnet.  
* **S3 Bucket**: Use for storing configuration files or assets for the web server.  
* **VPC**: Create a VPC with public and private subnets. No NAT Gateway or Elastic IP should be used. Internet access for the EC2 instance should be provided via an Internet Gateway attached to the VPC.  
* **CloudFormation Template**: Participants must create a CloudFormation template to automate the deployment process.  
* **Allowed Regions**: Deployment is restricted to the regions `us-east-1`, `us-east-2`, `us-west-1`, and `us-west-2`.

#### **Key Tasks:**

1. **Create a CloudFormation Template:**  
   * **VPC and Subnets**:  
     * Define a VPC with one public and one private subnet.  
    
**CF.yaml**
```yml
AWSTemplateFormatVersion: '2010-09-09'
Description: Make CloudFormation Template to deploy AWS resources.

Parameters:
  CustomVpcCidr:
    Type: String
    Default: '10.0.0.0/16'

  PubSubnet1CIDR:
    Type: String
    Default: '10.0.0.0/24'

  PubSubnet2CIDR:
    Type: String
    Default: '10.0.16.0/24'

  PvtSubnet1CIDR:
    Type: String
    Default: '10.0.32.0/24'

  PvtSubnet2CIDR:
    Type: String
    Default: '10.0.48.0/24'

Resources:
  MyVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref CustomVpcCidr
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: MyVPC-Bhavin

  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: !Ref PubSubnet1CIDR
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: Bhavin_pub_sub1

  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: !Ref PubSubnet2CIDR
      AvailabilityZone: !Select [1, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: Bhavin_pub_sub2

  PrivateSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: !Ref PvtSubnet1CIDR
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: Bhavin_pvt_sub1

  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: !Ref PvtSubnet2CIDR
      AvailabilityZone: !Select [1, !GetAZs '']
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: Bhavin_pvt_sub2

  # Create IGW
  CreateIgw:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: Bhavin-Igw

  # Attach IGW to your Custom VPC 
  IgwAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      InternetGatewayId: !Ref CreateIgw
      VpcId: !Ref MyVPC

  # Create Public Route Table
  PubRtb:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: Bhavin-Pub-rtb

  PublicRoute:
    Type: AWS::EC2::Route
    DependsOn: IgwAttachment
    Properties:
      RouteTableId: !Ref PubRtb
      DestinationCidrBlock: '0.0.0.0/0'
      GatewayId: !Ref CreateIgw

  # Public Subnet Associations
  PublicSubnet1RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet1
      RouteTableId: !Ref PubRtb

  PublicSubnet2RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet2
      RouteTableId: !Ref PubRtb

  # Create Private Route Table
  PvtRtb:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: Bhavin-pvt-rtb

  # Private Subnet Route Table Associations
  PrivateSubnet1RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet1
      RouteTableId: !Ref PvtRtb

  PrivateSubnet2RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet2
      RouteTableId: !Ref PvtRtb

```
  * Attach an Internet Gateway to the VPC for public subnet access.  
   * **Security Groups**:  
     * Create a security group for the EC2 instance, allowing SSH and HTTP access from a specific IP range.  

**Create EC2 SG**

```yml

  CreateEc2Sg:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Bhavin-Cf-Ec2-Sg
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          CidrIp: 0.0.0.0/0

        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
      
      SecurityGroupEgress:
        - IpProtocol: "-1"
          CidrIp: 0.0.0.0/0
          Description: Allow all outbound traffic
```

  * Create a security group for the RDS instance, allowing MySQL access from the EC2 instance only.  

```yml
  CreateRdsSg:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow Request from Ec2 SG into Rds SG
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 3306
          ToPort: 3306
          SourceSecurityGroupId: !Ref CreateEc2Sg
```
   * **EC2 Instance**:  
     * Launch a `t2.micro` EC2 instance in the public subnet.  
```yml
# Create EC2 Instance
  WebServerEc2:
    Type: AWS::EC2::Instance
    Properties:
      AvailabilityZone: !Select [0, !GetAZs '']
      ImageId: !Ref Ec2Id
      InstanceType: !Ref InstanceType
      KeyName: !Ref SSHKeyName
      SecurityGroupIds:
      - !Ref CreateEc2Sg
      SubnetId: !Ref PublicSubnet1
      UserData: !Base64
        Fn::Sub: | 
          #!/bin/bash
          sudo apt-get update -y
          sudo apt-get install -y nginx mysql-client
          sudo systemctl start nginx
          sudo systemctl enable nginx

      Tags:
      - Key: Name
        Value: Bhavin-cf-ec2
```
**Ensure ec2 is launched**

![alt text](<p1/Screenshot from 2024-08-24 19-03-27.png>)

![alt text](<p1/Screenshot from 2024-08-24 19-04-29.png>)

  * Configure the instance to access the S3 bucket and connect to the RDS instance.  

**Set up RDS and EC2 to Connect and communications**

```yml
# Create RDS 

  CreateRdsInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceClass: 'db.t3.micro'
      Engine: MySQL
      MasterUsername: !Ref MasterUsername
      MasterUserPassword: !Ref MasterUserPassword
      AllocatedStorage: 20
      DBSubnetGroupName: !Ref RdsDbSubnetGroup
      VPCSecurityGroups: 
      - !Ref CreateRdsSg

# Create RDS DB SunbetGroup to deploy RDS Instance in this pvt subnet
  RdsDbSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Create DB Subnet Group for RDS to deploy in your custom vpc
      SubnetIds:
      - !Ref PrivateSubnet1
      - !Ref PrivateSubnet2

```

**EC2 Instance get connected to RDS**

![alt text](<p1/Screenshot from 2024-08-24 19-49-02.png>)


   * **S3 Bucket**:  
     * Create an S3 bucket for storing static assets or configuration files.  
     * Ensure the EC2 instance has the necessary IAM role and permissions to access the S3 bucket.  
   * **RDS MySQL DB Instance**:  
     * Launch a `t3.micro` MySQL database in the private subnet.  
     * Configure the security group to allow access only from the EC2 instance.  
2. **Deploy the Application:**  
   * Deploy the CloudFormation stack using the template created.  
   * Verify that all components are correctly configured and operational.  
   * Ensure the EC2 instance can communicate with the RDS instance and access the S3 bucket.  
3. **Testing:**  
   * Test the deployed application by accessing it via the EC2 instance's public IP or DNS.  
   * Verify the connectivity between the EC2 instance and the RDS instance.  
   * Confirm that the EC2 instance can read from and write to the S3 bucket.  
4. **Documentation:**  
   * Document the entire process, including the design decisions, the CloudFormation template, and the testing steps.  
   * Include screenshots or logs demonstrating the successful deployment and testing of the application.  
5. **Resource Termination:**  
   * Once the deployment and testing are complete, terminate all resources by deleting the CloudFormation stack.  
   * Ensure that no resources, such as EC2 instances, RDS instances, or S3 buckets, are left running.

#### **Deliverables:**

* **CloudFormation Template**: A complete template file (`.yaml` or `.json`) used for deployment.  
* **Deployment Documentation**: Detailed documentation covering the deployment steps, design decisions, and testing process.  
* **Test Results**: Evidence of successful deployment and testing, including screenshots or logs.  
* **Cleanup Confirmation**: Confirmation that all resources have been terminated and no charges will continue to accrue.

#### **Estimated Time:**

This project is designed to be completed in **2 hours**.

#### **Regions:**

Ensure that the deployment is carried out only in the following AWS regions:

* `us-east-1`  
* `us-east-2`  
* `us-west-1`  
* `us-west-2`

**Note:** Participants should ensure that they follow the guidelines strictly, especially the use of `t2.micro` and `t3.micro`instance types, and the restriction on using NAT Gateway and Elastic IPs.

