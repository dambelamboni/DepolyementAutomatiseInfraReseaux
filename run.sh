 
#!/bin/bash

#Script de creation des conteneurs via lxc 

# creation des clients 

echo "Creation des clients du TP4 \n" 

lxc launch ubuntu:20.04 C1TP4
lxc launch ubuntu:20.04 C2TP4
lxc launch ubuntu:20.04 C3TP4

#creation des serveurs 
echo "Creation des serveurs du  TP4\n" 

lxc launch ubuntu:20.04 DHCP-TP4
lxc launch ubuntu:20.04 DNS-TP4
lxc launch ubuntu:20.04 DNS-SecondTP4

#creation des trois routeurs du TP4 
lxc launch ubuntu:20.04 R1-TP4
lxc launch ubuntu:20.04 R2-TP4
lxc launch ubuntu:20.04 R3-TP4



#creation des bridges necessaires

lxc network create br0-TP4 ipv4.address=none
lxc network create br1-TP4 ipv4.address=none
lxc network create br2-TP4 ipv4.address=none
lxc network create br3-TP4 ipv4.address=none
lxc network create br4-TP4 ipv4.address=none
lxc network create br5-P4 ipv4.address=none
lxc network create br6-TP4 ipv4.address=none


# ous procedons a la connexion des conteneurs aux bridges


# Réseau 1 : 192.168.1.96/28
lxc config device add C3TP4 eth1 nic nictype=bridged parent=br1-TP4
lxc config device add DNS-SecondTP4 eth1 nic nictype=bridged parent=br1-TP4
lxc config device add R2-TP4 eth1 nic nictype=bridged parent=br1-TP4

# Réseau 2 : 192.168.1.64/27
lxc config device add C1TP4 eth1 nic nictype=bridged parent=br0-TP4
lxc config device add DHCP-TP4 eth1 nic nictype=bridged parent=br0-TP4
lxc config device add R1-TP4 eth1 nic nictype=bridged parent=br0-TP4

# Réseau 3 : 192.168.1.0/26
lxc config device add C2TP4 eth1 nic nictype=bridged parent=br2-TP4
lxc config device add DNS-TP4 eth1 nic nictype=bridged parent=br2-TP4
lxc config device add R3-TP4 eth1 nic nictype=bridged parent=br2-TP4

# Liaison R1 et R3 avec br4-TP4 via eth2
lxc config device add R1-TP4 eth2 nic nictype=bridged parent=br4-TP4
lxc config device add R3-TP4 eth2 nic nictype=bridged parent=br4-TP4

# Liaison R1 (eth3) et R2 (eth2) avec br6-TP4
lxc config device add R1-TP4 eth3 nic nictype=bridged parent=br6-TP4
lxc config device add R2-TP4 eth2 nic nictype=bridged parent=br6-TP4

# Liaison R3 et R2 (eth3) avec br5-TP4
lxc config device add R2-TP4 eth3 nic nictype=bridged parent=br5-TP4
lxc config device add R3-TP4 eth3 nic nictype=bridged parent=br5-TP4

# Configuration des fichiers Netplan
echo "Mise en place du netplan \n"
lxc file push DHCP_TP4.yaml DHCP-TP4/etc/netplan/
lxc exec DHCP-TP4 -- netplan apply
lxc file push DNS_TP4.yaml DNS-TP4/etc/netplan/
lxc exec DNS-TP4 -- netplan apply
lxc file push DNS_SecondTP4.yaml DNS-SecondTP4/etc/netplan/
lxc exec DNS-SecondTP4 -- netplan apply
lxc file push R1_TP4.yaml R1-TP4/etc/netplan/
lxc exec R1-TP4 -- netplan apply
lxc file push R2_TP4.yaml R2-TP4/etc/netplan/
lxc exec R2-TP4 -- netplan apply
lxc file push R3_TP4.yaml R3-TP4/etc/netplan/
lxc exec R3-TP4 -- netplan apply

# Afficher la liste des conteneurs créés
echo "Liste des conteneurs créés :"
lxc list
