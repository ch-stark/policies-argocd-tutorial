# Tutorial: Tuning Options from PolicyGenerator

PolicyGenerator is a powerful tool for managing and generating policies in a Kubernetes environment. It allows you to define and configure policies for various purposes, such as compliance checks and resource management. In this tutorial, we will deep dive into some of the tuning options available in PolicyGenerator and explain their significance. We'll also provide links to important resources and real-world examples to help you better understand how to use these options effectively.

## Table of Contents

1. [Introduction to PolicyGenerator](#introduction-to-policygenerator)
2. [Tuning Options](#tuning-options)
    - [copyPolicyMetadata](#copypolicymetadata)
    - [evaluationInterval](#evaluationinterval)
    - [Kustomize](#kustomize)
    - [Patch](#patch)

## Introduction to PolicyGenerator

Before we delve into the tuning options, let's briefly introduce PolicyGenerator. It is a Kubernetes tool that allows you to generate and manage policies for your clusters. Policies define rules and constraints for the resources within your Kubernetes clusters, helping you enforce best practices, security, and compliance.

You can find the PolicyGenerator configuration reference [here](https://github.com/stolostron/policy-generator-plugin/blob/main/docs/policygenerator-reference.yaml). Additionally, you can explore real-world examples in the [policy-collection](https://github.com/open-cluster-management-io/policy-collection/tree/main/policygenerator) repository.

## Tuning Options

### copyPolicyMetadata

The `copyPolicyMetadata` option is used to control whether ArgoCD should ignore policies copied into Managed-Cluster namespaces, especially in large deployments. When set to `false`, ArgoCD will ignore policies in these namespaces.

```yaml
copyPolicyMetadata: false
```

- **Usage**: If you have policies that are specific to Managed-Cluster namespaces and you want to prevent ArgoCD from syncing them, you can set this option to `false`. This can help improve performance in large deployments by reducing unnecessary policy synchronization.

### evaluationInterval

The `evaluationInterval` option allows you to configure the evaluation interval for policies. It defines how often policies are evaluated, both for compliant and noncompliant states.

```yaml
evaluationInterval:
  compliant: 30m
  noncompliant: 45s
```

- **Usage**: This option is crucial for optimizing policy evaluation performance. By specifying shorter intervals for non-critical policies (e.g., `noncompliant: 45s`), you can ensure that they are checked more frequently for compliance, thus improving overall system responsiveness. Critical policies can have longer intervals (e.g., `compliant: 30m`) to reduce the load on the system.

### Kustomize

PolicyGenerator supports Kustomize, a tool for customizing Kubernetes configurations. You can define Kustomization configurations within your PolicyGenerator configuration to customize resources.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - https://github.com/ch-stark/gatekeeper-library/library
```

- **Usage**: This allows you to include external resources and apply custom configurations to them using Kustomize. In the example, resources from the `gatekeeper-library` repository are included and customized.

### Patch

The `Patch` section allows you to apply patches to specific resources in your policies, modifying their attributes.

```yaml
Patch:
  manifests:
    - path: input/configmap-aliens.yaml
      patches:
        - apiVersion: v1
          kind: ConfigMap
          metadata:
            labels:
              chandler: bing
  remediationAction: enforce
```

- **Usage**: You can use patches to enforce specific attributes or labels on resources. In this example, a patch is applied to a ConfigMap resource, adding a label. The `remediationAction` specifies whether the patch should enforce the changes.

### Example Policy

Here's an example of a policy definition within a PolicyGenerator configuration:

```yaml
- name: policy-require-labels
  disabled: true
  manifests:
    - path: input-kyverno/
  policySets:
    - policyset-kyverno
```

- **Usage**: This example shows how to define a policy. You can specify the policy's name, whether it's enabled or disabled (`disabled: true`), the resource manifests it applies to, and the associated policy sets.

## Conclusion

In this tutorial, we explored some of the tuning options available in PolicyGenerator and explained their significance. These options allow you to fine-tune the behavior of PolicyGenerator to meet the specific requirements of your Kubernetes environment. Be sure to refer to the provided links for more in-depth documentation and real-world examples to help you make the most of PolicyGenerator in your Kubernetes deployments.
