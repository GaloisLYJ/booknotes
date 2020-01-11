
# 第3章 基本的bash shell命令
    

---
## bash手册
- `man -k keyword` 关键字搜索命令手册页

- `man 1 hostname` 查看hostname命令手册页中第1部分 可执行程序或shell命令 的内容

- `hostname info` man手册页不是唯一参考资料，也可以查看info页面相关内容

- `hostname -help` 查看命令的帮助信息


---


## 文件系统

- ###基本列表
    - `ls` 输出列表按字母，列排序

    - `ls -F` 目录后加/，区分文件和目录

    - `ls -a` 把.开头的文件也显示

- ###长列表
    - `ls -l` 显示更多信息

- ###过滤输出列表
    - `ls -l my_script` 简单文本匹配过滤

    - `ls -l my_scr?pt`,`ls -l my*pt` ?代表一个字符，*代表0个或多个字符，ls命令能够识别标准通配符

- ###文件操作
    - `touch file` 创建文件、变更已有文件的访问时间或修改时间

    - `mkdir dir` 创建目录

    - `cp -R Scripts/  Mod_Scripts` -R参数创建一开始不存在的Mod_Scripts，Scripts/目录下的所有文件将会复制到其中

    - `cp *script  Mod_Scripts/` 所有以script结尾的文件复制

    - `mv -i fall /home/fzll` 移动文件，重命名文件，i在覆盖文件时会得到提示确认

    - `rm -i file` 删除文件，f强制删除，r表示使得命令可以向下进入目录，删除其中文件再删除目录本身

    - `rmdir dir` 删除空目录

    - `tree dir` 查看该目录的树形结构信息，可能没有默认安装

- ###常见Linux目录名称P39

---

##链接文件
    链接是目录中指向文件真实位置的占位符
    
- ###符号链接
    符号链接就是`一个实实在在的文件`，指向存放在虚拟目录结构中某个地方的另一个文件。彼此内容并不相同，文件大小不同
    - `ln -s data_file sl_data_file` 符号链接，也叫软链接

    - `ls -li *data_file` 查看文件的inode编号，由内核分配给文件系统的唯一数字标识
- ###硬链接
    硬链接会创建`独立的虚拟文件`，其中包含了原始文件的信息及位置。但是他们从根本上是同一个文件。引用硬链接文件等同于引用了源文件。带有硬链接的文件共享inode编号。
    - `ln code_file hl_code_file` 硬链接
    
    - `ls -li *code_file` l是长列表，i是inode编号，两者可写在一起

---

##文件内容
 - `file my_file` 查看文件类型

 - 查看整个文件
    - `cat -n test1` `-n`给所有行带上行号,`-b`只给有文本的行加上行号，`-T`不让制表符出现，用^I代替

    - `more my_file` 空格键或回车键逐行向前的方式浏览文本文件，浏览完之后按`q`键退出，`more`是一个分页工具，但只支持文本文件中的基本移动

    - `less my_file` less is more，一次显示一屏文件文本，其中一组特性是能够识别上下键和上下翻页键，要看终端的配置，还支持高级搜索，可使用`man less`查看

 - 查看部分文件
    - `tail -n 2 log_file` 显示文件尾部2行的内容，默认为10行

    - `head -5 log_file` 显示文件头部5行的内容