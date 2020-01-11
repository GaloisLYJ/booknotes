
#第3章 基本的bash shell命令
    

---
##bash手册
- `man -k keyword` 关键字搜索命令手册页

- `man 1 hostname` 查看hostname命令手册页中第1部分 可执行程序或shell命令 的内容

- `hostname info` man手册页不是唯一参考资料，也可以查看info页面相关内容

- `hostname -help` 查看命令的帮助信息


---


##文件系统

- ###基本列表
    - `ls` 输出列表按字母，列排序

    - `ls -F` 目录后加/，区分文件和目录

    - `ls -a` 把.开头的文件也显示

- ###长列表
    - `ls -l` 显示更多信息

- ###过滤输出列表
    - `ls -l my_script` 简单文本匹配过滤

    - `ls -l my_scr?pt`,`ls -l my*pt`?代表一个字符，*代表0个或多个字符，ls命令能够识别标准通配符

- ###文件操作
    - `touch file` 创建文件

    - `mkdir dir` 创建目录

    - `cp -R Scripts/  Mod_Scripts` -R参数创建一开始不存在的Mod_Scripts，Scripts/目录下的所有文件将会复制到其中

    - `cp *script  Mod_Scripts/` 所有以script结尾的文件复制
- ###常见Linux目录名称P39

---

##链接文件
    
- ###符号链接

---