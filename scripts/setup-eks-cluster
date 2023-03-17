#!/bin/bash

sudo rm ~/.kube/config

if (!(aws eks list-clusters | grep Final))
then

#create a cluster called Final with fargate nodes
eksctl create cluster --name Final --version 1.25 --fargate

#Associate iam odc provider
eksctl utils associate-iam-oidc-provider --cluster Final --approve

#Download Iam policy for eks cluster
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json

#Create the downloaded Iam Policy in aws
aws iam create-policy \
   --policy-name AWSLoadBalancerControllerIAMPolicy \
   --policy-document file://iam_policy.json

#Create a service account using cloud watch for eks aws-load-balancer controller
eksctl create iamserviceaccount \
  --cluster=Final \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::282179771650:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

#Verify the service account
eksctl get iamserviceaccount --cluster Final --name aws-load-balancer-controller --namespace kube-system

#Add eks helm chart
sudo helm repo add eks https://aws.github.io/eks-charts

#Add aws load balancer containers
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

#Set context to created cluster
aws eks update-kubeconfig --region us-west-2 --name Final

#Get the ID of the VPC created during cluster creation
ID=`aws ec2 describe-vpcs --filter Name=tag:Name,Values=eksctl-Final-cluster/VPC --query Vpcs[].VpcId --output text`

#Install Aws LoadBalancer controller in teh cluster
sudo helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    --set clusterName=Final \
    --set serviceAccount.create=false \
    --set region=us-west-2 \
    --set vpcId=$ID \
    --set serviceAccount.name=aws-load-balancer-controller \
    -n kube-system

else
# Do nothing, the cluster is already present
echo Cluster already present
fi
