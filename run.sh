
#Deploy the Observability Stuff 
kubectl apply -f 01-backend.yaml

kubectl port-forward -n observability-backend svc/grafana 3000:3000

#Install Cert Manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml

#Install Otel Operator
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.74.0/opentelemetry-operator.yaml

#Apply the Otel Collector
kubectl apply -f 02-otel-collector.yaml

#Application 
kubectl apply -f 03-application.yaml

http://localhost:3000/grafana/explore?orgId=1&left=%7B%22datasource%22:%22tempo%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22datasource%22:%7B%22type%22:%22tempo%22,%22uid%22:%22tempo%22%7D,%22queryType%22:%22nativeSearch%22,%22serviceName%22:%22backend2-deployment%22%7D,%7B%22refId%22:%22B%22,%22datasource%22:%7B%22type%22:%22tempo%22,%22uid%22:%22tempo%22%7D,%22queryType%22:%22traceId%22%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D

#Apply the Instrumentation
kubectl apply -f 04-instrumentation.yaml

#Patch the Frontend 
kubectl patch deployment frontend-deployment -n tutorial-application -p '{"spec": {"template":{"metadata":{"annotations":{"instrumentation.opentelemetry.io/inject-sdk":"true"}}}} }'

#Rollout applications
kubectl rollout restart deployment -n tutorial-application -l app=backend1
kubectl rollout restart deployment -n tutorial-application -l app=backend2
kubectl rollout restart deployment -n tutorial-application -l app=frontend
