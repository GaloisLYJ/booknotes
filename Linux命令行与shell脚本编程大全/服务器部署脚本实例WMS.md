## 微服务部署脚本
此脚本是基于SpringBoot、SpringCoud、Maven架构批量自动化部署服务脚本。
`/home/admin` 下有 `sudo2` 类似名称的脚本，显示为绿色

```
服务器IP：http://10.9.43.105
连接工具：BitVise
打包方式：IDEA 总包PAAS maven install
传输方式：工具拖动到对应war或jar替换
登录方式：密码
部署校测：http://10.9.43.105:8761 (SpringCloud注册发现，可以看到在运行的服务)
```

```
nohup java -jar xxx.jar 
```
以后台方式运行jar任务


以下是WMS项目部署的具体脚本：先停掉所有java进程(因为可以同时开启多个服务所以不能直接启动)，再重启
````
脚本名 + stop
```
停掉所有服务

```
脚本名 + start
```
开启所有服务

```shell
#! /bin/sh  
PORT=9091
PORT2=9090
PORT3=8761
SER_PORT=8889
WEB_PORT=8080
SAP_PORT=8888
SCAN_PORT=8081


SERVICE='/home/admin/tomcat-service/bin'
WEB='/home/admin/tomcat-web/bin'  
SAP='/home/admin/tomcat-sap/bin'
SCAN='/home/admin/tomcat-scan/bin'


HOME='/home/admin/wms_jar'   
JAR_HOME1=wms-webservice-1.0-SNAPSHOT.jar
JAR_HOME2=admin-service-1.0-SNAPSHOT.jar  
JAR_HOME3=eureka-server-1.0-SNAPSHOT.jar


pid=`netstat -apn | grep $PORT | awk '{print $7}' | cut -d/ -f 1`
pid2=`netstat -apn | grep $PORT2 | awk '{print $7}' | cut -d/ -f 1`
pid3=`netstat -apn | grep $PORT3 | awk '{print $7}' | cut -d/ -f 1`

SER_PID=`netstat -apn | grep $SER_PORT | awk '{print $7}' | cut -d/ -f 1`
WEB_PID=`netstat -apn | grep $WEB_PORT | awk '{print $7}' | cut -d/ -f 1`
SAP_PID=`netstat -apn | grep $SAP_PORT | awk '{print $7}' | cut -d/ -f 1`
SCAN_PID=`netstat -apn | grep $SCAN_PORT | awk '{print $7}' | cut -d/ -f 1`

export JAVA_HOME=/usr/local/jdk1.8

stop() { 
 if [ "$SCAN_PID" != "" ];then  
   kill -9 $SCAN_PID
 fi   
 echo "scan-service:stop.............."
 sleep 10
 
 if [ "$pid" != "" ];then  
   kill -9 $pid
 fi   
 echo "wms-webservice:stop.............."
 sleep 10
 
 if [ "$pid2" != "" ];then  
   kill -9 $pid2
 fi   
 echo "admin-service:stop.............."
 sleep 10
 
 if [ "$SER_PID" != "" ];then  
   kill -9 $SER_PID
 fi   
 echo "wms-service:stop.............."
 sleep 10
 
 if [ "$WEB_PID" != "" ];then  
   kill -9 $WEB_PID
 fi   
 echo "web-service:stop.............."
 sleep 10
  
 if [ "$SAP_PID" != "" ];then  
   kill -9 $SAP_PID
 fi   
 echo "sap-service:stop.............."
 sleep 10 
 
 if [ "$pid3" != "" ];then  
   kill -9 $pid3
 fi
 sleep 10   
 echo "eureka-service:stop.............."
 sleep 1
 
}  
  
