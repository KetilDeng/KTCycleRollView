# KTCycleRollView
### 轻量级图片轮播组件。
### 效果图：
![image](https://github.com/KetilDeng/KTCycleRollView/blob/master/sources/rollview.gif)

### 使用简单
```
CycleRollView *cyclerRollView = [CycleRollView cycleRollWithFrame:CGRectMake(0,0, 375, 135) placeholder:nil];
cyclerRollView.imageURLs = @[@"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b919050a32.png",
                             @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b926fa84c0.png",
                             @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b92ee7702c.png",
                             @"http:\/\/img.yishouapp.com\/2017\/12\/30\/5a479a221a186.png"];
[self.view addSubview:centeCyclerRollView];
```

### 类方法
```
+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type delegate:(id<CycleRollViewDelegate>)delegate placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer;
+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer;
+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type placeholder:(UIImage *)image;
+ (instancetype)cycleRollWithFrame:(CGRect)frame placeholder:(UIImage *)image;
```

### 参数说明
type：圆点的对齐方式

```
typedef NS_ENUM(NSInteger, CycleRollPageControlAlignType) {
    CycleRollPageControlAlignTypeCenter = 0, //圆点居中对齐
    CycleRollPageControlAlignTypeLeft = 1, //圆点居左对齐
    CycleRollPageControlAlignTypeRight = 2 //圆点居右对齐
};
```
**image：**默认图片

**disableTimer：**是否取消自动轮播

**delegate：**代理。如果要实现点击回调，可选择使用代理。也可以实现block

```
@property (nonatomic, copy) CycleRollViewClickItemBlock cycleRollViewClickItemBlock;//点击回调block
```

### 更多设置
@property (nonatomic, copy) NSArray <NSString *> *imageURLs;//网络图片数组

@property (nonatomic, copy) NSArray <UIImage *> *imageNames;//本地图片数组

@property (nonatomic, assign) NSTimeInterval timeInterval;//自动滚动时间间隔

@property (nonatomic, weak) id<CycleRollViewDelegate>delegate;//点击回调可实现的代理

@property (nonatomic, copy) CycleRollViewClickItemBlock cycleRollViewClickItemBlock;//点击回调block

如果你想修改pageControl的样式，可以到CycleRollView.m文件任意修改

```
const CGFloat kDotW = 5.0f;//圆点宽度
const CGFloat kDotSelectedW = 13.0f;//当前选中圆点宽度
const CGFloat kDotH = 5.0f;//圆点高度
const CGFloat kDotSpace = 4.0f;//圆点间间隔
const CGFloat kSelectedAlpha = 1.0f;//当前选中透明度
const CGFloat kNormalAlpha = 0.5f;//未选中透明度
const CGFloat kMargin = 10.0f;//圆点距左/右距离
const CGFloat kMarginBottom = 5.0f;//圆点距底部距离
#define DOT_COLOR [UIColor whiteColor];//圆点颜色
```

