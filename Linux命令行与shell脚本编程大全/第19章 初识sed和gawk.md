# 第19章 初识sed和gawk

```
shell脚本可以帮助我们将文本文件中各种数据的日常处理任务自动化。但仅靠shell脚本命令来处理文本文件的内容有点勉为其难。如果想在shell脚本中处理任何类型的数据，你得熟悉Linux中sed和gawk工具。这两个工具能够极大简化需要进行的数据处理任务,而并非一定使用交互式文本编辑器vim
```

---

## 文本处理

`sed`、`gawk` 是能够轻松实现自动格式化、插入、修改或删除文本元素的简单命令行编辑器

- `sed` 编辑器

  ​       `sed`编辑器可以根据命令来处理数据流中的数据，这些命令要么从命令行中输入，要么存储
  在一个命令文本文件中。`sed`编辑器会执行下列操作。

  ```
  (1) 一次从输入中读取一行数据。
  (2) 根据所提供的编辑器命令匹配数据。
  (3) 按照命令修改流中的数据。
  (4) 将新的数据输出到STDOUT。
  ```

  ​       在流编辑器将所有命令与一行数据匹配完毕后，它会读取下一行数据并重复这个过程。在流编辑器处理完流中的所有数据行后，它就会终止。

  ​       由于命令是按顺序逐行给出的，`sed` 编辑器只需对数据流进行一遍处理就可以完成编辑操作。这使得 `sed` 编辑器要比交互式编辑器快得多，你可以快速完成对数据的自动修改。

  ```shell
  sed options script file
  -e script 在处理输入时，将script中指定的命令添加到已有的命令中
  -f file 在处理输入时，将file中指定的命令添加到已有的命令中
  -n 不产生命令输出，使用print命令来完成输出
  ```

  - 在命令行定义编辑器命令

    ```shell
    $ echo "This is a test" | sed 's/test/big test/'
    This is a big test
    $
    `s`命令会用斜线间指定的第二个文本字符串来替换第一个文本字符串模式。在本例中是big test替换了test。
    
    $ cat data1.txt
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    $
    $ sed 's/dog/cat/' data1.txt
    The quick brown fox jumps over the lazy cat.
    The quick brown fox jumps over the lazy cat.
    The quick brown fox jumps over the lazy cat.
    The quick brown fox jumps over the lazy cat.
    $
    
    $ cat data1.txt
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    $
    
    所消耗的时间只够一些交互式编辑器启动。重要的是，要记住，sed编辑器并不会修改文本文件的数据。它只会将修改后的数据发送到 STDOUT
    ```

  - 在命令行使用多个编辑器命令

    ```shell
    要在sed命令行上执行多个命令时，只要用`-e`选项就可以了。
    $ sed -e 's/brown/green/;s/dog/cat/' data1.txt
    The quick green fox jumps over the lazy cat.
    The quick green fox jumps over the lazy cat.
    The quick green fox jumps over the lazy cat.
    The quick green fox jumps over the lazy cat.
    $
    两个命令都作用到文件中的每行数据上。命令之间必须用分号隔开，并且在命令末尾和分号之间不能有空格。
    -----------------------------------------------------
    $ sed -e '
    > s/brown/green/
    > s/fox/elephant/
    > s/dog/cat/' data1.txt
    The quick green elephant jumps over the lazy cat.
    The quick green elephant jumps over the lazy cat.
    The quick green elephant jumps over the lazy cat.
    The quick green elephant jumps over the lazy cat.
    $
    也可以使用bash shell中的次提示符来分隔命令，记住在封尾单引号所在行结束命令
    ```

  - 在文件中读取编辑器命令

    ```shell
    $ cat script1.sed
    s/brown/green/
    s/fox/elephant/
    s/dog/cat/
    $
    $ sed -f script1.sed data1.txt
    The quick green elephant jumps over the lazy cat.
    The quick green elephant jumps over the lazy cat.
    The quick green elephant jumps over the lazy cat.
    The quick green elephant jumps over the lazy cat.
    $
    不用分号，`sed` 编辑器知道每行都是一条单独的命令。跟在命令行输入命令一样，`sed` 编辑器会从指定文件中读取命令，并将它们应用到数据文件中的每一行上。
    
    使用`.sed`作为sed脚本文件后缀可以区分bash shell脚本文件
    ```

