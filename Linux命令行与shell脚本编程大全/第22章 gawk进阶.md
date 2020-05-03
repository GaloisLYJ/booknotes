# 第22章 gawk进阶

```
gawk是一门功能丰富的编程语言，能够处理可能遇到的各种数据格式化任务
```

------

## 使用变量

​	gawk编程语言支持两种不同类型的变量:

 - 内建变量
   	- 字段和记录分隔符变量
	
	  ```shell
	  FIELDWIDTHS 由空格分隔的一列数字，定义了每个数据字段确切宽度
	  FS 					输入字段分隔符
	  RS					输入记录分隔符
	  OFS					输出字段分隔符
	  ORS					输出记录分隔符
	  
	  变量FS和OFS定义了gawk如何处理数据流中的数据字段。你
	  $ cat data1
	  data11,data12,data13,data14,data15
	  data21,data22,data23,data24,data25
	  data31,data32,data33,data34,data35
	  $ gawk 'BEGIN{FS=","} {print $1,$2,$3}' data1
	  data11 data12 data13
	  data21 data22 data23
	  data31 data32 data33
	  $
	  
	  $ gawk 'BEGIN{FS=","; OFS="-"} {print $1,$2,$3}' data1
	  data11-data12-data13
	  data21-data22-data23
	  data31-data32-data33
	  $ gawk 'BEGIN{FS=","; OFS="--"} {print $1,$2,$3}' data1
	  data11--data12--data13
	  data21--data22--data23
	  data31--data32--data33
	  $ gawk 'BEGIN{FS=","; OFS="<-->"} {print $1,$2,$3}' data1
	  data11<-->data12<-->data13
	  data21<-->data22<-->data23
	  data31<-->data32<-->data33
	  $
	  通过设置OFS变量，可以在输出中使用任意字符串来分隔字段。
	  
	  $ cat data1b
	  1005.3247596.37
	  115-2.349194.00
	  05810.1298100.1
	  $ gawk 'BEGIN{FIELDWIDTHS="3 5 2 5"}{print $1,$2,$3,$4}' data1b
	  100 5.324 75 96.37
	  115 -2.34 91 94.00
	  058 10.12 98 100.1
	  $
	  FIELDWIDTHS变量定义4个字段，每个记录中的数字串会根 据已定义好的字段长度来分割。一旦设定了FIELDWIDTHS变量的值，就不能再改变了
	  
	  变量RS和ORS定义了gawk程序如何处理数据流中的字段。默认情况下，gawk将RS和ORS设为换行符。
	  
	  $ cat data2
	  Riley Mullen
	  123 Main Street
	  Chicago, IL  60601
	  (312)555-1234
	  
	  Frank Williams
	  456 Oak Street
	  Indianapolis, IN  46201
	  (317)555-9876
	  
	  Haley Snell
	  4231 Elm Street
	  Detroit, MI 48201
	  (313)555-4938
	  $ gawk 'BEGIN{FS="\n"; RS=""} {print $1,$4}' data2
	  Riley Mullen (312)555-1234
	  Frank Williams (317)555-9876
	  Haley Snell (313)555-4938
	  $
	  现在gawk把文件中的每行都当成一个字段，把空白行当作记录分隔符。
	  ```
	
	- 数据变量
	
	  ​		除了字段和记录分隔符变量外，gawk还提供了其他一些内建变量来帮助你了解数据发生了什 么变化，并提取shell环境的信息。 
	
	  ```shell
	  ARGC 	当前命令行参数个数
	  ARGIND 	当前文件在ARGV中的位置
	  ARGV 	包含命令行参数的数组
	  CONVFMT  数字的转换格式(参见printf语句)，默认值为%.6 g
	  ENVIRON 	当前shell环境变量及其值组成的关联数组
	  ERRNO 	当读取或关闭输入文件发生错误时的系统错误号
	  FILENAME 	用作gawk输入数据的数据文件的文件名
	  FNR 	当前数据文件中的数据行数
	  IGNORECASE 设成非零值时，忽略gawk命令中出现的字符串的字符大小写
	  NF	数据文件中的字段总数
	  NR 	已处理的输入记录数
	  OFMT 	数字的输出格式，默认值为%.6 g
	  RLENGTH 	由match函数所匹配的子字符串的长度
	  RSTART	由match函数所匹配的子字符串的起始位置
	  ```
	
	  跟shell变量不同，在脚本中引用gawk变量时，变量名前不加美元符。
	
