#!/bin/bash

echo "Iscsi setup"

# old homemade iscsi tgt ISCSITGT="192.168.100.10"
# Freenas
ISCSITGT="192.168.100.210"

# install packages
sudo ansible-playbook /data/playbooks/iscsi.yaml

cat - <<EOF >|/etc/multipath.conf
defaults {
	user_friendly_names no
	find_multipaths yes
}
EOF

sudo systemctl start multipathd.service

cat - <<EOF >|/etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.2009-11.com.opensvc.srv:$HOSTNAME.storage.initiator
EOF

echo ; echo

sudo iscsiadm -m discovery -t st -p $ISCSITGT && {

    sudo iscsiadm  -m node | awk '{print $2}' | xargs -n 1 sudo iscsiadm -m node --login --targetname

}

exit 0
