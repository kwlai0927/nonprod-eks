# aws-ebs-csi-driver

1. eks概觀可以看到 eks提供OIDC介面，用此在IAM建立身份提供者
    * aud: sts.amazonaws.com

2. 建立角色 nonprod-ebscsi，使用內建政策：AmazonEBSCSIDriverPolicy

3. 修改角色信任關係，限定 ebs-csi-controller-sa，這個是附加元件自動建立的k8s服務帳戶

``` txt
"oidc.eks.ap-southeast-1.amazonaws.com/id/1512659CB44311AB4EC2BEA77F25C7DA:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
```
