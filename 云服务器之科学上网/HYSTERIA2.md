# Hysteria2，hy2，歇斯底里2

---

## 海外云服务器

- [亿速云](https://uc.yisu.com/index.php/vhost/lightserver.html)
- 操作系统：Ubuntu Server 20.04 LTS 64位

![亿速云](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E4%BA%BF%E9%80%9F%E4%BA%91Ubuntu.png)

## SSH连接工具

- [XSHELL](https://www.xshell.com/zh/free-for-home-school/)
- [MobaXterm](https://mobaxterm.mobatek.net/)
- [FinalShell](https://www.hostbuf.com/t/988.html)
- [SecureCrt](https://www.vandyke.com/products/securecrt/)
- Mac ssh root@156.236.75.59 命令

## 教程说明

   - [文本教程](https://bulianglin.com/archives/hysteria2.html)

   - [视频教程](https://www.youtube.com/watch?v=CXj-ID33MhU)

   - 环境说明

     1、基于Ubuntu22.04

     2、先查看防火墙状态并关闭

     ```bash
     ufw status
     ufw disable
     ```

## 服务端

- 第一次安装和配置

  ```bash
  #一键安装Hysteria2
  bash <(curl -fsSL https://get.hy2.sh/)
  
  #设置开机自启
  systemctl enable hysteria-server.service
  ```

  ![hy2安装](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E5%AE%89%E8%A3%85.png)

  ```bash
  #生成自签证书
  openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -subj "/CN=bing.com" -days 36500 && sudo chown hysteria /etc/hysteria/server.key && sudo chown hysteria /etc/hysteria/server.crt
  ```

  [sduo 出现unable to resolve host 解决方法](https://blog.csdn.net/ichuzhen/article/details/8241847)，无碍后续步骤

  设置配置文件，整段复制执行

  ```bash
  cat << EOF > /etc/hysteria/config.yaml
  listen: :443 #监听端口
  
  #使用CA证书
  #acme:
  #  domains:
  #    - mywall.us.kg #你的域名，需要先解析到服务器ip
  #  email: 53241test@sharklasers.com
  
  #使用自签证书
  tls:
    cert: /etc/hysteria/server.crt
    key: /etc/hysteria/server.key
  #以上两段配置任选其一即可，当你的域名有证书的时候可以使用CA证书方式
  
  auth:
    type: password
    password: yujian #设置认证密码
    
  masquerade:
    type: proxy
    proxy:
      url: https://bing.com #伪装网址
      rewriteHost: true
  EOF
  
  #修改配置后记得重新启动服务
  ```

  启动，显示active，server up即为启动成功

  ```bash
  #启动Hysteria2
  systemctl start hysteria-server.service
  #重启Hysteria2
  systemctl restart hysteria-server.service
  #查看Hysteria2状态
  systemctl status hysteria-server.service
  ```

  ![hy2启动成功](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E5%90%AF%E5%8A%A8%E6%88%90%E5%8A%9F.png)

- hy2其他管理脚本相关

  ```bash
  #查看Hysteria2状态
  systemctl status hysteria-server.service
  #停止Hysteria2
  systemctl stop hysteria-server.service
  #设置开机自启
  systemctl enable hysteria-server.service
  #查看日志
  journalctl -u hysteria-server.service
  ```

## 客户端

- [v2rayN下载]([https://github.com/2dust/v2rayN/releases/latest](https://bulianglin.com/g/aHR0cHM6Ly9naXRodWIuY29tLzJkdXN0L3YycmF5Ti9yZWxlYXNlcy9sYXRlc3Q))

  ![支持hy2版的V2rayN下载](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E6%94%AF%E6%8C%81hy2%E7%89%88%E7%9A%84V2rayN%E4%B8%8B%E8%BD%BD.png)

- [hy2下载]([https://github.com/apernet/hysteria/releases](https://bulianglin.com/g/aHR0cHM6Ly9naXRodWIuY29tL2FwZXJuZXQvaHlzdGVyaWEvcmVsZWFzZXM))

  注意不要下错版本，darwin是macos，freebsd是类uniux，arm是不同x86的一种芯片

  ![hy2下载](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E4%B8%8B%E8%BD%BD.png)

   - hy2客户端文件替换，hysteria和hysteria2两个文件夹都替换

     ![hy2客户端文件替换](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%96%87%E4%BB%B6%E6%9B%BF%E6%8D%A2.png)

- 客户端配置文件

  ```bash
  #CA证书时
  server: 156.236.75.59:443
  auth: yujian
  
  bandwidth:
    up: 20 mbps
    down: 100 mbps
    
  tls:
    sni: mywall.us.kg
    insecure: false #使用自签时需要改成true
  
  socks5:
    listen: 127.0.0.1:1080
  http:
    listen: 127.0.0.1:8080
  ```

  ```bash
  #自签证书时
  server: 156.236.75.59:443
  auth: yujian
  
  bandwidth:
    up: 50 mbps
    down: 50 mbps
    
  tls:
    sni: bing.com
    insecure: true #使用自签时需要改成true
  
  socks5:
    listen: 127.0.0.1:1080
  http:
    listen: 127.0.0.1:8080
  ```

  将上述代码复制到一个txt文件中作为hy2节点配置文件。之后打开v2rayN，添加自定义配置服务器。浏览选择该txt文件，类型改为all后可选。socks端口填写客户端配置里面socks5后面的端口。

  ![hy2的v2rayN客户端配置](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/hy2%E7%9A%84V2rayN%E5%AE%A2%E6%88%B7%E7%AB%AF%E9%85%8D%E7%BD%AE.png)

  将该节点设置为活动服务器，下方设置为“自动配置系统代理”。

   - bandwidth说明

     即流量设置，不设置时默认使用BBR拥塞控制算法，网络拥堵时少发包。

     设置了bandwidth，即和服务端的bandwidth设置，比较选一个较低的配置适用。如果服务端没配置bandwidth，则都以客户端的为准。一般流程看4k视频50M下行速率已足够，还能防止速率过大被运营商或VPS商家检测。

     ```bash
     ignoreClientBandwidth: true
     ```

     服务端可以通过以上配置禁用

---

另一种脚本（亲测有效），使用相对简单，但是默认使用bbr拥赛控制算法。

## 教程说明

   - [文本教程](https://github.com/GaloisLYJ/Hysteria2)

   - [视频教程](https://www.youtube.com/watch?v=fWn0UCBRqOg&t=524s)

   - 环境说明

     1、基于Ubuntu22.04

     2、先查看防火墙状态并关闭

     ```bash
     ufw status
     ufw disable
     ```

​       3、在亿速云后台服务器管理，防火墙-放行所有端口

## 服务端

- 更新环境

  ```bash
  apt update -y
  apt install curl sudo -y
  ```

- Hysteria2一键安装脚本

  ```bash
  wget -N --no-check-certificate https://raw.githubusercontent.com/flame1ce/hysteria2-install/main/hysteria2-install-main/hy2/hysteria.sh && bash hysteria.sh
  ```

  依次使用自签证书，随机端口，密码：yujian，sni伪装：www.bing.com，其他都默认

- 设置常启动，显示active，server up即为启动成功

  ```bash
  systemctl start hysteria-server.service    # 启动 hysteria 服务
  systemctl enable hysteria-server.service   # 设置 hysteria 服务 开机自启
  systemctl restart hysteria-server.service  # 重启 hysteria 服务
  systemctl stop hysteria-server.service     # 停止 hysteria 服务
  systemctl status hysteria-server.service   # 查看 hysteria 服务 状态
  journalctl -u hysteria-server.service			 # 查看日志
  ```

- 使用winscp的scp协议连接156.236.75.59下载配置文件

  ```bash
  /root/hy/hy-client.json
  /root/hy/url.txt
  /root/hy/hy-client.yaml
  hysteria2://yujian@156.236.75.59:62766/?insecure=1&sni=www.bing.com#Hysteria2-misaka
  ```

## 客户端

- [v2rayN下载](https://github.com/2dust/v2rayN/releases/latest) v6.60 zz_v2rayN-With-Core-SelfContained 这个版本可以直接粘贴上述订阅链接

- 右击设置为活动服务器，下方系统代理设置为：自动配置系统代理，最后上方重启服务，wifi不要连接软路由

- 也可以通过配置文件使用(可以定义带宽)

  ```bash
  server: 156.236.75.59:62766
  
  auth: yujian
  
  tls:
    sni: www.bing.com
    insecure: true
  
  quic:
    initStreamReceiveWindow: 16777216
    maxStreamReceiveWindow: 16777216
    initConnReceiveWindow: 33554432
    maxConnReceiveWindow: 33554432
  
  bandwidth:
    up: 120 mbps
    down: 100 mbps
  
  fastOpen: true
  
  socks5:
    listen: 127.0.0.1:5678 #注意这里的scoks5端口，v2界面填的时候socks5端口填这个
  http:
    listen: 127.0.0.1:8080
  
  transport:
    udp:
      hopInterval: 30s
  ```

  ​       带宽取决于多方面限制，首先裸奔时连接speedtest.cn就是速度上限。然后连接海外用speedtest.net测试，海外服务器的带宽上限亿速云是10M，vultr是1G(1000M)，Linode是根据内存，如4G有40G带宽输入1G输出，所以国内服务器带宽巨贵。一般来说50M，就足够youtube4k流畅观看。

  ![亿速云带宽](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E4%BA%BF%E9%80%9F%E4%BA%91%E5%B8%A6%E5%AE%BD.png)

## google连接测试

<img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/google%E8%BF%9E%E6%8E%A5%E6%B5%8B%E8%AF%95.png" alt="google" style="zoom:50%;" />

