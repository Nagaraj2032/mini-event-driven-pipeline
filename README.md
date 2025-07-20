# Mini Event-Driven Pipeline

![CI/CD](https://github.com/Nagaraj2032/mini-lambda-pipeline/actions/workflows/deploy.yml/badge.svg)

This project implements a **mini event-driven data processing pipeline** on AWS using:
- **S3** for event source
- **AWS Lambda** for processing
- **DynamoDB** for storage
- **Terraform** for infrastructure as code
- **GitHub Actions** for CI/CD automation

It automatically deploys the Lambda function and infrastructure on push to the `main` branch.

