# Platform Engineer Summit - LinuxTips - 2023
---
## Deploy das Ferramentos de Observabilidade:
 - Grafana
 - Loki
 - Mimir
 - Tempo

```bash
kubectl apply -f 01-backend.yaml
````
- Você pode verificar se o serviços estão rodando através do comando `kubectl get pods -n observability-backend` e o resultado deve ser esse: 
````bash
NAME                              READY   STATUS    RESTARTS   AGE
grafana-5bcfcc785d-lw8b5          1/1     Running   0          5h38m
loki-0                            1/1     Running   0          5h38m
mimir-0                           1/1     Running   0          5h38m
tempo-7cd894b88f-tkk8j            1/1     Running   0          5h38m
````
- Abra uma conexão com o serviço do Grafana em uma outra sessão do terminal: 

````bash
kubectl port-forward -n observability-backend svc/grafana 3000:3000
`````
## Instalação Opentelemetry Operator

- Instalação do CertManager como dependência do operator: 

````bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
`````

- Instalação  OpenTelemetry Operator:
````bash
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.74.0/opentelemetry-operator.yaml
````
 - Para verificar se a instalação do Operator ocorreu bem basta executar o seguinte comando substituindo o nome do pod `kubectl logs -n opentelemetry-operator-system opentelemetry-operator-controller-manager-7487c6674d-shpbl`: 

 ````bash
Defaulted container "manager" out of: manager, kube-rbac-proxy
{"level":"info","ts":"2023-04-27T11:28:16.807422088Z","msg":"Starting the OpenTelemetry Operator","opentelemetry-operator":"0.74.0","opentelemetry-collector":"ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector:0.74.0","opentelemetry-targetallocator":"ghcr.io/open-telemetry/opentelemetry-operator/target-allocator:0.74.0","operator-opamp-bridge":"ghcr.io/open-telemetry/opentelemetry-operator/operator-opamp-bridge:0.74.0","auto-instrumentation-java":"ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java:1.23.0","auto-instrumentation-nodejs":"ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-nodejs:0.34.0","auto-instrumentation-python":"ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-python:0.36b0","auto-instrumentation-dotnet":"ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-dotnet:0.6.0","build-date":"2023-03-29T11:22:05Z","go-version":"go1.20.2","go-arch":"arm64","go-os":"linux","labels-filter":[]}
{"level":"info","ts":"2023-04-27T11:28:16.807667255Z","logger":"setup","msg":"the env var WATCH_NAMESPACE isn't set, watching all namespaces"}
{"level":"info","ts":"2023-04-27T11:28:16.832493297Z","logger":"controller-runtime.metrics","msg":"Metrics server is starting to listen","addr":"127.0.0.1:8080"}
{"level":"info","ts":"2023-04-27T11:28:16.838661213Z","logger":"controller-runtime.builder","msg":"Registering a mutating webhook","GVK":"opentelemetry.io/v1alpha1, Kind=OpenTelemetryCollector","path":"/mutate-opentelemetry-io-v1alpha1-opentelemetrycollector"}
{"level":"info","ts":"2023-04-27T11:28:16.838714338Z","logger":"controller-runtime.webhook","msg":"Registering webhook","path":"/mutate-opentelemetry-io-v1alpha1-opentelemetrycollector"}
{"level":"info","ts":"2023-04-27T11:28:16.838741547Z","logger":"controller-runtime.builder","msg":"Registering a validating webhook","GVK":"opentelemetry.io/v1alpha1, Kind=OpenTelemetryCollector","path":"/validate-opentelemetry-io-v1alpha1-opentelemetrycollector"}
{"level":"info","ts":"2023-04-27T11:28:16.83878788Z","logger":"controller-runtime.webhook","msg":"Registering webhook","path":"/validate-opentelemetry-io-v1alpha1-opentelemetrycollector"}
{"level":"info","ts":"2023-04-27T11:28:16.838815422Z","logger":"controller-runtime.builder","msg":"Registering a mutating webhook","GVK":"opentelemetry.io/v1alpha1, Kind=Instrumentation","path":"/mutate-opentelemetry-io-v1alpha1-instrumentation"}
{"level":"info","ts":"2023-04-27T11:28:16.83883838Z","logger":"controller-runtime.webhook","msg":"Registering webhook","path":"/mutate-opentelemetry-io-v1alpha1-instrumentation"}
{"level":"info","ts":"2023-04-27T11:28:16.838853838Z","logger":"controller-runtime.builder","msg":"Registering a validating webhook","GVK":"opentelemetry.io/v1alpha1, Kind=Instrumentation","path":"/validate-opentelemetry-io-v1alpha1-instrumentation"}
{"level":"info","ts":"2023-04-27T11:28:16.838866088Z","logger":"controller-runtime.webhook","msg":"Registering webhook","path":"/validate-opentelemetry-io-v1alpha1-instrumentation"}
{"level":"info","ts":"2023-04-27T11:28:16.83896938Z","logger":"controller-runtime.webhook","msg":"Registering webhook","path":"/mutate-v1-pod"}
{"level":"info","ts":"2023-04-27T11:28:16.839004005Z","logger":"setup","msg":"starting manager"}
{"level":"info","ts":"2023-04-27T11:28:16.839308422Z","msg":"Starting server","path":"/metrics","kind":"metrics","addr":"127.0.0.1:8080"}
{"level":"info","ts":"2023-04-27T11:28:16.83936588Z","msg":"Starting server","kind":"health probe","addr":"[::]:8081"}
{"level":"info","ts":"2023-04-27T11:28:16.839088963Z","logger":"controller-runtime.webhook.webhooks","msg":"Starting webhook server"}
 ````


## Deploy da instância do Collector
- Para fazer o deploy da instância do OpenTelemetry Collector basta executar o seguinte comando: 

````bash
kubectl apply -f 02-otel-collector.yaml
````

- Verifique se a instalação ocorreu sem erros:
````bash
kubectl get pods -n observability-backend
NAME                              READY   STATUS    RESTARTS   AGE
grafana-5bcfcc785d-lw8b5          1/1     Running   0          5h46m
loki-0                            1/1     Running   0          5h46m
mimir-0                           1/1     Running   0          5h46m
otel-collector-569977b889-ggcj4   1/1     Running   0          8m10s
tempo-7cd894b88f-tkk8j            1/1     Running   0          5h46m
````

## Deploy da Aplicação 
  - Frontend - NodeJS
  - Backend - Python
  - Backend - Java

````bash
kubectl apply -f 03-application.yaml
````

[Veja que os traces ainda não estão chegando no Grafana Tempo](http://localhost:3000/grafana/explore?orgId=1&left=%7B%22datasource%22:%22tempo%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22datasource%22:%7B%22type%22:%22tempo%22,%22uid%22:%22tempo%22%7D,%22queryType%22:%22nativeSearch%22,%22serviceName%22:%22backend2-deployment%22%7D,%7B%22refId%22:%22B%22,%22datasource%22:%7B%22type%22:%22tempo%22,%22uid%22:%22tempo%22%7D,%22queryType%22:%22traceId%22%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D
)

## Aplicar o CR de Instrumentation:
````bash
kubectl apply -f 04-instrumentation.yaml
````

- Verifique se o CR foi criado com sucesso `kubectl get otelinst -n tutorial-application`:
````bash
NAME                 AGE     ENDPOINT                                                             SAMPLER                    SAMPLER ARG
my-instrumentation   5h38m   http://otel-collector.observability-backend.svc.cluster.local:4317   parentbased_traceidratio   1
````

## Patch do Frontend:
- Para finalizar a auto-instrumentação precisamos fazer o patch do frontend:
````batch
kubectl patch deployment frontend-deployment -n tutorial-application -p '{"spec": {"template":{"metadata":{"annotations":{"instrumentation.opentelemetry.io/inject-sdk":"true"}}}} }'
````

## Após o Patch realizado vamos fazer o rollout das apps: 
````bash
kubectl rollout restart deployment -n tutorial-application -l app=backend1
kubectl rollout restart deployment -n tutorial-application -l app=backend2
kubectl rollout restart deployment -n tutorial-application -l app=frontend

````

[Veja que os traces AGORA estão chegando no Grafana Tempo](http://localhost:3000/grafana/explore?orgId=1&left=%7B%22datasource%22:%22tempo%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22datasource%22:%7B%22type%22:%22tempo%22,%22uid%22:%22tempo%22%7D,%22queryType%22:%22nativeSearch%22,%22serviceName%22:%22backend2-deployment%22%7D,%7B%22refId%22:%22B%22,%22datasource%22:%7B%22type%22:%22tempo%22,%22uid%22:%22tempo%22%7D,%22queryType%22:%22traceId%22%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D
)