- 自定义变量

    gawk自定义变量名可以是任意数目的字母、数字和下划线，但不能以数字开头。区分大小写。

    - 在脚本中给变量赋值

      ```shell
      $ gawk '
      > BEGIN{
      > testing="This is a test"
      > print testing
      > }'
      This is a test
      $
      
      $ gawk '
      > BEGIN{
      > testing="This is a test"
      > print testing
      > testing=45
      > print testing
      > }'
      This is a test
      45
      $
      
      $ gawk 'BEGIN{x=4; x= x * 2 + 3; print x}'
      11
      $
      ```

    - 在命令行上给变量赋值

      ```shell
      $ cat script1
      BEGIN{FS=","}
      {print $n}
      $ gawk -f script1 n=2 data1
      data12
      data22
      data32
      $ gawk -f script1 n=3 data1
      data13
      data23
      data33
      $
      使用命令行变量来显示文件中特定数据字段。
      
      $ cat script2
      BEGIN{print "The starting value is",n; FS=","}
      {print $n}
      $ gawk -f script2 n=3 data1
      The starting value is
      data13
      data23
      data33
      $
      会有一个问题。在你设置了变量后，这个值在代码的BEGIN部分不可用。
      ```

## 处理数组

​			gawk编程语言使用关联数组提供数组功能。关联数组跟数字数组不同之处在于它的索引值可以是任意文本字符串。你不需要用连续的数字来标识数组中的数据元素。如果你熟悉其他编程语言的话，就知道这跟散列表和字典是同一个概念。

  - 定义数组变量

    ```shell
    var[index] = element
    var是变量名，index是关联数组的索引值，element是数据元素值。
    capital["Illinois"] = "Springfield"
    capital["Indiana"] = "Indianapolis"
    capital["Ohio"] = "Columbus"
    
    引用数组变量时，必须包含索引值来提取相应的数据元素值。
    $ gawk 'BEGIN{
    > capital["Illinois"] = "Springfield"
    > print capital["Illinois"]
    > }'
    Springfield
    $
    
    引用数组变量时，会得到数据元素的值。数据元素值是数字值时也一样。
    $ gawk 'BEGIN{
    > var[1] = 34
    > var[2] = 3
    > total = var[1] + var[2]
    > print total
    > }' 37
    $
    ```

  - 遍历数组变量

    ​	跟使用连续数字作为索引值的数字数组不同，关联数组的索引可以是任何东西。

    ```shell
    要在gawk中遍历一个关联数组
    for (var in array) {
    	statements
    }
    重要的是记住这个变量中存储的是索引值而不是数组元素值。可以将这个变量用作数组的索引，轻松地取出数据元素值。
    $ gawk 'BEGIN{
    > var["a"] = 1
    > var["g"] = 2
    > var["m"] = 3
    > var["u"] = 4
    > for (test in var) >{
    > print "Index:",test," - Value:",var[test] >}
    > }'
    Index: u - Value: 4
    Index: m  - Value: 3
    Index: a  - Value: 1
    Index: g  - Value: 2
    $
    注意，索引值不会按任何特定顺序返回，但它们都能够指向对应的数据元素值。明白这点很重要，因为你不能指望着返回的值都是有固定的顺序，只能保证索引值和数据值是对应的。
    ```

- 删除数组变量

  ```shell
  从关联数组中删除数组索引
  delete array[index]
  
  $ gawk 'BEGIN{
  > var["a"] = 1
  > var["g"] = 2
  > for (test in var) >{
  > print "Index:",test," - Value:",var[test] >}
  > delete var["g"]
  > print "---"
  > for (test in var)
  >    print "Index:",test," - Value:",var[test]
  > }'
  Index: a  - Value: 1
  Index: g  - Value: 2
  ---
  Index: a  - Value: 1
  $
  从关联数组中删除了索引值，你就没法再用它来提取元素值。
  ```

