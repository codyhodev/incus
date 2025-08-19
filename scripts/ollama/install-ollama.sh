#!/usr/bin/bash

OLLAMA_FILE=ollama-linux-amd64.tgz
tar -C /usr -xzf $OLLAMA_FILE

useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
usermod -a -G ollama linux

cat > /etc/systemd/system/ollama.service  << EOF
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable ollama
