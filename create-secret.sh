#!/bin/bash

# 設定變數
NAMESPACE=${1:-"dev-things"}
SECRET_NAME="things-srv"
CONFIG_FILE="things/dev-things/things-srv/config.yaml"

# 檢查 config.yaml 是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "錯誤: 找不到 config.yaml 檔案: $CONFIG_FILE"
    exit 1
fi

# 檢查 kubectl 是否可用
if ! command -v kubectl &> /dev/null; then
    echo "錯誤: kubectl 未安裝或不在 PATH 中"
    exit 1
fi

# 檢查 namespace 是否存在，如果不存在則創建
if ! kubectl get namespace "$NAMESPACE" &> /dev/null; then
    echo "創建 namespace: $NAMESPACE"
    kubectl create namespace "$NAMESPACE"
fi

# 檢查 secret 是否已存在，如果存在則刪除
if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" &> /dev/null; then
    echo "刪除現有的 secret: $SECRET_NAME"
    kubectl delete secret "$SECRET_NAME" -n "$NAMESPACE"
fi

# 創建 secret
echo "創建 secret: $SECRET_NAME 在 namespace: $NAMESPACE"
kubectl create secret generic "$SECRET_NAME" \
    --from-file=config.yaml="$CONFIG_FILE" \
    -n "$NAMESPACE"

# 驗證 secret 是否創建成功
if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" &> /dev/null; then
    echo "✅ Secret 創建成功!"
    echo "Secret 名稱: $SECRET_NAME"
    echo "Namespace: $NAMESPACE"
    echo ""
    echo "Secret 內容:"
    kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o yaml
else
    echo "❌ Secret 創建失敗!"
    exit 1
fi 