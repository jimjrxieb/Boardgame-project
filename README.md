# 🎲 Board Game Review Platform - Cloud-Native DevSecOps Demo

## 🎯 Project Overview

Enterprise-grade **Spring Boot application** demonstrating cloud infrastructure, containerization, Kubernetes orchestration, and comprehensive DevSecOps automation. This project showcases end-to-end cloud engineering skills from development to production deployment.

**Live Application:** Board game review system with role-based authentication, REST API, and H2 database.

---

## 🛠️ Technology Stack & Skills Demonstrated

### **Backend Development**
- ☕ **Java 11** - Spring Boot 2.5.6, Spring Security, Spring Data JPA
- 🗄️ **Database** - H2 in-memory, JDBC, JPA/Hibernate
- 🔒 **Security** - Role-based access control (RBAC), authentication, authorization
- 🧪 **Testing** - JUnit, Spring Security Test, JaCoCo code coverage

### **Cloud & Infrastructure (IaC)**
- 🐳 **Docker** - Multi-stage builds, security hardening (non-root user, dropped capabilities)
- ☸️ **Kubernetes** - Deployments, Services, LoadBalancer, security contexts
- 🏗️ **Infrastructure as Code** - Kubernetes manifests, deployment automation
- 📦 **Artifact Management** - Maven, Nexus repository integration

### **DevSecOps & CI/CD**
- 🔄 **GitHub Actions** - Automated pipelines, matrix builds, self-hosted runners
- 🔧 **Jenkins** - Alternative pipeline with OWASP integration
- 🛡️ **Security Scanning** - 15+ integrated scanners:
  - **SAST:** SonarQube, Semgrep, Bandit
  - **Dependency Scanning:** OWASP Dependency-Check, Trivy, Snyk
  - **Container Scanning:** Trivy, Grype
  - **Secret Detection:** GitGuardian, TruffleHog, Gitleaks
  - **IaC Security:** KICS, Checkov, Terrascan
  - **Compliance:** Custom OPA policies
- 📊 **Code Quality** - SonarQube integration, JaCoCo coverage reports
- 🤖 **AI Security Analysis** - GP-Copilot automated fix recommendations

### **Monitoring & Observability**
- 📈 **Security Dashboard** - [GP-COPILOT/README.md](GP-COPILOT/README.md) - Real-time posture tracking
- 📋 **Executive Reporting** - Automated summaries for stakeholders
- 🔍 **Vulnerability Tracking** - Version-controlled security findings

---

## 🚀 Quick Start

### **Prerequisites**
- Java 11+ (OpenJDK or Oracle)
- Maven 3.6+
- Docker (optional)
- Kubernetes cluster (optional - AWS EKS, GCP GKE, Azure AKS, or Minikube)

### **1. Run Locally**
```bash
# Clone and navigate
git clone https://github.com/jimjrxieb/CLOUD-project.git
cd CLOUD-project

# Build and run
mvn clean package
java -jar target/database_service_project-0.0.4.jar

# Access application
open http://localhost:8080
```

**Default Credentials:**
- User: `user` / Password: `password`
- Manager: `manager` / Password: `password`

### **2. Run with Docker**
```bash
# Build JAR
mvn clean package

# Build and run container
docker build -t boardgame:latest .
docker run -p 8080:8080 boardgame:latest
```

