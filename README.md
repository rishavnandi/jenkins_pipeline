# Complete CI/CD Pipeline for a Flask Application

## Overview

This project is a web application that allows users to view stock price graphs and historical data for a given ticker symbol. It is built using Flask for the backend and uses yfinance to fetch stock data. The application is containerized using Docker and can be deployed on AWS using Terraform and Ansible.

This project was created for the purpose of learning and practicing CI/CD pipelines, infrastructure as code, and containerization.
So, it is not optimized for production use and is not recommended to be used in a production environment.

## Features

- Real-time stock price graphs using FinViz charts
- Historical price data in a tabular format
- Responsive web design with mobile support
- Automated CI/CD pipeline with Jenkins
- Infrastructure as Code using Terraform
- Automated deployment using Ansible
- Containerized application using Docker

## Prerequisites

- Docker
- Terraform
- Ansible
- Jenkins
- AWS account with appropriate permissions
- Python
- pip package manager

## Setup Instructions

### Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jenkins_pipeline.git
   cd jenkins_pipeline
   ```

2. **Create and activate a virtual environment (recommended):**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application:**
   ```bash
   flask run
   ```
   The application will be available at `http://localhost:5000`

### Docker Deployment

1. **Build the Docker image:**
   ```bash
   docker build -t flask-stock-app .
   ```

2. **Run the Docker container:**
   ```bash
   docker run -p 5000:5000 flask-stock-app
   ```
   Access the application at `http://localhost:5000`

### Production Deployment

#### 1. Infrastructure Setup

1. **Configure AWS credentials:**
   ```bash
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   export AWS_DEFAULT_REGION="your_preferred_region"
   ```

#### 2. Jenkins CI/CD Setup

1. **Deploy Jenkins server:**
   ```bash
   cd jenkins/terraform
   terraform init
   terraform apply
   ```

2. **Configure Jenkins:**
   ```bash
   cd ../ansible
   ansible-playbook playbook.yml
   ```

3. **Access Jenkins UI:**
   - Navigate to `http://<jenkins-server-ip>:8080`
   - Use the initial admin password displayed in the Ansible output
   - Install suggested plugins
   - Create admin user
   - Configure the following credentials:
     - Docker Hub credentials
     - AWS credentials
     - GitHub credentials

4. **Configure Jenkins Pipeline:**
   - Create a new pipeline job
   - Point it to your repository
   - Use the provided Jenkinsfile

#### 3. Application Deployment

1. **Update variables:**
   - Edit `main-server/ansible/vars.yml` with your Docker image details
   - Edit `jenkins/ansible/vars.yml` with your GitHub repository

2. **Deploy application:**
   ```bash
   cd main-server/ansible
   ansible-playbook playbook.yml
   ```

## Project Structure

```
.
├── app.py                 # Flask application
├── Dockerfile            # Docker configuration
├── requirements.txt      # Python dependencies
├── static/              # Static assets
├── templates/           # HTML templates
├── main-server/         # Main application deployment
│   ├── ansible/        # Ansible playbooks
│   └── terraform/      # Infrastructure as code
└── jenkins/            # Jenkins CI/CD setup
    ├── ansible/        # Jenkins configuration
    └── terraform/      # Jenkins infrastructure
```

## Acknowledgments

- yfinance for stock data API
- FinViz for stock charts
- Flask framework
- Jenkins community
- Terraform and Ansible communities
```