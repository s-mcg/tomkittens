tomkittens
==========

A simple Bash script for installing any number of instances of Apache Tomcat.

By default it is installing Tomcat 6.0.35. If you want to install a different version you'll have to modify the script.

Easy download link:

    wget https://raw.github.com/s-mcg/tomkittens/master/install-tomcats.sh

Usage

./install-tomcats.sh {number of tomcat instances (required)} {start (optional)}

Example call:

./install-tomcats.sh 2 start

This will create 2 Tomcat containers, one at port 8080 and one at 8081, and then start them.

Possible future features:

Interactive installation script

Choosing tomcat version

Choosing ports

Multiple mirrors in case one goes down
