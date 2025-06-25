# 安裝 aws-load-balancer-controller 過程紀錄

## 建立IAM

### Eks OIDC

* IAM 建立以EKS作為 Identity Provider 的 OIDC 紀錄

``` zsh
eksctl utils associate-iam-oidc-provider --region=ap-southeast-1 --cluster=nonprod-eks --approve
```

### Policy

* 下載需要的權限 policy json，可能會更新，所以每次處理請下載最新的ima-policy.json

``` zsh
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```

* 建立 Policy

``` zsh
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

* 如果已經存在，可以覆蓋版本

``` zsh
aws iam create-policy-version \
    --policy-arn arn:aws:iam::418295696814:policy/AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json \
    --set-as-default
```

### Role

* 建立 role，文件上以下命令會直接建立 role 和 k8s sa

``` zsh
eksctl create iamserviceaccount --cluster=nonprod-eks --namespace=kube-system --name=aws-load-balancer-controller --role-name nonprod-aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::418295696814:policy/AWSLoadBalancerControllerIAMPolicy --approve --override-existing-serviceaccounts
```

* 但實際上有權限問題，沒法建立，所以直接在console建立

1. 角色 -> 建立角色 -> Web 身份 -> 選擇 eks OIDC -> audiance: sts.amazonaws.com
2. 許可政策 AWSLoadBalancerControllerIAMPolicy
3. 名稱 nonprod-aws-load-balancer-controller 描述 nonprod-eks sa aws-load-balancer-controller use this role to set alb.
4. 建立後修改信任關係補上 sub那條

``` json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::418295696814:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/1512659CB44311AB4EC2BEA77F25C7DA"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.ap-southeast-1.amazonaws.com/id/1512659CB44311AB4EC2BEA77F25C7DA:aud": "sts.amazonaws.com",
                    "oidc.eks.ap-southeast-1.amazonaws.com/id/1512659CB44311AB4EC2BEA77F25C7DA:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
```

## Helm 安裝 controller

### k8s service account

* 建立 service account

``` zsh

kubectl apply -f ./sa.yaml

```

### helm install aws-load-balancer-controller

``` zsh
helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=nonprod-eks \
  --set region=ap-southeast-1 \
  --set vpcId=vpc-0e1b7c8de1e21597d \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```
