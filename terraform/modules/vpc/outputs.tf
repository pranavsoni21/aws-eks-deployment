output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.eks_public_subnet[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.eks_private_subnet[*].id
}