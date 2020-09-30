#!bin/bash

# 1
cd $HOME
mkdir test 2>>/dev/null

# 2, 3
numberOfDirectories=0
numberOfHiddenFiles=0

for str in $(ls -a /etc)
do
	if [[ -d /etc/$str ]]; then
		echo "$str is directory"
		let numberOfDirectories=$numberOfDirectories+1
		
	elif [[ -f /etc/$str ]]; then
		echo "$str is file"
		if [[ $str = .* ]]; then
			let numberOfHiddenFiles=$numberOfHiddenFiles+1
		fi
	else
		echo "Nothing"
	fi
done > $HOME/test/list

# 3
echo $numberOfDirectories >> $HOME/test/list
echo $numberOfHiddenFiles >> $HOME/test/list

# 4
mkdir $HOME/test/links 2>>/dev/null

#5
ln $HOME/test/list $HOME/test/links/list_hlink 2>>/dev/null

#6
ln -s $HOME/test/list $HOME/test/links/list_slink 2>>/dev/null

#7
# ls -l <file> prints detailed info about file, awk takes the second word and prints it
# result: 2 2 1
echo "#7"
echo "Number of hard links to list_hlink"
ls -l $HOME/test/links/list_hlink | awk '{ print $2 }'
echo "Number of hard links to list"
ls -l $HOME/test/list | awk '{ print $2 }'
echo "Number of hard links to list_slink"
ls -l $HOME/test/links/list_slink | awk '{ print $2 }'

#8
wc $HOME/test/list | awk '{ print $1 }' >> $HOME/test/links/list_hlink

#9
# slink contains pointer to the original file, while hlink is the original file itself
echo "#9"
cmp -s $HOME/test/links/list_hlink $HOME/test/links/list_slink && echo YES

#10
mv $HOME/test/list $HOME/test/list1

#11
echo "#11"
cmp -s $HOME/test/links/list_hlink $HOME/test/links/list_slink && echo YES

#12
ln $HOME/test/links/list_hlink $HOME/list1 2>>/dev/null

#13
find /etc -type f -name *.conf > $HOME/list_conf 2>>/dev/null

#14
find /etc -type d -name *.d > $HOME/list_d 2>>/dev/null

#15
cat $HOME/list_conf > $HOME/list_conf_d
cat $HOME/list_d >> $HOME/list_conf_d

#16
cd $HOME/test
mkdir .sub 2>>/dev/null

#17
cp $HOME/list_conf_d $HOME/test/.sub

#18
cp -b $HOME/list_conf_d $HOME/test/.sub

#19
echo "#19"
ls -aR $HOME/test

#20
man man > $HOME/man.txt

#21
cd $HOME
mkdir man_parts 2>>/dev/null
cd man_parts
split -b 1k ../man.txt

#22
mkdir $HOME/man.dir 2>>/dev/null

#23
mv $HOME/man_parts/x* $HOME/man.dir

#24
cat $HOME/man.dir/x?? > $HOME/man.dir/man.txt

#25
echo "#25"
cmp -s $HOME/man.txt $HOME/man.dir/man.txt && echo YES

#26
sed -i '1s/^/Hello World! /' $HOME/man.txt
echo "Goodbye!" >> $HOME/man.txt

#27
diff -u $HOME/man.txt $HOME/man.dir/man.txt > $HOME/man_difference

#28
mv $HOME/man_difference $HOME/man.dir

#29
echo "#29"
patch $HOME/man.dir/man.txt < $HOME/man.dir/man_difference

#30
echo "#30"
cmp -s $HOME/man.txt $HOME/man.dir/man.txt && echo YES
