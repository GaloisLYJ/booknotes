# VLESS+WS+TLS+WEB+(CDN)

---

## 海外云服务器

- [亿速云](https://uc.yisu.com/index.php/vhost/lightserver.html)
- 操作系统：Ubuntu Server 20.04 LTS 64位

![亿速云](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E4%BA%BF%E9%80%9F%E4%BA%91Ubuntu.png?token=GHSAT0AAAAAAC3ELS3CXLIQFBKCBBAOPEHOZ2NQMWQ)

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

  ![cf上进行dns解析](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/%E5%9F%9F%E5%90%8DDNS%E8%A7%A3%E6%9E%90.png?token=GHSAT0AAAAAAC3ELS3CEIQSCNH246BZ6UUAZ2NQUWQ)

- 解析成功验证

  <img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/dns%E8%A7%A3%E6%9E%90%E6%A0%A1%E9%AA%8C.png?token=GHSAT0AAAAAAC3ELS3CCAIBDVF6PIRAXI64Z2NQUGA" alt="dns解析校验" style="zoom:60%;" />

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

  ![Xray服务端配置](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Xray%E6%9C%8D%E5%8A%A1%E7%AB%AF%E9%85%8D%E7%BD%AE.png?token=GHSAT0AAAAAAC3ELS3DJYGUZSZIKY3XNQVSZ2NQT2A)

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

  ![V2rayN下载](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/V2rayN%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%B8%8B%E8%BD%BD.png?token=GHSAT0AAAAAAC3ELS3D3K2ILIFSP3HMFKWAZ2NQTNA)

- V2rayN配置

  ![V2rayN配置](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/V2rayN%E5%AE%A2%E6%88%B7%E7%AB%AF%E9%85%8D%E7%BD%AE.png?token=GHSAT0AAAAAAC3ELS3DV3RHOK7PYY7NSKFQZ2NQSZA)

  ```
  1、注意伪装域名、传输协议、端口、uuid、底层传输安全等关键配置即可。
  2、ws是websocket应用层传输协议和http并论，都基于tcp，tcp是传输层协议
  3、右击管理员打开软件，开启tun模式(多切换下)，自动配置系统代理，全局模式下，可以打通所有软件和网页。
  ```


- [V2rayNG 安卓下载](https://github.com/2dust/v2rayNG/releases)

  ![V2rayN客户端](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/V2rayNG%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%B8%8B%E8%BD%BD.png?token=GHSAT0AAAAAAC3ELS3CEU3BLLKW3UCLLHP2Z2NQSJQ)

## google连接测试

<img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/google%E8%BF%9E%E6%8E%A5%E6%B5%8B%E8%AF%95.png?token=GHSAT0AAAAAAC3ELS3CCCWU7F2WEQC765G2Z2NQRWQ" alt="google" style="zoom:50%;" />

---



## CDN  内容分部网络

- [使用CDN的好处](https://www.youtube.com/watch?v=Azj8-1rdF-o&t=630s)
  
  - 防止IP被封
  
  - 解封IP服务器
  
  - 理论情况下可以加速网络
  
    ```
    网络越狱实践除外，因为需要套国内CDN。
    此外使用CF的人过多，可能已被GFW重点关照。
    免费CDN链路会被防火墙劣化，使用加密数据基本不会命中缓存。
    ```
  
- CloudFlare CDN

  点亮云图案，等待两三分钟，ping v.zxe.us.kg检查IP是否不为服务器IP，即得到套了CDN的域名

  ```
  v.zxe.us.kg
  ```

  ![cf的CDN](D:\booknotes\云服务器之科学上网\file\CF的CDN.png)

- CloudFlare CDN 节点配置使用

  ![CDN节点配置](D:\booknotes\云服务器之科学上网\file\CDN节点配置.png)