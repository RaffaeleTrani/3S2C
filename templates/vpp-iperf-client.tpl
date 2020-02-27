---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "vpp-iperf-client"
      networkservicemesh.io/impl: "vpp-example"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "vpp-iperf-client"
        networkservicemesh.io/impl: "vpp-example"
    spec:
      serviceAccount: nsc-acc
      affinity:
          nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                  nodeSelectorTerms:
                      - matchExpressions:
                        - key: kubernetes.io/hostname
                          operator: In
                          values:
                            - cube4
      containers:
        - name: vpp-iperf-client
          image: raffaeletrani/vpp-test-common:vppiperf3
          imagePullPolicy: {{ .Values.pullPolicy }}
          env:
            - name: TEST_APPLICATION
              value: "vppagent-nsc"
            - name: CLIENT_NETWORK_SERVICE
              value: "vpp-example"
          resources:
            limits:
              networkservicemesh.io/socket: 1
metadata:
  name: vpp-iperf-client
  namespace: default
