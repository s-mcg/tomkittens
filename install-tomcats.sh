#!/bin/bash
#Installs $1 tomcat instances on the current machine
#this script should be run in the directory where the tomcat instances will be installed

if [ $# -eq 0 ];
then
  echo "Usage: install-tomcats.sh {number of tomcat instances (required)} {start (optional)}"
  echo "example (this will create 2 tomcat containers and start them): ./install-tomcats.sh 2 start"
  exit 1
fi

DIR=`pwd`

#download the .tar
if [ -f $DIR/apache-tomcat-6.0.35.tar.gz ];
then
  echo "tomcat .tar already exists, will not re-download"
else
  echo "downloading tomcat 6 from mirror site"
  wget http://apache.cs.utah.edu/tomcat/tomcat-6/v6.0.37/bin/apache-tomcat-6.0.37.tar.gz
fi

START_SCRIPT="#!/bin/sh\n"
SHUT_SCRIPT="#!/bin/sh\n"

for i in `seq 1 1 $1`
do
  let "j = $i - 1"
  let "CONNECTOR = 8080 + $j"
  let "REDIRECT = 8443 + $j"
  let "SERVER = 8005 + $j"
  let "AJP = 8109 + $j"
  tar -xzf apache-tomcat-6.0.35.tar.gz
  mv apache-tomcat-6.0.35 apache-tomcat-6.0.35-$j
  #replace port numbers
  SERVER_XML=$DIR/apache-tomcat-6.0.35-$j/conf/server.xml
  USERS_XML=$DIR/apache-tomcat-6.0.35-$j/conf/tomcat-users.xml
  sed -i -e "s/port=\"8080\"/port=\"$CONNECTOR\"/" $SERVER_XML
  sed -i -e "s/redirectPort=\"8443\"/redirectPort=\"$REDIRECT\"/" $SERVER_XML
  sed -i -e "s/port=\"8005\"/port=\"$SERVER\"/" $SERVER_XML
  sed -i -e "s/port=\"8009\"/port=\"$AJP\"/" $SERVER_XML
  sed -i -e "s/<\/tomcat-users>/<role rolename=\"manager\"\/><user username=\"tomcat\" password=\"tomcat\" roles=\"manager\"\/><\/tomcat-users>/" $USERS_XML
  START_SCRIPT=$START_SCRIPT"$DIR/apache-tomcat-6.0.35-$j/bin/startup.sh\n"
  SHUT_SCRIPT=$SHUT_SCRIPT"$DIR/apache-tomcat-6.0.35-$j/bin/shutdown.sh\n"
  echo -e "installed tomcat to directory $DIR/apache-tomcat-6.0.35-$j accessible at port $CONNECTOR"
done

echo -e $START_SCRIPT > startup_all.sh
echo -e $SHUT_SCRIPT > shutdown_all.sh
chmod +x startup_all.sh
chmod +x shutdown_all.sh
if test "$2" = "start"
then
  ./startup_all.sh
  echo "started up all tomcat containers that were just created"
fi
