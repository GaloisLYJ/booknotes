# 附录B sed和gawk快速指南

```
 sed编辑器基础 
 gawk必知必会
```

------

## `sed` 编辑器

```
	sed编辑器可以基于命令来操作数据流中的数据，这些命令要么从命令行中输入，要么保存在命令文本文件中。它每次从输入中读取一行数据，并用提供的编辑器命令匹配该数据，按命令中指定的操作修改数据，然后将生成的新数据输出到STDOUT。
```

### 启动`sed`编辑器

```shell
sed options script file
-e script 将script中指定的命令添加到处理输入时运行的命令中
-f file 	将file文件中指定的命令添加到处理输入时运行的命令中
-n				不要为每条命令产生输出，但会等待打印命令
```

### `sed`命令

- 替换

  ```shell
  s/pattern/replacement/flags
  pattern是要被替换的文本，replacement是sed要插到数据流中的新文本。flags参数控制如何进行替换。
  
  有4种类型的替换标记可用。
   一个数字，表明该模式出现的第几处应该被替换。 
   g:表明所有该文本出现的地方都应该被替换。
   p:表明原来行中的内容应该被打印出来。
   w file:表明替换的结果应该写入到文件file中。
  
  在第一类替换中，你可以指定sed编辑器应该替换第几处匹配模式的地方。举个例子，你可 以用数字2来只替换该模式第二次出现的地方。
  ```

- 寻址

  ```shell
  默认情况下，你在sed编辑器中使用的命令会作用在文本数据的所有行上。如果你想让命令 只作用在指定行或一组行上，就必须使用行寻址(line addressing)。
   行区间(数字形式)
   可以过滤出特定行的文本模式
  
  [address]command
  $ sed '2,3s/dog/cat/' data1
  
  
  /pattern/command
  $ sed '/rich/s/bash/csh/' /etc/passwd
  
  address { 
  	command1
  	command2 
  	command3 }
  	
  $ sed '2{
  > s/fox/elephant/
  > s/dog/cat/
  > }' data1
  sed 编辑器将每一条替换命令都作用在数据文件的第二行上。
  ```

- 删除行

  ```shell
  删除所有与提供的地址模式匹配的文本行。
  小心，如果你忘记加地址模式，所有的行都会被从数据流中删掉。
  $ sed 'd' data1
  
  通过行号指定:
  $ sed '3d' data6
  
  通过特定的行区间指定:
  $ sed '2,3d' data6
  
  模式匹配功能也适用于删除命令:
  $ sed '/number 1/d' data6
  ```

- 插入和附加文本

  ```shell
   插入(insert)命令(i)在指定行前面添加一个新行; 
   附加(append)命令(a)在指定行后面添加一个新行。
  
  你不能在单个命令行上使用这两条命令。要插入或附加的行必须作为单独的一行出现，格式如下。
  sed '[address]command\ 
  new line'
  
  $ echo "testing" | sed 'i\ 13 > This is a test'
  This is a test
  testing
  $
  当使用插入命令时， 文本会出现在指定行之前。
  
  $ echo "testing" | sed 'a\ > This is a test'
  testing
  This is a test
  $
  当使用追加命令时，文本会出现在指定行之后。
  
  这允许你在普通文本的末尾插入文本。
  ```

- 修改行

  ```shell
  修改数据流中的整行文本。其格式跟插入和附加命令一样，你必须将新行与sed命令的其余部分分开。
  $ sed '3c\
  > This is a changed line of text.' data6
  反斜线字符用来表明脚本中的新数据行。
  ```

- 转换命令

  ```shell
  转换(transform)命令(y)是唯一一个作用在单个字符上的sed编辑器命令
  [address]y/inchars/outchars/
  
  转换命令对inchars和outchars执行一对一的映射。inchars中的第一个字符会转换为outchars中的第一个字符，inchars中的第二个字符会转换为outchars中的第二个字符，依此类推，直到超过了指定字符的长度。如果inchars和outchars长度不同，sed编辑器会报错。
  ```

- 打印行

  ```shell
  常见的用法是打印与指定文本模式匹配的文本行。
  $ sed -n '/number 3/p' data6 
  This is line number 3.
  $
  打印命令允许你从输入流中过滤出特定的数据行。
  ```

- 写入到文件

  ```shell
  [address]w filename
  filename可以用相对路径或绝对路径指定，但不管怎样，运行sed编辑器的人都必须有文件的写权限。address可以是任意类型的寻址方法，比如单行行号、文本模式、行号区间或多个文本模式。
  
  
  $ sed '1,2w test' data6
  只将数据流的前两行写入到文本文件。
  ```

- 从文件中读取

  ```shell
  读取(read)命令(r)允许 你插入单个文件中的数据。
  [address]r filename
  其中filename参数使用相对路径或绝对路径的形式来指定含有数据的文件。读取命令不能使用地址区间，只能使用单个行号或文本模式地址。sed编辑器会将文件中的文本插入指定地址之后:
  
  $ sed '3r data' data2
  sed 编辑器将data文件中的全部文本都插入了data2文件中第3行开始的地方
  ```

---

## `gawk` 程序

### `gawk` 命令格式

```shell
gawk options program file
-F fs							指定用于分隔行中数据字段的文件分隔符
-f file						指定要读取的程序文件名
-v var=value 			定义gawk程序中的一个变量及其默认值
-mf N	 						指定要处理的数据文件中的最大字段数
-mr N							指定数据文件中的最大记录数
-W keyword				指定gawk的兼容模式或警告等级。用help选项来列出所有可用的关键字
```

### 使用`gawk`程序

- 从命令行上读取程序脚本

  ```shell
  $ gawk '{print $1}'
  显示输入流中每行的第一个数据字段。
  ```

