# 🛡️ WireGuard VPN sur Google Cloud

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-GCP-blue.svg)](https://cloud.google.com)
[![WireGuard](https://img.shields.io/badge/WireGuard-0.5.3-green.svg)](https://www.wireguard.com)

## 📖 À propos

Ce projet vous permet de déployer votre propre serveur VPN personnel sur **Google Cloud Platform** en utilisant **WireGuard**. 
Profitez de l'offre **Always Free** de GCP pour un VPN gratuit, sécurisé et performant.

## ✨ Fonctionnalités

- 🔒 **Sécurisé** : Chiffrement moderne (WireGuard)
- 🚀 **Performant** : Latence minimale et débits élevés
- 💰 **Gratuit** : Fonctionne avec l'offre Always Free de GCP
- 📱 **Multi-plateforme** : Compatible avec tous les appareils
- 🛠️ **Facile à configurer** : Scripts automatisés

## 📋 Prérequis

- Un compte [Google Cloud Platform](https://cloud.google.com)
- Des connaissances de base en ligne de commande
- Un appareil client (téléphone, ordinateur, tablette)

## 🚀 Installation rapide

### 1. Créer une VM sur GCP

```bash
gcloud compute instances create vpn-server \
    --machine-type=e2-micro \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --tags=wireguard
