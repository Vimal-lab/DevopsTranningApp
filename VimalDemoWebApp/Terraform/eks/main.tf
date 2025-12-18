module "vpc" {
  source       = "../vpc"
  cluster_name = var.cluster_name
}


# --- IAM roles (created by Terraform, not hardcoded) ---
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_node_role" {
  name               = "${var.cluster_name}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# SSH access SG for managed node group remote access
resource "aws_security_group" "ssh_access_sg" {
  name        = "${var.cluster_name}-ssh-access-sg"
  description = "Allow SSH to EKS worker nodes (restrict admin_cidr for real use)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ELB SG (Classic ELB created by Service can attach this via annotation)
resource "aws_security_group" "app_elb_sg" {
  name        = "${var.cluster_name}-app-elb-sg"
  description = "Allow inbound HTTP to the Classic ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# ==================Controle plane creation ============================#



resource "aws_eks_cluster" "ekscluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id, module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
    endpoint_public_access  = true
    endpoint_private_access = true
  }

}


#==========================Workernodescreation=================================
resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.ekscluster.name
  node_group_name = join("-",[var.cluster_name,"workernodes"])
  node_role_arn   = aws_iam_role.eks_node_role.arn
  

  subnet_ids = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]

  capacity_type  = "ON_DEMAND"
  instance_types = [var.workernode_instance_type]
  disk_size      =  var.workernode_storage

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.ssh_access_sg.id]
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.maximum_worker_nodes
    min_size     = var.min_worker_nodes
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = var.cluster_name
  }
}