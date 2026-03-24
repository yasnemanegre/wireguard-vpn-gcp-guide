#!/bin/bash
# Script d'installation automatique de WireGuard sur GCP
# Utilisation : bash install.sh

set -e

echo "🚀 Installation de WireGuard sur Google Cloud..."

# Installation des paquets
sudo apt update && sudo apt upgrade -y
sudo apt install wireguard resolvconf iptables -y

# Activation du routage
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

# Création des clés
sudo mkdir -p /etc/wireguard
cd /etc/wireguard
sudo wg genkey | sudo tee private.key
sudo chmod 600 private.key
sudo cat private.key | sudo wg pubkey | sudo tee public.key

# Détection de l'interface réseau
INTERFACE=$(ip route | grep default | awk '{print $5}')
echo "Interface détectée : $INTERFACE"

# Configuration du serveur
PRIVATE_KEY=$(sudo cat private.key)
sudo tee /etc/wireguard/wg0.conf > /dev/null <<EOF
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.8.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE
EOF

# Démarrage
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0

echo ""
echo "✅ Installation terminée !"
echo "🔑 Clé publique du serveur :"
sudo cat /etc/wireguard/public.key
echo ""
echo "🌍 IP externe : $(curl -s ifconfig.me)"
echo "📌 N'oubliez pas de configurer le pare-feu GCP (port 51820/UDP)"
