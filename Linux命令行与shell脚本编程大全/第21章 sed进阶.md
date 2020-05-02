# 第21章 sed进阶

```
还有一些文本编辑的高级特性可能在需要的时候用到
```

------

## 多行命令

​		有时需要对跨多行的数据执行特定操作。有三个命令。

```
 N:将数据流中的下一行加进来创建一个多行组(multiline group)来处理。
 D:删除多行组中的一行。
 P:打印多行组中的一行。
```

  - `next` 命令

      - 单行的`next`命令

        ```shell
        需要删除首行之后的空白行，留下最后一行之前的空白行。
        $ cat data1.txt
        This is the header line.
        
        This is a data line.
        
        This is the last line.
        $
        $ sed '/^$/d' data1.txt 
        This is the header line. 
        This is a data line. 
        This is the last line.
        $
        
        由于要删除的行是空行，没有任何能够标示这种行的文本可供查找。解决办法是用n命令。脚本要查找含有单词header的那一行。找到之后，n命令会让sed编辑器移动到文 本的下一行，也就是那个空行。
        $ sed '/header/{n ; d}' data1.txt 
        This is the header line.
        This is a data line.
        
        This is the last line.
        $
        然后`sed`从数据流中读取下一行文本，并从头开始执行命令脚本。但再也找不到包含单词header的行，所以不会有其他的行被删掉。
        ```

      - 合并文本行

        ```shell
        $ cat data2.txt
        This is the header line.
        This is the first data line.
        This is the second data line.
        This is the last line.
        $
        $ sed '/first/{ N ; s/\n/ / }' data2.txt
        This is the header line.
        This is the first data line. This is the second data line. This is the last line.
        $
        sed 编辑器脚本查找含有单词first的那行文本。找到该行后，它会用N命令将下一行合并到那行，然后用替换命令s将换行符替换成空格。结果是，文本文件中的两行在sed编辑器的输出中成了一行。
        
        如果要在数据文件中查找一个可能会分散在两行中的文本短语
        $ cat data3.txt
        On Tuesday, the Linux System
        Administrator's group meeting will be held.
        All System Administrators should attend.
        Thank you for your attendance.
        $
        $ sed 'N ; s/System Administrator/Desktop User/' data3.txt On Tuesday, the Linux System
        Administrator's group meeting will be held.
        All Desktop Users should attend.
        Thank you for your attendance.
        $
        替换命令会在文本文件中查找特定的双词短语System Administrator。如果短语在一行中的话，事情很好处理，替换命令可以直接替换文本。但如果短语分散在两行中的话，替换命令就没法识别匹配的模式了。
        
        $ sed 'N ; s/System.Administrator/Desktop User/' data3.txt
        On Tuesday, the Linux Desktop User's group meeting will be held. All Desktop Users should attend.
        Thank you for your attendance.
        $
        用`N`命令将发现第一个单词的那行和下一行合并后，即使短语内出现了换行，你仍然可以找到它。通配符模式(.)匹配空格和换行符。
        
        如果不想两行合并成一行，可以用两个替换命令
        一个用来匹配短语出现在多行的情况；
        一个用来匹配短语出现在单行中的情况；
        $ sed 'N
        > s/System\nAdministrator/Desktop\nUser/ 
        > s/System Administrator/Desktop User/
        > ' data3.txt
        On Tuesday, the Linux Desktop
        User's group meeting will be held.
        All Desktop Users should attend.
        Thank you for your attendance.
        $
        
        但有个小问题
        $ cat data4.txt
        On Tuesday, the Linux System 
        Administrator's group meeting will be held.
        All System Administrators should attend.
        $
        $ sed 'N
        > s/System\nAdministrator/Desktop\nUser/
        > s/System Administrator/Desktop User/
        > ' data4.txt
        On Tuesday, the Linux Desktop
        User's group meeting will be held.
        All System Administrators should attend.
        $
        总是在执行sed编辑器命令前将下一行文本读入到模式空间。当它到了最后一行文本时，就没有下一行可读了。如果要匹配的文本正好在数据流的最后一行上，命令就不会发现要匹配的数据。
        
        可以将单行命令放到N命令前面，并将多行命令放到N命令后面来解决
        $ sed '
        > s/System Administrator/Desktop User/ 
        > N
        > s/System\nAdministrator/Desktop\nUser/ 
        > ' data4.txt
        On Tuesday, the Linux Desktop
        User's group meeting will be held.
        All Desktop Users should attend.
        $
        现在，查找单行中短语的替换命令在数据流的最后一行也能正常工作，多行替换命令则会负责短语出现在数据流中间的情况。
        ```

  - 多行删除命令

    ```shell
    $ sed 'N ; /System\nAdministrator/D' data4.txt Administrator's group meeting will be held. 
    All System Administrators should attend.
    $
    sed 编辑器提供了多行删除命令D，它只删除模式空间中的第一行。该命令会删除到换行符(含换行符)为止的所有字符。
    
    $ cat data5.txt
    
    This is the header line.
    This is a data line.
    
    This is the last line.
    $
    $ sed '/^$/{N ; /header/D}' data5.txt 
    This is the header line.
    This is a data line.
    
    This is the last line.
    $
    sed 编辑器脚本会查找空白行，然后用N命令来将下一文本行添加到模式空间。如果新的模式空间内容含有单词header，则D命令会删除模式空间中的第一行。如果不结合使用N命令和D命令，就不可能在不删除其他空白行的情况下只删除第一个空行。
    ```

