#!/bin/sh
if [ -s /etc/my.cnf ];then
rm -rf /etc/my.cnf
fi

echo "----------------------------------start install mysql -----------------------------"
yum install -y ncurses gcc gcc-c++ ncurses ncurses-devel openssl openssl-devel libtool* cmake
mkdir -p /data/mysql
if [ 'grep "mysql" /etc/passwd | wc -l' ]; then
echo "adding user mysql"
groupadd mysql
useradd -s /sbin/nologin -M -g mysql mysql
else
echo "mysql user exists"
fi

echo "-------------------------------downloading mysql----------------------------------"
wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.46.tar.gz

echo "------------------------------unpackaging mysql -----------------------------------"
tar -xvf mysql-5.5.46.tar.gz 
cd mysql-5.5.46

echo "-------------------------configuring mysql,please wait-----------------"
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/var/mysql/data \
-DMYSQL_USER=mysql

if [ $? -ne 0 ];then
echo "configure failed ,please check it out!"
exit 1
fi

echo "make mysql, please wait for 20 minutes"
make
if [ $? -ne 0 ];then
echo "make failed ,please check it out!"
exit 1
fi

make install

chown -R mysql:mysql /usr/local/mysql
chown -R mysql.mysql /data/mysql/

/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql
#chown -R mysql /usr/local/mysql/var
chgrp -R mysql /usr/local/mysql/

cp -f ./support-files/my-large.cnf /etc/my.cnf 
sed -i 's#^thread_concurrency = 8#& \ndatadir = /data/mysql#g' /etc/my.cnf
cp ./support-files/mysql.server /etc/rc.d/init.d/mysql
chmod 755 /etc/init.d/mysql

#chkconfig --add mysqld
#chkconfig --level 2345 mysqld on
ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe

echo "mysql starting"
/usr/local/mysql/bin/mysqld --user=mysql
if [ $? -ne 0 ];then
echo "mysql start filed ,please check it out!"
else
echo "mysql start successful,congratulations!"
fi
