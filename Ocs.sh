#!/bin/bash

if [ $USER != 'root' ]; then
	echo "Anda harus menjalankan ini sebagai root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

if [[ -e /etc/debian_version ]]; then
	#OS=debian
	RCLOCAL='/etc/rc.local'
else
	echo "Anda tidak menjalankan script ini pada OS Debian"
	exit
fi

vps="FNS";

if [[ $vps = "FNS" ]]; then
	source="https://raw.githubusercontent.com/pijan0/pijan-atok/master/"
else
	source="https://raw.githubusercontent.com/pijan0/pijan-atok/master"
fi

# go to root
cd

echo ""
echo -e "\e[38;5;6m     ========================================================="
echo -e "\e[38;5;82m     *              AUTOSCRIPT OCS PANEL 2018                *"
echo -e "\e[38;5;6m     ========================================================="
echo -e "\e[38;5;6m     *                     Contact Me                        *"
echo -e "\e[38;5;6m     *                Channel: CuCuAtoK_TeaM                 *"
echo -e "\e[38;5;6m     *                Whatsapp: -                            *"
echo -e "\e[38;5;196m     *              Telegram: @Cucu_atok                     *"
echo -e "\e[38;5;6m     ========================================================="
echo -e "\e[38;5;226m     *                AUTOSCRIPT VPS 2018                    *"
echo -e "\e[38;5;6m     ========================================================="

MYIP=$(wget -qO- ipv4.icanhazip.com);

# check registered ip
wget -q -O daftarip https://raw.githubusercontent.com/pijan0/pijan-atok/master/ip.txt
if ! grep -w -q $MYIP daftarip; then
	echo -e "\e[38;5;196m "Maaf, hanya IP yang terdaftar yang Boleh menggunakan script ini!"
	if [[ $vps = "FNS" ]]; then
		echo -e "\e[38;5;226m PM Telagram: https://t.me/Cucu_atok sila rujuk admin\e[0m"
	else
		echo -e "\e[38;5;226m PM Telegram: https://t.me/Cucu_atok untuk dapatkan harga diskaun kaw²\e[0m"
	fi
	rm -f /root/IP
	exit
fi

#https://github.com/adenvt/OcsPanels/wiki/tutor-debian

clear
echo ""
echo -e "\e[38;5;11m "Saya perlu mengajukan beberapa pertanyaan sebelum memulai setup"
echo -e "\e[38;5;82m "Anda dapat membiarkan pilihan default dan hanya tekan enter jika Anda setuju dengan pilihan tersebut"
echo ""
echo "Pertama saya perlu tahu password baru user root MySQL:"
read -p "Password baru: " -e -i Pass1234 DatabasePass
echo ""
echo "Terakhir, sebutkan Nama Database untuk OCS Panels"
echo -e "\e[38;5;6m "Tolong, gunakan satu kata saja, tidak ada karakter khusus selain Underscore (_)"
read -p "Nama Database: " -e -i OCS_FNS DatabaseName
echo ""
echo -e "\e[38;5;82m "Oke, itu semua saya perlukankan. Kami sedia untuk setup OCS Panels Anda sekarang"
read -n1 -r -p "Tekan tombol Enter untuk Teruskan Setup..."

#apt-get update
apt-get update -y
apt-get install build-essential expect -y

apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get install -y nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
curl $source/ocs/nginx.conf > /etc/nginx/nginx.conf
curl $source/ocs/vps.conf > /etc/nginx/conf.d/vps.conf
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

useradd -m 
mkdir -p /home//public_html
chown -R www-data:www-data /home/public_html
chmod -R g+rw /home/fns/public_html
service php5-fpm restart
service nginx restart

apt-get -y install rar unzip
cd /home/fns/public_html
wget $source/pijan.rar
unzip pijan.rar
rm -f pijan.rar
chown -R www-data:www-data /home/fns/public_html
chmod -R g+rw /home/fns/public_html

#mysql -u root -p
so2=$(expect -c "
spawn mysql -u root -p; sleep 3
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"CREATE DATABASE IF NOT EXISTS $DatabaseName;EXIT;\r\"
expect eof; ")
echo "$so2"
#pass
#CREATE DATABASE IF NOT EXISTS OCS_PANEL;EXIT;

chmod 777 /home/fns/public_html/config
chmod 777 /home/fns/public_html/config/inc.php
chmod 777 /home/fns/public_html/config/route.php


clear
echo "Buka Browser, terus ke alamat http://$MYIP:81/ dan lengkapkan data2 seperti dibawah ini!"
echo "Database:"
echo "- Database Host: localhost"
echo "- Database Name: $DatabaseName"
echo "- Database User: root"
echo "- Database Pass: $DatabasePass"
echo ""
echo "Admin Login:"
echo -e "\e[38;5;11m "- Username: ikot suka hampa la mak boh apa pun"
echo -e "\e[38;5;11m "- Password Baru: ikot suka tapi jangan lupa pulak noh"
echo -e "\e[38;5;11m "- Masukkan Ulang Password Baru: bagi sama password tak sat"
echo ""
echo -e "\e[38;5;10m "Klik Install dan tunggu proses selesai, kembali lagi ke terminal dan kemudian tekan tombol [ENTER]!"

sleep 3
echo ""
read -p "Jika Step diatas sudah dilakukan, silahkan Tekan tombol [Enter] untuk melanjutkan..."
echo ""
read -p "Jika anda benar-benar yakin Step diatas sudah dilakukan, silahkan Tekan tombol [Enter] untuk melanjutkan..."
echo ""
cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

rm -f /root/jcameron-key.asc

apt-get -y --force-yes -f install libxml-parser-perl


rm -R /home/fns/public_html/installation

cd
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

chmod 755 /home/fns/public_html/config
chmod 644 /home/fns/public_html/config/inc.php
chmod 644 /home/fns/public_html/config/route.php

# info
clear
echo "=======================================================" | tee -a log-install.txt
echo "Silahkan login Panel Reseller di http://$MYIP:81" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Auto Script Installer OCS Panels | Cucu_atok"  | tee -a log-install.txt
echo "             (https://cucuatok.pe.hu/ - 0175835809)           "  | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Thanks You noh.hehe " | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt" | tee -a log-install.txt
echo "=======================================================" | tee -a log-install.txt
cd ~/

rm -f /root/kedah.sh
