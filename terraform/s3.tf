resource "aws_s3_bucket" "dreams_artifacts" {
  bucket = "dreams-artifacts"
}

data "archive_file" "artifact" {
  type        = "zip"

  source_dir = "${path.module}/../src/dreams"
  output_path = "${path.module}/dreams.zip"
}

resource "aws_s3_object" "artifact" {
  bucket = aws_s3_bucket.dreams_artifacts.bucket

  key    = data.archive_file.artifact.output_md5
  source = data.archive_file.artifact.output_path

  etag = filemd5(data.archive_file.artifact.output_path)
}
