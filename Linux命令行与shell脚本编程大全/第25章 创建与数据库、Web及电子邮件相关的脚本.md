# 第25章 创建与数据库、Web及电子邮件相关的脚本

```
编写数据库shell的脚本
在脚本中使用互联网
在脚本中发送电子邮件
```

------

## MySQL 数据库

		shell脚本的问题之一是持久性数据。你可以将所有信息都保存shell脚本变量中，但脚本运行结束后，这些变量就不存在了。有时你会希望脚本能够将数据保存下来以备后用。将shell脚本和有专业水准的开源数据库对接起来非常容易。

  - 连接到服务器

    ```shell
    $ mysql -u root –p
    Enter password:
    Welcome to the MySQL monitor. Commands end with ; or \g. Your MySQL connection id is 42
    Server version: 5.5.38-0ubuntu0.14.04.1 (Ubuntu)
    
    Copyright (c) 2000, 2014, Oracle and/or its 
    affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its affiliates. Other names may be trademarks of their respective owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement. 
    mysql>
    ```

  - `mysql` 命令

    ```shell
     特殊的mysql命令 
    	mysql程序使用它自有的一组命令，方便你控制环境和提取关于MySQL服务器的信息。这些命令要么是全名(例如status)，要么是简写形式(例如\s)。
    	
     标准SQL语句
    	创建数据库
    	创建用户账户
    	创建数据表
    	插入和删除数据
    	查询数据
    ```

    - 在脚本中使用数据库

      - 登录到服务器

        ```shell
        如果你为自己的shell脚本在MySQL中创建了一个特定的用户账户，那你需要使用mysql命 令，以该用户的身份登录。
        
        mysql mytest -u test –p test
        这并不是一个好做法。所有能够访问你脚本的人都会知道数据库的用户账户和密码。
        
        可以借助mysql程序所使用的一个特殊配置文件。mysql程序使用 $HOME/.my.cnf文件来读取特定的启动命令和设置。其中一项设置就是用户启动的mysql会话的默认密码。
        $ cat .my.cnf [client]
        password = test
        $ chmod 400 .my.cnf $
        
        使用chmod命令将.my.cnf文件限制为只能由本人浏览
        $ mysql mytest -u test
        Reading table information for completion of table and column names You can turn off this feature to get a quicker startup with -A
        
        Welcome to the MySQL monitor. Commands end with ; or \g. Your MySQL connection id is 44
        Server version: 5.5.38-0ubuntu0.14.04.1 (Ubuntu)
        
        Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
        
        Oracle is a registered trademark of Oracle Corporation and/or its affiliates. Other names may be trademarks of their respective owners.
        
        Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
        
        mysql>
        这样就不用在shell脚本中将密码写在命令行上了。
        ```

      - 向服务器发送命令

        ```shell
        发送单条命令
        $ cat mtest1
        #!/bin/bash
        # send a command to the MySQL server
        MYSQL=$(which mysql)
        $MYSQL mytest -u test -e 'select * from employees' 
        $ ./mtest1 
        +-------+----------+------------+---------+
        | empid | lastname | firstname | salary | 
        +-------+----------+------------+---------+
        | 1 		| Blum 		| Rich 				| 25000 | 
        | 2 		| Blum 		| Barbara 		| 45000 | 
        | 3 		| Blum 		| Katie Jane 	| 34500 | 
        | 4 		| Blum  	| Jesssica		| 52340 | 
        +-------+----------+------------+---------+ 
        $
        数据库服务器会将SQL命令的结果返回给shell脚本，脚本会将它们显示在STDOUT中。
        
        发送多条命令
        $ cat mtest2
        #!/bin/bash
        # sending multiple commands to MySQL
        
        MYSQL=$(which mysql)
        $MYSQL mytest -u test <<EOF
        show tables;
        select * from employees where salary > 40000; 
        EOF
        $ ./mtest2
        Tables_in_test
        employees
        empid 	lastname 	firstname 	salary
        2 			Blum 			Barbara 		45000
        4 			Blum 			Jessica 		52340
        $
        shell会将EOF分隔符之间的所有内容都重定向给mysql命令。mysql命令会执行这些命令行， 就像你在提示符下亲自输入的一样。用了这种方法，你可以根据需要向MySQL服务器发送任意 多条命令。但你会注意到，每条命令的输出之间没有没有任何分隔。
        
        当然不是只能从数据表提取数据，可以任何类型，比如INSERT
        $ cat mtest3
        #!/bin/bash
        # send data to the table in the MySQL database
        
        MYSQL=$(which mysql)
        
        if [ $# -ne 4 ] 
        then
        	echo "Usage: mtest3 empid lastname firstname salary" 
        else
        	statement="INSERT INTO employees VALUES ($1, '$2', '$3', $4)" 
        	$MYSQL mytest -u test << EOF
        	$statement
        EOF
        	if [ $? -eq 0 ] 
        	then
        		echo Data successfully added 
        	else
        		echo Problem adding data 
        	fi
        fi
        $ ./mtest3
        Usage: mtest3 empid lastname firstname salary
        $ ./mtest3 5 Blum Jasper 100000
        Data added successfully
        $
        $ ./mtest3 5 Blum Jasper 100000
        ERROR 1062 (23000) at line 1: Duplicate entry '5' for key 1 
        Problem adding data
        $
        ```

      - 格式化数据

        ```shell
        mysql命令的标准输出并不太适合提取数据。如果要对提取到的数据进行处理，你需要做一些特别的操作。
        $ cat mtest4
        #!/bin/bash
        # redirecting SQL output to a variable
        
        MYSQL=$(which mysql)
        
        dbs=$($MYSQL mytest -u test -Bse 'show databases') for db in $dbs
        do
        	echo $db
        done
        
        $ ./mtest4
        information_schema
        test
        $
        这个例子在mysql程序的命令行上用了两个额外参数。-B选项指定mysql程序工作在批处理模式运行，-s(silent)选项用于禁止输出列标题和格式化符号。通过将mysql命令的输出重定向到一个变量，此例可以逐步输出每条返回记录里的每个值。
        ```

        ```xml
        $ mysql mytest -u test -X -e 'select * from employees where empid = 1'
        mysql程序还支持另外一种叫作可扩展标记语言xml，对于mysql程序，可以用-X命令行选项来输出。
        
        <?xml version="1.0"?>
        
        <resultset statement="select * from employees"> 
        <row>
        	<field name="empid">1</field> 
          <field name="lastname">Blum</field> 
          <field name="firstname">Rich</field> 
          <field name="salary">25000</field>
        </row> 
        </resultset> $
        
        通过使用XML，你能够轻松标识出每条记录以及记录中的各个字段值。然后你就可以使用标准的Linux字符串处理功能来提取需要的数据。
        ```

