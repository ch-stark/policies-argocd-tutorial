# Tutorial: Deploying ACM Gatekeeper Integration with ArgoCD

Welcome to the second part of our tutorial series! In this tutorial, we will walk you through the process of creating a new application to deploy ACM Gatekeeper-Operator, Gatekeeper-Constraints, and Constraint Templates. We will also demonstrate the integration with ArgoCD.

## Prerequisites

Before we begin, please make sure you have completed the setup-gitops folder as a prerequisite. This step is crucial for setting up the environment correctly.

## Overview

In this tutorial, we will perform the following tasks:

1. Create an ArgoCD Instance on the Hub-Cluster in a namespace called 'policies.'

2. Create ACM-Policies that wrap Gatekeeper Policies, establishing a link between ACM and Gatekeeper.

3. Demonstrate various features, including:
   - Dependency between policies.
   - Installation of Gatekeeper.
   - Configuration of Gatekeeper instances and exclusion of namespaces.
   - Verification of Gatekeeper's operational status.
   - Installation of the Gatekeeper library.
   - Installation of Custom Constraint Templates.
   - Installation of a Custom Constraint.
   - Policy Templates, which allow checking only Kubernetes Clusters with a certain version.
   - Placement of Gatekeeper files distributed to clusters with specific labels. Gatekeeper Operator and Constraints will be installed on ManagedClusters with the label 'gatekeeper=true.'

## Central Configuration

All of the configurations discussed in this tutorial are managed in a central file. You can find this file at the following URL:

[Policy Generator Plugin Configuration](https://github.com/stolostron/policy-generator-plugin/blob/main/docs/policygenerator-reference.yaml)

## InformGatekeeperPolicies

One important aspect to note is the `informGatekeeperPolicies` setting. When set to `true`, the policy expander will wrap everything in ConfigurationPolicies. Otherwise, it will leave it as a Gatekeeper manifest.

Now, let's dive into the step-by-step instructions for deploying ACM Gatekeeper Integration with ArgoCD:

## Step 1: Create an ArgoCD Instance

- Use the provided setup-gitops folder to create an ArgoCD instance on the Hub-Cluster. This instance should be created in the 'policies' namespace.

## Step 2: Create ACM-Policies

- Create ACM-Policies that wrap your Gatekeeper Policies to establish the integration between ACM and Gatekeeper.

## Step 3: Demonstrate Key Features

### 3.1 Dependency between Policies

- Ensure that there is a clear dependency between your policies to enforce the desired order of execution.

### 3.2 Install Gatekeeper

- Begin by installing Gatekeeper on your clusters.

### 3.3 Configure Gatekeeper Instances

- Configure Gatekeeper instances and exclude specific namespaces if needed.

### 3.4 Verify Gatekeeper Status

- Check if Gatekeeper is running smoothly after installation.

### 3.5 Install Gatekeeper Library

- Install the Gatekeeper library to enhance functionality.

### 3.6 Install Custom Constraint Templates

- Add your custom Constraint Templates to Gatekeeper.

### 3.7 Install Custom Constraint

- Install custom constraints as needed.

### 3.8 Policy Templates

- Create policy templates to check for specific Kubernetes Cluster versions.

### 3.9 Placement

- Distribute Gatekeeper files to clusters with specific labels. Install Gatekeeper Operator and Constraints on ManagedClusters with the label 'gatekeeper=true.'

## Conclusion

By following these steps, you will successfully deploy ACM Gatekeeper Integration with ArgoCD. This integration allows you to manage policies effectively and ensure the compliance of your Kubernetes clusters.

Feel free to refer to the central configuration file for more advanced settings and customization options.