## 使用模式

  - 正则表达式

    ```shell
    正则表达式必须出现在它要控制的程序脚本的左花括号前。
    $ gawk 'BEGIN{FS=","} /11/{print $1}' data1
    data11
    $
    正则表达式/11/匹配了数据字段中含有字符串11的记录。
    $ gawk 'BEGIN{FS=","} /,d/{print $1}' data1
    data11
    data21
    data31
    $
    匹配了用作字段分隔符的逗号
    ```

  - 匹配操作符

    匹配操作符(matching operator)允许将正则表达式限定在记录中的特定数据字段。匹配操作符是波浪线(~)。可以指定匹配操作符、数据字段变量以及要匹配的正则表达式。

    ```shell
    $1 ~ /^data/
    $1变量代表记录中的第一个数据字段。这个表达式会过滤出第一个字段以文本data开头的所有记录。
    
    $ gawk 'BEGIN{FS=","} $2 ~ /^data2/{print $0}' data1
    data21,data22,data23,data24,data25
    $ 
    匹配操作符会用正则表达式/^data2/来比较第二个数据字段，该正则表达式指明字符串要以文本data2开头。
    
    这可是强大个工具，gawk程序脚本中经常用它在数据文件中搜索特定的数据元素。
    $ gawk -F: '$1 ~ /rich/{print $1,$NF}' /etc/passwd
    rich /bin/bash
    $
    在第一个数据字段中查找文本rich。如果在记录中找到了这个模式，它会打印该记录的第一个和最后一个数据字段值。
    
    可以用!符号来排除正则表达式的匹配。
    $1 !~ /expression/
    
    $ gawk –F: '$1 !~ /rich/{print $1,$NF}' /etc/passwd
    root /bin/bash
    daemon /bin/sh
    bin /bin/sh
    sys /bin/sh
    --- output truncated ---
    $
    gawk 程序脚本会打印/etc/passwd文件中与用户ID rich不匹配的用户ID和登录shell。
    ```

- 数学表达式

  在匹配模式中用数学表达式。这个功能在匹配数据字段中的数字值时非常方便。

  ```shell
  显示所有属于root用户组(组ID为0)的系统用户
  $ gawk -F: '$4 == 0{print $1}' /etc/passwd
  root
  sync
  shutdown
  halt
  operator
  $
  会查看第四个数据字段含有值0的记录。Linux系统中，有五个用户账户属于 root用户组。
  
  常见的数学比较表达式。
   x == y:值x等于y。
   x <= y:值x小于等于y。
   x < y:值x小于y。
   x >= y:值x大于等于y。 
   x > y:值x大于y。
  
  对文本数据使用表达式跟正则表达式不同，表达式必须完全匹配。
  $ gawk -F, '$1 == "data"{print $1}' data1
  $
  $ gawk -F, '$1 == "data11"{print $1}' data1
  data11
  $
  ```

