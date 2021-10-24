# CG-NAT-VPS-bypass

This is a set of scripts that is used host public services by configuring a VPS and a Client (which hosts webservices) which is inaccessible directly because of Carrier grade NAT or CG-NAT 


## Steps 

### Install wireguard on the client

``` sh
sudo apt install wireguard
```

### Generate Public and Private keys 

Run this command twice to generate keys for both VPS and Client

``` sh
echo "Private key: " `wg genkey` "\nPublic Key: " | tee /dev/tty | awk '{print $3}' | wg pubkey
```

Copy the Keys in the appropriate places in the Conf and publickey files in the repo

### Copy Public IP

After provisioning the VPS in your favourite cloud provider add the IP address to client_wg0.conf and host.yml 

### Copy the client files to /etc/wireguard on the Client

``` sh
sudo cp client_wg0.conf /etc/wireguard/wg0.conf && sudo cp client_publickey /etc/wireguard/publickey 
```

### Running the ansible scripts

Ensure ssh access to the VPS, Make sure you have installed ansible and then run 

``` sh
ansible-playbook -i ./hosts.yml init.yml
```

Note: You may have to change the interface name 'eth0' in iptables.sh to the appropriate public facing network interface in on your vps which you can check by running 

``` sh
ip a
```

### Start and Enable the wireguard service on the Client

``` sh
sudo systemctl enable --now wg-quick@wg0
```

You can verify that the wireguard connection is live by pinging the VPS from the client 

``` sh
ping 192.168.69.1
```


### You're Done! If everything worked correctly all the http and https traffic should be forwarded to the client through the VPS


## Running a quick test

Start a local http server using python

``` sh
sudo python3 -m http.server 80
```

Now try accessing it through the public ip address of the VPS
