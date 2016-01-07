#app是对iOS Apprentice的学习写的.

##app中全部用的都是tableView
 - 了解到了有关tableView相关方法的使用 数据源,协议等
##采用storyboard来布局, appUI比较简单
  - 了解到了prepareForSegue:sender方法的使用, 页面将的跳转会调用这个方法

##控制器之间值的传递
  - 控制器A 传值给控制器B, 则定义控制B一个属性,将值传给属性
  - 控制器B 传值给控制器A, 需要控制器B定义一个代理协议, 控制器A实现代理方法

##数据持久化
  - Plist文件
  - NSCoding, 归档与解档, NSKeyArchiver NSKeyUnArchiver
  - NSUserDefaults , 采用类似字典的形式
##本地通知
  - schedule notification, 将通知安排到系统通知中
  - cancel notification, 不需要时要从系统通知中删除通知

##swift一些基础知道 
 