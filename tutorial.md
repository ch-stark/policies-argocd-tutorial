# Getting Started with RHACM-Policies using ArgoCD

In this tutorial, we will guide you through the process of setting up ArgoCD to deploy Policies. This PolicySet will help configure OpenShift for best practices, offering a robust level of hardening and compliance checking. ArgoCD is a popular GitOps tool that enables you to manage Kubernetes resources through Git repositories, making it an excellent choice for managing policies.

Please note that the following approach can be seen as a best practise and can be highly recommended.

## Prerequisites

Before we dive into the tutorial, ensure you have the following prerequisites in place:

1. Access to a Kubernetes cluster, preferably OpenShift.
2. `kubectl` and `oc` command-line tools installed.
3. Git installed on your local machine.
4. Clone the [GitHub repository](https://github.com/open-cluster-manaement/policy-collection) containing the PolicySet YAML files.

## Setup

To simplify the setup process, we have provided a script that will apply the necessary Kubernetes files to create the required resources. Here's how you can set up ArgoCD for deploying Policies:

1. Create a new file named `setup-argocd.sh` and paste the following script into it:

```bash
#!/bin/bash

# List of Kubernetes files to apply
files=(
    "01_namespaces.yaml"
    "02_managedclustersetbinding.yaml"
    "03_installoperator.yaml"
    "04_argocd.yaml"
    "05_applications.yaml"
    "06_appproject.yaml"
    "07_placement.yaml"
)

# Function to apply a file with retries (especially we need to wait till GitopsOperator is installed)
apply_with_retry() {
    local file="$1"
    local retries=3
    local interval=10

    for ((i=0; i<retries; i++)); do
        echo "Applying $file (Attempt $((i+1)))"
        oc apply -f "$file"
        if [ $? -eq 0 ]; then
            echo "$file applied successfully"
            return 0
        else
            echo "Error applying $file. Retrying in $interval seconds..."
            sleep $interval
        fi
    done

    echo "Failed to apply $file after $retries attempts"
    return 1
}

# Iterate over the files and apply them with retries
for file in "${files[@]}"; do
    apply_with_retry "$file" || exit 1
done

echo "All files applied successfully"
```

2. Save the file and make it executable by running:

```bash
chmod +x setup-argocd.sh
```

3. Execute the script to set up ArgoCD and deploy the Policies:

```bash
./setup-argocd.sh
```

## Understanding the YAML Files

Now, let's briefly explain the contents of the YAML files provided in the script:

1. `01_namespaces.yaml`: Defines two namespaces, `policies` and `openshift-gitops`.

2. `02_managedclustersetbinding.yaml`: Binds a ManagedClusterSet to the `policies` namespace.

3. `03_installoperator.yaml`: Installs the OpenShift GitOps Operator in the `openshift-gitops` namespace.

4. `04_argocd.yaml`: Defines the ArgoCD configuration in the `policies` namespace.


Note:  We are customizing the default ArgoCD Instance which is a supported configuration change.


```
  repo:
    resources:
      limits:
        cpu: '1'
        memory: 512Mi
      requests:
        cpu: 250m
        memory: 256Mi
    env:
    - name: KUSTOMIZE_PLUGIN_HOME
      value: /etc/kustomize/plugin
    initContainers:
    - args:
      - cp /etc/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator/PolicyGenerator
        /policy-generator/PolicyGenerator
      command:
      - sh
      - -c
      image: registry.redhat.io/rhacm2/multicluster-operators-subscription-rhel8:v2.8.0
      name: policy-generator-install
      volumeMounts:
      - mountPath: /policy-generator
        name: policy-generator
    volumeMounts:
    - mountPath: /etc/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator
      name: policy-generator
    volumes:
    - emptyDir: {}
      name: policy-generator
  kustomizeBuildOptions: --enable-alpha-plugins
```


5. `05_applications.yaml`: Configures an ArgoCD application for deploying the PolicySet.

6. `06_appproject.yaml`: Sets up an ArgoCD application project.

7. `07_placement.yaml`: Defines placement-definitions for the Policys.


At the end you will see the deployed policies in RHACM Governance-UI


![Alt Text](files/policies.png)


## Conclusion

By following this tutorial and executing the provided script, you've achieved a rapid, efficient, and proven setup of ArgoCD for deploying Policies. This PolicySet serves as a robust framework to enforce best practices, fortify the security, and ensure compliance within your OpenShift cluster. Leveraging Git, you can effortlessly customize and manage your policies, maintaining your cluster in the desired state with ease. Embrace the power of streamlined policy management!