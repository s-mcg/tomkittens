#!/bin/sh
#Installs $1 tomcat instances on the current machine
#this script should be run in the directory where the tomcat instances will be installed
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COUNT=0


wget http://www.globalish.com/am/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz


while [ $COUNT -le $1 ]
do
CONNECTOR=8080+$COUNT
REDIRECT=8443+$COUNT
SERVER=8005+$COUNT
AJP=8109+$COUNT

tar -xzvf apache-tomcat-6.0.35.tar.gz
mv apache-tomcat-6.0.35 apache-tomcat-6.0.35-$COUNT
#replace port numbers
SERVERXML = $DIR/apache-tomcat-6.0.35-$COUNT
sed -i 's/port="$CONNECTOR"/port="8080"/' $SERVERXML
sed -i 's/port="$REDIRECT"/port="8443"/' $SERVERXML
sed -i 's/port="$SERVER"/port="8005"/' $SERVERXML
sed -i 's/port="$AJP"/port="8009"/' $SERVERXML

$COUNT+=1
done 
