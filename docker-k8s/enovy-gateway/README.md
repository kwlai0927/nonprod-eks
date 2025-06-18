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