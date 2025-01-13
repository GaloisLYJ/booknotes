# 永久免费服务器Serv00，X-UI 面板搭建

---

## 波兰永久免费虚拟主机托管

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


## SSH连接工具

- [XSHELL](https://www.xshell.com/zh/free-for-home-school/)

- [MobaXterm](https://mobaxterm.mobatek.net/)

- [FinalShell](https://www.hostbuf.com/t/988.html)

- [SecureCrt](https://www.vandyke.com/products/securecrt/)

- FinalShell连接到156.236.75.59跳板机，再ssh root@[s14.serv00.com](http://s14.serv00.com/) 命令

  如果ssh登录失败，可以尝试[ip解锁](https://www.serv00.com/ip_unban/)

## 教程说明

   - [视频教程](https://www.youtube.com/watch?v=YCq0pEpG2jE)

   - [X-ui](https://am.809098.xyz/am-serv00-x-ui/) 支持Serv00非root的X-ui安装脚本

     该github仓库已fork

## 服务端

- 第一次安装和配置

  ```bash
  wget -O x-ui.sh -N --no-check-certificate https://raw.githubusercontent.com/amclubs/am-serv00-x-ui/main/x-ui.sh && chmod +x x-ui.sh && ./x-ui.sh
  
  自己仓库：
  wget -O x-ui.sh -N --no-check-certificate https://raw.githubusercontent.com/GaloisLYJ/am-serv00-x-ui/refs/heads/main/x-ui.sh && chmod +x x-ui.sh && ./x-ui.sh
  ```
  
  ![Serv00-Xui](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00-X-ui.png)
  
  依次输入0安装，面板端口，流量监测端口，和X-ui面板账密：admin。
  
  在serv00的配置是，tcp节点流量端口6914，tcp流量监控端口25342，tcp面板访问端口29003
  
- 清除serv00原域名php站点设置

  ![serv00删除php站点域名](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/serv00%E5%88%A0%E9%99%A4php%E7%AB%99%E7%82%B9%E5%9F%9F%E5%90%8D.png)

- 配置代理类型的站点域名

  ![Serv00添加prxoy站点域名](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E6%B7%BB%E5%8A%A0prxoy%E7%AB%99%E7%82%B9%E5%9F%9F%E5%90%8D.png)

- 通过站点域名进行访问

  ![Serv00原站点域名X-ui](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%E5%8E%9F%E7%AB%99%E7%82%B9%E5%9F%9F%E5%90%8DX-ui.png)

- 节点配置

  入站列表——新增——备注：tcp端口，端口改为预留的节点流量端口，其他默认，即可生成一个节点。

  此时是纯Vmess节点，未加tls加密，未web伪装等。

- 解析网站到其他域名，可详见视频后半段

  可实现+ws+tls的节点。并用域名如：serv00.mywall.us.kg访问。

  这里不需要，就默认liuyj00.serv00.net访问即可。因为端口占用，不能同时都有。等后续gxd服务器过期后，可把zxe.us.kg域名解析过来。

## 客户端

- [v2rayN下载]([https://github.com/2dust/v2rayN/releases/latest](https://bulianglin.com/g/aHR0cHM6Ly9naXRodWIuY29tLzJkdXN0L3YycmF5Ti9yZWxlYXNlcy9sYXRlc3Q))

  ![支持hy2版的V2rayN下载](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E6%94%AF%E6%8C%81hy2%E7%89%88%E7%9A%84V2rayN%E4%B8%8B%E8%BD%BD.png)

- 生成的节点使用

  点击X-ui入站列表上的节点——操作——二维码——复制，黏贴到客户端中即可使用。

  ![Serv00-X-ui-Vmess节点配置](D:\booknotes\云服务器之科学上网\file\Serv00-X-ui-Vmess节点配置.png)

## google连接测试

![serv00谷歌连接测试](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/serv00%E8%B0%B7%E6%AD%8C%E8%BF%9E%E6%8E%A5%E6%B5%8B%E8%AF%95.png)

ChatGpt 也可解锁。
