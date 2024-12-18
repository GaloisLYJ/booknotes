# 永久免费服务器Serv00

---

## 波兰永久免费服务器

- [Serv00](https://www.serv00.com/)

  3G存储，512mb内存，无限流量，十年起步免费

  请至少3个月内进行一次ssh或web登录，或者用脚本，否则会被删号

- 账号注册

  ![账号注册](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E6%B3%A8%E5%86%8C.png)

  注册要点：
  1、使用代理的节点访问网站进行注册，多更换尝试，这里使用的是v2rayN，5.6top订阅中的台湾节点注册成功
  2、使用gmail、outlook等大型邮箱，临时的暂未尝试成功(自行谷歌)，protonmail等待验证

- 注册成功自动收到服务器信息邮件

  ![服务器邮件](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%82%AE%E4%BB%B6.png)

- 操作系统：FreeBSD

  ```bash
  uname -a
  ```

- 服务器后台配置，默认是波兰语，右上角小旗子菜单可以切换language为English

  - 启用允许安装自定义软件

    ![Serv00启用软件安装](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E5%90%AF%E7%94%A8%E8%BD%AF%E4%BB%B6%E5%AE%89%E8%A3%85.png)

  - 通过random随机放开三个端口访问

    ![Serv00端口访问](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E7%AB%AF%E5%8F%A3%E8%AE%BF%E9%97%AE.png)

## 当前账号

 - galoisliuyujian@gmail.com

   ```
   Login:	galoisliuyujian
   Password:	V9pUpkho)w&j6Qd1%r5U
   SSH/SFTP server address:	s14.serv00.com
   Home directory:	/usr/home/galoisliuyujian
   DevilWEB webpanel: https://panel14.serv00.com/
   ```

 - galoisliuyujian@outlook.com

   ```
   Login:	LIUYJ00
   Password:	%3(^8*Bz^f7mDx^%s&9@
   SSH/SFTP server address:	s15.serv00.com
   Home directory:	/usr/home/LIUYJ00
   DevilWEB webpanel: https://panel15.serv00.com/
   ```

## SSH连接工具

- [XSHELL](https://www.xshell.com/zh/free-for-home-school/)

- [MobaXterm](https://mobaxterm.mobatek.net/)

- [FinalShell](https://www.hostbuf.com/t/988.html)

  取消勾选：智能加速、Exec Channel

  ![本地socks5](D:\booknotes\云服务器之科学上网\file\FinalShell本地Socks5配置用于连接Serv00.png)

- [SecureCrt](https://www.vandyke.com/products/securecrt/)

- FinalShell连接到156.236.75.59跳板机，再ssh root@[s14.serv00.com](http://s14.serv00.com/) 命令

  如果ssh登录失败，可以尝试[ip解锁](https://www.serv00.com/ip_unban/)