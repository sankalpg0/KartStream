# KartStream: Cloud-Native Microservices on Amazon EKS with Observability

## 📌 Overview

KartStream is a **10 microservices-based cloud-native application** deployed on **Amazon Elastic Kubernetes Service (EKS)** with production-style networking, monitoring, and observability. This project demonstrates a full lifecycle from **local development** to **cloud-native deployment** on AWS, incorporating best practices for **security, scalability, and observability**.

---

## 🚀 Architecture

The application follows a **multi-tier architecture**:

* **Frontend**: Public-facing services (LoadBalancer + frontend pods).
* **Backend**: Business logic services (cart, checkout, currency, payment, etc.).
* **Database**: Redis-based cart storage.
* **Monitoring**: Prometheus, Grafana, Alertmanager for observability.

📸 **Architecture Diagram:**

![Architecture](a.png)

---

## 🔧 Phase 1 — Local Development & Kubernetes Readiness

* Authored a **Docker Compose setup** to build container images for all microservices.
* Pushed **versioned images to Docker Hub** for distribution.
* Created **Kubernetes manifests (Deployment + Service)** for each microservice.
* Validated service interactions on a **local Kubernetes cluster** (1 control-plane, 3 workers).
* Verified rollouts using `kubectl get pods/svc/deploy`.

📸 **kubectl Outputs (Local Validation):**

```bash
NAME                                     READY   STATUS    RESTARTS   AGE
adservice-984b8574-62mdg                 1/1     Running   0          2d18h
cartservice-749c6bf6d5-96qcr             1/1     Running   0          2d18h
...
```

---

## ☁️ Phase 2 — AWS Infrastructure & Secure Access

* **VPC Design**: Dedicated VPC with three subnets across Availability Zones (AZs):

  * Public subnet → Frontend components
  * Private subnet → Backend & Monitoring services
  * Private subnet → Database

* **Networking**:

  * Public Route Table → Internet Gateway (IGW) for public ingress/egress
  * Private Route Table → NAT Gateway for secure outbound internet access

* **Security**:

  * IAM Groups & Roles with **least-privilege access**
  * Hardened **Bastion Host** for secure access

📸 **VPC Setup:**

![VPC Setup](b.png)

---

## ⚙️ Amazon EKS Cluster & Node Groups

* Created an **Amazon EKS cluster** with IAM roles and HA control-plane.
* Defined **4 managed node groups**:

  * Frontend (public subnet)
  * Backend (private subnet)
  * Database (private subnet)
  * Monitoring (private subnet)
* Configured **taints, tolerations, and labels** to enforce workload isolation.

📸 **EKS Cluster View:**

![EKS Cluster](c.png)

📸 **Node Groups Configuration:**

![Node Groups](d.png)

---

## 📦 Application Deployment on AWS

* Cloned the repo onto the **Bastion Host**.
* Deployed microservices via `kubectl apply -f .`.
* Verified deployments:

```bash
kubectl get pods
kubectl get svc
```

📸 **kubectl Services Output:**

```bash
NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)        AGE
frontend-external       LoadBalancer   10.100.51.222    a2fc5964c6d18487ab69852f404af19f-831725361.ap-south-1.elb.amazonaws.com   80:31366/TCP   2d18h
paymentservice          ClusterIP      10.100.166.120   <none>                                                                    50051/TCP      2d18h
...
```

📸 **Service View:**

![kubectl services](e.png)

---

## 📊 Observability & Monitoring

* Installed **kube-prometheus-stack** using Helm.
* Monitoring components:

  * **Prometheus** → Metrics collection
  * **Grafana** → Dashboards
  * **Alertmanager** → Alerts
* Verified scraping of node and service metrics.

📸 **Prometheus Targets:**

![Prometheus Targets](e1.jpg)

📸 **Monitoring Pods Output:**

```bash
pod/alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          2d18h
pod/monitoring-grafana-7f85f98dcb-fg4wz                      3/3     Running   0          2d18h
...
```

📸 **Monitoring Services Output:**

```bash
service/monitoring-grafana                        ClusterIP   10.100.46.159    <none>        80/TCP     2d18h
service/monitoring-kube-prometheus-prometheus     ClusterIP   10.100.139.22    <none>        9090/TCP   2d18h
...
```

---

## 🔐 Security & Operations

* Enforced **least-privilege IAM roles**.
* Isolated workloads via **subnets, taints/tolerations, and security groups**.
* Centralized admin access through **Bastion Host**.
* Implemented **cost control** by scaling node groups to zero during idle hours.

---

## ✅ What This Delivers

* Production-style, multi-tier cloud-native microservices deployment.
* Repeatable workflow from **local development → AWS cloud**.
* Strong security via **IAM, SGs, subnet isolation**.
* Observability with **Prometheus, Grafana, Alertmanager**.
* Cost-efficient operations with **scale-to-zero practices**.

---

