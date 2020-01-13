# 第4章 更多的bash shell命令
    

---
## 进程管理
- `ps -ef` `e`表示显示所有进程，`f`表示更多信息
- `top` 跟`ps`类似，但实时显示


    ps是实时监测的，只能显示某个特定时间点的信息，不能观察频繁换进换出的内存进程趋势。
- `kill -9 pid` 只能用进程的pid传递信号，`9`表示无条件终止，P72
- `killall http*` 支持通过进程名而不是pid来结束进程，也支持通配符
    
    
    ps因为历史原因有三种风格的输入：
    Unix风格的参数，-
    BSD风格的参数，不加
    GNU风格的参数，--   
    
---

## 磁盘空间
- `mount` 输出当前系统上挂载的设备列表，提供 媒体的设备文件名、虚拟目录挂载点、文件系统类型、已挂载媒体的访问状态 四部分信息
- `mount -t type device directory`,`mount vfat /dev/sdb1 /media/disk` 手动挂载媒体设备


    vfat：Windows长文件系统
    ntfs：WindowsNT、XP、Vista以及Windows7中广泛使用的高级文件系统
    iso9660：标准CD-ROM文件系统
    需要root，其他高级功能可参看P75
- `umount [directory | device]` 移除一个可移动设备时应该先卸载，`umount`支持通过设备文件或是挂载点来指定卸载设备
- `lsof /path/to/device/node` 卸载设备时提示繁忙可用`lsof`获得使用它的进仓信息，在应用中停止使用或停止该进程
- `df -h` 查看磁盘空间，`h`以用户易读的方式
- `du -chs` 查看特定目录的磁盘使用情况，判断是否有超大文件，`c`显示列出文件总的大小，`h`用户可读，`s`显示每个输出参数的总计

---

## 处理数据
- `sort -n file` 默认语言对文本文件数据行排序并`cat`，`n`把数字识别成数字而非字符，`M`按月排序含有时间戳日期的文件如日志
- `grep [options] pattern file` 查找匹配指定模式字符的行，`n`行号,`v`反向搜索,`pattern`支持正则表达式，文本搜索神器
- `tar -cvf test.tar test/ test2/` `c`,c创建一个名为test.tar的归档文件,含有test和test2目录内容,`v`在处理文件时显示文件,`f`输出结果到文件或设备file
- `tar -tf test.tar` `t`列出已有tar文件,列出文件内容但不提取文件
- `tar -xvf test.tar /mytest/` 解压,`x`提取,`v`处理文件时显示文件,`f`输出结果到文件或设备file
- `bzip2` `gzip` `zip` 其他Linux文件压缩工具