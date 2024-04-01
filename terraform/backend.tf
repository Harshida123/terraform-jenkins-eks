#bucket already in aws
terraform {
  backend "s3" {
    bucket = "eks-cicd-jenkins"
    key = "jenkins/terraform.tfstate"
    region = "ap-south-1" 
  }
}
 