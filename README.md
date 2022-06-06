## Infrastructure
1. `AWS S3 bucket` to hold software artifact.
2. `AWS lambda function` to run software artifacts.
3. `AWS API Gateway` to trigger lambda function.

## Pipeline
1. `Build`: create zip file containing all it's needed to execute code as lambda function on AWS.
2. `Release`: create `AWS S3 object` with the zip file.
3. `Publish`: update lambda function to run the new released version of the software.