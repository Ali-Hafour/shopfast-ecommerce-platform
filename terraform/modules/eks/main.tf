resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.33"

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "${var.project_name}-cluster"
  }
}


#################################################
# Worker Node IAM Role
#################################################

resource "aws_iam_role" "node_role" {
  name = "${var.project_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-node-role"
  }
}


resource "aws_iam_role_policy_attachment" "worker_node" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


#################################################
# Required for AWS Load Balancer Controller
#################################################

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


#################################################
# Managed Node Group
#################################################

resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-workers"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnets

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.cni,
    aws_iam_role_policy_attachment.ecr,
    aws_iam_role_policy_attachment.ssm
  ]

  tags = {
    Name = "${var.project_name}-workers"
  }
}
resource "aws_security_group_rule" "bastion_to_eks_api" {

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id

  source_security_group_id = var.bastion_security_group_id
}
