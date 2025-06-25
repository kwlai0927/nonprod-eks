# enovy-gateway

## 說明

安裝後，可以使用 k8s Gateway API 建立 enovy 規則，並部署 enovy 和 nlb

## 安裝

### 完整文檔

* <https://gateway.envoyproxy.io/docs/install/install-helm/>

### 操作

* [value.temp.yaml](https://github.com/envoyproxy/gateway/blob/main/charts/gateway-helm/values.tmpl.yaml)

* 修改 value.yaml

* 安裝

``` zsh

helm upgrade -i eg oci://docker.io/envoyproxy/gateway-helm --version v1.3.0 -n gateway --create-namespace -f values.yaml

```

* memo

```yaml
    # Traffic Routing
    service.beta.kubernetes.io/aws-load-balancer-name: 'nonprod-nlb'
    service.beta.kubernetes.io/aws-load-balancer-type: 'external'
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: 'ip'
    service.beta.kubernetes.io/aws-load-balancer-alpn-policy: 'HTTP2Preferred'

    # Traffic Listening
    service.beta.kubernetes.io/aws-load-balancer-ip-address-type: 'ipv4'

    # Health Check
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol: 'http'
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-port: '8081'
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: '/healthz'

    # TLS
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:ap-southeast-1:418295696814:certificate/1749ca08-1bab-41c3-8d6f-65b543e8d981,arn:aws:acm:ap-southeast-1:418295696814:certificate/4d90f142-f549-42a3-9818-f374e553bb93,arn:aws:acm:ap-southeast-1:418295696814:certificate/6391b92b-bb8d-49db-9b16-c2af452698c9,arn:aws:acm:ap-southeast-1:418295696814:certificate/dbc38b32-c72d-4859-b1a9-dd2b38be06f1
    service.beta.kubernetes.io/aws-load-balancer-scheme: 'internet-facing'
```
