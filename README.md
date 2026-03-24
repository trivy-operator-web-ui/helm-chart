# Trivy Operator Web UI - Helm Chart

This chart deploys the Trivy Operator Web UI project inside your cluster. It consists of :
- An Operator that collects your reports' data and serve them through an API
- A Frontend that displays the data.

Both components live in seperate Pods.

# 1. Deploy

Simply run
```bash
helm install \
  -n trivy-operator-web-ui \
  --create-namespace \
  trivy-operator-web-ui \
  oci://ghcr.io/trivy-operator-web-ui/chart:0.2.1
```

# 2. Cluster Role

In order to collect your reports, the Operator must have the following permissions :
```yaml
rules:
  - apiGroups: ["aquasecurity.github.io"]
    resources: ["vulnerabilityreports", "sbomreports"] # more to come
    verbs: ["get", "watch", "list"]
```

This is already handled by the Chart, but it's worth precising.

# 3. Exposure and URLs

By default, a common Ingress and/or HttpRoute object is shared by both components. You configure a list of domains, then the Frontend is served using the **empty route**, and the Frontend calls the Operator using the `/api` route. That routing is already configured inside the [Ingress](./templates/common/ingress.yaml) and [HttpRoute](./templates/common/httproute.yaml).

**However**, if you need to manually configure a different domain for the Operator (exposed through NodePort or whatever), you can **disable** the Ingress and HttpRoute objects **AND** use the `.operator.url` value. This value will be injected in the Frontend container which will then call that specific URL for requests instead of the same root URL.

# 4. TLS

This application uses [Secure cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies#block_access_to_your_cookies) to store the JWT for authentication, which means that this application cannot be used if you don't have TLS endpoints for this application (except if `localhost` is used).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| common.ingress.enabled | bool | `false` |  |
| common.ingress.className | string | `""` |  |
| common.ingress.annotations | object | `{}` |  |
| common.ingress.hosts | list | `[]` | List of hosts for the Ingress |
| common.ingress.tls | list | `[]` | TLS Section of the Ingress ressource. Keep in mind that each host should have a match in this section in order for the application to fully work. See "TLS" section of the README |
| common.httpRoute.enabled | bool | `false` |  |
| common.httpRoute.annotations | object | `{}` |  |
| common.httpRoute.parentRefs[0].name | string | `"gateway"` |  |
| common.httpRoute.parentRefs[0].sectionName | string | `"http"` |  |
| common.httpRoute.hostnames | string | `nil` |  |
| operator.image.repository | string | `"ghcr.io/trivy-operator-web-ui/operator"` |  |
| operator.image.pullPolicy | string | `"IfNotPresent"` |  |
| operator.image.tag | string | `"0.1.1"` |  |
| operator.serviceAccount.automount | bool | `true` |  |
| operator.serviceAccount.annotations | object | `{}` |  |
| operator.resources.requests.cpu | string | `"10m"` |  |
| operator.resources.limits.memory | string | `"100Mi"` |  |
| operator.portal.username | string | `""` | List of hosts for the HttpRoute |
| operator.portal.password | string | `""` | List of hosts for the HttpRoute |
| operator.log.level | string | `"error"` | Log Level for the rust application. Must be one of `debug`, `info`, `warn`, `error` |
| operator.livenessProbe.httpGet.path | string | `"/api/health"` |  |
| operator.livenessProbe.httpGet.port | string | `"http"` |  |
| operator.readinessProbe.httpGet.path | string | `"/api/health"` |  |
| operator.readinessProbe.httpGet.port | string | `"http"` |  |
| operator.nodeSelector | object | `{}` |  |
| operator.tolerations | list | `[]` |  |
| operator.affinity | object | `{}` |  |
| operator.podAnnotations | object | `{}` |  |
| operator.podLabels | object | `{}` |  |
| operator.podSecurityContext | object | `{}` |  |
| operator.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| operator.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| operator.securityContext.runAsNonRoot | bool | `true` |  |
| operator.securityContext.runAsUser | int | `3000` |  |
| operator.service.type | string | `"ClusterIP"` |  |
| operator.service.port | int | `8080` |  |
| operator.url | string | `""` | URL of the backend injected in the frontend container. Not considered if either Ingress or HttpRoute is enabled. See "Exposure and URLs" section of the README |
| operator.httpRoute.filters | list | `[]` | HttpRoute filters for the Operator |
| frontend.image.repository | string | `"ghcr.io/trivy-operator-web-ui/frontend"` |  |
| frontend.image.pullPolicy | string | `"IfNotPresent"` |  |
| frontend.image.tag | string | `"0.1.2"` |  |
| frontend.replicaCount | int | `1` |  |
| frontend.serviceAccount.automount | bool | `true` |  |
| frontend.serviceAccount.annotations | object | `{}` |  |
| frontend.resources.requests.cpu | string | `"10m"` |  |
| frontend.resources.limits.memory | string | `"100Mi"` |  |
| frontend.livenessProbe.httpGet.path | string | `"/"` |  |
| frontend.livenessProbe.httpGet.port | string | `"http"` |  |
| frontend.readinessProbe.httpGet.path | string | `"/"` |  |
| frontend.readinessProbe.httpGet.port | string | `"http"` |  |
| frontend.nodeSelector | object | `{}` |  |
| frontend.tolerations | list | `[]` |  |
| frontend.affinity | object | `{}` |  |
| frontend.podAnnotations | object | `{}` |  |
| frontend.podLabels | object | `{}` |  |
| frontend.podSecurityContext | object | `{}` |  |
| frontend.service.type | string | `"ClusterIP"` |  |
| frontend.service.port | int | `8080` |  |
| frontend.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| frontend.securityContext.runAsNonRoot | bool | `true` |  |
| frontend.securityContext.runAsUser | int | `101` |  |
| frontend.httpRoute.filters | list | `[]` | HttpRoute filters for the Operator |
----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
