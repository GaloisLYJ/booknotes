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

  - 使用文本模式过滤器

    `sed` 编辑器允许指定文本模式来过滤出命令要作用的行

    ```shell
    /pattern/command
    
    只修改用户Samantha的默认shell，可以使用`sed`命令
    $ grep Samantha /etc/passwd
    Samantha:x:502:502::/home/Samantha:/bin/bash
    $
    $ sed '/Samantha/s/bash/csh/' /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/bin:/sbin/nologin
    [...]
    Christine:x:501:501:Christine B:/home/Christine:/bin/bash
    Samantha:x:502:502::/home/Samantha:/bin/csh
    Timothy:x:503:503::/home/Timothy:/bin/bash
    $
    ```

  - 命令组合

    ```shell
    在单行上执行多条命令，可以用花括号将多条命令组合在一起
    $ sed '2{
    > s/fox/elephant/
    > s/dog/cat/
    > }' data1.txt
    The quick brown fox jumps over the lazy dog.
    The quick brown elephant jumps over the lazy cat.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    $
    两条命令都会作用到该地址上。当然，也可以在一组命令前指定一个地址区间。
    $ sed '3,${
    > s/brown/green/
    > s/lazy/active/
    > }' data1.txt
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick green fox jumps over the active dog.
    The quick green fox jumps over the active dog.
    $
    sed 编辑器会将所有命令作用到该地址区间内的所有行上。
    ```

- 删除行

  ```shell
  如果没有加入寻址模式，流中所有的文本行都会被删除
  $ cat data1.txt
  The quick brown fox jumps over the lazy dog
  The quick brown fox jumps over the lazy dog
  The quick brown fox jumps over the lazy dog
  The quick brown fox jumps over the lazy dog
  $
  $ sed 'd' data1.txt
  $
  
  通过行号指定
  $ cat data6.txt
  This is line number 1.
  This is line number 2.
  This is line number 3.
  This is line number 4.
  $
  $ sed '3d' data6.txt
  This is line number 1.
  This is line number 2.
  This is line number 4.
  $
  
  通过行区间指定
  $ sed '2,3d' data6.txt
  This is line number 1.
  This is line number 4.
  $
  
  通过特殊的文件结尾字符
  $ sed '3,$d' data6.txt
  This is line number 1.
  This is line number 2.
  $
  
  也可以模式匹配，`sed` 编辑器会删掉包含匹配指定模式的行。
  $ sed '/number 1/d' data6.txt
  This is line number 2.
  This is line number 3.
  This is line number 4.
  $
  
  也可以使用两个文本模式来删除某个区间内的行
  sed 编辑器会删除两个指定行之间的所有行（包括指定的行）。
  $ sed '/1/,/3/d' data6.txt
  This is line number 4.
  $
  ```

- 插入和附加文本

  ```shell
   插入（insert）命令（i）会在指定行前增加一个新行；
   附加（append）命令（a）会在指定行后增加一个新行。
  
  它们不能在单个命令行上使用,必须指定是要将行插入还是附加到另一行
  sed '[address]command\
  
  $ echo "Test Line 2" | sed 'i\Test Line 1'
  Test Line 1
  Test Line 2
  $
  当使用附加命令时，文本会出现在数据流文本的后面。
  $ echo "Test Line 2" | sed 'a\Test Line 1'
  Test Line 2
  Test Line 1
  $
  
  将一个新行插入到数据流第三行前。
  $ sed '3i\
  > This is an inserted line.' data6.txt
  This is line number 1.
  This is line number 2.
  This is an inserted line.
  This is line number 3.
  This is line number 4.
  $
  将一个新行附加到数据流中第三行后。
  $ sed '3a\
  > This is an appended line.' data6.txt
  This is line number 1.
  This is line number 2.
  This is line number 3.
  This is an appended line.
  This is line number 4.
  $
  
  将新行附加到数据流的末尾，只要用代表数据最后一行的美元符就可以了。
  $ sed '$a\
  > This is a new line of text.' data6.txt
  This is line number 1.
  This is line number 2.
  This is line number 3.
  This is line number 4.
  This is a new line of text.
  $
  
  要插入或附加多行文本，就必须对要插入或附加的新文本中的每一行使用反斜线，直到最后一行。
  $ sed '1i\
  > This is one line of new text.\
  > This is another line of new text.' data6.txt
  This is one line of new text.
  This is another line of new text.
  This is line number 1.
  This is line number 2.
  This is line number 3.
  This is line number 4.
  $
  ```