### **3. Deploy to Kubernetes**
```bash
# Apply deployment
kubectl apply -f deployment-service.yaml

# Check status
kubectl get pods -l app=boardgame
kubectl get svc boardgame-ssvc

# Access via LoadBalancer IP
kubectl get svc boardgame-ssvc -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

---

## 📊 Application Features

### **REST API Endpoints**
- `GET /boardgames` - List all board games
- `GET /boardgames/{id}` - Get specific game
- `POST /boardgames` - Add new game (authenticated)
- `GET /boardgames/{id}/reviews` - Get reviews
- `POST /boardgames/{id}/reviews` - Add review (authenticated)

### **Web Interface**
- 🏠 **Home** - Public landing page
- 🎮 **Games Catalog** - Browse board games
- ⭐ **Reviews** - Read/write reviews
- 👤 **User Dashboard** - Authenticated user area
- 👔 **Manager Portal** - Admin functions

### **Security Features**
- Spring Security authentication
- Role-based authorization (USER, MANAGER)
- CSRF protection
- Secure password storage
- Access denied handling

---

## 🔐 Security Posture

### **Current Security Score: 37/100**
*(View [Live Dashboard](GP-COPILOT/README.md))*

- ✅ **0 Critical** vulnerabilities
- ✅ **0 High** severity issues
- 📋 **18 Medium** findings (best practices)
- 📋 **1 Low** finding

**Security Hardening Applied:**
- Non-root container user (UID 1001)
- Dropped ALL Linux capabilities
- Read-only root filesystem option
- Kubernetes security contexts
- Unprivileged pod execution

### **Automated Security Gates**
Every commit triggers:
1. ✅ Dependency vulnerability scan (Trivy)
2. ✅ Static code analysis (SonarQube)
3. ✅ Secret detection (GitGuardian, TruffleHog)
4. ✅ OWASP dependency check
5. ✅ Container security scan
6. ✅ IaC security validation (KICS)

**Failed security checks block deployment** - ensuring production systems meet security standards.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Load Balancer (K8s Service)          │
│                    Port 80 → 8080                       │
└──────────────────┬──────────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
┌───────▼────────┐   ┌───────▼────────┐
│  Pod Replica 1 │   │  Pod Replica 2 │
│                │   │                │
│  Spring Boot   │   │  Spring Boot   │
│  App (8080)    │   │  App (8080)    │
│                │   │                │
│  H2 Database   │   │  H2 Database   │
│  (in-memory)   │   │  (in-memory)   │
└────────────────┘   └────────────────┘
```

**Tech Stack Details:**
- **Application Layer:** Spring Boot with Thymeleaf (MVC)
- **Data Layer:** Spring Data JPA + H2 Database
- **Security Layer:** Spring Security (Filter Chain)
- **Container:** Docker (adoptopenjdk/openjdk11 base)
- **Orchestration:** Kubernetes Deployment (2 replicas)
- **Networking:** LoadBalancer Service

---

## 📂 Project Structure

```
CLOUD-project/
├── src/
│   ├── main/
│   │   ├── java/com/javaproject/
│   │   │   ├── controllers/        # REST + MVC controllers
│   │   │   ├── beans/              # Domain models
│   │   │   ├── database/           # Data access layer
│   │   │   ├── security/           # Security config
│   │   │   └── DatabaseServiceProjectApplication.java
│   │   └── resources/
│   │       ├── templates/          # Thymeleaf views
│   │       └── application.properties
│   └── test/                       # Unit tests
├── .github/
│   └── workflows/
│       ├── gh_actions.yml          # CI/CD pipeline
│       └── security_scan.yml       # Security automation (15+ scanners)
├── GP-COPILOT/                     # 🤖 AI Security Dashboard
│   ├── README.md                   # Live security posture
│   ├── reports/                    # Automated reports
│   └── scans/                      # Scan results (JSON)
├── Dockerfile                      # Container definition
├── deployment-service.yaml         # Kubernetes manifests
├── Jenkinsfile                     # Alternative CI/CD
├── pom.xml                         # Maven build config
└── sonar-project.properties        # Code quality config
```

---

## 🔄 CI/CD Pipeline

### **GitHub Actions Workflow**
```yaml
Trigger: Push to main
├── 🏗️  Build (self-hosted runner)
│   ├── Checkout code
│   ├── Setup JDK 17
│   ├── Maven build + test
│   ├── Upload JAR artifact
│   ├── Trivy filesystem scan
│   ├── SonarQube analysis
│   ├── TruffleHog secret scan
│   ├── OWASP dependency check
│   └── GitGuardian scan
├── 🐳 Docker Build
│   ├── Build image
│   ├── Trivy container scan
│   └── Push to registry
└── 🛡️  Security Gate
    └── GP-Copilot analysis
```

