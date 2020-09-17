# ------------------------------------------------------------------------------
# Setup job to deploy the emr task.
# ------------------------------------------------------------------------------
resource "aws_codebuild_project" "service-build" {
  count = length(local.terraform_envs)
  name          = "service-build"
  service_role  = "arn:aws:iam::707965404768:role/DemoCodeBuildServiceRole"
  build_timeout = "120"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "ENVIRONMENT"
      value = element(local.terraform_envs,count.index)
    }

    environment_variable {
      name  = "ACTION"
      value = "apply"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/shergill-iron-net/code-pipeline-demo"
    git_clone_depth = 1
    buildspec       = "buildspec/build.yml"
  }

  vpc_config {
    vpc_id = "vpc-0df9705705346cad9"

    subnets = [
      "subnet-0e163b02adcf07ab7"
    ]

    security_group_ids = [
      "sg-03ab9d44472d7086b",
    ]
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  tags = {
    TERRAFORMED = "cloud-infra/codepipeline-build"
  }

}

# ------------------------------------------------------------------------------
# Setup job to deploy the emr task.
# ------------------------------------------------------------------------------
resource "aws_codebuild_project" "service-test" {
  count = length(local.terraform_envs)
  name          = "service-test"
  service_role  = "arn:aws:iam::707965404768:role/DemoCodeBuildServiceRole"
  build_timeout = "120"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "ENVIRONMENT"
      value = element(local.terraform_envs,count.index)
    }

    environment_variable {
      name  = "ACTION"
      value = "apply"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/shergill-iron-net/code-pipeline-demo"
    git_clone_depth = 1
    buildspec       = "buildspec/test.yml"
  }

  vpc_config {
    vpc_id = "vpc-0df9705705346cad9"

    subnets = [
      "subnet-0e163b02adcf07ab7"
    ]

    security_group_ids = [
      "sg-03ab9d44472d7086b",
    ]
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  tags = {
    TERRAFORMED = "cloud-infra/codepipeline-test"
  }

}


# ------------------------------------------------------------------------------
# Setup job to deploy the emr task.
# ------------------------------------------------------------------------------
resource "aws_codebuild_project" "service-deploy" {
  count = length(local.terraform_envs)
  name          = "service-deploy"
  service_role  = "arn:aws:iam::707965404768:role/DemoCodeBuildServiceRole"
  build_timeout = "120"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "ENVIRONMENT"
      value = element(local.terraform_envs,count.index)
    }

    environment_variable {
      name  = "ACTION"
      value = "apply"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/shergill-iron-net/code-pipeline-demo"
    git_clone_depth = 1
    buildspec       = "buildspec/deploy.yml"
  }

  vpc_config {
    vpc_id = "vpc-0df9705705346cad9"

    subnets = [
      "subnet-0e163b02adcf07ab7"
    ]

    security_group_ids = [
      "sg-03ab9d44472d7086b",
    ]
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  tags = {
    TERRAFORMED = "cloud-infra/codepipeline-deploy"
  }

}

locals {
  terraform_envs   = ["dev"]
}

