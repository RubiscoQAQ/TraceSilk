# TraceSilk
# ios课程大作业:《TraceSilk：踪丝》

## 简单的利用PhotosKit和CoreML实现的图片定位软件

### 1.软件简介

帮助用户轻松获取目标图片的定位信息，像《哈利波特》中的踪丝一样，即使是天涯海角，也无处可藏。

从此再也不用担心不认识朋友圈朋友发的景点照片啦！轻轻一点，不必尴尬私聊也能看见TA们的旅行好去处！

### 2.软件核心方法

软件采取两种方式获取图片定位。

- 通过PhotosKit提供的API，获取拍摄照片时提供的地理位置信息，并将它标注在地图上。
- 如果图片没有地理位置信息，则通过[在AWS EC2上使用Apache MXNet和Multimedia Commons数据集估计图像的位置](https://aws.amazon.com/cn/blogs/machine-learning/estimating-the-location-of-images-using-mxnet-and-multimedia-commons-dataset-on-aws-ec2/)文中提供的模型转为mlmodel，并使用此模型进行预测，对较著名地点有不错的效果。

### 3.实现功能

- 使用最新的PhotosKit从相册加载图片
- 获取图片地址信息或使用模型预测地址信息
- 调用MapKit实现位置在地图上的标示
- 按钮调用Safari浏览器进入“关于”页面

### 4.遇到的问题

```swift
  if let asset: PHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset 
```

**总是返回nil的问题：**

  ​		可能是由于UIImagePickerController已经可以被PHPickerViewController替代的缘故，更换到PHPicker可以解决[参考博文](https://www.felixlarsen.com/blog/photo-metadata-phpickerview)

**图片地理位置读取不到的问题：**

  在info.plist中请求对应权限可解决!
###  5.预期效果
![预期效果图-预测][1]
![预期效果图-获取][2]


  [1]: https://rubisco.cn/usr/uploads/2021/01/4226629343.png
  [2]: https://rubisco.cn/usr/uploads/2021/01/2550416190.png