start() {
	
  if [ "$pid3" == "" ];then  
     cd $HOME  
     nohup java -jar $JAR_HOME3& > e.log  
  fi
  sleep 15 
  echo "eureka-service:start............."
  sleep 5  
	
  cd $SERVICE
  ./startup.sh
  sleep 10
  echo "wms-service:start................"
  sleep 5
  
  
  cd $WEB
  ./startup.sh
  sleep 10
  echo "web:start........................"  
  sleep 5
  
  cd $SCAN
  ./startup.sh
  sleep 10
  echo "scan:start........................"  
  sleep 5
  
  
  cd $SAP
  ./startup.sh
  sleep 10
  echo "sap-service:start........................" 
  sleep 5
  
  if [ "$pid" == "" ];then  
     cd $HOME  
     nohup java -jar $JAR_HOME1& > w.log  
  fi
  sleep 35 
  echo "wms-webservice:start............."
  sleep 5
  
  if [ "$pid2" == "" ];then  
     cd $HOME  
     nohup java -jar $JAR_HOME2& > a.log  
  fi
  sleep 40 
  echo "admin-service:start............."
  
}

stope(){
 if [ "$pid3" != "" ];then  
 kill -9 $pid3
 fi   
 echo "eureka-service:stop.............."
 sleep 1
}

stopa(){
 if [ "$pid2" != "" ];then  
   kill -9 $pid2
 fi   
 echo "admin-service:stop.............."
 sleep 1
}

stopsap(){
 if [ "$SAP_PID" != "" ];then  
   kill -9 $SAP_PID
 fi   
 echo "sap-service:stop.............."
 sleep 10 
}

stopweb(){
 if [ "$WEB_PID" != "" ];then  
   kill -9 $WEB_PID
 fi   
 echo "web-service:stop.............."
 sleep 10	
}

stopscan(){
 if [ "$SCAN_PID" != "" ];then  
   kill -9 $SCAN_PID
 fi   
 echo "scan:stop.............."
 sleep 10	
}

stopser(){
	
 if [ "$SER_PID" != "" ];then  
   kill -9 $SER_PID
 fi   
 echo "wms-service:stop.............."
 sleep 10
}

stopw(){
 if [ "$pid" != "" ];then  
   kill -9 $pid
 fi   
 echo "wms-webservice:stop.............."
 sleep 1	
	
}
 
starte(){

  if [ "$pid3" == "" ];then  
     cd $HOME  
     nohup java -jar $JAR_HOME3& > e.log  
  fi
  sleep 1 
  echo "eureka-service:start............."
  sleep 20
	
}

starta(){
	
  if [ "$pid2" == "" ];then  
     cd $HOME  
     nohup java -jar $JAR_HOME2& > a.log  
  fi
  sleep 1 
  echo "admin-service:start............."
  sleep 1
	
}

startw(){

  if [ "$pid" == "" ];then  
     cd $HOME  
     nohup java -jar $JAR_HOME1& > w.log  
  fi
  sleep 1 
  echo "wms-webservice:start............."
  sleep 1
	
}
  
startweb(){
  cd $WEB
  ./startup.sh
  sleep 10
  echo "web:start........................"  
  sleep 5
}

startscan(){
  cd $SCAN
  ./startup.sh
  sleep 10
  echo "scan:start........................"  
  sleep 5
}

startsap(){
  cd $SAP
  ./startup.sh
  sleep 10
  echo "sap-service:start........................" 
  sleep 5
}

startser(){
  cd $SERVICE
  ./startup.sh
  sleep 10
  echo "wms-service:start................"
  sleep 5
}
  
case $1 in  
  start)  
    start  
  ;;  
  stop)  
    stop  
  ;;
  stope)  
    stope 
  ;;
  stopa)  
    stopa 
  ;; 
  stopw)  
    stopw 
  ;;
  stopweb)  
    stopweb 
  ;;
  stopscan)  
    stopscan 
  ;;
  stopsap)  
    stopsap 
  ;;
  stopser)  
    stopser 
  ;;
   startw)  
    startw 
  ;;
  starta)  
    starta 
  ;;
  start-e)  
    starte 
  ;;
  startweb)  
    startweb 
  ;;
  startscan)  
    startscan 
  ;;
  startsap)  
    startsap 
  ;;
  startser)  
    startser 
  ;; 
  *)  
  echo "Script command:stop,start"  
   exit 0  
  ;;  
esac
```

 

