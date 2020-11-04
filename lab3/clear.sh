#!/bin/bash

rm -f work3.log
rm -rf /home/test13
rm -rf /home/test14
rm -rf /home/test15

gpasswd -d u1 g1
userdel -rf u1
userdel -rf u2
groupdel g1
