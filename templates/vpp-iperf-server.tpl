---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "vpp-iperf-server"
      networkservicemesh.io/impl: "vpp-example"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "vpp-iperf-server"
        networkservicemesh.io/impl: "vpp-example"
    spec:
      serviceAccount: nse-acc
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
        - name: vpp-iperf-server
          image: raffaeletrani/vpp-test-common:vppiperf3
          imagePullPolicy: IfNotPresent
          env:
            - name: TEST_APPLICATION
              value: "vppagent-icmp-responder-nse"
            - name: ENDPOINT_NETWORK_SERVICE
              value: "vpp-example"
            - name: ENDPOINT_LABELS
              value: "app=iperf-server"
            - name: IP_ADDRESS
              value: "172.16.2.0/24"
          resources:
            limits:
              networkservicemesh.io/socket: 1
metadata:
  name: vpp-iperf-server
  namespace: default
