---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "firewall"
      networkservicemesh.io/impl: "vpp-example"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "firewall"
        networkservicemesh.io/impl: "vpp-example"
    spec:
      serviceAccount: nse-acc
      containers:
        - name: vpp-firewall
          image: raffaeletrani/vppagent-firewall-nse:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: TEST_APPLICATION
              value: "vppagent-firewall-nse"
            - name: ENDPOINT_NETWORK_SERVICE
              value: "vpp-example"
            - name: ENDPOINT_LABELS
              value: "app=firewall"
            - name: CLIENT_NETWORK_SERVICE
              value: "vpp-example"
            - name: CLIENT_LABELS
              value: "app=firewall"
          resources:
            limits:
              networkservicemesh.io/socket: 1
          volumeMounts:
                      - mountPath: /etc/vppagent-firewall/config.yaml
                        subPath: config.yaml
                        name: vppagent-firewall-config-volume
      volumes:
        - name: vppagent-firewall-config-volume
          configMap:
            name: vppagent-firewall-config-file
metadata:
  name: vpp-firewall
  namespace: default
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: vppagent-firewall-config-file
  namespace: default
data:
  config.yaml: |
    aclRules:
      "Allow ICMP": "action=reflect,icmptype=8"
      "Allow TCP": "action=reflect,tcplowport=5201,tcpupport=5201"
      "Allow UDP": "action=reflect,udplowport=5201,udpupport=5201"
