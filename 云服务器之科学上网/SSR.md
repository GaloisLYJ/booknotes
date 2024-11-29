# ShadowrocketR，SSR，酸酸乳

---

## 海外云服务器

- [亿速云](https://uc.yisu.com/index.php/vhost/lightserver.html)
- 操作系统：Ubuntu Server 20.04 LTS 64位

<img src="D:\booknotes\云服务器之科学上网\file\亿速云Ubuntu.png" style="zoom:36%;"/>

## SSH连接工具

- [XSHELL](https://www.xshell.com/zh/free-for-home-school/)
- [MobaXterm](https://mobaxterm.mobatek.net/)
- [FinalShell](https://www.hostbuf.com/t/988.html)
- [SecureCrt](https://www.vandyke.com/products/securecrt/)
- Mac ssh root@156.236.75.59 命令

## 服务端

- 安装wget

  ```bash
  yum -y install wget
  ```

- 一键脚本

  - 源SSR作者仓库的一键脚本 v2.0.38

    ```bash
    wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
    ```

  - [GaloisLYJ仓库](https://github.com/GaloisLYJ/doubi)一键脚本 v2.0.37

    ```bash
    wget -N --no-check-certificate https://raw.githubusercontent.com/GaloisLYJ/doubi/refs/heads/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
    ```

- 脚本执行过程配置实例

  ```
  端口设置：80
  密码设置：yujian
  加密方式：1 none
  协议插件：5 auth_chain_a
  混淆插件：1 plain
  设备数、线程限速、端口限速配置。默认Enter
  ```

  <img src="D:\booknotes\云服务器之科学上网\file\SSR服务端配置.png" style="zoom:60%;" />

## 客户端

- 小飞机下载

  ![小飞机下载](D:\booknotes\云服务器之科学上网\file\小飞机下载.png)

- 小飞机配置

  复制SSR链接，右击小飞机图标选择剪贴板批量导入ssr链接

  ![小飞机配置](D:\booknotes\云服务器之科学上网\file\SSR客户端配置.png)

  ```
  系统代理模式：PAC模式
  系统代理规则：绕过局域网和大陆
  ```

  ## google连接测试

  <img src="D:\booknotes\云服务器之科学上网\file\google连接测试.png" alt="google" style="zoom:50%;" />

  