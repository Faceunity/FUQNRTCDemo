# FUQNRTCDemo 快速接入文档

FUQNRTCDemo 是集成了 [Faceunity](https://github.com/Faceunity/FULiveDemo/tree/dev) 面部跟踪和虚拟道具功能 和 [七牛云视频通话](https://github.com/pili-engineering/QNRTC-iOS) 功能的 Demo。

**本文是 FaceUnity SDK  快速对接 七牛云视频通话 的导读说明**

**关于  FaceUnity SDK 的更多详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)**

### 一、导入 SDK

将  FaceUnity  文件夹全部拖入工程中，NamaSDK所需依赖库为 `OpenGLES.framework`、`Accelerate.framework`、`CoreMedia.framework`、`AVFoundation.framework`、`libc++.tbd`、`CoreML.framework`

- 备注: 上述NamaSDK 依赖库使用 Pods 管理 会自动添加依赖,运行在iOS11以下系统时,需要手动添加`CoreML.framework`,并在**TARGETS -> Build Phases-> Link Binary With Libraries**将`CoreML.framework`手动修改为可选**Optional**

### FaceUnity 模块简介
```C
-FUManager              //nama 业务类
-FUCamera               //视频采集类(示例程序未用到)   
-authpack.h             //权限文件

+FUAPIDemoBar     //美颜工具条,可自定义
+items       //贴纸和美妆资源 xx.bundel文件
      
```

### 二、加入展示 FaceUnity SDK 美颜贴纸效果的UI

1、在 `QRDRTCViewController.m` 中添加头文件，并创建页面属性

```C
#pragma mark ----- FaceUnity ----
#import "FUManager.h"
#import "FUAPIDemoBar.h"
#pragma mark ----- FaceUnity ----

@property (nonatomic, strong) FUAPIDemoBar *demoBar ;

```

2、初始化 UI，并遵循代理  FUAPIDemoBarDelegate ，实现代理方法 `bottomDidChange:` 切换贴纸 和 `filterValueChange:` 更新美颜参数。

```C
/// 初始化demoBar
- (FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 164 - 240, self.view.frame.size.width, 164)];
        _demoBar.mDelegate = self;
    }
    return _demoBar ;
}

```

#### 切换贴纸

```C
// 切换贴纸
-(void)bottomDidChange:(int)index{
    if (index < 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeBeautify];
    }
    if (index == 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeStrick];
    }
    
    if (index == 4) {
        [[FUManager shareManager] setRenderType:FUDataTypeMakeup];
    }
    if (index == 5) {
        [[FUManager shareManager] setRenderType:FUDataTypebody];
    }
}

```

#### 更新美颜参数

```C
// 更新美颜参数    
- (void)filterValueChange:(FUBeautyParam *)param{
    [[FUManager shareManager] filterValueChange:param];
}
```

### 三、在 `viewDidLoad:` 中初始化 SDK  并将  demoBar 添加到页面上

```C
/**     -----  FaceUnity  ----     **/
[[FUManager shareManager] loadFilter];
[FUManager shareManager].isRender = YES;
[FUManager shareManager].flipx = YES;
[FUManager shareManager].trackFlipx = YES;
[self.view addSubview:self.demoBar];
/**     -----  FaceUnity  ----     **/

```

### 四、在视频数据回调中 加入 FaceUnity  的数据处理

在 `QNRTCEngineDelegate` 代理方法中,可以看到
```C
/*!
 * @abstract 摄像头原数据时的回调。
 *
 * @discussion 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致编码帧率下降。
 *
 * @since v2.0.0
 */
- (void)RTCEngine:(QNRTCEngine *)engine cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer;
```
```C
- (void)RTCEngine:(QNRTCEngine *)engine cameraSourceDidGetSampleBuffer:(CMSampleBufferRef)sampleBuffer{

    //可以对 sampleBuffer 做美颜/滤镜等操作
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    
}
```

### 五、销毁道具

1 视图控制器生命周期结束时,销毁道具
```C
[[FUManager shareManager] destoryItems];
```

2 切换摄像头需要调用,切换摄像头
```C
[[FUManager shareManager] onCameraChange];
```

### 关于 FaceUnity SDK 的更多详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)