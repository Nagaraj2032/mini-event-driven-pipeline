#  Mini Event-Driven Pipeline

![CI/CD](https://github.com/Nagaraj2032/mini-lambda-pipeline/actions/workflows/deploy.yml/badge.svg)

A **mini event-driven data processing pipeline** built on AWS using **Terraform** and **GitHub Actions CI/CD**. This project captures S3 object upload events, triggers a Lambda function, and stores processed results in DynamoDB.

---

## ✅ Features

* 📦 **S3 Trigger**: Automatically invokes a Lambda function on new object uploads
* 🧠 **AWS Lambda**: Custom Python function for processing file metadata
* 🗂️ **DynamoDB**: Stores processed event details in a NoSQL table
* ⚙️ **Terraform IaC**: Provisions AWS resources reproducibly
* 🔁 **CI/CD with GitHub Actions**: Automatically deploys Lambda + infrastructure on code push

---

## 🛠️ Tech Stack

| Category       | Technology     |
| -------------- | -------------- |
| Cloud Provider | AWS            |
| IaC Tool       | Terraform      |
| Compute        | AWS Lambda     |
| Storage        | S3, DynamoDB   |
| Language       | Python 3.11    |
| CI/CD          | GitHub Actions |

---

## 📁 Project Structure

```bash
mini-lambda-pipeline/
├── lambda/                    # Python Lambda source code
│   └── handler.py             # Lambda handler function
├── main.tf                    # Terraform root config
├── s3.tf                      # S3 bucket module
├── lambda.tf                  # Lambda + IAM roles
├── dynamodb.tf                # DynamoDB table
├── variables.tf               # Input variables
├── outputs.tf                 # Terraform outputs
├── .github/workflows/
│   └── deploy.yml             # GitHub Actions CI/CD workflow
└── README.md                  # You're reading it!
```