- 多行打印命令

  `P` 只打印多行模式空间中的第一行。这包括模式空间中直到换行符为止的所有字符。

## 保持空间

模式空间(pattern space)是一块活跃的缓冲区，在sed编辑器执行命令时它会保存待检查的文本。sed编辑器有另一块称作保持空间(hold space)的缓冲区域。在处理模式空间中的某些行时，可以用保持空间来临时保存一些行。

```shell
h  将模式空间复制到保持空间
H  将模式空间附加到保持空间
g  将保持空间复制到模式空间
G  将保持空间附加到模式空间
x  交换模式空间和保持空间的内容
这些命令用来将文本从模式空间复制到保持空间。这可以清空模式空间来加载其他要处理的字符串。

$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed -n '/first/ {h ; p ; n ; p ; g ; p }' data2.txt
This is the first data line.
This is the second data line.
This is the first data line.
$

(1) sed 脚本在地址中用正则表达式来过滤出含有单词first的行;
(2) 当含有单词first的行出现时，h命令将该行放到保持空间;
(3) p命令打印模式空间也就是第一个数据行的内容;
(4) n命令提取数据流中的下一行(This is the second data line)，并将它放到模式空间;
(5) p命令打印模式空间的内容，现在是第二个数据行;
(6) g命令将保持空间的内容(This is the first data line)放回模式空间，替换当前文本; 
(7) p命令打印模式空间的当前内容，现在变回第一个数据行了。

通过使用保持空间来回移动文本行，你可以强制输出中第一个数据行出现在第二个数据行后面。如果丢掉了第一个p命令，你可以以相反的顺序输出这两行。

$ sed -n '/first/ {h ; n ; p ; g ; p }' data2.txt 
This is the second data line.
This is the first data line.
$
可以用这种方法来创建一个sed脚本将整个文件的文本行反转!
```

## 排除命令

```shell
感叹号命令(!)用来排除(negate)命令，也就是让原本会起作用的命令不起作用。
$ sed -n '/header/!p' data2.txt 
This is the first data line. 
This is the second data line. 
This is the last line.
$
除了包含单词header那一行外，文件中其他所有的行都被打印出来了。

反转行
$ cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
$
$ sed -n '{1!G ; h ; $p }' data2.txt 
This is the last line.
This is the second data line.
This is the first data line.
This is the header line.
$
这展示了在sed脚本中使用保持空间的强大之处。它提供了一种在脚本输出中控制行顺序的简单办法。
```

