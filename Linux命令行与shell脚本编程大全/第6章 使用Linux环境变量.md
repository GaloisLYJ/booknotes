# 第6章 使用Linux环境变量

---
## 环境变量

    存储有关shell会话和工作环境的信息,允许在内存中存储数据
### 全局环境变量
- `printenv` `printenv HOME` 查看全局变量
- `env`
- `echo $HOME` 这个需要带上`$`
- `ls $HOME` 能够让变量作为命令行参数
  
  
    对于shell会话和所有生成的子shell可见,系统环境变量基本都是使用全大写字母。
### 局部环境变量
- `set` 显示为某个特定进程设置的所有环境变量,包括局部变量,全局变量,以及用户定义变量


    只对创建它们的shell可见,Linux中没有只显示局部变量的命令

### 用户定义变量
 - `my_variable=Hello`
 - `my_variable='Hell o'`
 - `echo $my_variable`
   
   
    注意=左右没有空格,当值里面有空格时需要用单引号       
 - `my_variable='I am Galois'`
 - `export my_variable` 先创建局部环境变量,再用`export`将其导出到全局环境中,不需要加`$`


    修改子shell中全局环境变量并不会影响到父shell中该变量的值。甚至无法使用export命令改变父shell中全局环境变量的值。
- `unset my_variable` `echo $my_variable` 删除已经存在的环境变量

  
    和修改变量一样，在子shell中删除全局变量后，你无法将效果反映到父shell中。

### 默认的shell环境变量P112

### PATH环境变量
- `echo $PATH` 用于进行命令和程序查找的目录
- `PATH=$PATH:/home/christine/Scripts` 给PATH变量添加新的搜索目录
- `export PATH` 如果希望子shell也能生效,要记得导出修改后的PATH环境变量
- `PATH=&PATH:.` 通常将单点符`.`也加入PATH环境变量，代表当前目录


    对PATH变量的修改只能持续到退出或重启系统。

### 定位系统环境变量
- 登录shell
    - `/etc/profile`
            
        
            系统默认的bash shell主启动文件,系统上每个用户登录时都会执行。
    - `$HOME/.bash_profile`
    - $HOME/.bashrc
    - $HOME/.bash_login
    - $HOME/.profile
    
            其他启动文件提供一个用户专属的启动文件来定义该用户所用到的环境变量。大多数Linux发行版只用这四个启动文件中的一到两个。以.号开头,默认隐藏。位于HOME目录下,在每次启动bash shell会话时生效。
            
            shell会按照按照下列顺序，运行第一个被找到的文件，余下的则被忽略：
            $HOME/.bash_profile
            $HOME/.bash_login
            $HOME/.profile
            注意，这个列表中并没有$HOME/.bashrc文件。这是因为该文件通常通过其他文件运行的。
            
            $HOME表示的是某个用户的主目录。它和波浪号（~）的作用一样。
        .bash_profile启动文件会先去检查HOME目录中是不是还有一个叫.bashrc的启动文件。如果有的话，会先执行启动文件里面的命令。
    
- 交互式shell进程

        bash不是登录时启动,如运行bash命令启动,叫做交互式shell,不会像登录shell一样运行,但依然提供命令行提示符来输入命令。
    
   交互式shell`不会访问/etc/profile文件,只会检查用户HOME目录中的.bashrc文件`。
   
        .bashrc文件有两个作用：
        一是查看/etc目录下通用的bashrc文件
        二是为用户提供一个定制自己的命令别名和私有脚本函数的地方。
   
