# learn-eks-infra-repo

terraform code repo

```
├── README.md
├── backend.tf
├── data.tf
├── main.tf
├── modules
│   ├── eks-cluster
│   │   ├── data.tf
│   │   ├── ebs-csi-driver.tf
│   │   ├── ecr.tf
│   │   ├── karpenter.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   └── yaml
│       └── karpenter
│           ├── karpenter-test-pod.yaml
│           ├── management.yaml
│           └── service.yaml
├── output.tf
└── provider.tf
```