## 使用Web

	- 安装 `Lynx`
	- `Lynx` 配置文件
	- 从 `Lynx` 中获取数据

```shell
$ cat weather
#!/bin/bash
# extract the current weather for Chicago, IL

URL="http://weather.yahoo.com/united-states/illinois/chicago-2379574/" 
LYNX=$(which lynx)
TMPFILE=$(mktemp tmpXXXXXX)
$LYNX -dump $URL > $TMPFILE
conditions=$(cat $TMPFILE | sed -n -f sedcond)
temp=$(cat $TMPFILE | sed -n -f sedtemp | awk '{print $4}') 
rm -f $TMPFILE
echo "Current conditions: $conditions"
echo The current temp outside is: $temp 

$ ./weather
Current conditions: Mostly Cloudy
The current temp outside is: 32 °F
$
天气脚本会连接到指定城市的Yahoo!天气页面，将Web页面保存到一个文件中，提取对应的文本，删除临时文件，然后显示天气信息。

注意，互联网无时无刻不在变化，如果Web页面数据的精确位置发生了变化，脚本也就没法工作了。
重要的是知道从Web页面提取数据的过程。这样可以将原理运动到任何情形中。
```

## 使用电子邮件

```shell
	用来从shell脚本中发送电子邮件的主要工具是Mailx程序。不仅可以用它交互地读取和发送消息，还可以用命令行参数指定如何发送消息。
	
	mail [-eIinv] [-a header] [-b addr] [-c addr] [-s subj] to-addr
	
-a 指定额外的SMTP头部行
-b 给消息增加一个BCC:收件人
-c 给消息增加一个CC:收件人
-e 如果消息为空，不要发送消息
-i 忽略TTY中断信号
-I 强制Mailx以交互模式运行
-n 不要读取/etc/mail.rc启动文件
-s 指定一个主题行
-v 在终端上显示投递细节

你完全可以使用命令行参数来创建整个电子邮件消息。唯一需要添加的就是消息正文。
$ echo "This is a test message" | mailx -s "Test message" rich
在命令行上创建和发送电子邮件消息。


$ cat factmail
#!/bin/bash
# mailing the answer to a factorial

MAIL=$(which mailx)

factorial=1
counter=1

read -p "Enter the number: " value
while [ $counter -le $value ]
do
	factorial=$[$factorial * $counter]
	counter=$[$counter + 1]
done

echo The factorial of $value is $factorial | $MAIL -s "Factorial
answer" $USER
echo "The result has been mailed to you."

不会假定Mailx程序位于标准位置。它使用which命令来确定mail程序在哪里。在计算出阶乘函数的结果后，shell脚本使用mail命令将这个消息发送到用户自定义的$USER 环境变量，这应该是运行这个脚本的人。

$ ./factmail
Enter the number: 5
The result has been mailed to you.
$

$ mail
"/var/mail/rich": 1 message 1 new
>N 1 Rich Blum Mon Sep 1 10:32 13/586 Factorial answer
?
Return-Path: <rich@rich-Parallels-Virtual-Platform>
X-Original-To: rich@rich-Parallels-Virtual-Platform
Delivered-To: rich@rich-Parallels-Virtual-Platform
Received: by rich-Parallels-Virtual-Platform (Postfix, from userid 1000)
	id B4A2A260081; Mon, 1 Sep 2014 10:32:24 -0500 (EST) 
Subject: Factorial answer
To: <rich@rich-Parallels-Virtual-Platform>
X-Mailer: mail (GNU Mailutils 2.1)
Message-Id: <20101209153224.B4A2A260081@rich-Parallels-Virtual-Platform> 
Date: Mon, 1 Sep 2014 10:32:24 -0500 (EST)
From: rich@rich-Parallels-Virtual-Platform (Rich Blum)

The factorial of 5 is 120 
?

在消息正文中只发送一行文本有时会不方便。通常，你需要将整个输出作为电子邮件消息发送。这种情况总是可以将文本重定向到临时文件中，然后用`cat`命令将输出重定向给mail程序。

$ cat diskmail
#!/bin/bash
# sending the current disk statistics in an e-mail message

date=$(date +%m/%d/%Y)
MAIL=$(which mailx)
TEMP=$(mktemp tmp.XXXXXX)

df -k > $TEMP
cat $TEMP | $MAIL -s "Disk stats for $date" $1
rm -f $TEMP

diskmail程序用date命令(采用了特殊格式)得到了当前日期，找到Mailx程序的位置后创建了一个临时文件。接着用df命令显示了当前磁盘空间的统计信息(参见第4章)，并将输出重定向到了那个临时文件。

$ ./diskmail rich
$ mail
"/var/mail/rich": 1 message 1 new
>N 1 Rich Blum Mon Sep 1 10:35 19/1020 Disk stats for 09/01/2014 
?
Return-Path: <rich@rich-Parallels-Virtual-Platform>
X-Original-To: rich@rich-Parallels-Virtual-Platform
Delivered-To: rich@rich-Parallels-Virtual-Platform
Received: by rich-Parallels-Virtual-Platform (Postfix, from userid 1000)
        id 3671B260081; Mon,  1 Sep 2014 10:35:39 -0500 (EST)
Subject: Disk stats for 09/01/2014

To: <rich@rich-Parallels-Virtual-Platform>
X-Mailer: mail (GNU Mailutils 2.1)
Message-Id: <20101209153539.3671B260081@rich-Parallels-Virtual-Platform> 
Date: Mon, 1 Sep 2014 10:35:39 -0500 (EST)
From: rich@rich-Parallels-Virtual-Platform (Rich Blum)

Filesystem          1K-blocks			Used	  		Available 		Use% 				Mounted on
/dev/sda1           63315876			2595552			57504044			5%					/
none								507052				228					506824				1%					/dev
none								512648				192					512456				1%					/dev/shm
none								512648				100					512548				1%					/var/run
none								512648				0						512648				0%					/var/lock
none								4294967296		0						4294967296		0%					/media/psf

现在你要做的是用cron功能安排每天运行该脚本，这样就可以将磁盘空间报告自动发送到你的收件箱了。
```



