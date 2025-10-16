# 🛰️ Déploiement d'une Infrastructure Réseau Complète avec LXD

**Auteur :** DAMBE Lamboni
**Date :** Dimanche 27 Octobre 2024
**Formation :** Master 2 SSI – Option Sécurité des Systèmes d’Information
**Module :** Administration et Protocoles Réseaux
**Contact :** [dlamboni31@gmail.com](mailto:dlamboni31@gmail.com)
**Encadrant :** —
**TP4 :** Script de déploiement automatique d’infrastructure réseau sous LXD

---

## 📘 Objectif du projet

L’objectif de ce TP est de **déployer automatiquement une infrastructure réseau complète** à l’aide d’un **script Shell**, basée sur des conteneurs LXD, intégrant :

* Un **serveur DHCP** assurant la distribution automatique des adresses IP,
* Deux **serveurs DNS** (primaire et secondaire),
* Une **passerelle de routage** entre les sous-réseaux,
* Des règles **iptables** pour assurer la connectivité et le routage entre les zones.

Ce projet permet de simuler un réseau local segmenté et fonctionnel dans un environnement de virtualisation légère.

---

## ⚙️ Architecture Réseau

| Composant     | Rôle                   | Adresse IP      | Sous-réseau     | Service               |
| ------------- | ---------------------- | --------------- | --------------- | --------------------- |
| DHCP-TP4      | Serveur DHCP           | 192.168.1.70–94 | 192.168.1.64/27 | isc-dhcp-server       |
| DNS-TP4       | Serveur DNS principal  | 192.168.1.65    | 192.168.1.0/26  | bind9                 |
| DNS-SecondTP4 | Serveur DNS secondaire | 192.168.1.98    | 192.168.1.96/28 | dnsmasq               |
| Passerelle    | Routeur                | 192.168.1.94    | —               | iptables / forwarding |

---

## 🧩 Étapes principales du déploiement

### 1️⃣ Installation et configuration du réseau LXD

Création d’un pont réseau dédié au TP :

```bash
sudo lxc network create lxdbr1_tp4 ipv4.address=192.168.1.1/24 ipv4.nat=false ipv6.address=none
```

Activation du **forwarding IP** :

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

---

### 2️⃣ Configuration du routage avec iptables

Ajout des règles pour permettre le transfert entre les interfaces :

```bash
sudo iptables -P FORWARD ACCEPT
sudo iptables -A FORWARD -i lxdbr1_tp4 -o lxdbr1_tp4 -j ACCEPT
sudo iptables -A FORWARD -i lxdbr1_tp4 -o wlp2s0 -j ACCEPT
sudo iptables -A FORWARD -i wlp2s0 -o lxdbr1_tp4 -j ACCEPT
```

---

### 3️⃣ Installation du serveur DHCP

```bash
lxc exec DHCP-TP4 -- bash
sudo apt update
sudo apt install isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl start isc-dhcp-server
```

**Fichier `/etc/dhcp/dhcpd.conf` :**

```bash
# Sous-réseau pour DHCP_TP4
subnet 192.168.1.64 netmask 255.255.255.224 {
  range 192.168.1.70 192.168.1.94;
  option routers 192.168.1.94;
  option subnet-mask 255.255.255.224;
  option domain-name "local";
  option domain-name-servers 8.8.8.8, 8.8.4.4;
}

# Sous-réseau pour DNS_TP4
subnet 192.168.1.0 netmask 255.255.255.192 {
  range 192.168.1.2 192.168.1.62;
  option routers 192.168.1.62;
  option subnet-mask 255.255.255.192;
  option domain-name "local";
  option domain-name-servers 8.8.8.8, 8.8.4.4;
}

# Sous-réseau pour DNS_SecondTP4
subnet 192.168.1.96 netmask 255.255.255.240 {
  range 192.168.1.98 192.168.1.110;
  option routers 192.168.1.110;
  option subnet-mask 255.255.255.240;
}
```

---

### 4️⃣ Installation du serveur DNS principal (BIND9)

```bash
lxc exec DNS-TP4 -- bash
sudo apt update
sudo apt install bind9
```

**Configuration `/etc/bind/named.conf.options` :**

```bash
options {
  directory "/var/cache/bind";
  recursion yes;
  forwarders {
    8.8.8.8;
    8.8.4.4;
  };
  dnssec-validation auto;
  auth-nxdomain no;
  listen-on-v6 { any; };
};
```

**Fichier de zone `/etc/bind/named.conf.local` :**

```bash
zone "local" {
  type master;
  file "/etc/bind/db.local";
};
```

**Fichier `/etc/bind/db.local` :**

```bash
$TTL 604800
@ IN SOA ns.local. admin.local. (
    2 ; Serial
    604800 ; Refresh
    86400 ; Retry
    2419200 ; Expire
    604800 ) ; Negative Cache TTL
;
@   IN NS ns.local.
ns  IN A 192.168.1.65
@   IN A 192.168.1.65
```

---

### 5️⃣ Installation du DNS secondaire (dnsmasq)

```bash
lxc exec DNS-SecondTP4 -- bash
sudo apt update
sudo apt install dnsmasq
```

**Fichier `/etc/dnsmasq.conf` :**

```bash
# Configuration ajoutée par DAMBE Lamboni – TP4
port=53
interface=eth1
server=8.8.8.8
server=8.8.4.4
dhcp-range=192.168.1.65,192.168.1.94,12h
```

---

## 🧪 Résultats des tests de validation

✅ **Test DHCP :** Attribution correcte des adresses IP sur les différents sous-réseaux.
✅ **Test DNS :** Résolution locale et externe fonctionnelle.
✅ **Test Ping :** Fonctionnel après ajout de la règle `sudo iptables -P FORWARD ACCEPT`.
✅ **Connectivité entre les conteneurs :** Validée.

---

## 🧠 Observations

* Les **pings inter-conteneurs** ne fonctionnaient pas initialement, nécessitant la mise à jour des règles iptables.
* Les **zones DNS** ont été configurées manuellement pour éviter les erreurs de synchronisation.
* L’utilisation de **LXD** a permis un déploiement léger, rapide et modulaire.

---

## 🚀 Script de déploiement automatisé

Le script Shell joint à ce projet permet d’automatiser toutes les étapes précédentes :

* Création du réseau et des conteneurs,
* Attribution des IP,
* Installation et configuration des services (DHCP, DNS, routage),
* Activation des règles iptables.

**Exécution :**

```bash
chmod +x deploy_tp4.sh
sudo ./deploy_tp4.sh
```

---

## 📄 Licence

Projet académique — Université [Nom de l’établissement si applicable].
Usage pédagogique uniquement.

---

Souhaites-tu que je te rédige **le contenu exact du script `deploy_tp4.sh`** correspondant à cette architecture (création réseau + conteneurs + services + iptables) ?
Cela permettrait d’avoir un projet 100 % reproductible avec ton README.