**Pipeline Features:**
- ✅ Automated testing with JUnit
- ✅ Code coverage with JaCoCo
- ✅ Quality gates (SonarQube)
- ✅ Artifact versioning (0.0.4)
- ✅ Self-hosted runner support
- ✅ Fail-fast on critical vulnerabilities

---

## 📈 DevSecOps Highlights

### **Shift-Left Security**
- Security checks run **before** code reaches production
- **Blocking vulnerabilities** prevent bad deployments
- Automated fix recommendations via GP-Copilot AI

### **Compliance & Governance**
- 🔍 **100% code coverage** for security scans
- 📋 **Audit trail** - All findings version-controlled
- 🤖 **Automated reporting** - Executive summaries on every scan
- 📊 **Risk scoring** - Quantified security posture (0-100)

### **Real-World Security**
- **Dependency vulnerabilities** detected and tracked
- **Container hardening** applied (CIS benchmarks)
- **Secret leakage prevention** with multiple scanners
- **IaC security** validation before deployment

---

## 🎓 Skills Demonstrated

### **Cloud Engineering**
✅ Design cloud-native architectures (12-factor app principles)
✅ Implement Infrastructure as Code (Kubernetes YAML)
✅ Container orchestration (K8s Deployments, Services, scaling)
✅ Cloud platform deployment (AWS EKS, GCP GKE, Azure AKS ready)

### **DevOps Automation**
✅ CI/CD pipeline design (GitHub Actions, Jenkins)
✅ Build automation (Maven, Docker multi-stage builds)
✅ Artifact management (Nexus integration)
✅ Self-hosted runner configuration

### **Security Engineering**
✅ SAST/DAST integration (15+ security tools)
✅ Vulnerability management workflow
✅ Container security hardening
✅ Secret detection and prevention
✅ Compliance automation (OPA policies)

### **Software Development**
✅ Java enterprise development (Spring Boot, JPA)
✅ RESTful API design
✅ Database design and ORM
✅ Test-driven development (JUnit)
✅ Code quality management (SonarQube)

---

## 🌐 Production Deployment

### **Deployment Options**

**AWS (EKS):**
```bash
aws eks create-cluster --name boardgame-cluster
aws eks update-kubeconfig --name boardgame-cluster
kubectl apply -f deployment-service.yaml
```

**Google Cloud (GKE):**
```bash
gcloud container clusters create boardgame-cluster
gcloud container clusters get-credentials boardgame-cluster
kubectl apply -f deployment-service.yaml
```

**Azure (AKS):**
```bash
az aks create --resource-group myRG --name boardgame-cluster
az aks get-credentials --resource-group myRG --name boardgame-cluster
kubectl apply -f deployment-service.yaml
```

### **Scaling**
```bash
# Horizontal scaling
kubectl scale deployment boardgame-deployment --replicas=5

# Autoscaling
kubectl autoscale deployment boardgame-deployment --min=2 --max=10 --cpu-percent=80
```

---

## 🔧 Development

### **Build Commands**
```bash
mvn clean compile          # Compile only
mvn clean test            # Run tests
mvn clean package         # Build JAR
mvn clean verify          # Run all checks
mvn sonar:sonar           # SonarQube analysis
```

### **Testing**
```bash
mvn test                           # Unit tests
mvn jacoco:report                  # Coverage report
open target/site/jacoco/index.html # View coverage
```

### **Local Database**
- **URL:** jdbc:h2:mem:testdb
- **Console:** http://localhost:8080/h2-console
- **User:** sa
- **Password:** *(empty)*

---

## 📜 License

This project is a portfolio demonstration for cloud engineering and DevSecOps capabilities.

---

## 🤖 AI-Powered Security

This project uses **GP-Copilot** - an AI security platform that:
- 🔍 Analyzes 15+ security scanners
- 🧠 Deduplicates findings intelligently
- 🛠️ Generates fix recommendations
- 📊 Provides executive summaries
- 📈 Tracks security posture over time

**View Live Dashboard:** [GP-COPILOT/README.md](GP-COPILOT/README.md)

---

**Built by:** [Your Name]
**Portfolio:** Demonstrating Cloud Engineering, Kubernetes, DevSecOps, and CI/CD expertise
