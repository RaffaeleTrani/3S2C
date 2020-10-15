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
#      hostNetwork: true
      containers:
        - name: vpp-iperf-client
          image: raffaeletrani/vppagent-nsc:latest
          imagePullPolicy: IfNotPresent
          securityContext:
            capabilities:
              add: ["ALL"]
            privileged: true
          env:
            - name: TEST_APPLICATION
              value: "vppagent-nsc"
            - name: CLIENT_NETWORK_SERVICE
              value: "vpp-example"
          resources:
            limits:
              networkservicemesh.io/socket: 1
          volumeMounts:
            - name: vpp-config
              mountPath: /etc/vpp/vpp.conf
              subPath: vpp.conf
      volumes:
        - name: vpp-config
          configMap:
            name: vpp-config-map
metadata:
  name: vpp-iperf-client
  namespace: default
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: vpp-config-map
  namespace: default
data:
  vpp.conf: |
    unix {
      nodaemon
      log /var/log/vpp/vpp.log
      full-coredump
      cli-listen /run/vpp/cli.sock
      gid vpp
    }
    api-trace {
      on
    }
    api-segment {
      gid vpp
    }
    socksvr {
      default
    }
    cpu {
    }
    plugins {
      plugin dpdk_plugin.so { disable }
    }

