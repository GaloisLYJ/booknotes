# 第5章 理解shell

---
## shell的类型

    取决于个人用户ID配置,在/etc/passwd记录的第7个字段
- `cat /etc/passwd` 可看到/bin/bash
- `ls -lF /bin/bash` 是一个可执行程序
- `ls -lF /bin/tcsh` `ls -lF /bin/dash` `ls -lf /bin/csh` Cshell的软链接指向tcsh,dash是ash shell的Debian版
- `ls -l /bin/sh` 默认的系统shell,常常是软链接到bash shell,但在Ubuntu中链接到的是dash shell
- `/bin/dash` `exit` 输入对应文件名启动相应shell,`exit`退出shell

---

## shell的父子关系
- `ps -f` `bash` `bash` `ps --forest` 创建3个子shell(子shell再创建),`ps --forest`查看子shell间的嵌套结构,`PPID`可看出其父子关系
  
  ```
    bash shell命令或运行shell脚本 是生成子shell的第一种方式
  ```
  
- `pwd;ls;cd/etc;pwd;cd;pwd;ls;echo $BASH_SUBSHELL` 命令列表,依次执行

- `(pwd;ls;cd/etc;pwd;cd;pwd;ls;echo $BASH_SUBSHELL)` 进程列表,生成1个子shell执行

- `echo $BASH_SUBSHELL` 返回0表明没有子shell,返回1或者更大的数字表明存在子shell

- `(pwd;(echo $BASH_SUBSHELL))` 返回2,括号中的括号可创建子shell的子shell

  ```
    	进程列表 是生成子shell的第二种方式。在shell脚本中，经常使用子shell进行多进程处理，但是使用子shell的成本不菲，会明显拖慢处理速度。在交互式的CLI shell会话中，子shell同样存在问题。它并非真正的多进程处理，因为终端控制着子shell的I/O
  ```
---

## 子shell用法
- `sleep 3000&` 在命令末尾加上`&`让其以后台模式执行,返回的第一条信息是后台作业号 第二条是后台作业的进程ID
- `ps -f` `jobs -l` 查看运行的进程,`jobs`则只列出后台模式的进程，返回作业号,状态,对应的命令,`l`可显示PID


    后台模式 是创建子shell的第三种方式

- `(sleep 2 ; echo $BASH_SUBSHELL ; sleep 2)`
- `(sleep 2 ; echo $BASH_SUBSHELL ; sleep 2)&`
  



在CLI中运用子shell的创造性方法:

- `将进程列表置入后台模式`
  
    - `(sleep 2 ; echo $BASH_SUBSHELL ; sleep 2)&`
    
    - `(tar -cf Rich.tar /home/rich ; tar -cf My.tar /home/christine)&` 使用tar创建备份文件是有效利用后台进程列表的一个更实用的例子。
      
      ```
    	注意，后台模式中表明单一级子shell的数字1显示在了提示符的旁边,只需按一个回车键可得到另一个提示符。你既可以在子shell中进行繁重的处理工作，同时也不会让子shell的I/O受制于终端。
    	```
    
- 协程
  
    - `coproc sleep 10` 创建子shell并执行命令,返回作业号和进程ID
    
    - `jobs` 可以看到执行的命令是`coproc COPROC sleep 10` `COPROC`是`coproc`命令给进程起的名字
    
    - `coproc My_Job { sleep 10; }` 扩展语法定义协程名,注意花括号和命令之间，分号和命令之间都要有空格
    
      ```
      协程可以同时做两件事。它在后台生成一个子shell，并在这个子shell中执行命令。
      ```
    
- 同时使用创建嵌套的子shell
  
    - `coproc ( sleep 10; sleep 2 )`
    
    - `jobs`
    
    - `ps --forest`
    
      ```
      生成子shell的成本不低，而且速度还慢。创建嵌套子shell更是火上浇油！
      ```
    
---

## 外部命令

```
	也叫文件系统命令，存在于bash shell之外的程序。并不是shell的一部分，通常位于/bin,/usr/bin,/sbi或/usr/sbin中,如ps。外部命令执行时会创建一个子进程,成为衍生forking,`ps -f`外部命令可以方便地显示出它的父进程以及自己对应的衍生子进程。当进程必须执行衍生操作时,需要花费时间和精力来设置新子进程的环境,所以多少还是有代价的。
```

- `which ps` `type -a ps`可以用`which`和`type -a`来找到外部命令的程序位置
- `ls -l /bin/ps`

## 内建命令
- `type cd` `type exit`

  ```
  	内建命令和外部命令的区别在于前者不需要使用子进程来执行。它们已经和shell编译成了一体，作为shell工具的组成部分存在。不需要借助外部程序文件来运行。如cd,exit等。执行速度更快效率更高。
  ```

- `type -a echo` 有些命令有不同实现，`type -a`可查看全部,而`which`只显示外部文件
  
  ```
    对于有多种实现的命令,如果想要使用其外部命令实现,直接指明对应的文件就可以,如`/bin/pwd`
  ```
  
- `history` 查看最近用过的命令列表,通常历史记录会保存近1000条

- `!!` 代表刚刚用过的那条命令

- `history -a` 在退出shell会话之前强制将命令历史记录写入用户主目录.bash_history中,`cat .bash_history`

- `alias -p` 查看当前可用的命令别名

- `alias li='ls -li'`  创建自己的命令别名'li',命令别名属于内部命令,仅在它所被定义的shell进程中有效。不过第6章有办法让其在不同的子shell中都有效。

    ```
    history和alias都是内建命令。
    ```

    
