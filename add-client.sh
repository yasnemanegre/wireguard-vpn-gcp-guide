#!/bin/bash
# Script pour ajouter un client WireGuard
# Utilisation : ./add-client.sh <nom_du_client> [dernier_octet_ip]

CLIENT_NAME=${1:-"client"}
CLIENT_IP=${2:-"2"}

if [ -z "$1" ]; then
    echo "Usage: $0 <nom_du_client> [dernier_octet_ip]"
    echo "Exemple: $0 telephone 2"
    exit 1
fi

# Génération des clés
cd /tmp
umask 077
wg genkey | tee ${CLIENT_NAME}_private.key
wg pubkey < ${CLIENT_NAME}_private.key > ${CLIENT_NAME}_public.key

CLIENT_PRIV=$(cat ${CLIENT_NAME}_private.key)
CLIENT_PUB=$(cat ${CLIENT_NAME}_public.key)
SERVER_PUB=$(sudo cat /etc/wireguard/public.key)
SERVER_IP=$(curl -s ifconfig.me)

# Ajout au serveur
sudo tee -a /etc/wireguard/wg0.conf > /dev/null <<PEER

[Peer]
PublicKey = $CLIENT_PUB
AllowedIPs = 10.8.0.$CLIENT_IP/32
PEER

# Redémarrage
sudo wg-quick down wg0 && sudo wg-quick up wg0

# Création de la configuration client
tee ${CLIENT_NAME}.conf > /dev/null <<CLIENT
[Interface]
PrivateKey = $CLIENT_PRIV
Address = 10.8.0.$CLIENT_IP/24
DNS = 8.8.8.8

[Peer]
PublicKey = $SERVER_PUB
Endpoint = $SERVER_IP:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
CLIENT

echo "✅ Client '$CLIENT_NAME' créé avec IP 10.8.0.$CLIENT_IP"
echo "📁 Configuration : /tmp/${CLIENT_NAME}.conf"
echo ""
echo "📱 Contenu à importer dans WireGuard :"
cat ${CLIENT_NAME}.conf
