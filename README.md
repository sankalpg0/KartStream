# KartStream: Cloud-Native Microservices on Amazon EKS with Observability
![Home page](https://github.com/sankalpg0/KartStream/blob/79426607928a1d85aa2d033400ce4f335315961c/images/online-boutique-frontend-1.png)
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

![Architecture](https://github.com/sankalpg0/KartStream/blob/79426607928a1d85aa2d033400ce4f335315961c/images/a.png)

---

## 🔧 Phase 1 — Local Development & Kubernetes Readiness

* Authored a **Docker Compose setup** to build container images for all microservices.
* Pushed **versioned images to Docker Hub** for distribution.
* Created **Kubernetes manifests (Deployment + Service)** for each microservice.
* Validated service interactions on a **local Kubernetes cluster** (1 control-plane, 3 workers).
* Verified rollouts using `kubectl get pods/svc/deploy`.

📸 **kubectl Outputs (Local Validation):**

```bash
NAME                                     READY   STATUS             RESTARTS        AGE
adservice-984b8574-62mdg                 1/1     Running            0               1h
cartservice-749c6bf6d5-96qcr             1/1     Running            0               1h
checkoutservice-6656fdb484-spmnq         1/1     Running            0               1h
currencyservice-d59987cdb-zlqsk          1/1     Running            0               1h
emailservice-6c9896bbfd-hmz6r            1/1     Running            0               1h
frontend-5cdb7c8856-zmjsd                1/1     Running            0               1h
paymentservice-544bf9596b-4s5f2          1/1     Running            0               1h
productcatalogservice-64b76c5df8-pfztv   1/1     Running            0               1h
recommendationservice-6bdbbc4fdd-2jwtq   1/1     Running            0               1h
redis-cart-8dbf7cf4b-chmhf               1/1     Running            0               1h
shippingservice-59848c8745-h8xkz         1/1     Running            0               1h
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

![VPC Setup](https://github.com/sankalpg0/KartStream/blob/79426607928a1d85aa2d033400ce4f335315961c/images/b.png)

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

![EKS Cluster](https://github.com/sankalpg0/KartStream/blob/79426607928a1d85aa2d033400ce4f335315961c/images/c.png)

📸 **Node Groups Configuration:**

![Node Groups](https://github.com/sankalpg0/KartStream/blob/79426607928a1d85aa2d033400ce4f335315961c/images/d.png)

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
adservice               ClusterIP      10.100.79.101    <none>                                                                    9555/TCP       2d18h
cartservice             ClusterIP      10.100.163.167   <none>                                                                    7070/TCP       2d18h
checkoutservice         ClusterIP      10.100.64.115    <none>                                                                    5050/TCP       2d18h
currencyservice         ClusterIP      10.100.237.78    <none>                                                                    7000/TCP       2d18h
emailservice            ClusterIP      10.100.239.188   <none>                                                                    5000/TCP       2d18h
frontend                ClusterIP      10.100.66.94     <none>                                                                    80/TCP         2d18h
frontend-external       LoadBalancer   10.100.51.222    a2fc5964c6d18487ab69852f404af19f-831725361.ap-south-1.elb.amazonaws.com   80:31366/TCP   2d18h
kubernetes              ClusterIP      10.100.0.1       <none>                                                                    443/TCP        2d19h
paymentservice          ClusterIP      10.100.166.120   <none>                                                                    50051/TCP      2d18h
productcatalogservice   ClusterIP      10.100.123.203   <none>                                                                    3550/TCP       2d18h
recommendationservice   ClusterIP      10.100.186.145   <none>                                                                    8080/TCP       2d18h
redis-cart              ClusterIP      10.100.183.86    <none>                                                                    6379/TCP       2d18h
shippingservice         ClusterIP      10.100.130.137   <none> 
```

---

## 📊 Observability & Monitoring

* Installed **kube-prometheus-stack** using Helm.
* Monitoring components:

  * **Prometheus** → Metrics collection
  * **Grafana** → Dashboards
  * **Alertmanager** → Alerts
* Verified scraping of node and service metrics.

📸 **Prometheus Targets:**

![Prometheus Targets](https://github.com/sankalpg0/KartStream/blob/79426607928a1d85aa2d033400ce4f335315961c/images/e1.jpg)

📸 **Monitoring Pods Output:**

```bash
NAME                                                         READY   STATUS    RESTARTS   AGE
pod/alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          2d18h
pod/alertmanager-monitoring-kube-prometheus-alertmanager-1   2/2     Running   0          2d18h
pod/monitoring-grafana-7f85f98dcb-fg4wz                      3/3     Running   0          2d18h
pod/monitoring-kube-prometheus-operator-684d77995c-zqnwd     1/1     Running   0          2d18h
pod/monitoring-kube-state-metrics-585b45df98-wxvzx           1/1     Running   0          2d18h
pod/monitoring-prometheus-node-exporter-cjc9r                1/1     Running   0          2d18h
pod/monitoring-prometheus-node-exporter-f9shh                1/1     Running   0          2d18h
pod/monitoring-prometheus-node-exporter-klrr2                1/1     Running   0          2d18h
pod/monitoring-prometheus-node-exporter-rnh96                1/1     Running   0          2d18h
pod/prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0          2d18h
```

📸 **Monitoring Services Output:**

```bash
NAME                                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
service/alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   2d18h
service/monitoring-grafana                        ClusterIP   10.100.46.159    <none>        80/TCP                       2d18h
service/monitoring-kube-prometheus-alertmanager   ClusterIP   10.100.111.210   <none>        9093/TCP,8080/TCP            2d18h
service/monitoring-kube-prometheus-operator       ClusterIP   10.100.240.12    <none>        443/TCP                      2d18h
service/monitoring-kube-prometheus-prometheus     ClusterIP   10.100.139.22    <none>        9090/TCP,8080/TCP            2d18h
service/monitoring-kube-state-metrics             ClusterIP   10.100.28.156    <none>        8080/TCP                     2d18h
service/monitoring-prometheus-node-exporter       ClusterIP   10.100.136.232   <none>        9100/TCP                     2d18h
service/prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     2d18h
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

