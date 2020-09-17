resource "aws_codepipeline" "codepipeline" {
  name     = "eks-service-pipeline"
  role_arn = "arn:aws:iam::707965404768:role/service-role/AWSCodePipelineServiceRole-us-east-1-IronCloud-Demo"

  artifact_store {
    location = "codepipeline-us-east-1-24962652373"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = "shergill-iron-net"
        Repo                 = "demo-codepipeline"
        Branch               = "master"
        PollForSourceChanges = false
        OAuthToken           = ""
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["zip_artifacts"]
      version         = "1"
      configuration = {
        ProjectName = "service-build"
      }
    }
  }

  stage {
    name = "Test"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["zip_artifacts"]
      version         = "1"
      run_order       = 2

      configuration = {
        ProjectName = "service-test"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name      = "Gate-Prod"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 1
    }

    action {
      name            = "Deploy-Prod"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["zip_artifacts"]
      version         = "1"
      run_order       = 2

      configuration = {
        ProjectName = "service-deploy"
      }
    }
  }
}
