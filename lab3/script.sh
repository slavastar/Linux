#!/bin/bash

# 1. выводит в файл work3.log построчно список всех пользователей в системе в следующем формате: «user NNN has id MM»;
awk -F: '{ print "user",$1,"has id", $3 }' /etc/passwd > work3.log

# 2. добавляет в файл work3.log строку, содержащую дату последней смены пароля для пользователя root;
chage -l root | grep "Last password change" | awk '{print $5, $6, $7}' >> work3.log

# 3. добавляет в файл work3.log список всех групп в системе (только названия групп) через запятую;
getent group | cut -d : -f1 | sed -z 's/\n/,/g;s/,$/\n/' >> work3.log

# 4. делает так, чтобы при создании нового пользователя у него в домашнем каталоге создавался файл readme.txt с текстом «Be careful!»;
# echo /etc/skel >> /etc/default/useradd/readme.txt

# 5. создает пользователя u1 с паролем 12345678;
useradd -p 12345678 u1

# 6. создает группу g1;
groupadd g1

# 7. делает так, чтобы пользователь u1 дополнительно входил в группу g1;
usermod -a -G g1 u1

# 8. добавляет в файл work3.log строку, содержащую сведения об идентификаторе и имени пользователя u1 и идентификаторах и именах всех групп, в которые он входит;
# /etc/passwd contains information about all the users
# /etc/group contains infromation about all the groups
# {BEGIN{FS=":"} sets : as a field separator
echo user >> work3.log
cat /etc/passwd | grep "u1" | awk 'BEGIN{FS=":"} {print $1, $3}' >> work3.log
echo groups >> work3.log
cat /etc/group | grep "u1" | awk 'BEGIN{FS=":"} {print $1, $3}' >> work3.log

# 9. делает так, чтобы пользователь user дополнительно входил в группу g1
usermod -a -G g1 root

# 10. добавляет в файл work3.log строку с перечнем пользователей в группе g1 через запятую;
cat /etc/group | grep "g1" | awk 'BEGIN{FS=":"} {print $1, $3}' >> work3.log

# 11. делает так, что при входе пользователя u1 в систему вместо оболочки bash автоматически запускается /usr/bin/mc, при выходе из которого пользователь возвращается к вводу логина и пароля;
usermod --shell /usr/bin/mc u1

# 12. создает пользователя u2 с паролем 87654321;
useradd -p 87654321 u2

# 13. в каталоге /home создает каталог test13, в который копирует файл work3.log два раза с разными именами (work3-1.log и work3-2.log);
mkdir /home/test13
cp work3.log /home/test13/work3-1.log
cp work3.log /home/test13/work3-2.log

# 14. сделает так, чтобы пользователи u1 и u2 смогли бы просматривать каталог test13 и читать эти файлы, только пользователь u1 смог бы изменять и удалять их, а все остальные пользователи системы не могли просматривать содержимое каталога test13 и файлов в нем. При этом никто не должен иметь права исполнять эти файлы;
# add user u2 to group g1
usermod -a -G g1 u2
# chown - change file owner
chown -R u1 /home/test13
#chgrp - change the group of each file to group
chgrp -R g1 /home/test13
# 750 - rwe r-e ---
chmod 750 /home/test13
# 660 - rw- rw- ---
chmod 660 /home/test13/*

# 15. создает в каталоге /home каталог test14, в который любой пользователь системы сможет записать данные, но удалить любой файл сможет только пользователь, который его создал или пользователь u1;
mkdir /home/test14
chown u1 /home/test14
# sticky bit allows only the owner to delete it
chmod 1777 /home/test14

# 16. копирует в каталог test14 исполняемый файл редактора nano и делает так, чтобы любой пользователь смог изменять с его помощью файлы, созданные в пункте 13;
cp /usr/bin/nano /home/test14
# When SUID bit is set, the file will execute with the file owner's user ID, not the person running it
chmod u+s /home/test14/nano

# 17. создает каталог test15 и создает в нем текстовый файл /test15/secret_file. Делает так, чтобы содержимое этого файла можно было вывести на экран, используя полный путь, но чтобы узнать имя этого файла, было бы невозможно.
mkdir /home/test15
echo "Slava" > /home/test15/secret_file
chmod a-r /home/test15
