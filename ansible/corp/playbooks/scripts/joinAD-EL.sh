#!/bin/bash

adDomain="$1"
upperAdDomain=${adDomain^^}
joinusername=$2
joinpw=$3


(
printf "====================\nInstalling Packages\n====================\n"
yum -y install realmd sssd samba-common-tools krb5-workstation oddjob oddjob-mkhomedir

printf "$joinpw\n" | realm join $adDomain -vv -U $joinusername
if [ "$?" == "1" ]; then
	printf "\n========================================\n= [ERROR] Something went wrong, realmd failed to join to the domain, might be credentials.  check /root/joinAD.log for more details.\n========================================\n"
	exit 1
fi

#disable fully qualified usernames (because ssh "user@super.long.domain.com@computername" is stupid)
sed -i 's/use_fully_qualified_names.*/use_fully_qualified_names = False/' /etc/sssd/sssd.conf
systemctl restart sssd

#lay down krb5.conf that supports gssapi
cat << EOF > /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_ccache_name = KEYRING:persistent:%{uid}
 default_realm = $upperAdDomain

[realms]
 $upperAdDomain = {
 }

[domain_realm]
 $adDomain = $upperAdDomain
 .$adDomain = $upperAdDomain
EOF

#print the keytab, make sure it worked
printf "====================\nMachine Keytab\n====================\n"
klist -ke

#try and get ID of admin user
printf "====================\nQuerying join user\n====================\n"
id $joinusername

if [ $? == "0" ]; then
	printf "\n========================================\nWe were successfully able to join the domain!\n========================================\n"
else
	printf "\n========================================\n= [ERROR] Something went wrong, check /root/joinAD.log\n========================================\n"
fi
) 2>&1 | tee /root/joinAD.log
