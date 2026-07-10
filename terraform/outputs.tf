output "alb_dns_name"      { value = aws_lb.app.dns_name }
output "app_server_ips"    { value = aws_instance.app[*].public_ip }
output "rds_endpoint"      { value = aws_db_instance.postgres.endpoint }
output "s3_bucket_name"    { value = aws_s3_bucket.assets.bucket }
