

resource "aws_iam_role" "eks_cluster" { 

  name = "eks-cluster-role" 

  

  assume_role_policy = jsonencode({ 

    Version = "2012-10-17" 

    Statement = [ 

      { 

        Action = "sts:AssumeRole" 

        Effect = "Allow" 

        Principal = { 

          Service = "eks.amazonaws.com" 

        } 

      } 

    ] 

  }) 

} 

  

resource "aws_iam_policy_attachment" "eks_cluster_policy" { 

  name       = "eks-cluster-policy" 

  roles      = [aws_iam_role.eks_cluster.name] 

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" 

} 
resource "aws_iam_policy" "kubernetes_deployments_policy" {
  name        = "kubernetes_deployments_policy"
  description = "IAM policy for performing kubectl apply operations for deployments in a specific namespace"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:ListUpdates",
        "eks:UpdateClusterVersion",
        "eks:CreateNodegroup",
        "eks:DeleteNodegroup",
        "eks:UpdateNodegroupConfig",
        "eks:UpdateNodegroupVersion",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:TagResource",
        "eks:UntagResource",
        "eks:DescribeUpdate",
        "eks:DescribeAddon",
        "eks:DescribeAddonVersions",
        "eks:DescribeClusterConfig",
        "eks:ListFargateProfiles",
        "eks:ListIdentityProviderConfigs",
        "eks:ListAddons",
        "eks:DescribeFargateProfile",
        "eks:DescribeIdentityProviderConfig",
        "eks:DescribeAddonVersion",
        "eks:ListClusters",
        "eks:ListUpdates",
        "eks:UpdateClusterVersion",
        "eks:CreateAddon",
        "eks:DeleteAddon",
        "eks:TagResource",
        "eks:UntagResource",
        "eks:ListFargateProfiles",
        "eks:ListIdentityProviderConfigs",
        "eks:ListAddons",
        "eks:DescribeAddonVersions",
        "eks:DescribeAddon",
        "eks:DescribeClusterConfig",
        "eks:DescribeIdentityProviderConfig",
        "eks:ListClusters",
        "eks:ListUpdates",
        "eks:UpdateClusterVersion",
        "eks:CreateAddon",
        "eks:DeleteAddon",
        "eks:TagResource",
        "eks:UntagResource",
        "eks:ListFargateProfiles",
        "eks:ListIdentityProviderConfigs",
        "eks:ListAddons",
        "eks:DescribeAddonVersions",
        "eks:DescribeAddon",
        "eks:DescribeClusterConfig",
        "eks:DescribeIdentityProviderConfig",
        "eks:ListClusters",
        "eks:ListUpdates",
        "eks:UpdateClusterVersion",
        "eks:CreateAddon",
        "eks:DeleteAddon",
        "eks:TagResource",
        "eks:UntagResource",
        "eks:ListFargateProfiles",
        "eks:ListIdentityProviderConfigs",
        "eks:ListAddons",
        "eks:DescribeAddonVersions",
        "eks:DescribeAddon",
        "eks:DescribeClusterConfig",
        "eks:DescribeIdentityProviderConfig",
        "eks:ListClusters",
        "eks:ListUpdates",
        "eks:UpdateClusterVersion",
        "eks:CreateAddon",
        "eks:DeleteAddon",
        "eks:TagResource",
        "eks:UntagResource",
        "eks:ListFargateProfiles",
        "eks:ListIdentityProviderConfigs",
        "eks:ListAddons",
        "eks:DescribeAddonVersions",
        "eks:DescribeAddon",
        "eks:DescribeClusterConfig",
        "eks:DescribeIdentityProviderConfig"
      ],
      Resource = ["*"]
    }]
  })
}


resource "aws_iam_role_policy_attachment" "attach_kubernetes_policy" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.kubernetes_deployments_policy.arn
}

 


  

# Get default VPC id 

data "aws_vpc" "default" { 

  default = true 

} 

  

# Get public subnets in VPC 

data "aws_subnets" "public" { 

  filter { 

    name   = "vpc-id" 

    values = [data.aws_vpc.default.id] 

  } 

} 

  

resource "aws_eks_cluster" "eks" { 

  name     = "my-eks-cluster" 

  role_arn = aws_iam_role.eks_cluster.arn 

  

  vpc_config { 

    subnet_ids = data.aws_subnets.public.ids 

  } 

} 

  

resource "aws_iam_role" "example" { 

  name = "eks-node-group-example" 

  

  assume_role_policy = jsonencode({ 

    Statement = [{ 

      Action = "sts:AssumeRole" 

      Effect = "Allow" 

      Principal = { 

        Service = "ec2.amazonaws.com" 

      } 

    }] 

    Version = "2012-10-17" 

  }) 

} 

  

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" { 

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" 

  role       = aws_iam_role.example.name 

} 

  

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" { 

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" 

  role       = aws_iam_role.example.name 

} 

  

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" { 

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" 

  role       = aws_iam_role.example.name 

} 

  

# Create managed node group 

resource "aws_eks_node_group" "example" { 

  cluster_name    = aws_eks_cluster.eks.name 

  node_group_name = "managed-nodes" 

  node_role_arn   = aws_iam_role.example.arn 

  

  subnet_ids = data.aws_subnets.public.ids 

  scaling_config { 

    desired_size = 1 

    max_size     = 2 

    min_size     = 1 

  } 

  instance_types = ["t2.micro"] 

  

  depends_on = [ 

    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy, 

    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy, 

    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly, 

    aws_eks_cluster.eks 

  ] 

} 
