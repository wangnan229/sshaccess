# sshaccess

> 这是一个可以脚本化打通主机间相互SSH登录的试验性的小工具


* 原理流程：
  使用其中1台装有FTP服务的主机作为中介，将每台主机的公钥文件id_rsa.pub上传到这台主机上的FTP目录中。然后逐台主机从FTP下载公钥，并加入到自己的authorized_keys文件中。
## 使用步骤及说明
* 先在FTP主机上创建好保存主机id_rsa.pub的目录，ftp用户对此目录有写权限，比如/home/ftpuser/pubkey
* 在非FTP主机上，每台主机都执行commonhostrun_1.sh脚本，其目的是生成id_rsa.pub，并重命名id_rsa_[主机名].pub后上传到FTP目录。
* 转到FTP主机，执行ftphostrun.sh脚本，其目的是生成id_rsa.pub，并重命名id_rsa_[主机名].pub后上传到FTP目录，然后将所有主机的id_rsa_[主机名].pub加入到authorized_keys中。
* 再转到非FTP主机，每台主机都执行commonhostrun_2.sh脚本，其目的是从FTP目录下载所有主机的id_rsa_[主机名].pub加入到authorized_keys中，完成。

## 配置
配置项位于commonhostrun_1.sh：
HOSTIP=192.168.176.200,192.168.176.100,192.168.176.101   # 所有主机地址
HOSTNAME=ks-allinone,VMmaster,node1                      # 所有主机名，与主机地址要一一位置对应，不能错了。
FTP_HOST_IP=192.168.176.200                              # FTP主机地址
USERNAME=ftpuser                                         # FTP主机登录用户
PASSWORD=0000                                            # FTP主机登录用户密码
FTP_HOST_DIR=/home/ftpuser/pubkey                        # FTP保存所有主机公钥id_rsa_[主机名].pub的目录
FTP_PORT=21                                              # FTP端口
LOCAL_DIR=$FTP_HOST_DIR                                  # 各主机上的从FTP公钥目录下载后存放的地址，一般跟其一致即可

我的3台主机的执行后的截图：
FTP主机名： ks-allinone
非FTP主机名：VMmaster、node1
FTP主机上的公钥目录：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200414222828133.png)

VMmaster上的从FTP目录下载下来的公钥目录，node1也一样：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200414223044493.png)