- 修改行

  ```shell
  在`sed`命令中单独指定新行。
  $ sed '3c\
  > This is a changed line of text.' data6.txt
  This is line number 1.
  This is line number 2.
  This is a changed line of text.
  This is line number 4.
  $
  
  也可以用文本模式来寻址。
  $ sed '/number 3/c\
  > This is a changed line of text.' data6.txt
  This is line number 1.
  This is line number 2.
  This is a changed line of text.
  This is line number 4.
  $
  
  会修改它匹配的数据流中的任意文本行。
  $ cat data8.txt
  This is line number 1.
  This is line number 2.
  This is line number 3.
  This is line number 4.
  This is line number 1 again.
  This is yet another line.
  This is the last line in the file.
  $
  $ sed '/number 1/c\
  > This is a changed line of text.' data8.txt
  This is a changed line of text.
  This is line number 2.
  This is line number 3.
  This is line number 4.
  This is a changed line of text.
  This is yet another line.
  This is the last line in the file.
  $
  
  使用地址区间
  $ sed '2,3c\
  > This is a new line of text.' data6.txt
  This is line number 1.
  This is a new line of text.
  This is line number 4.
  $
  sed编辑器会用这一行文本来替换数据流中的两行文本，而不是逐一修改这两行文本。
  ```

- 转换命令

  转换（transform）命令（y）是唯一可以处理单个字符的sed编辑器命令

  ```shell
  [address]y/inchars/outchars/
  
  inchars模式中指定字符的每个实例都会被替换成outchars模式中相同位置的那个字符。
  $ sed 'y/123/789/' data8.txt
  This is line number 7.
  This is line number 8.
  This is line number 9.
  This is line number 4.
  This is line number 7 again.
  This is yet another line.
  This is the last line in the file.
  $
  
  转换命令是一个全局命令，也就是说，它会文本行中找到的所有指定字符自动进行转换，而不会考虑它们出现的位置。
  $ echo "This 1 is a test of 1 try." | sed 'y/123/456/'
  This 4 is a test of 4 try.
  $
  sed 编辑器转换了在文本行中匹配到的字符1的两个实例。你无法限定只转换在特定地方出现的字符。
  ```

- 回顾打印

  ```shell
  有3个命令可以用于打印数据流中的信息
   p命令用来打印文本行；
   等号（=）命令用来打印行号；
   l（小写的L）命令用来列出行。
  ```

  - 打印行

    ```shell
    $ echo "this is a test" | sed 'p'
    this is a test
    this is a test
    $
    
    常见用法：打印包含匹配文本模式的行。
    $ cat data6.txt
    This is line number 1.
    This is line number 2.
    This is line number 3.
    This is line number 4.
    $
    $ sed -n '/number 3/p' data6.txt
    This is line number 3.
    $
    
    -n 选项，可以禁止输出其他行，只打印包含匹配文本模式的行。也可以用它来快速打印数据流中的某些行。
    $ sed -n '2,3p' data6.txt
    This is line number 2.
    This is line number 3.
    $
    ```

  - 打印行号

    ```shell
    等号命令会打印行在数据流中的当前行号。行号由数据流中的换行符决定
    $ cat data1.txt
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    The quick brown fox jumps over the lazy dog.
    $
    $ sed '=' data1.txt
    1
    The quick brown fox jumps over the lazy dog.
    2
    The quick brown fox jumps over the lazy dog.
    3
    The quick brown fox jumps over the lazy dog.
    4
    The quick brown fox jumps over the lazy dog.
    $
    
    在数据流中查找特定文本模式的行号
    $ sed -n '/number 4/{
    > =
    > p
    > }' data6.txt
    4
    This is line number 4.
    $
    -n 选项，你就能让`sed`编辑器只显示包含匹配文本模式的行的行号和文本。
    ```

  - 列出行

    列出（list）命令（l）可以打印数据流中的文本和不可打印的ASCII字符。任何不可打印字符要么在其八进制值前加一个反斜线，要么使用标准C风格的命名法（用于常见的不可打印字符），比如\t，来代表制表符。

    ```shell
    制表符的位置使用\t来显示。行尾的美元符表示换行符
    $ cat data9.txt
    This line contains tabs.
    $
    $ sed -n 'l' data9.txt
    This\tline\tcontains\ttabs.$
    $
    
    data10.txt文本文件包含了一个转义控制码来产生铃声。当用cat命令来显示文本文件时，你看不到转义控制码，只能听到声音（如果你的音箱打开的话）。但是，利用列出命令，你就能显示出所使用的转义控制码。
    $ cat data10.txt
    This line contains an escape character.
    $
    $ sed -n 'l' data10.txt
    This line contains an escape character. \a$
    $
    ```

