#!/bin/zsh

# 刪除現有的 secret
kubectl delete secret llm-embedding -n nonprod

# 使用 config.yaml 重新創建 secret
kubectl create secret generic llm-embedding --from-file=config.yaml=config.yaml -n nonprod 