output "api_repository_url" {
  value = aws_ecr_repository.api.repository_url
}

output "payment_repository_url" {
  value = aws_ecr_repository.payment.repository_url
}

output "search_repository_url" {
  value = aws_ecr_repository.search.repository_url
}

output "web_repository_url" {
  value = aws_ecr_repository.web.repository_url
}


output "repository_urls" {
  value = {
    api     = aws_ecr_repository.api.repository_url
    payment = aws_ecr_repository.payment.repository_url
    search  = aws_ecr_repository.search.repository_url
    web     = aws_ecr_repository.web.repository_url
  }
}
