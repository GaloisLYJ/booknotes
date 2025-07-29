import subprocess

import sys
import codecs

aa = ["liz.peng",
      "sharon.yujian",
      "wu.shuimei"]

# 设置标准输出编码为utf-8编码
sys.stdout = codecs.getWriter('utf-8')(sys.stdout.buffer)

substring = "账户启用       Yes"
print(f"---遍历检查程序开始---")
for v in aa:
    # 使用subprocess模块调用net user命令
    command = f'net user {v} /domain'
    # 使用subprocess模块执行命令并捕获输出
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stdeer=subprocess.PIPE, shell=True)
    stdout,stdeer = process.communicate()

    # 解码输出并打印
    stdout = stdout.decode('gbk')
    stdeer = stdeer.decode('gbk')

    if substring not in stdout:
        print(f"'{v}该账户未启用")
print(f"---遍历检查程序结束---")