## 结构化命令

  - `if`语句

    ```shell
    if (condition) 
    	statement1
    或
    if (condition) statement1
    
    $ cat data4
    10
    5
    13
    50
    34
    $ gawk '{if ($1 > 20) print $1}' data4
    50
    34
    $
    如果执行多条语句
    $ gawk '{
    > if ($1 > 20) 
    > {
    > 	x = $1 * 2 
    > 	print x 
    >	}
    > }' data4
    100
    68
    $
    
    else语句
    $ gawk '{
    > if ($1 > 20) 
    > {
    > 	x	=	$1 * 2
    > 	print x > 
    > } else
    > {
    >		x	=	$1 * 2
    > 	print x
    > }}' data4
    5
    2.5
    6.5
    100
    68
    $
    
    也可以单行使用
    if (condition) statement1; else statement2
    $ gawk '{if ($1 > 20) print $1 * 2; else print $1 / 2}' data4
    5
    2.5
    6.5
    100 
    68 
    $
    ```

  - `while`语句

    ```shell
    while (condition)
    {
    	statements 
    }
    
    $ cat data5
    130 120 135
    160 113 140
    145 170 215
    $ gawk '{
    > total = 0
    > i = 1
    > while (i < 4)
    > {
    > 	total += $i
    > 	i++
    >	}
    > avg = total / 3
    > print "Average:",avg > }' data5
    Average: 128.333 
    Average: 137.667
    Average: 176.667
    $
    
    gawk 编程语言支持在while循环中使用break语句和continue语句，允许你从循环中跳出。
    $ gawk '{
    > total = 0
    > i = 1
    > while (i < 4)
    > {
    >	 total += $i
    >	 if( i == 2 )
    > 	 break
    >  i++
    > }
    > avg = total / 2
    > print "The average of the first two data elements is:",avg > }' data5
    The average of the first two data elements is: 125
    The average of the first two data elements is: 136.5
    The average of the first two data elements is: 157.5
    $
    ```

  - `do-while`语句

    ```shell
    do {
    	statements
    } while (condition)
    
    保证了语句会在条件被求值之前至少执行一次。
    $ gawk '{
    > total = 0
    > i = 1
    > do
    > {
    > total += $i
    > i++
    > } while (total < 150) 
    > print total }' data5 250
    160
    315
    $
    读取每条记录的数据字段并将它们加在一起，直到累加结果达到150。
    ```

- `for` 语句

  ```shell
  gawk 支持C风格的for循环
  for( variable assignment; condition; iteration process)
  
  $ gawk '{
  > total = 0
  > for (i = 1; i < 4; i++) 
  > {
  >  total += $i
  > }
  > avg = total / 3
  > print "Average:",avg
  > }' data5
  Average: 128.333
  Average: 137.667
  Average: 176.667
  $
  ```

## 格式化打印

​		`print` 语句在`gawk`如何显示数据上并未提供多少控制。你能做的只是控制输出字段分隔符(OFS)。如果要创建详尽的报表，通常需要为数据选择特定的格式和位置。解决办法是使用格式化打印命令，叫作 `printf`。

```shell
printf "format string", var1, var2 . . .
format string是格式化输出的关键。

%[modifier]control-letter
control-letter是一个单字符代码，用于指明显示什么类型的数据，而modifier则定义了可选的格式化特性。

c	将一个数作为ASCII字符显示
d 显示一个整数值
i 显示一个整数值(跟d一样) 
e 用科学计数法显示一个数
f 显示一个浮点值
g 用科学计数法或浮点数显示(选择较短的格式)
o 显示一个八进制值
s 显示一个文本字符串
x 显示一个十六进制值
X 显示一个十六进制值，但用大写字母A~F

如果你需要显示一个字符串变量，可以用格式化指定符%s。
$ gawk 'BEGIN{
> x = 10 * 100
> printf "The answer is: %e\n", x
> }'
The answer is: 1.000000e+03
$
  
还有3种修饰符可以用来进一步控制输出。
 width:指定了输出字段最小宽度的数字值。
 prec:这是一个数字值，指定了浮点数中小数点后面位数，或者文本字符串中显示的最
大字符数。
 -(减号):指明在向格式化空间中放入数据时采用左对齐而不是右对齐。
$ gawk 'BEGIN{FS="\n"; RS=""} {print $1,$4}' data2
Riley Mullen (312)555-1234
Frank Williams (317)555-9876
Haley Snell (313)555-4938
$
换成printf
$ gawk 'BEGIN{FS="\n"; RS=""} {printf "%s %s\n", $1, $4}' data2
    Riley Mullen  (312)555-1234
    Frank Williams  (317)555-9876
    Haley Snell  (313)555-4938
$
需要在printf命令的末尾手动添加换行符来生成新行。没添加的话，printf命令会继续在同一行打印后续输出。

几个单独的printf命令在同一行上打印多个输出
$ gawk 'BEGIN{FS=","} {printf "%s ", $1} END{printf "\n"}' data1
data11 data21 data31
$

用修饰符来格式化第一个字符串值。
$ gawk 'BEGIN{FS="\n"; RS=""} {printf "%16s  %s\n", $1, $4}' data2
       Riley Mullen  (312)555-1234
     Frank Williams  (317)555-9876
        Haley Snell  (313)555-4938
$

强制第一个字符串的输出宽度为16个字符
$ gawk 'BEGIN{FS="\n"; RS=""} {printf "%-16s  %s\n", $1, $4}' data2
Riley Mullen			(312)555-1234
Frank Williams		(317)555-9876
Haley Snell				(313)555-4938
$

通过为变量指定一个格式，你可以让输出看起来更统一。
$ gawk '{
> total = 0
> for (i = 1; i < 4; i++)
>	{
> 	total += $i
> }
> avg = total / 3
> printf "Average: %5.1f\n",avg 
> }' data5
Average: 128.3
Average: 137.7
Average: 176.7
$
```

