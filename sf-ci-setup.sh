#!/bin/bash
# Navigate to user home
cd /home/ec2-user/

# install Git using Yellowdog Update Manager
sudo yum install -y git

# check install succeeded
git --version

# list contents of current directory
ls

# print working directory (where you are now)
pwd

# use HTTP GET to fetch Tomcat
wget -P "/home/ec2-user/" "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz"

# expands gunzip file
tar -zxf /home/ec2-user/apache-tomcat-8.5.9.tar.gz

# remove unneeded file
rm /home/ec2-user/apache-tomcat-8.5.9.tar.gz

# rename files by moving them
mv /home/ec2-user/apache-tomcat-8.5.9 /home/ec2-user/tomcat

# add manager-gui role and tomcat user with this role.. 
# echo prints something and > pipes the content into the file 
# ( > overwrites while >> will concatenate)
echo "<?xml version='1.0' encoding='utf-8'?><tomcat-users><role rolename=\"manager-gui\"/><role rolename=\"manager-script\"/><user username=\"tomcat\" password=\"tomcat\" roles=\"manager-gui\"/><user username=\"maven\" password=\"maven\" roles=\"manager-script\"/></tomcat-users>" > /home/ec2-user/tomcat/conf/tomcat-users.xml

# allow the remote access of Tomcat manager console
# removes the default RemoteAddrValve constraint
echo "<?xml version='1.0' encoding='UTF-8'?><Context antiResourceLocking=\"false\" privileged=\"true\"><Manager sessionAttributeValueClassNameFilter=\"java\.lang\.(?:Boolean|Integer|Long|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)>HashMap\"/></Context>" > /home/ec2-user/tomcat/webapps/manager/META-INF/context.xml

# install OpenJDK 8
sudo yum install -y java-1.8.0-openjdk-devel.x86_64

# creates an environment variable for this Shell session. 
# long-term variables can go into /etc/environment file
export JAVA_HOME=/usr/lib/jvm/java-openjdk

# print an environment variable with $variable_name
echo $JAVA_HOME

# install the sfdx cli
wget -P "/home/ec2-user/" "https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz"

# make sfdx directory
mkdir sfdx

# unzip
tar -xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1

# Run the install script
./sfdx/install

# verify the sfdx version
sfdx --version

# use HTTP GET to fetch the latest Jenkins war
wget -P "/home/ec2-user/" https://updates.jenkins-ci.org/latest/jenkins.war

# moving a war into webapps folder will deploy the war
mv /home/ec2-user/jenkins.war /home/ec2-user/tomcat/webapps/jenkins.war

# executes a shell command to start Tomcat
sudo sh /home/ec2-user/tomcat/bin/startup.sh

# prints the Jenkins admin credentials
# this only works after browsing to your.aws.ip:8080/jenkins
# hence it is commented here
# sudo cat /root/.jenkins/secrets/initialAdminPassword