- `gawk` 程序

  更高级工具，提供一个类编程环境来修改和重新组织文件中的数据。默认都不安装，可以参考第9章安装。

  ```shell
  gawk 提供了一种编程语言而不只是编辑器命令，它可以完成：
   定义变量来保存数据；
   使用算术和字符串操作符来处理数据；
   使用结构化编程概念（比如if-then语句和循环）来为数据处理增加处理逻辑；
   通过提取数据文件中的数据元素，将其重新排列或格式化，生成格式化报告。
  gawk 程序的报告生成能力通常用来从大文本文件中提取数据元素，并将它们格式化成可读的报告。其中最完美的例子是格式化日志文件。
  ```

  - `gawk` 命令格式

    ```shell
    gawk options program file
    -F fs 指定行中划分数据字段的字段分隔符
    -f file 从指定的文件中读取程序
    -v var=value 定义gawk程序中的一个变量及其默认值
    -mf N 指定要处理的数据文件中的最大字段数
    -mr N 指定数据文件中的最大数据行数
    -W keyword 指定gawk的兼容模式或警告等级
    ```

    `gawk` 的强大之处在于程序脚本。可以写脚本来读取文本行的数据，然后处理并显示数据，创建任何类型的输出报告。

  - 从命令行读取程序脚本

    ```shell
    单括号 和 花引号
    gawk 命令行假定脚本是单个文本字符串，你还必须将脚本放到单引号中
    $ gawk '{print "Hello World!"}'
    
    会从 `STDIN` 接收数据，并将文本打印到 `STDOUT`
    $ gawk '{print "Hello World!"}'
    This is a test
    Hello World!
    hello
    Hello World!
    This is another test
    Hello World!
    
    跟`sed`编辑器一样，`gawk`程序会针对数据流中的每行文本执行程序脚本。由于程序脚本被设为显示一行固定的文
    本字符串，因此不管你在数据流中输入什么文本，都会得到同样的文本输出。
    
    Ctrl+D 组合键产生 EOF 字符终止程序
    ```

  - 使用数据字段变量

    ```shell
    默认情况下，gawk会将如下变量分配给它在文本行中发现的数据字段：
     $0代表整个文本行；
     $1代表文本行中的第1个数据字段；
     $2代表文本行中的第2个数据字段；
     $n代表文本行中的第n个数据字段。
    
    在文本行中，每个数据字段都是通过字段分隔符划分的。gawk在读取一行文本时，会用预定义的字段分隔符划分每个数据字段。`gawk`中默认的字段分隔符是任意的空白字符（例如空格或制表符）。
    $ cat data2.txt
    One line of test text.
    Two lines of test text.
    Three lines of test text.
    $
    $ gawk '{print $1}' data2.txt
    One
    Two
    Three
    $
    
    如果你要读取采用了其他字段分隔符的文件，可以用`-F`选项指定。
    `/etc/passwd`文件用冒号来分隔数字字段
    $ gawk -F: '{print $1}' /etc/passwd
    root
    bin
    daemon
    adm
    lp
    sync
    shutdown
    halt
    mail
    [...]
    ```

  - 在程序脚本中使用多个命令

    ```shell
    要在命令行上的程序脚本中使用多条命令，只要在命令之间放个分号即可。
    $ echo "My name is Rich" | gawk '{$4="Christine"; print $0}'
    My name is Christine
    $
    也可以用次提示符一次一行地输入程序脚本命令。
    $ gawk '{
    > $4="Christine"
    > print $0}'
    My name is Rich
    My name is Christine
    $
    ```

  - 从文件中读取多个程序

    ```shell
    跟`sed`编辑器一样，`gawk`编辑器允许将程序存储到文件中，然后再在命令行中引用。
    $ cat script2.gawk
    {print $1 "'s home directory is " $6}
    $
    $ gawk -F: -f script2.gawk /etc/passwd
    root's home directory is /root
    bin's home directory is /bin
    daemon's home directory is /sbin
    adm's home directory is /var/adm
    lp's home directory is /var/spool/lpd
    [...]
    Christine's home directory is /home/Christine
    Samantha's home directory is /home/Samantha
    Timothy's home directory is /home/Timothy
    $
    
    可以在程序文件中指定多条命令。要这么做的话，只要一条命令放一行即可，不需要用分号。
    $ cat script3.gawk
    {
    text = "'s home directory is "
    print $1 text $6
    }
    注意，`gawk`程序在引用变量值时并未像shell脚本一样使用美元符。
    $
    $ gawk -F: -f script3.gawk /etc/passwd
    root's home directory is /root
    bin's home directory is /bin
    daemon's home directory is /sbin
    adm's home directory is /var/adm
    lp's home directory is /var/spool/lpd
    [...]
    Christine's home directory is /home/Christine
    Samantha's home directory is /home/Samantha
    Timothy's home directory is /home/Timothy
    $
    ```

  - 在处理数据前运行脚本

    有时可能需要在处理数据前运行脚本，比如为报告创建标题。`BEGIN`关键字就是用来做这个的。它会强制`gawk`在读取数据前执行`BEGIN`关键字后指定的程序脚本。

    ```shell
    $ gawk 'BEGIN {print "Hello World!"}'
    Hello World!
    $
    $ cat data3.txt
    Line 1
    Line 2
    Line 3
    $
    $ gawk 'BEGIN {print "The data3 File Contents:"}
    > {print $0}' data3.txt
    The data3 File Contents:
    Line 1
    Line 2
    Line 3
    $
    ```

  - 在处理数据后运行脚本

    与`BEGIN`关键字类似，`END`关键字允许你指定一个程序脚本，`gawk`会在读完数据后执行它。

    ```shell
    $ gawk 'BEGIN {print "The data3 File Contents:"}
    > {print $0}
    > END {print "End of File"}' data3.txt
    The data3 File Contents:
    Line 1
    Line 2
    Line 3
    End of File
    $
    
    可以将所有这些内容放到一起组成一个漂亮的小程序脚本文件，用它从一个简单的数据文件中创建一份完整的报告。
    $ cat script4.gawk
    BEGIN {
    print "The latest list of users and shells"
    print " UserID \t Shell"
    print "-------- \t -------"
    FS=":"
    }
    {
    print $1 " \t " $7
    }
    END {
    print "This concludes the listing"
    }
    $
    $ gawk -f script4.gawk /etc/passwd
    The latest list of users and shells
    UserID 				Shell
    -------- 			-------
    root 				/bin/bash
    bin 				/sbin/nologin
    daemon 				/sbin/nologin
    [...]
    Christine 			/bin/bash
    mysql 				/bin/bash
    Samantha 			/bin/bash
    Timothy 			/bin/bash
    This concludes the listing
    $
    小试牛刀，更多专业范的报告输出可以参考`gawk`进阶
    ```

