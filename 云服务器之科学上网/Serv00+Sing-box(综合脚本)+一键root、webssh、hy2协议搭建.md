# Serv00，Serv00-play，root和webssh，hy2协议搭建

---

## 教程说明

   - [视频教程](https://www.youtube.com/@frankiejun8965)

   - [Sin-box](https://github.com/frankiejun/serv00-play) argo+vmess/vmess+ws/hy2/socks5/mtproto/alist/哪吒探针/sun-panel/webssh 等, 自动化部署、批量保号、进程防杀、消息推送

     该github仓库已fork
     
     本笔记为进阶版本，sev00等前置知识不再介绍

## serv00 一键root

- thepassword0001一键root

  ```bash
  #serv00-play 综合脚本
  bash <(curl -Ls https://raw.githubusercontent.com/frankiejun/serv00-play/main/start.sh)
  
  #serv00-play 综合脚本 1安装过后，快捷进入
  ss
  
  #serv00-play fork脚本
  bash <(curl -Ls https://raw.githubusercontent.com/GaloisLYJ/serv00-play/refs/heads/main/start.sh)
  ```
  
  ![Serv00-play安装](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00-play%E5%AE%89%E8%A3%85.png)
  
  ```
  依次是：22
  ```
  
  ![serv00-play 一键root](D:\booknotes\云服务器之科学上网\file\Serv00-play 一键root.png)
  
  ```bash
  id
  查看当前用户
  ```
  
  该root不影响搭建的hy2服务

## serv00 webssh

- galoisliuyujian webssh

  ```bash
  #serv00-play fork脚本
  bash <(curl -Ls https://raw.githubusercontent.com/GaloisLYJ/serv00-play/refs/heads/main/start.sh)
  
  #serv00-play 综合脚本 1安装过后，快捷进入
  ss
  
  依次输入：3、自定义域名
  ```

  <img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00%20webssh.png" alt="serv00 webssh" style="zoom:60%;" />
  
  https://myssh.us.kg/
  ![myssh](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/myssh.png)

## serv00 hy2 搭建

- thepassword0001 服务端安装和配置

  ```bash
  #serv00-play 综合脚本
  bash <(curl -Ls https://raw.githubusercontent.com/frankiejun/serv00-play/main/start.sh)
  
  #serv00-play 综合脚本 1安装过后，快捷进入
  ss
  
  #serv00-play fork脚本
  bash <(curl -Ls https://raw.githubusercontent.com/GaloisLYJ/serv00-play/refs/heads/main/start.sh)
  ```

  ![Serv00-play安装](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00-play%E5%AE%89%E8%A3%85.png)

  ```
  依次是：1、7、8、10
  按步骤输入，serv00开放的端口即可，外部伪装这里选n，则是www.bing.com
  ```

  ![serv00-play hy2启动](https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/Serv00-paly%20hy2%E5%90%AF%E5%8A%A8.png)

- 客户端使用和配置

  - 使用支持hy2的v2rayN客户端，复制节点地址黏贴进去

    ```bash
    hysteria2://3baef01e-355a-467a-87cf-fa78545d57d5@188.68.250.202:9649/?sni=www.bing.com&alpn=h3&insecure=1#Hy2-s15-thepassword0001
    ```

    双击节点，设置跳过证书验证：

    ```
    跳过证书验证 allowInsecure ：ture
    ```

    右击节点，测试服务器真连接延迟。设为活动服务器。

    google连接测试

    <img src="https://raw.githubusercontent.com/GaloisLYJ/booknotes/refs/heads/master/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91/file/google%E8%BF%9E%E6%8E%A5%E6%B5%8B%E8%AF%95.png" alt="google" style="zoom:50%;" />