## 改变流

sed编辑器提供了一个方法来改变命令脚本的执行流程，其结果与结构化编程类似。

 - 分支

   ```shell
   [address]b [label]
   address参数决定了哪些行的数据会触发分支命令。label参数定义了要跳转到的位置。如果没有加label参数，跳转命令会跳转到脚本的结尾。
   
   $ cat data2.txt
   This is the header line.
   This is the first data line.
   This is the second data line.
   This is the last line.
   $
   $ sed '{2,3b ; s/This is/Is this/ ; s/line./test?/}' data2.txt Is this the header test?
   This is the first data line.
   This is the second data line.
   Is this the last test?
   $
   分支命令在数据流中的第2行和第3行处跳过了两个替换命令。
   
   要是不想直接跳到脚本的结尾，可以为分支命令定义一个要跳转到的标签。标签以冒号开始，最多可以是7个字符长度。`:label2`
   $ sed '{/first/b jump1 ; s/This is the/No jump on/ > :jump1
   > s/This is the/Jump here on/}' data2.txt
   No jump on header line
   Jump here on first data line
   No jump on second data line
   No jump on last line
   $
   跳转命令指定如果文本行中出现了first，程序应该跳到标签为jump1的脚本行。
   如果分支命令的模式没有匹配，sed编辑器会继续执行脚本中的命令，包括分支标签后的命令
   
   $ echo "This, is, a, test, to, remove, commas." | sed -n '{ > :start
   > s/,//1p
   > b start
   > }'
   This is, a, test, to, remove, commas. 
   This is a, test, to, remove, commas. 
   This is a test, to, remove, commas. 
   This is a test to, remove, commas. 
   This is a test to remove, commas. 
   This is a test to remove commas.
   ^C
   $
   脚本的每次迭代都会删除文本中的第一个逗号，并打印字符串。这个脚本有个问题:它永远 不会结束。这就形成了一个无穷循环，不停地查找逗号。
   
   要防止这个问题，可以为分支命令指定一个地址模式来查找。如果没有模式，跳转就应该结束。
   $ echo "This, is, a, test, to, remove, commas." | sed -n '{ > :start
   > s/,//1p
   > /,/b start
   > }'
   This is, a, test, to, remove, commas. 
   This is a, test, to, remove, commas. 
   This is a test, to, remove, commas. 
   This is a test to, remove, commas. 
   This is a test to remove, commas. 
   This is a test to remove commas.
   $
   现在分支命令只会在行中有逗号的情况下跳转。在最后一个逗号被删除后，分支命令不会再执行，脚本也就能正常停止了。
   ```

 - 测试

   测试(test)命令(t)也可以用来改变sed编辑器脚本的执行流程。测试命令会根据替换命令的结果跳转到某个标签，而不是根据地址进行跳转。

   ```shell
   [address]t [label]
   跟分支命令一样，在没有指定标签的情况下，如果测试成功，sed会跳转到脚本的结尾。
   
   $ sed '{
   > s/first/matched/
   >t
   > s/This is the/No match on/ > }' data2.txt
   No match on header line
   This is the matched data line 
   No match on second data line 
   No match on last line
   $
   第一个替换命令会查找模式文本first。如果匹配了行中的模式，它就会替换文本，而且测 试命令会跳过后面的替换命令。如果第一个替换命令未能匹配模式，第二个替换命令就会被执行。有了测试命令，你就能结束之前用分支命令形成的无限循环。
   $ echo "This, is, a, test, to, remove, commas. " | sed -n '{ > :start
   > s/,//1p
   > t start
   > }'
   This is, a, test, to, remove, commas. 
   This is a, test, to, remove, commas. 
   This is a test, to, remove, commas. 
   This is a test to, remove, commas. 
   This is a test to remove, commas. 
   This is a test to remove commas.
   $
   当无需替换时，测试命令不会跳转而是继续执行剩下的脚本。
   ```