- 在程序脚本中使用多条命令

  ```shell
  在命令行上指定的程序脚本使用多条命令，只需在每个命令之间放一个分号就可以了。
  $ echo "My name is Rich" | gawk '{$4="Dave"; print $0}'
  My name is Dave
  $
  先用一个不同的值替换第四个数据字段，再显示流中的整个数据行。
  ```

- 从文件中读取程序

  ```shell
  gawk 编辑器也允许你将程序存储在文件中，然后在命令行上引用它们
  $ cat script2
  { print $5 "'s userid is " $1 }
  $ gawk -F: -f script2 /etc/passwd
  gawk 程序在输入数据流上执行了文件中指定的所有命令。
  ```

- 在处理数据前运行脚本

  ```shell
  允许你指定程序脚本何时运行。默认情况下，gawk从输入中读取一行文本，然后对这行文本中的数据执行程序脚本。有时，你可能需要在处理数据之前(比如创建报告的标题) 运行脚本。可以使用BEGIN关键字。它会强制gawk先执行BEGIN关键字后面指定 的程序脚本，然后再读取数据。
  $ gawk 'BEGIN {print "This is a test report"}'
  This is a test report
  $
  可以在BEGIN块中放置任何类型的gawk命令，比如给变量赋默认值。
  ```

- 在处理数据后运行脚本

  ```shell
  类似于BEGIN关键字，END关键字允许你指定一个程序脚本，在gawk读取数据后执行。
  $ gawk 'BEGIN {print "Hello World!"} {print $0} END {print "byebye"}' data1
  Hello World!
  This is a test
  This is a test
  This is another test.
  This is another test.
  byebye
  $
  gawk 程序会先执行BEGIN块中的代码，然后处理输入流中的数据，最后执行END块中的代码。
  ```

### `gawk`变量

```
gawk程序不只是一个编辑器，还是一个完整的编程环境。
```

 - 内建变量

   ```shell
   		gawk 程序使用内建变量来引用程序数据中特定特性。gawk程序将数据定义成记录和数据字段。记录是一行数据(默认用换行符分隔)，而数据字段则是行中独立的数据元素(默认用空白字符分隔，比如空格或制表符)。
   		
   gawk 数据字段和记录变量
   $0 					整条记录
   $1 					记录中的第1个数据字段
   $2 					记录中的第2个数据字段
   $n 					记录中的第n个数据字段
   FIELDWIDTHS 一列由空格分隔的数字，定义了每个字段具体宽度 FS 输入字段分隔符
   RS 					输入记录分隔符
   OFS 				输出字段分隔符
   ORS 				输出字段分隔符
   
   其他，可以帮助你了解数据的相关 情况以及从shell环境中提取信息。
   ARGC 				当前命令行参数个数
   ARGIND 			当前文件在ARGV中的索引
   ARGV 				包含命令行参数的数组
   CONVFMT 		数字的转换格式(参见printf语句)，默认值为%.6g
   ENVIRON 		由当前shell环境变量及其值组成的关联数组
   ERRNO 			当读取或关闭输入文件发生错误时的系统错误号
   FILENAME 		用作gawk输入的数据文件的文件名
   FNR					当前数据文件中的记录数
   IGNORECASE  设成非零时，忽略gawk命令中出现的字符串的字符大小写 
   NF 					数据文件中的字段总数
   NR				  已处理的输入记录数
   OFMT 				数字的输出格式，默认值为%.6g
   RLENGTH 		由match函数所匹配的子串的长度 
   RSTART 			由match函数所匹配的子串的起始位置
   
   可以在gawk程序脚本中的任何地方使用内建变量，包括BEGIN和END代码块中。     
   ```

 - 在脚本中给变量赋值

   ```shell
   $ gawk '
   > BEGIN{
   > testing="This is a test"
   > print testing
   > }'
   This is a test
   $
   给变量赋值后，就可以在gawk脚本中任何地方使用该变量了。
   ```

-  在命令行上给变量赋值

  ```shell
  也可以用gawk命令行为gawk程序给变量赋值。这允许你在正常代码外设置值，即时修改值。
  $ cat script1
  BEGIN{FS=","}
  {print $n}
  $ gawk -f script1 n=2 data1
  $ gawk -f script1 n=3 data1
  使用命令行变量来显示文件中特定数据字段。
  这个特性是在gawk脚本中处理shell脚本数据的一个好办法。
  ```

---

## `gawk` 程序的特性

### 正则表达式

```shell
可使用基础正则表达式(BRE)或扩展正则表达式(ERE)将程序脚本要处理的行过滤出来。
$ gawk 'BEGIN{FS=","} /test/{print $1}' data1
This is a test
$
```

### 匹配操作符

```shell
匹配操作符(matching operator)`~`允许你将正则表达式限定在数据行中的特定数据字段上。
$1 ~ /^data/
过滤出第一个数据字段以文本data开头的记录。
```

### 数学表达式

```shell
还可以在匹配模式中使用数学表达式，在匹配数据字段中的数字值时非常有用。
如，显示所有属于root用户组(组ID为0)的系统用户
$ gawk -F: '$4 == 0{print $1}' /etc/passwd
显示出第四个数据字段含有值0的所有行的第一个数据字段。
```

### 结构化命令

```shell
if-then-else语句:
 	if (condition) statement1; else statement2 
 
while语句:
 	while (condition)
	{
		statements 
	}

do-while语句: 
	do {
		statements
	} while (condition)
	
for语句:
	for(variable assignment; condition; iteration process)
	
	这为gawk脚本程序员提供了大量的编程手段。可以利用它们编写出能够媲美其他高级语言程序功能的gawk程序。
```