- 使用 `sed` 处理文件

  - 写入文件

    filename 可以使用相对路径或绝对路径，但不管是哪种，运行sed编辑器的用户都必须有文件的写权限。地址可以是sed中支持的任意类型的寻址方式，例如单个行号、文本模式、行区间或文本模式。

    ```shell
    [address]w filename
    
    将数据流中的前两行打印到一个文本文件中。
    $ sed '1,2w test.txt' data6.txt
    This is line number 1.
    This is line number 2.
    This is line number 3.
    This is line number 4.
    $
    $ cat test.txt
    This is line number 1.
    This is line number 2.
    $
    
    要根据一些公用的文本值从主文件中创建一份数据文件
    $ cat data11.txt
    Blum, R Browncoat
    McGuiness, A Alliance
    Bresnahan, C Browncoat
    Harken, C Alliance
    $
    $ sed -n '/Browncoat/w Browncoats.txt' data11.txt
    $
    $ cat Browncoats.txt
    Blum, R Browncoat
    Bresnahan, C Browncoat
    $
    sed编辑器会只将包含文本模式的数据行写入目标文件。
    ```

  - 从文件读取数据

    读取（read）命令（r）允许你将一个独立文件中的数据插入到数据流中。

    ```shell
    [address]r filename
    
    在读取命令中使用地址区间，只能指定单独一个行号或文本模式地址。sed编辑器会将文件中的文本插入到指定地址后。
    $ cat data12.txt
    This is an added line.
    This is the second added line.
    $
    $ sed '3r data12.txt' data6.txt
    This is line number 1.
    This is line number 2.
    This is line number 3.
    This is an added line.
    This is the second added line.
    This is line number 4.
    $
    
    sed 编辑器会将数据文件中的所有文本行都插入到数据流中。同样的方法在使用文本模式地址时也适用。
    $ sed '/number 2/r data12.txt' data6.txt
    This is line number 1.
    This is line number 2.
    This is an added line.
    This is the second added line.
    This is line number 3.
    This is line number 4.
    $
    
    要在数据流的末尾添加文本，只需用美元符地址符
    $ sed '$r data12.txt' data6.txt
    This is line number 1.
    This is line number 2.
    This is line number 3.
    This is line number 4.
    This is an added line.
    This is the second added line.
    $
    
    读取命令的另一个很酷的用法是和删除命令配合使用：利用另一个文件中的数据来替换文件中的占位文本。
    $ cat notice.std
    Would the following people:
    LIST
    please report to the ship's captain.
    $
    
    $ sed '/LIST/{
    > r data11.txt
    > d
    > }' notice.std
    Would the following people:
    Blum, R Browncoat
    McGuiness, A Alliance
    Bresnahan, C Browncoat
    Harken, C Alliance
    please report to the ship's captain.
    $
    现在占位文本已经被替换成了数据文件中的名单。
    ```

    

    