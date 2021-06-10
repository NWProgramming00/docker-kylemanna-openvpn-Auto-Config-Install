#!/bin/bash
echo OVPN DOCKER AUTOMATIC INSTALL SCRIPT
echo 
echo What would you like to do?
echo 1 Install kylemanna/openvpn server
echo 2 Create new openvpn user
read OPTION
if (( $OPTION == "1" ))
then
	read OVPN_NAME
	OVPN_DATA="ovpn-data-$OVPN_NAME"
	echo Server name is $OVPN_DATA
	echo Please provide servers public ip
	read PUBLIC_IP
	echo IP: $PUBLIC_IP PORT: 1194
	docker pull kylemanna/openvpn
	docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$PUBLIC_IP:1194
	docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
	docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
else
	echo "Provide SERVERNAME:
	read OVPN_NAME
	OVPN_DATA="ovpn-data-$OVPN_NAME"
	echo Server name is $OVPN_DATA
 	echo "Provide username"
	read USERNAME
	echo "USERNAME: $USERNAME PASSWORD: NOPASSWORD"
	docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $USERNAME nopass
	docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $USERNAME > $USERNAME.ovpn
fi