## `sed` 编辑器基础

- 更多的替换选项

  - 替换标记

    ```shell
    $ cat data4.txt
    This is a test of the test script.
    This is the second test of the test script.
    $
    $ sed 's/test/trial/' data4.txt
    This is a trial of the test script.
    This is the second trial of the test script.
    $
    默认只替换每行中出现的第一处
    
    要让替换命令能够替换一行中不同地方出现的文本必须使用替换标记（substitution flag）。替换标记会在替换命令字符串之后设置。
    s/pattern/replacement/flags
    有4种可用的替换标记：
     数字，表明新文本将替换第几处模式匹配的地方；
     g，表明新文本将会替换所有匹配的文本；
     p，表明原先行的内容要打印出来；
     w file，将替换的结果写到文件中。
    
    $ sed 's/test/trial/2' data4.txt
    This is a test of the trial script.
    This is the second test of the trial script.
    $
    
    $ sed 's/test/trial/g' data4.txt
    This is a trial of the trial script.
    This is the second trial of the trial script.
    $
    
    `p`替换标记会打印与替换命令中指定的模式匹配的行，通常会和`sed`的`-n`选项一起使用。
    $ cat data5.txt
    This is a test line.
    This is a different line.
    $
    $ sed -n 's/test/trial/p' data5.txt
    This is a trial line.
    $
    `-n`选项将禁止sed编辑器输出。但`p`替换标记会输出修改过的行。将二者配合使用的效果就是只输出被替换命令修改过的行。
    
    `w` 替换标记会产生同样的输出，不过会将输出保存到指定文件中。
    $ sed 's/test/trial/w test.txt' data5.txt
    This is a trial line.
    This is a different line.
    $
    $ cat test.txt
    This is a trial line.
    $
    sed 编辑器的正常输出是在STDOUT中，而只有那些包含匹配模式的行才会保存在指定的输出文件中。
    ```

  - 替换字符

    ```shell
    $ sed 's!/bin/bash!/bin/csh!' /etc/passwd
    感叹号被用作字符串分隔符,避免转义正斜线可能带来的困惑
    ```

- 使用地址

  在`sed`编辑器中使用的命令默认会作用于文本数据的所有行，要作用于特定行或某些行则需要使用行寻址。

  ```shell
  相同格式：`[address]command`
  
  也可以将特定地址的多个命令分组
  address {
      command1
      command2
      command3
  }
  ```

  - 数字方式的行寻址

    ```shell
    指定行号
    $ sed '2s/dog/cat/' data1.txt
    The quick brown fox jumps over the lazy dog
    The quick brown fox jumps over the lazy cat
    The quick brown fox jumps over the lazy dog
    The quick brown fox jumps over the lazy dog
    $
    
    行地址区间
    $ sed '2,3s/dog/cat/' data1.txt
    The quick brown fox jumps over the lazy dog
    The quick brown fox jumps over the lazy cat
    The quick brown fox jumps over the lazy cat
    The quick brown fox jumps over the lazy dog
    $
    
    从某行开始所有行
    $ sed '2,$s/dog/cat/' data1.txt
    The quick brown fox jumps over the lazy dog
    The quick brown fox jumps over the lazy cat
    The quick brown fox jumps over the lazy cat
    The quick brown fox jumps over the lazy cat
    $
    ```

  - 

- 删除行

- 插入和附加文本

- 修改行

- 转换命令

- 回顾打印

- 使用 `sed` 处理文件