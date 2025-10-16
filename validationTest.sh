#!/bin/bash

# Ce script permet d'effectuer les tests de connectivité pour valider le bon fonctionnement de notre architecture.

echo -e "\n********* Test de connectivité de C1TP4 vers C2TP4 *********\n"
lxc exec C1TP4 -- ping -c 4 10.207.193.78  # Adresse de C2TP4

echo -e "\n********* Test de connectivité de C1TP4 vers C3TP4 *********\n"
lxc exec C1TP4 -- ping -c 4 10.207.193.157  # Adresse de C3TP4

echo -e "\n********* Test de connectivité de C1TP4 vers DHCP-TP4 *********\n"
lxc exec C1TP4 -- ping -c 4 10.207.193.79  # Adresse de DHCP-TP4

echo -e "\n********* Test de connectivité de C1TP4 vers DNS-TP4 *********\n"
lxc exec C1TP4 -- ping -c 4 10.207.193.115  # Adresse de DNS-TP4

echo -e "\n********* Test de connectivité de C2TP4 vers C1TP4 *********\n"
lxc exec C2TP4 -- ping -c 4 10.207.193.70  # Adresse de C1TP4

echo -e "\n********* Test de connectivité de C2TP4 vers C3TP4 *********\n"
lxc exec C2TP4 -- ping -c 4 10.207.193.157  # Adresse de C3TP4

echo -e "\n********* Test de connectivité de C2TP4 vers DHCP-TP4 *********\n"
lxc exec C2TP4 -- ping -c 4 10.207.193.79  # Adresse de DHCP-TP4

echo -e "\n********* Test de connectivité de C2TP4 vers DNS-TP4 *********\n"
lxc exec C2TP4 -- ping -c 4 10.207.193.115  # Adresse de DNS-TP4

echo -e "\n********* Test de connectivité de C3TP4 vers C1TP4 *********\n"
lxc exec C3TP4 -- ping -c 4 10.207.193.70  # Adresse de C1TP4

echo -e "\n********* Test de connectivité de C3TP4 vers C2TP4 *********\n"
lxc exec C3TP4 -- ping -c 4 10.207.193.78  # Adresse de C2TP4

echo -e "\n********* Test de connectivité de C3TP4 vers DHCP-TP4 *********\n"
lxc exec C3TP4 -- ping -c 4 10.207.193.79  # Adresse de DHCP-TP4

echo -e "\n********* Test de connectivité de C3TP4 vers DNS-TP4 *********\n"
lxc exec C3TP4 -- ping -c 4 10.207.193.115  # Adresse de DNS-TP4

echo -e "\n********* Test de connectivité de DHCP-TP4 vers DNS-TP4 *********\n"
lxc exec DHCP-TP4 -- ping -c 4 10.207.193.115  # Adresse de DNS-TP4

echo -e "\n********* Test de connectivité de R1-TP4 vers R2-TP4 *********\n"
lxc exec R1-TP4 -- ping -c 4 10.207.193.27  # Adresse de R2-TP4

echo -e "\n********* Test de connectivité de R1-TP4 vers R3-TP4 *********\n"
lxc exec R1-TP4 -- ping -c 4 10.207.193.190  # Adresse de R3-TP4

echo -e "\n********* Test de connectivité de R2-TP4 vers R1-TP4 *********\n"
lxc exec R2-TP4 -- ping -c 4 10.207.193.88  # Adresse de R1-TP4

echo -e "\n********* Test de connectivité de R2-TP4 vers R3-TP4 *********\n"
lxc exec R2-TP4 -- ping -c 4 10.207.193.190  # Adresse de R3-TP4

echo -e "\n********* Test de connectivité de R3-TP4 vers R1-TP4 *********\n"
lxc exec R3-TP4 -- ping -c 4 10.207.193.88  # Adresse de R1-TP4

echo -e "\n********* Test de connectivité de R3-TP4 vers R2-TP4 *********\n"
lxc exec R3-TP4 -- ping -c 4 10.207.193.27  # Adresse de R2-TP4


#Test de Demande d'adresses IP

echo -e "\n********* Test de demande d'adresse IP au serveur DHCP depuis C1TP4 *********\n"
lxc exec C1TP4 -- dhclient -v eth0  # Interface eth0 de C1TP4

echo -e "\n********* Test de demande d'adresse IP au serveur DHCP depuis C2TP4 *********\n"
lxc exec C2TP4 -- dhclient -v eth0  # Interface eth0 de C2TP4

echo -e "\n********* Test de demande d'adresse IP au serveur DHCP depuis C3TP4 *********\n"
lxc exec C3TP4 -- dhclient -v eth0  # Interface eth0 de C3TP4

echo -e "\n********* Test de demande d'adresse IP au serveur DHCP depuis DHCP-TP4 *********\n"
lxc exec DHCP-TP4 -- dhclient -v eth0  # Interface eth0 de DHCP-TP4

