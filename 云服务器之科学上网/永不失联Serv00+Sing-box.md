# 永久免费服务器Serv00，Sing-box代理节点搭建

---

## 波兰永久免费服务器

- [Serv00](https://www.serv00.com/)

  3G存储，512mb内存，无限流量，十年起步免费

  请至少3个月内进行一次ssh或web登录，或者用脚本，否则会被删号

- 账号注册

  ![账号注册](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E6%B3%A8%E5%86%8C.png)

  注册要点：
  1、使用代理的节点访问网站进行注册，多更换尝试，这里使用的是v2rayN，5.6top订阅中的台湾节点注册成功
  2、使用gmail、outlook等大型邮箱，临时的也行(自行谷歌)，protonmail等待验证

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

## SSH连接工具

- [XSHELL](https://www.xshell.com/zh/free-for-home-school/)

- [MobaXterm](https://mobaxterm.mobatek.net/)

- [FinalShell](https://www.hostbuf.com/t/988.html)

- [SecureCrt](https://www.vandyke.com/products/securecrt/)

- FinalShell连接到156.236.75.59跳板机，再ssh root@[s14.serv00.com](http://s14.serv00.com/) 命令

  如果ssh登录失败，可以尝试[ip解锁](https://www.serv00.com/ip_unban/)

## 教程说明

   - [视频教程](https://www.youtube.com/watch?v=gOc1J91PAFo)

   - [Sin-box](https://github.com/GaloisLYJ/Sing-box) Serv00|CT8一键三协议安装脚本vless-reality|hy2|tuic5

     该github仓库已fork

## 服务端

- 第一次安装和配置

  ```bash
  #一键安装三种协议vless-reality|hy2|tuic5
  bash <(curl -Ls https://raw.githubusercontent.com/eooce/sing-box/test/sb_00.sh)
  ```
  
  ![Sing-box安装](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E7%9A%84Sing-box%E5%AE%89%E8%A3%85.png)
  
不按照探针，其他依次输入即可获得节点链接三个。
  

## 客户端

- [v2rayN下载]([https://github.com/2dust/v2rayN/releases/latest](https://bulianglin.com/g/aHR0cHM6Ly9naXRodWIuY29tLzJkdXN0L3YycmF5Ti9yZWxlYXNlcy9sYXRlc3Q))

  ![支持hy2版的V2rayN下载](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E6%94%AF%E6%8C%81hy2%E7%89%88%E7%9A%84V2rayN%E4%B8%8B%E8%BD%BD.png)

- [hy2下载]([https://github.com/apernet/hysteria/releases](https://bulianglin.com/g/aHR0cHM6Ly9naXRodWIuY29tL2FwZXJuZXQvaHlzdGVyaWEvcmVsZWFzZXM))

  注意不要下错版本，darwin是macos，freebsd是类uniux，arm是不同x86的一种芯片

  ![hy2下载](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E4%B8%8B%E8%BD%BD.png)

   - hy2客户端文件替换，hysteria和hysteria2两个文件夹都替换

     ![hy2客户端文件替换](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%96%87%E4%BB%B6%E6%9B%BF%E6%8D%A2.png)

- 使用支持hy2的v2rayN客户端，复制节点地址黏贴进去

  ```bash
  vless://bc97f674-c578-4940-9234-0a1da46041b9@188.68.240.161:38111?encryption=none&flow=xtls-rprx-vision&security=reality&sni=www.cerebrium.ai&fp=chrome&pbk=ySuX5fxZwxVOW2bFEgC8xRlUqtBVwncZWVxhH1nfMyI&type=tcp&headerType=none#-s14-reality
  
  hysteria2://bc97f674-c578-4940-9234-0a1da46041b9@188.68.240.161:20273/?sni=www.bing.com&alpn=h3&insecure=1#-s14-hy2
  
  tuic://bc97f674-c578-4940-9234-0a1da46041b9:admin123@188.68.240.161:38120?sni=www.bing.com&congestion_control=bbr&udp_relay_mode=native&alpn=h3&allow_insecure=1#-s14-tuic
  ```
  
  双击节点，将：
  
  ```
  跳过证书验证 allowInsecure ：ture
  ```
  
  右击节点，测试服务器真连接延迟。设为活动服务器。

## google连接测试

<img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/google%E8%BF%9E%E6%8E%A5%E6%B5%8B%E8%AF%95.png" alt="google" style="zoom:50%;" />

延迟经测268ms均非常不错了

## 全场景使用

1、开启tun模式，自动配置系统代理，路由全局，可以畅联电脑所有软件使用(如gitbash)。此时部分网站如github不支持使用，关闭tun即可。

2、关闭tun模式，自动配置系统代理，路由全局，可以解禁网页如github。印象笔记、qq邮箱因其自身检测的问题暂未通过。

![全场景使用](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E7%9A%84V2rayN%E5%85%A8%E5%9C%BA%E6%99%AF.png)

注意这里的版本：v6.60。

<img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E7%9A%84git.png" alt="serv00的git亲测可用" style="zoom:60%;" />