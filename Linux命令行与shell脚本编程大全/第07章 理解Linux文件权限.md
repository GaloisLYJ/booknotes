# 第7章 理解Linux文件权限
	能够保护文件免遭非授权用户浏览或修改的机制，即允许用户根据每个文件和目录的安全性设置来访问文件。

---

## Linux的安全性
		用户对系统中各种对象的访问权限取决于他们登录系统时用的账户，每个能进入Linux系统的用户都会分配唯一的用户账户。
	用户权限通过创建用户时分配的UID来跟踪。

### `/etc/passwd`文件

​	一个专门的文件来将用户名匹配到对应的UID值，root的UID固定是0

```shell
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash

登录用户名
用户密码
用户账户的UID（数字形式）
用户账户的GID（数字形式 组ID）
用户账户的文本描述（备注）
用户HOME目录的位置
用户的默认shell
```

​	Linux系统预留了500以下的UID值，是系统账户，系统上运行的各种服务进程访问资源用的特殊账户。在安全成为问题之前，后台服务是以root账户登录的，这会导致一旦其中一个服务被非法用户攻陷，他就能以root身份进入系统。

​	密码字段都被置为`x`，早期是加密后存在这里，现在存在`/etc/shadow`中。

```
	/etc/passwd是标准的文本文件，用户管理可以直接手动进行，但是极其危险，如果文件损坏会导致所有用户无法正常登录。故应该使用标准的Linux用户管理工具去执行管理功能。
```

### `/etc/shadow`文件

​	提供对Linux系统密码管理的更多控制，只有root用户和特定的程序(如登录程序)才能访问

```shell
$ cat /etc/shadow
rich:$1$.FfcK0ns$f1UgiyHQ25wrB/hykCn020:11627:0:99999:7:::

与/etc/passwd文件中的登录名字段对应的登录名
加密后的密码
自上次修改密码后过去的天数密码（自1970年1月1日开始计算）
多少天后才能更改密码
多少天后必须更改密码
密码过期前提前多少天提醒用户更改密码
密码过期后多少天禁用用户账户
用户账户被禁用的日期（用自1970年1月1日到当天的天数表示）
预留字段给将来使用
```

### 添加新用户

 - `/usr/sbin/useradd -D` `D`查看Linux系统创建新用户时使用的默认值

   ```shell
   # /usr/sbin/useradd -D
   GROUP=100	GID为100的公共组
   HOME=/home	新用户的HOME目录将位于/home/loginname;
   INACTIVE=-1	用户密码过期后不会被禁用
   EXPIRE=	账户未设置过期日期
   SHELL=/bin/bash 将bash shell作为默认shell
   SKEL=/etc/skel 系统会将/etc/skel目录下的内容复制到用户的HOME目录下，.profile\.bashrc等
   CREATE_MAIL_SPOOL=yes 为该用户账户在mail目录下创建一个用于接收邮件的文件
   
   更多命令行参数可参考P128
   ```

- `useradd -m test` `ls -al /home/test` 默认不创建，`m`选项将会创建新用户的HOME目录，并复制/etc/skel文件

- `useradd -D -s /bin/tsch` 更改系统默认值，tsch shell作为新建用户的默认登录shell

### 删除用户


- `/usr/sbin/userdel -r test` 默认只删除/etc/passwd中的用户信息，`r`会删除用户的HOME目录和邮件目录

### 修改用户

 - `usermod` 能用来修改/etc/passwd文件中的大部分字段，跟`useradd`命令参数一样

   ```shell
   -l 修改用户账户的登录名。
   -L 锁定账户，使用户无法登录，无需删除账户和用户数据。
   -p 修改账户的密码。
   -U 解除锁定，使用户能够登录。
   ```

 - `passwd` 默认改自己的密码，只有root用户有权限改别人的密码，用`passwd -e test`，`e`强制用户下次登录时修改密码

 - `chpasswd < users.txt` 批量修改用户密码，从标准输入中读取userid:passwd（登录名:密码）冒号分割的文件列表，加密给该用户

 - `chsh` `chfn` `chage` 修改特定的账户信息

    - `chsh -s /bin/csh test` 修改test用户的默认登录shell，使用时要shell的全路径名作参数
    - `chfn test` 在/etc/passwd文件的备注字段存储指纹信息，`grep test /etc/passwd`
    - `finger test` 方便地查看Linux系统上的用户信息，但出于安全性考虑有些默认没有安装

- `chage -I test` 帮助管理用户账户的有效期P132，`I`设置密码过期到锁定账户的天数

  ```
  支持两种格式的日期：
  YYYY-MM-DD格式的日期
  代表从1970年1月1日起到该日期天数的数值
  ```

---

## 使用Linux组

```
组权限允许多个用户对系统中的对象共享一组共用的权限
```
### `/etc/group`文件

​	/etc/group文件包含系统上用到的每个组的信息

```
root:x:0:root
bin:x:1:root,bin,daemon
daemon:x:2:root,bin,daemon
sys:x:3:root,bin,adm
adm:x:4:root,adm,daemon
rich:x:500:

组名
组密码
GID
属于该组的用户列表

1、用户账户从500开始分配
2、组密码允许非组内成员通过它临时成为该组成员
3、当一个用户在/etc/passwd中指定某个组作为默认组时，用户账户不会作为该组成员再出现在/etc/group文件中
```

### 创建新组

- `/usr/sbin/groupadd shared` `tail /etc/group` 添加新组并查看
- `/usr/sbin/usermod -G shared rich` 将rich用户添加到shared组