## 模式替代

```shell
如果你只是要匹配模式中的一个单词，那就非常简单。
$ echo "The cat sleeps in his hat." | sed 's/cat/"cat"/' 
The "cat" sleeps in his hat.
$
如果在模式中用通配符(.)来匹配多个单词呢?
$ echo "The cat sleeps in his hat." | sed 's/.at/".at"/g' 
The ".at" sleeps in his ".at".
$
用于替代的字符串无法匹配 已匹配单词中的通配符字符。
```

 - & 符号

   ```shell
   &符号可以用来代表替换命令中的匹配的模式。不管模式匹 配的是什么样的文本，你都可以在替代模式中使用&符号来使用这段文本。
   $ echo "The cat sleeps in his hat." | sed 's/.at/"&"/g' 
   The "cat" sleeps in his "hat".
   $
   ```

 - 替代单独的单词

   `&`符号会提取匹配替换命令中指定模式的整个字符串。有时你只想提取这个字符串的一部分。用圆括号来定义替换模式中的子模式。你可以在替代模式中使用特殊字符来引用每个子模式。替代字符由反斜线和数字组成。数字表明子模式的位置。sed编辑器会给第一个子 模式分配字符`\1`，给第二个子模式分配符`\2`，依此类推。 

   ```shell
   $ echo "The System Administrator manual" | sed '
   > s/\(System\) Administrator/\1 User/'
   The System User manual
   $
   这个替换命令用一对圆括号将单词System括起来，将其标示为一个子模式。然后它在替代模 式中使用\1来提取第一个匹配的子模式。
   
   如果需要用一个单词来替换一个短语，而这个单词刚好是该短语的子字符串，但那个子字符 串碰巧使用了通配符，这时使用子模式会方便很多
   $ echo "That furry cat is pretty" | sed 's/furry \(.at\)/\1/' That cat is pretty
   $
   $ echo "That furry hat is pretty" | sed 's/furry \(.at\)/\1/' That hat is pretty
   $
   不能用&符号，因为它会替换整个匹配的模式。子模式提供了答案
   
   使用子模式在大数字中插入逗号。
   $ echo "1234567" | sed '{
   > :start
   > s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/ > t start
   > }'
   1,234,567
   $
   这个脚本将匹配模式分成了两部分。
   .*[0-9]
   [0-9]{3}
   
   会查找两个子模式。
   第一个子模式是以数字结尾的任意长度的字符。
   第二个子模式是若干组三位数字
   如果这个模式在文本中找到了，替代文本会在两个子模式之间加一个逗号，每个子模式都会通过其位置来标示。这个脚本使用测试命令来遍历这个数字，直到放置好所有的逗号。
   ```

## 在脚本中使用`sed`

  - 使用包装脚本

    可以将sed编辑器命令放到shell包装脚本(wrapper)中，不用每次使用时都重新键入整个脚本。包装脚本充当着sed编辑器脚本和命令行之间的中间人角色。

    ```shell
    有个将命令行参数变量作为sed脚本输入的例子。
    $ cat reverse.sh
    #!/bin/bash
    # Shell wrapper for sed editor script.
    # to reverse text file lines.
    #
    sed -n '{ 1!G ; h ; $p }' $1
    #
    $
    反转数据流中的文本行。它使用shell参数 $1 从命令行中提取第一个参数，这正是需要进行反转的文件名。
    $ ./reverse.sh data2.txt
    This is the last line.
    This is the second data line. 
    This is the first data line. 
    This is the header line.
    $
    现在你能在任何文件上轻松使用这个sed编辑器脚本，再不用每次都在命令行上重新输入了。
    ```

  - 重定向`sed`的输出

    默认情况下，sed 编辑器会将脚本的结果输出到STDOUT上。你可以在shell脚本中使用各种标准方法对sed编辑器的输出进行重定向。

    ```shell
    用 $() 将sed编辑器命令的输出重定向到一个变量中，以备后用。
    $ cat fact.sh
    #!/bin/bash
    # Add commas to number in factorial answer #
    factorial=1
    counter=1
    number=$1
    #
    while [ $counter -le $number ]
    do
    	factorial=$[ $factorial * $counter ]
    	counter=$[ $counter + 1 ]
    done
    #
    result=$(echo $factorial | sed '{ 
    :start 
    s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/
    t start
    }')
    #
    echo "The result is $result"
    #
    $
    $ ./fact.sh 20
    The result is 2,432,902,008,176,640,000 
    $
    使用sed脚本来向数值计算结果添加逗号。
    ```