## 内建函数

  - 数学函数

    gawk编程语言不会让那些寻求高级数学功能的程序员失望。

    ```shell
    atan2(x,y) x/y的反正切，x和y以弧度为单位
    cos(x) x/y的反正切，x和y以弧度为单位
    exp(x) x的余弦，x以弧度为单位
    int(x) x的指数函数
    log(x) x的整数部分，取靠近零一侧的值
    rand( ) x的自然对数
    sin(x) 比0大比1小的随机浮点值
    sqrt(x) x的正弦，x以弧度为单位x的平方根
    srand(x) 为计算随机数指定一个种子值
    
    在使用一些数学函数时要小心，因为gawk语言对于它能够处理的数值有一个限定区间
    $ gawk 'BEGIN{x=exp(100); print x}'
    26881171418161356094253400435962903554686976
    $ gawk 'BEGIN{x=exp(1000); print x}'
    gawk: warning: exp argument 1000 is out of range
    inf
    $
    
    除了标准数学函数外，gawk还支持一些按位操作数据的函数。 
     and(v1, v2): 执行值v1和v2的按位与运算。
     compl(val): 执行val的补运算。
     lshift(val, count): 将值val左移count位。
     or(v1, v2): 执行值v1和v2的按位或运算。
     rshift(val, count): 将值val右移count位。 
     xor(v1, v2):执行值v1和v2的按位异或运算。
    ```

  - 字符串函数

    ```shell
    asort(s [,d])	
    将数组s按数据元素值排序。索引值会被替换成表示新的排序顺序的连续数字。另外， 如果指定了d，则排序后的数组会存储在数组d中
    
    asorti(s [,d])
    将数组s按索引值排序。生成的数组会将索引值作为数据元素值，用连续数字索引来表 明排序顺序。另外如果指定了d，排序后的数组会存储在数组d中
    
    gensub(r, s, h [, t])
    查找变量$0或目标字符串t(如果提供了的话)来匹配正则表达式r。如果h是一个以g 或G开头的字符串，就用s替换掉匹配的文本。如果h是一个数字，它表示要替换掉第h 处r匹配的地方
    
    gsub(r, s [,t])
    查找变量$0或目标字符串t(如果提供了的话)来匹配正则表达式r。如果找到了，就 全部替换成字符串s
    
    index(s, t) length([s])
    返回字符串t在字符串s中的索引值，如果没找到的话返回0 返回字符串s的长度;如果没有指定的话，返回$0的长度
    
    match(s, r [,a])
    返回字符串s中正则表达式r出现位置的索引。如果指定了数组a，它会存储s中匹配正则表达式的那部分
    
    split(s, a [,r])
    将s用FS字符或正则表达式r(如果指定了的话)分开放到数组a中。
    
    sprintf(format,variables)
    返回字段的总数 用提供的format和variables返回一个类似于printf输出的字符串
    
    sub(r, s [,t])
    在变量$0或目标字符串t中查找正则表达式r的匹配。如果找到了，就用字符串s替换 掉第一处匹配
    
    substr(s, i [,n])
    返回s中从索引值i开始的n个字符组成的子字符串。如果未提供n，则返回s剩下的部 分
    
    tolower(s)
    将s中的所有字符转换成小写
    
    toupper(s)
    将s中的所有字符转换成大写
    
    $ gawk 'BEGIN{x = "testing"; print toupper(x); print length(x) }'
    TESTING
    7
    $
    ```

