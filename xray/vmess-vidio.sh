#!/bin/bash
domain=$(cat /etc/xray/domain)
idsq=$(cat /etc/xray/idsq)
clear
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
clear
echo -e "BUAT AKUN VMESS XL VIDIO"
echo -e " "    
read -rp "User: " -e user
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "BUAT AKUN VMESS XL VIDIO"
echo ""
echo "Nama Sudah Digunakan"
echo " "
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
VMESS_GRPC=`cat<<EOF
      {
      "v": "2",
      "ps": "${user} [unlimited] [${idsq}] ",
      "add": "experience.xeileenc.com",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF`
vmesslink2="vmess://$(echo $VMESS_GRPC | base64 -w 0)"
systemctl restart xray
systemctl restart nginx
service cron restart
clear
echo -e "============================"
echo -e "Username   : ${user}" | tee -a /etc/log-create-user.log
echo -e "IDsvr      : $idsq" | tee -a /etc/log-create-user.log
echo -e "Expired On : $exp" | tee -a /etc/log-create-user.log
echo -e "Script By  : Axsystem" | tee -a /etc/log-create-user.log
echo -e "============================"
echo -e "Link GRPC :
${vmesslink2}" | tee -a /etc/log-create-user.log
echo -e "============================"
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "Powered by Xeileencell"

menu
