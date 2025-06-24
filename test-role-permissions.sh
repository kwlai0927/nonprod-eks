#!/bin/bash

# 設定變數
ROLE_ARN="arn:aws:iam::418295696814:role/github-action-kwlai0927-deploy"
CLUSTER_NAME="nonprod-eks"
REGION="ap-southeast-1"

echo "=== 測試 AWS 角色權限 ==="
echo "角色 ARN: $ROLE_ARN"
echo "集群名稱: $CLUSTER_NAME"
echo "區域: $REGION"
echo ""

# 1. 檢查角色是否存在
echo "1. 檢查角色是否存在..."
if aws iam get-role --role-name github-action-kwlai0927-deploy > /dev/null 2>&1; then
    echo "✅ 角色存在"
else
    echo "❌ 角色不存在"
    exit 1
fi

# 2. 檢查附加的策略
echo ""
echo "2. 檢查附加的管理策略..."
aws iam list-attached-role-policies --role-name github-action-kwlai0927-deploy --query 'AttachedPolicies[].PolicyName' --output table

# 3. 檢查內聯策略
echo ""
echo "3. 檢查內聯策略..."
aws iam list-role-policies --role-name github-action-kwlai0927-deploy --query 'PolicyNames' --output table

echo ""
echo "=== 測試完成 ==="