- 时间函数

  ```shell
  mktime(datespec) 
  将一个按YYYY MM DD HH MM SS [DST]格式指定的日期转换成时间戳值1
  
  strftime(format[,timestamp]) 
  将当前时间的时间戳或timestamp(如果提供了的话)转化格式化日期(采用shell
  函数date()的格式) 
  
  systime( )
  返回当前时间的时间戳
  
   $ gawk 'BEGIN{
   > date = systime()
   > day = strftime("%A, %B %d, %Y", date)
   > print day
   > }'
   Friday, December 26, 2014
   $
  systime函数从系统获取当前的epoch时间戳，然后用strftime函数将它转换成用户 可读的格式，转换过程中使用了shell命令date的日期格式化字符。
  ```

## 自定义函数

  - 定义函数

    ```shell
    function name([variables]) 
    {
    	statements
    }
    函数名必须能够唯一标识函数。可以在调用的gawk程序中传给这个函数一个或多个变量。
    
    function printthird()
    {
    	print $3 
    }
    
    function myrand(limit)
    {
      return int(limit * rand())
    }
    
    可以将函数的返回值赋给gawk程序中的一个变量:
    x = myrand(100)
    ```

  - 使用自定义函数

    ```shell
    $ gawk '
    > function myprint() 
    > {
    > 	printf "%-16s - %s\n", $1, $4
    >	}
    > BEGIN{FS="\n"; RS=""}
    > {
    > 	myprint()
    > }' data2
    Riley Mullen		- (312)555-1234
    Frank Williams	- (317)555-9876
    Haley Snell			- (313)555-4938
    $
    格式化记录中的第一个和第四个数据字段以供打印输出。
    ```

- 创建函数库

  ```shell
  gawk 提供了一种途径来将多个函数 放到一个库文件中，这样你就能在所有的gawk程序中使用了。
  
  首先，你需要创建一个存储所有gawk函数的文件。
  $ cat funclib
  function myprint()
  {
  	printf "%-16s - %s\n", $1, $4
  }
  function myrand(limit)
  {
  	return int(limit * rand())
  }
  function printthird()
  {
  	print $3 
  }
  $
  
  funclib文件含有三个函数定义。需要使用-f命令行参数来使用它们。很遗憾，不能将-f命令行参数和内联gawk脚本放到一起使用，不过可以在同一个命令行中使用多个-f参数。
  
  $ cat script4
  BEGIN{ FS="\n"; RS=""}
  {
  	myprint() 
  }
  $ gawk -f funclib -f script4 data2
  Riley Mullen			- (312)555-1234
  Frank Williams		- (317)555-9876
  Haley Snell				- (313)555-4938
  $
  要做的是当需要使用库中定义的函数时，将funclib文件加到你的gawk命令行上就可以了。
  ```

## 实例

```shell
手边有一个数据文件，其中包含了两支队伍(每队两名选手)的保龄球比赛得分情况。
$ cat scores.txt
Rich Blum,team1,100,115,95
Barbara Blum,team1,110,115,100
Christine Bresnahan,team2,120,115,118
Tim Bresnahan,team2,125,112,116
$

$ cat bowling.sh
#!/bin/bash

for team in $(gawk –F, '{print $2}' scores.txt | uniq)
do
	gawk –v team=$team 'BEGIN{FS=","; total=0}
	{
		if ($2==team)
		{
			total += $3 + $4 + $5;
		}
	}
	END {
		avg = total / 6;
		print "Total for", team, "is", total, ",the average is",avg
	}' scores.txt
done $

你就拥有了一件趁手的工具来计算保龄球锦标赛成绩了。你要做的就是将每位选手的成 绩记录在文本文件中，然后运行这个脚本!
$ ./bowling.sh
Total for team1 is 635, the average is 105.833
Total for team2 is 706, the average is 117.667
$
```



## 