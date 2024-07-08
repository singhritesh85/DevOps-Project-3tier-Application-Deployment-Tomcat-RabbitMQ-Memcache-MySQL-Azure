#!/bin/bash
/usr/sbin/useradd -s /bin/bash -m ritesh;
mkdir /home/ritesh/.ssh;
chmod -R 700 /home/ritesh;
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ritesh@DESKTOP-0XXXXXX" >> /home/ritesh/.ssh/authorized_keys;
chmod 600 /home/ritesh/.ssh/authorized_keys;
chown ritesh:ritesh /home/ritesh/.ssh -R;
echo "ritesh  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ritesh;
chmod 440 /etc/sudoers.d/ritesh;

####################################################### Installation of Tomcat ###################################################################

useradd -s /bin/bash -m tomcat-admin;
echo "Password@#795" | passwd tomcat-admin --stdin;
echo "tomcat-admin  ALL=(ALL)  NOPASSWD:ALL" >> /etc/sudoers
yum install -y java-1.8*
cd /opt && wget https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/8.0.32/tomcat-8.0.32.tar.gz
tar -xvf tomcat-8.0.32.tar.gz
rm -f tomcat-8.0.32.tar.gz
mv /opt/apache-tomcat-8.0.32 /opt/apache-tomcat
chown -R tomcat-admin:tomcat-admin /opt/apache-tomcat

cat > /etc/systemd/system/tomcat.service <<EOT
[Unit]
Description=Tomcat Service
Requires=network.target
After=network.target
[Service]
Type=forking
User=root
Environment="CATALINA_PID=/opt/apache-tomcat/logs/tomcat.pid"
Environment="CATALINA_BASE=/opt/apache-tomcat"
Environment="CATALINA_HOME=/opt/apache-tomcat"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/apache-tomcat/bin/startup.sh
ExecStop=/opt/apache-tomcat/bin/shutdown.sh
Restart=on-abnormal
[Install]
WantedBy=multi-user.target 
EOT

systemctl daemon-reload
systemctl start tomcat && systemctl enable tomcat && systemctl status tomcat
