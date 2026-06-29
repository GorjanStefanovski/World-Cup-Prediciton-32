# Kubernetes deployment (Minikube)

All resources live in the `worldcup` namespace.

```
Ingress (worldcup.local)
   └── / → frontend Service → frontend Deployment (nginx)
                 nginx proxies /api → backend Service → backend Deployment
                                         ├── ml-service Service → ml-service Deployment
                                         └── postgres (headless) → postgres StatefulSet
```

## 1. Build the images into Minikube (Apple Silicon / arm64)

CI builds `amd64` images for Docker Hub, but Minikube here runs `arm64`, so build
the images natively inside Minikube's own Docker daemon:

```bash
eval $(minikube docker-env)
docker build -t gorjanstefanovski/worldcup-ml-service:latest ./ml-service
docker build -t gorjanstefanovski/worldcup-backend:latest    ./backend
docker build -t gorjanstefanovski/worldcup-frontend:latest   ./frontend/worldcup-frontend
```

(The manifests use `imagePullPolicy: IfNotPresent`, so they use these local images.)

## 2. Apply the manifests

```bash
kubectl apply -f k8s/
```

The numeric filename prefixes keep a sensible order (namespace first).

## 3. Watch it come up

```bash
kubectl get all -n worldcup
kubectl get pods -n worldcup -w        # wait until all are Running / Ready
```

Order of readiness: postgres → ml-service → backend (waits ~30s, seeds the DB) → frontend.

## 4. Reach the app through the Ingress

```bash
# add the host once
echo "127.0.0.1 worldcup.local" | sudo tee -a /etc/hosts

# on macOS with the docker driver, open a tunnel (keep it running in a tab)
minikube tunnel
```

Then open: http://worldcup.local

If `minikube tunnel` is not used on your driver, instead map the host to the cluster IP:

```bash
echo "$(minikube ip) worldcup.local" | sudo tee -a /etc/hosts
```

## Useful checks / screenshots for the report

```bash
kubectl get namespace worldcup
kubectl get all -n worldcup
kubectl get ingress -n worldcup
kubectl get configmap,secret -n worldcup
kubectl get pvc -n worldcup
kubectl logs -n worldcup deploy/backend | tail -20
```

## Tear down

```bash
kubectl delete -f k8s/
# or: kubectl delete namespace worldcup
```