### 修改组

- `/usr/sbin/groupmod -n sharing shared` `n`将shared组名改为sharing，`g`改组ID

---

## 理解文件权限

### 使用文件权限符

```shell
-rwxrwxr-x 1 rich rich 4882 2010-09-18 13:58 myprog
第一个字符：-代表文件 d代表目录 l代表链接 c代表字符型设备 b代表块设备 n代表网络设备
连续三组字符： 属主 属组 其他用户 的权限，r可读，w可写，x可执行

rwx：文件的属主（设为登录名rich）。
rwx：文件的属组（设为组名rich）。
r-x：系统上其他人。
```

### 默认文件权限

- `umask` 用来设置所创文件和目录的默认权限

  ```shell
  $ touch newfile
  $ ls -al newfile
  -rw-r--r-- 1 rich rich 0 Sep 20 19:16 newfile
  
  $ umask
  0022
  
  第一位是黏着位
  后面的3位表示文件或目录对应的umask八进制值
  对于文件：666 - 022 = 644 故为newfile的默认权限
  
  $ umask 026 设置默认创建的文件和目录权限(对文件和目录都生效)
  $ mkdir newdir
  $ ls -l
  drwxr-x--x 2 rich rich 4096 Sep 20 20:11 newdir/
  对于目录：777 - 022 = 751 故为newdir的默认权限
  ```

- Linux文件权限码
	
	```shell
	表7-5 Linux文件权限码
	权 限 	二进制值 	八进制值 	 描 述
	--- 	  000 		 0 			没有任何权限
	--x 	  001 		 1 			只有执行权限
	-w- 	  010 		 2 			只有写入权限
	-wx 	  011 		 3 			有写入和执行权限
	r-- 	  100 		 4 			只有读取权限
	r-x 	  101 		 5 			有读取和执行权限
	rw- 	  110 		 6 			有读取和写入权限
	rwx 	  111 		 7 			有全部权限
	
	具体的原理P137
	```

---

## 改变安全性设置

```
已经创建了一个目录或文件，需要改变它的安全性设置
```

### 改变权限
- `chmod options mode file`  mode参数可以使用八进制模式或符号模式进行安全性设置
- `chmod 760 newfile` 八进制模式设置`-rwxrw----`权限
- `chmod o+r newfile` 符号模式设置`-rwxrw----`权限 详解 p138

### 改变所属关系
- `chown options owner[.group] file` 改变文件的默认属组

- `chown dan newfile` 可用登录名或UID来指定文件的新属主

- `chown dan.shared newfile` 支持同时改变文件的属主和属组

- `chown .rich newfile` 只改变目录的默认属组

- `chown test. newfile` 如果Linux系统采用和用户登录名匹配的组名，可以只用一个条目就改变二者

  ```shell
  -R 选项配合通配符可以递归地改变子目录和文件的所属关系。
  -h 选项可以改变该文件的所有符号链接文件的所属关系
  ```
  
- `chgrp shared newfile` 更改文件或目录的默认属组

  ```
  	用户账户必须是这个文件的属主，除了能够更换属组之外，还得是新组的成员。现在shared组的任意一个成员都可以写这个文件了。这是Linux系统共享文件的一个途径。
  ```

---

## 共享文件

```
想在大范围环境中创建文档并将文档与人共享
```

Linux还为每个文件和目录存储了3个额外的信息位。

- 设置用户ID（SUID）：当文件被用户使用时，程序会以文件属主的权限运行。
- 设置组ID（SGID）：对文件来说，程序会以文件属组的权限运行；对目录来说，目录中创建的新文件会以目录的默认属组作为默认属组。
- 粘着位：进程结束后文件还驻留（粘着）在内存中。

​	启用SGID位后，你可以强制在一个共享目录下创建的新文件都属于该目录的属组，这个组也就成为了每个用户的属组。SGID可通过chmod命令设置。它会加到标准3位八进制值之前（组成4位八进制值），或者在符号模式下用符号s。

```shell
chmod SUID、SGID和粘着位的八进制值
二进制值 		 八进制值 			描 述
000 			0 				 所有位都清零
001 			1 				 粘着位置位
010 			2 				 SGID位置位
011 			3 				 SGID位和粘着位都置位
100 			4 				 SUID位置位
101 			5 				 SUID位和粘着位都置位
110 			6 				 SUID位和SGID位都置位
111 			7 				 所有位都置位
```

​	用`mkdir`命令来创建希望共享的目录。然后通过`chgrp命令将目录的默认属组改为包含所有需要共享文件的用户的组`（你必须是该组的成员）。最后，`chmod g+s`将目录的SGID位置位，以保证目录中新建文件都用shared作为默认属组。为了让这个环境能正常工作，所有组成员都需把他们的umask值设置成文件对属组成员可写。在例子中，umask改成了`002`，所以文件对属组是可写的。

```shell
$ mkdir testdir
$ ls -l
drwxrwxr-x 2 rich rich 4096 Sep 20 23:12 testdir/
$ chgrp shared testdir
$ chmod g+s testdir
$ ls -l
drwxrwsr-x 2 rich shared 4096 Sep 20 23:12 testdir/
$ umask 002
$ cd testdir
$ touch testfile
$ ls -l
total 0
-rw-rw-r-- 1 rich shared 0 Sep 20 23:13 testfile
$
组成员就能到共享目录下创建新文件了。跟期望的一样，新文件会沿用目录的属组，而不是用户的默认属组。
```

