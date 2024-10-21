# Portfolio DSO_Boardgame Project
This is my 1st Jenkins and Github Actions pipeline I configured. I followed the YouTube video https://www.youtube.com/watch?v=NnkUGzaqqOc&t=1794s by DEVOPS Shack and forked https://github.com/jaiswaladi246/Boardgame as a base project. I added and will continue to add more security stages and jobs as I gain more knowledge on DevSecOps best practices and tools. 

## Description

**Board Game Database Full-Stack Web Application.**
This CRUD web application displays lists of board games and their reviews. While anyone can view the board game lists and reviews, they are required to log in to add/ edit the board games and their reviews. The 'users' have the authority to add board games to the list and add reviews, and the 'managers' have the authority to edit/ delete the reviews on top of the authorities of users.  


## Pipeline Overview and Workflow
- The CI pipeline is triggered on every push. It consists of the following major stages:
- Checkout Code: Pull the latest version of the repository.
- A install and use Bandit a Python security analyzer that looks for common security issues.
- Trivy is used to scan the file system for vulnerabilities in the code.
- Use SonarQube server: A tool to detect bugs, vulnerabilities, and code smells.
- OWASP Dependency-Check: Scans project dependencies to identify known vulnerabilities.
- TruffleHog: Scans the repository for sensitive information such as hardcoded secrets.
- GitGuardian: Scans for any potential secret leaks in the repository.
- After SAST Scan passes, the Docker image is built and scanned for vulnerabilities before being pushed to Docker Hub.
- Trivy Image Scan again: Scans the Docker image for vulnerabilities before pushing it.
- Push Docker Image to Docker Hub: Logs into Docker Hub and pushes the Docker image.
- Finally, the pipeline deploys the application to a Kubernetes cluster using kubectl.

## Tools and Dependencies
- An AWS EC2 VM running a Jenkins server with Trivy, Maven, Docker, Kubectl and Prometheus Node Exporter installed
- An AWS EC2 instance for the Runner server with Docker, Trivy, Maven, and Gitguardian installed
- An AWS EC2 VM running the Official Sonarqube container
- An AWS EC2 VM running the Official Nexus container
- An AWS EC2 VM running a Prometheus server with Grafana and Blackbox installed
- An AWS EC2 VM running a Kubernetes Controller node
- An AWS EC2 VMs running Kubernetes Worker nodes

 ** for detailed steps in setup, refer to my CICD pipeline repository: https://github.com/jimjrxieb/Terraform_CICD_Setup