## 创建`sed`实用工具

​		sed 编辑器可以进行大量很酷的数据格式化工作，以下是常见数据处理工作实例

  - 加倍行间距

    ```shell
    向文本文件的行间插入空白行
    $ sed 'G' data2.txt
    This is the header line.
    
    This is the first data line.
    
    This is the second data line.
    
    This is the last line.
    
    $
    
    可以用排除符号(!)和尾行符号($)来确 保脚本不会将空白行加到数据流的最后一行后面。
    $ sed '$!G' data2.txt 
    This is the header line.
    
    This is the first data line.
    
    This is the second data line.
    
    This is the last line.
    $
    只要该行不是最后一行，G命令就会附加保持空间内容。当sed编辑器到了最后一行时，它会跳过G命令。
    ```

  - 对可能含有空白行的文件加倍行间距

    ```shell
    $ cat data6.txt 
    This is line one. 
    This is line two.
    
    This is line three. 
    This is line four.
    $
    
    $ sed '$!G' data6.txt 
    This is line one.
    
    This is line two.
    
    
    
    This is line three.
    
    This is line four.
    $
    在原来空白行的位置有了三个空白行。这个问题的解决办法是，首先删除数据流中的 所有空白行，然后用`G`命令在所有行后插入新的空白行。要删除已有的空白行，需要将`d`命令和一个匹配空白行的模式一起使用。
    
    /^$/d
    这个模式使用了行首符号(^)和行尾符号($)。将这个模式加到脚本中会生成想要的结果。 
    $ sed '/^$/d ; $!G' data6.txt
    This is line one.
    
    This is line two.
    
    This is line three.
    
    This is line four.
    $
    完美
    ```

  - 给文件中的行编号

    ```shell
    $ sed '=' data2.txt
    1
    This is the header line.
    2
    This is the first data line. 
    3
    This is the second data line. 
    4
    This is the last line.
    $
    有点难看，因为行号是在数据流中实际行的上方。比较好的解决办法是将行号和文本 放在同一行。
    
    $ sed '=' data2.txt | sed 'N; s/\n/ /' 
    1 This is the header line.
    2 This is the first data line.
    3 This is the second data line.
    4 This is the last line.
    $
    在查看错误消息的行号时，这是一个很好用的小工具。
    
    $ nl data2.txt
    				1 This is the header line.
    				2 This is the first data line. 
    				3 This is the second data line. 
    				4 This is the last line.
    $
    $ cat -n data2.txt
             1  This is the header line.
             2  This is the first data line.
             3  This is the second data line.
             4  This is the last line.
    $
    有些bash shell命令也可以添加行号，但它们会另外加入一些东西(可能是不需要的间隔)
    ```

  - 打印末尾行

    ```shell
    只显示最后一行
    $ sed -n '$p' data2.txt 
    This is the last line. 
    $
    
    如何用美元符来显示数据流末尾的若干行呢?
    答案是创建滚动窗口。
    $ cat data7.txt 
    This is line 1. 
    This is line 2. 
    This is line 3. 
    This is line 4. 
    This is line 5. 
    This is line 6. 
    This is line 7. 
    This is line 8. 
    This is line 9. 
    This is line 10. 
    This is line 11. 
    This is line 12. 
    This is line 13. 
    This is line 14. 
    This is line 15. 
    $
    $ sed '{
    > :start
    > $q ; N ; 11,$D > b start
    > }' data7.txt 
    This is line 6. 
    This is line 7. 
    This is line 8. 
    This is line 9. 
    This is line 10. 
    This is line 11. 
    This is line 12. 
    This is line 13. 
    This is line 14. 
    This is line 15. 
    $
    首先检查这行是不是数据流中最后一行。如果是，退出(quit)命令会停止循环。`N`命令会将下一行附加到模式空间中当前行之后。如果当前行在第10行后面，11,`$D`命令会 删除模式空间中的第一行。这就会在模式空间中创建出滑动窗口效果。因此，这个sed程序脚本只会显示出data7.txt文件最后10行。
    ```

  - 删除行

    删除数据流中的所有空白行很容易，但要选择性地删除空白行则需要一点创造力。

    - 删除连续的空白行

      ```shell
      $ cat data8.txt 
      This is line one.
      
      
      This is line two.
      
      This is line three.
      
      
      This is line four.
      $
      删除连续空白行的关键在于创建包含一个非空白行和一个空白行的地址区间。如果sed编辑 器遇到了这个区间，它不会删除行。但对于不匹配这个区间的行(两个或更多的空白行)，它会删除这些行。
      $ sed '/./,/^$/!d' data8.txt 
      This is line one.
      
      This is line two.
      
      This is line three.
      
      This is line four.
      $
      无论文件的数据行之间出现了多少空白行，在输出中只会在行间保留一个空白行。
      ```

    - 删除开头的空白行

      ```shell
      $ cat data9.txt
      
      
      This is line one.
      
      This is line two.
      $
      用地址区间来决定哪些行要删掉。这个区间从含有字符的行开始，一直到数据流结束。在这个区间内的任何行都不会从输出中删除。这意味着含有字符的第一行之前的任何行都会删除
      $ sed '/./,$!d' data9.txt 
      This is line one.
      
      This is line two.
      $
      ```

    - 删除结尾的空白行

      ```shell
      $ cat data10.txt
      This is the first line. 
      This is the second line.
      
      注意，在正常脚本的花括号里还有花括号。这允许你在整个命令脚本 中将一些命令分组。该命令组会被应用在指定的地址模式上。地址模式能够匹配只含有一个换行符的行。如果找到了这样的行，而且还是最后一行，删除命令会删掉它。如果不是最后一行，N 命令会将下一行附加到它后面，分支命令会跳到循环起始位置重新开始。
      $ sed '{
      > :start
      > /^\n*$/{$d ; N ; b start }
      > }' data10.txt
      This is the first line.
      This is the second line.
      $
      ```

    - 删除HTML标签

      ```shell
      $ cat data11.txt
      <html>
      <head>
      <title>This is the page title</title> </head>
      <body>
      <p>
      This is the <b>first</b> line in the Web page.
      This should provide some <i>useful</i>
      information to use in our sed script.
      </body>
      </html>
      $
      
      认为删除HTML标签的办法就是查找以小于号(<)开头、大于号(>)结尾且其中有数据的文本字符串，然而出现了意料之外的结果
      $ sed 's/<.*>//g' data11.txt
      
      
      
      
      
      This is the  line in the Web page.
      This should provide some
      information to use in our sed script.
      
      
      $
      
      解决办法是让sed编辑器忽略掉任何嵌入到原始标签中的大于号。要这么做的话，你可以创建一个字符组来排除大于号。
      $ sed 's/<[^>]*>//g' data11.txt
          
          
      This is the page title
      
      
      
      This is the first line in the Web page.
      This should provide some useful
      information to use in our sed script.
      
      
      $
      
      加一条命令来删除多余的空白行
      $ sed 's/<[^>]*>//g ; /^$/d' data11.txt 
      This is the page title
      This is the first line in the Web page. 
      This should provide some useful 
      information to use in our sed script.
      $
      ```

      