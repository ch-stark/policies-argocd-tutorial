#!/bin/bash

# Define the path to the HTPasswd file
HTPASSWD_FILE="${HOME}/htpasswd_users"

# Create the HTPasswd file
touch "${HTPASSWD_FILE}"

# Generate HTPasswd entries for users
for i in {1..2}; do
    for TYPE in sre deployer view; do
        htpasswd -b "${HTPASSWD_FILE}" "test${i}${TYPE}" "multitenancy!"
    done
done

# Create a Kubernetes secret with the HTPasswd file
oc create secret generic multitenancy-users --from-file=htpasswd="${HTPASSWD_FILE}" -n openshift-config

# Patch the OAuth configuration
oc patch -n openshift-config oauth cluster --type json --patch '[{"op":"add","path":"/spec/identityProviders/-","value":{"name":"multitenancy-users","mappingMethod":"claim","type":"HTPasswd","htpasswd":{"fileData":{"name":"multitenancy-users"}}}}]'

# Define a user group
cat << EOF | oc apply -f -
kind: Group
apiVersion: user.openshift.io/v1
metadata:
  name: app-red-admins
users:
  - test1view
  - test2view
EOF

# Define a cluster role
cat << EOF | oc apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-red-metrics
rules:
  - apiGroups:
    - "cluster.open-cluster-management.io"
    resources:
    - managedclusters
    resourceNames:
    - spoke1
    - devcluster2
    verbs:
    - metrics/AppRedNs1
    - metrics/AppRedNs2
EOF

# Create a cluster role binding
cat << EOF | oc apply -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: app-red-metric-viewers
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: app-red-admins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-red-metrics
EOF
