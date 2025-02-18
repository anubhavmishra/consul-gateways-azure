#!/bin/bash

apt-get update && apt-get install -y unzip dnsmasq

cd /tmp

# Fetch Fake service
wget https://github.com/nicholasjackson/fake-service/releases/download/v0.7.8/fake-service-linux -O /usr/local/bin/fake-service
chmod +x /usr/local/bin/fake-service

# Fetch Envoy
wget https://github.com/nicholasjackson/cloud-pong/releases/download/v0.3.0/envoy -O /usr/local/bin/envoy
chmod +x /usr/local/bin/envoy

# Fetch Consul
wget https://releases.hashicorp.com/consul/1.6.0/consul_1.6.0_linux_amd64.zip -O ./consul.zip
unzip ./consul.zip
mv ./consul /usr/local/bin

# Create the consul config
mkdir -p /etc/consul/config

cat << EOF > /etc/consul/config.hcl
data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc2"

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

enable_central_service_config = true

advertise_addr = "${advertise_addr}"
retry_join = ["${consul_cluster_addr}"]
EOF

# Create config and register service
cat << EOF > /etc/consul/config/payment.json
{
  "service": {
    "name": "payment",
    "id":"payment-vms",
    "port": 9090,
    "checks": [
       {
        "id": "payment-vms",
        "name": "HTTP API check",
        "http": "http://localhost:9090/health",
        "interval": "1s",
        "timeout": "1s"
    }],
    "connect": { 
      "sidecar_service": {
        "port": 20000,
        "proxy": {
          "upstreams": [
            {
              "destination_name": "payment-gateway",
              "local_bind_address": "127.0.0.1",
              "local_bind_port": 9091
            }
          ]
        }
      }
    }  
  }
}
EOF

# Setup systemd Consul Agent
cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description=Consul Server
After=syslog.target network.target

[Service]
ExecStart=/usr/local/bin/consul agent -config-file=/etc/consul/config.hcl -config-dir=/etc/consul/config
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/consul.service

# Setup systemd Envoy Sidecar
cat << EOF > /etc/systemd/system/consul-envoy.service
[Unit]
Description=Consul Envoy
After=syslog.target network.target

[Service]
ExecStart=/usr/local/bin/consul connect envoy -sidecar-for payment-vms
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/consul-envoy.service

# Setup systemd Payment service
cat << EOF > /etc/systemd/system/payment.service
[Unit]
Description=Payment
After=syslog.target network.target

[Service]
Environment="MESSAGE=payment successful from vms"
Environment=NAME=Payment
Environment=UPSTREAM_URIS=http://localhost:9091
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/payment.service

# Configure dnsmasq
mkdir -p /etc/dnsmasq.d
cat > /etc/dnsmasq.d/10-consul <<'EOF'
server=/consul/127.0.0.1#8600
EOF

systemctl enable dnsmasq

systemctl daemon-reload
systemctl start consul.service
systemctl start consul-envoy.service
systemctl start payment.service
systemctl start dnsmasq
# Force restart for adding consul dns
systemctl restart dnsmasq
