resource "aws_ecr_repository" "app_services" {
  for_each             = toset(local.ecr_repositories)
  name                 = each.value
  image_tag_mutability = "IMMUTABLE"
}

locals {
  ecr_repositories = [
    "backend",
    "frontend"
  ]
}

resource "aws_ecr_lifecycle_policy" "papp_services_lifecycle" {
  for_each   = aws_ecr_repository.app_service
  repository = each.value.name
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only keep last 20 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 20
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF  
}