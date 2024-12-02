# VLESS+WS+TLS+(CDN)

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

## 服务端

- [永久域名申请教程](https://www.youtube.com/watch?v=5eFwyapO9ew)

- [身份生成网址](https://www.shenfendaquan.com/)

  ```
  username:thewall
  legal full name:Gladys P James
  email:sio13lag@protonmail.com
  phone:+1-4433184481
  fuu address:4250 Five Points,Bel Air,Maryland
  password:lYj3354130
  ```

- [预备永久免费域名](https://register.us.kg/panel/main)

  一个用户身份可以申请三个us.kg永久域名，以下是已经申请的其中一个

  ```
  zxe.us.kg
  ```

- 已经将该域名DNS解析到该服务器IP

  ![dns解析](D:\booknotes\云服务器之科学上网\file\域名DNS解析.png)

- 解析成功验证

  <img src="D:\booknotes\云服务器之科学上网\file\dns解析校验.png" alt="dns解析校验" style="zoom:60%;" />

- 安装curl

  ```bash
  apt install -y curl
  ```

- 一键脚本

  - 引用源仓库的一键脚本

    ```bash
    bash <(curl -sL https://raw.githubusercontent.com/daveleung/hijkpw-scripts-mod/main/xray_mod1.sh)
    ```

  - [GaloisLYJ仓库](https://github.com/GaloisLYJ/hijkpw-scripts-mod)一键脚本

    ```bash
    bash <(curl -sL https://raw.githubusercontent.com/GaloisLYJ/hijkpw-scripts-mod/refs/heads/main/xray_mod1.sh)
    ```

- 示例

  ![Xray服务端配置](D:\booknotes\云服务器之科学上网\file\Xray服务端配置.png)

- 脚本执行过程配置实例

  ```
   Xray运行状态：已安装 未运行
   Xray配置文件:  /usr/local/etc/xray/config.json
   Xray配置信息：
   协议:  VLESS
   IP(address):  156.232.13.97
   端口(port)：443
   id(uuid)：ba6583d5-7fd4-4fc6-844e-55c31df0cea3
   流控(flow)：无
   加密(encryption)： none
   传输协议(network)： ws
   伪装类型(type)：none
   伪装域名/主机名(host)/SNI/peer名称：zxe.us.kg
   路径(path)：/lyj
   底层安全传输(tls)：TLS
  ```

   - 再次执行和配置

     ```bash
     bash <(curl -sL https://raw.githubusercontent.com/daveleung/hijkpw-scripts-mod/main/xray_mod1.sh)
     ```

## 客户端

- [V2rayN  PC下载](https://github.com/2dust/v2rayn/releases)

  没有MacOS

  ![小飞机下载](D:\booknotes\云服务器之科学上网\file\V2rayN客户端下载.png)

- V2rayN配置

  ![V2rayN配置](D:\booknotes\云服务器之科学上网\file\V2rayN客户端配置.png)

  ```
  1、注意伪装域名、传输协议、端口、uuid、底层传输安全等关键配置即可。
  2、ws是websocket应用层传输协议和http并论，都基于tcp，tcp是传输层协议
  ```


- [V2rayNG 安卓下载](https://github.com/2dust/v2rayNG/releases)

  ![V2rayN客户端](D:\booknotes\云服务器之科学上网\file\V2rayNG客户端下载.png)

## google连接测试

<img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/google%E8%BF%9E%E6%8E%A5%E6%B5%8B%E8%AF%95.png" alt="google" style="zoom:50%;" />