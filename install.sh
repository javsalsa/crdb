#!/bin/bash
sudo yum install wget curl unzip -y
cd /home/ec2-user
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
wget -qO- https://binaries.cockroachdb.com/cockroach-v20.2.7.linux-amd64.tgz | tar  xvz
cp -i cockroach-v20.2.7.linux-amd64/cockroach /usr/local/bin/
mkdir -p /usr/local/lib/cockroach
cp -i cockroach-v20.2.7.linux-amd64/lib/libgeos.so /usr/local/lib/cockroach/
cp -i cockroach-v20.2.7.linux-amd64/lib/libgeos_c.so /usr/local/lib/cockroach/
sed -i 's/pool 2.rhel.pool.ntp.org iburst/#pool 2.rhel.pool.ntp.org iburst/' /etc/chrony.conf
systemctl restart chronyd

while [ ! -e /dev/nvme1n1 ] ; do sleep 1 ; done
if [ "$(file -b -s /dev/nvme1n1)" == "data" ]; then
      mkfs -t ext4 /dev/nvme1n1
    fi

mkdir /cockroachdb_data
mount /dev/nvme1n1 /cockroachdb_data
echo '/dev/nvme1n1 /cockroachdb_data ext4 defaults,nofail 0 2' >> /etc/fstab
chown ec2-user:ec2-user /cockroachdb_data

cat << 'EOF' >> start-cockroachdb.sh
#!/bin/bash
sudo chronyc -a 'burst 4/4'
sleep 30
hostname=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
crdbnodes=$(/usr/local/bin/aws ec2 describe-instances --filters "Name=tag:Role,Values=crdbnode" --query 'Reservations[*].Instances[*].PrivateDnsName' --region us-east-1 --output text)

results=$(
for value in $crdbnodes;
do
  x=$value","
  echo $x
done
)

if [[ ${results: -1} = "," ]]; then
  l=${#results}-1
  crdbnodes=${results:0:$l}
else
  crdbnodes=$results
fi

crdbnodes=$(echo $crdbnodes | tr -d '\r' | tr -d [:space:])
cockroach start --insecure --advertise-addr=$hostname --store=/cockroachdb_data --join=$crdbnodes --cache=.25 --max-sql-memory=.25 --background
EOF

chmod +x start-cockroachdb.sh
chown ec2-user:ec2-user start-cockroachdb.sh
