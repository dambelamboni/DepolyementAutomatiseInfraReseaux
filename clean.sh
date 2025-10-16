#!/bin/bash

# Script de nettoyage pour supprimer les conteneurs et les réseaux LXC

# Suppression des conteneurs
echo "Nettoyage des conteneurs...\n"
lxc rm --force C1TP4
lxc rm --force C2TP4
lxc rm --force C3TP4

lxc rm --force DHCP-TP4
lxc rm --force DNS-TP4
lxc rm --force DNS-SecondTP4

lxc rm --force R1-TP4
lxc rm --force R2-TP4
lxc rm --force R3-TP4

# Suppression des réseaux
echo -e "\nNettoyage des réseaux...\n"
lxc network rm br0-TP4
lxc network rm br1-TP4
lxc network rm br2-TP4
lxc network rm br3-TP4
lxc network rm br4-TP4
lxc network rm br5-TP4
lxc network rm br6-TP4

echo -e "\nNettoyage terminé."
