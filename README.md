# GitTools
Linux系统 gittools工具

1.该工具作用:
  1.1.可以自动化上库代码
  1.2.可以自动化将版本回退到自己需要的特定版本
  1.3.可以自动化选择项目下载

2.配置
  2.1.ProjectConfig.xml文件中按照固定格式将项目
      初始化命令以及编译命令填入xml文件中
  2.2将该文件路径按照下面格式配置.bashrc文件

    利用vim .bashrc命令打开文件

    在该文件最后两行添加
    export GitTool = 该工具文件存在路径
    export PATH="$PATH:$GitTool"

  2.3配置好以后运行 source .bashrc即可
  
3.接下来随便哪里运行gittool.sh即可正常使用该工具

4.文件说明:
针对部分linux中文显示乱码问题，特定出了一个英文版本
请配置完成以后，输入gittoolen.sh命令运行即可，
且请将项目信息配置到ProjectConfigEn.xml文件中，请注意使用英文描述


具体运行效果，可以查看下载包中"效果演示文档"


欢迎大家有问题或者疑问可以添加QQ:2251858097
或者邮件:2251858097@qq.com