- 非交互式shell

        系统执行脚本时用的shell,没有命令行提示符。但是当你在系统上运行脚本时,也许希望能够运行一些特定启动的命令。
    bash shell提供了`BASH_ENV环境变量`,当启动一个非交互式shell即脚本shell时,会检查这个环境变量来查看要执行的启动文件。如果有指定文件,shell会执行该文件里的命令,通常就包括shell脚本变量设置。
        
        `printenv BASH_ENV` `echo $BASH_ENV` 这个环境变量默认情况未设置。返回一个空行。
    
    如果`BASH_ENV`变量没有设置,shell脚本可以通过启动一个子shell执行,而`子shell可以继承父shell导出过的变量`。
    
    举例来说，如果父shell是登录shell，在/etc/profile、/etc/profile.d/*.sh和$HOME/.bashrc文件中,设置并导出了变量，用于执行脚本的子shell就能够继承这些变量。
    
    对于那些不启动子shell的脚本，变量已经存在于当前shell中了。所以就算没有设置BASH_ENV，也可以使用当前shell的局部变量和全局变量。
    
- 环境变量持久化

        了解了各种shell进程以及对应的环境文件,就可以利用这些文件创建自己的永久性全局变量或局部变量。
    对于所有用户都需要使用的变量来说,可能更倾向于放到/etc/profile文件中,但这并非是个好主意,如果升级了发行版,这个文件会被更新。
    
    最好是`在/etc/profile.d目录中创建一个以.sh结尾的文件,把所有新的或修改过的全局环境变量设置放在这个文件中(所有用户永久性)`。在/etc/profile中有for语句迭代该目录下的文件。
    
    在大多数发行版中，`存储个人用户永久性bash shell变量的地方是$HOME/.bashrc文件(个人用户永久性)。这一点适用于所有类型的shell进程。`但如果设置了BASH_ENV变量，那么记住，除非它指向的是$HOME/.bashrc，否则你应该将非交互式shell的用户变量放在别的地方。
    
        bash shell会在启动时执行几个启动文件。这些启动文件包含了环境变量的定义，可用于为每个bash会话设置标准环境变量。每次登录Linux系统，bash shell都会访问/etc/profile启动文件以及3个针对每个用户的本地启动文件：
    `$HOME/.bash_profile、$HOME/.bash_login、$HOME/.profile` 用户可以在这些文件中定制自己想要的环境变量和启动脚本。`待测试bash生成的bash是否生效和脚本shell是否生效。
    
    ```
    1、全局不全局看该变量有没有执行export命令,全局变量在不同的shell中(父shell不能)都能获取,局部变量只能在当前定义的shell中获取。
    2、永久不永久是指该变量在重启系统之后是否持续生效,或者说重启shell窗口是否持续生效,如alias命令设置如果不是放在$HOME/.bashrc启动文件中就不是永久的。
    
    执行顺序：
    /etc/profile —> /etc/profile.d/*.sh 全部用户永久性
         |
    $HOME/.bash_profile —> 存在 —> 检查$HOME/.bashrc是否存在 —> 存在先执行$HOME/.bashrc,然后执行.bash_profile
         |     不存在                                 
    $HOME/.bash_login
         |     不存在
    $HOME/.profile 执行完任一个即终止
         
    ```
    
    Mac下  alias 个人用户持久性配置  实例
    
    ```
    # ~/study/booknotes [master ✗ (74af234)] [20:21:51]
    ➜ echo $BASH_ENV
    
    ➜ cat ~/.bashrc
    
    BASH=/Users/yons/bash
    source $BASH/common_bash
    
    ➜ cat common_bash
    #=========file=========
    alias cdp="cd /Users/yons/project"
    alias cda="cd /Users/yons/project/api"
    alias cdl="cd /Users/yons/project/lib"
    alias cds="cd /Users/yons/project/service"
    alias c="clear"
    
    #=========git==========
    alias emptycm="git commit --allow-empty -m 'rebuild';git push"
    alias syn="git fetch upstream;git checkout master;git merge upstream/master;git push;"
    #更新lib，service，api中的所有项目,同步fork的仓库代码，更新本地master分支为最新
    alias pull="cdl;./pullAllLib.sh;cds;./pullAllService.sh;cda;./pullAllApi.sh"
    #查看所有本地分支和远程分支的连接关系，以及版本信息
    alias vv="git branch -vv;"
    #查看所有远程项目地址及其别名
    alias remote="git remote -v;"
    
    ➜ cat ~/.bash_profile
    export JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_212.jdk/Contents/Home
    export JAVA_HOME=$JAVA_8_HOME
    alias jdk8='export JAVA_HOME=$JAVA_8_HOME'
    export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
    export PATH=$PATH:$JAVA_HOME/bin:.
    
    export M2_HOME=/usr/local/Cellar/maven/3.6.1/libexec
    export PATH=$PATH:$M2_HOME/bin
    
    export PYTHON_3=/Library/Frameworks/Python.framework/Versions/3.7/bin
    export PYTHON=$PYTHON_3
    export PATH=$PATH:$PYTHON
    alias python='/Library/Frameworks/Python.framework/Versions/3.7/bin/python3.7'
    
    export ADB='/Applications/Nox App Player.app/Contents/MacOS'
    export PATH=$PATH:$ADB
    
    export PATCH=$PATH:/usr/local/mysql/bin
    
    source ~/.bashrc
    
    ➜ cat /etc/profile
    # System-wide .profile for sh(1)
    
    if [ -x /usr/libexec/path_helper ]; then
    	eval `/usr/libexec/path_helper -s`
    fi
    
    if [ "${BASH-no}" != "no" ]; then
    	[ -r /etc/bashrc ] && . /etc/bashrc
    fi
    ```
    
    
### 数组变量
- `mytest=(one two three four five)`
- `echo ${mytest[2]}` 引用一个单独的数组元素
- `echo ${mytest[*]}` 显示整个数组变量
- `mytest[2]=seven` 改变某个索引位置的值
- `unset mytest[2]` `echo ${mytest[*]}` `echo ${mytest[2]}` 删除数组中的某个值,注意只是置空
- `unset mytest` 删除整个数组


    数组变量的可移植性(在不同的shell环境下)并不好,总体上不会太频繁用到

---
