# iosAnimationDemo
iOS动画综合应用
动效设计一直是iOS平台的优势，良好的动效设计可以很好地提升用户体验。而动画则是动效的基础支撑。本动画将从易到难逐步分析，从CABasicAnimation，UIBezierPath，CAShapeLayer三个方面完整的阐述iOS动画的实现。最终的效果如下：

![WuWeilogin.gif](http://upload-images.jianshu.io/upload_images/1968278-403281110ac5653e.gif?imageMogr2/auto-orient/strip)
例子来源与网络，不是我写的，我只是加上了详细的注释，方便大家理解（我只是代码的搬运工...）。这个例子是CABasicAnimation，UIBezierPath，CAShapeLayer的综合实现，如果能完全理解这个例子，相信其它的iOS动画也难不倒你了。[demo下载地址](https://github.com/a130785/iosAnimationDemo)


   ###CABasicAnimation
一、概念
这个部分你需要了解以下概念: CALayer、CAAnimation、CAAnimationGroup
#####1、CALayer
CALayer是个与UIView很类似的概念，同样有backgroundColor、frame等相似的属性，我们可以将UIView看做一种特殊的CALayer。但实际上UIView是对CALayer封装，在CALayer的基础上再添加交互功能。UIView的显示必须依赖于CALayer。我们同样可以跟新建view一样新建一个layer，然后添加到某个已有的layer上，同样可以对layer调整大小、位置、透明度等。一般来说，layer可以有两种用途：一是对view相关属性的设置，包括圆角、阴影、边框等参数，更详细的参数请点击这里；二是实现对view的动画操控。**因此对一个view进行动画，本质上是对该view的.layer进行动画操纵。**

#####2、CAAnimation
CAAnimation可以分为以下几类：
>CABasicAnimation基础动画，通过设定起始点，终点，时间，动画会沿着你这设定点进行移动。可以看做特殊的CAKeyFrameAnimation
CAKeyframeAnimation关键帧动画，可定制度比CABasicAnimation高，也是本系列的接下来的内容
CAAnimationGroup组动画，支持多个CABasicAnimation或者CAKeyframeAnimation动画同时执行

####实例化
使用方法animationWithKeyPath:对 CABasicAnimation进行实例化，并指定Layer的属性作为关键路径进行注册。
```
//围绕y轴旋转CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
```
设定动画的属性和说明属性说明
![CABasicAnimation的属性](http://upload-images.jianshu.io/upload_images/1968278-4d86ac2689b6647b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
transformAnima.fromValue = @(M_PI_2);
transformAnima.toValue = @(M_PI);
transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
transformAnima.autoreverses = YES;
transformAnima.repeatCount = HUGE_VALF;
transformAnima.beginTime = CACurrentMediaTime() + 2;
```
防止动画结束后回到初始状态只需设置removedOnCompletion、fillMode两个属性就可以了。
```
transformAnima.removedOnCompletion = NO;
transformAnima.fillMode = kCAFillModeForwards;
```
解释：为什么动画结束后返回原状态？首先我们需要搞明白一点的是，layer动画运行的过程是怎样的？其实在我们给一个视图添加layer动画时，真正移动并不是我们的视图本身，而是 presentation layer 的一个缓存。动画开始时 presentation layer开始移动，原始layer隐藏，动画结束时，presentation layer从屏幕上移除，原始layer显示。这就解释了为什么我们的视图在动画结束后又回到了原来的状态，因为它根本就没动过。
这个同样也可以解释为什么在动画移动过程中，我们为何不能对其进行任何操作。
所以在我们完成layer动画之后，最好将我们的layer属性设置为我们最终状态的属性，然后将presentation layer 移除掉。
添加动画
```
[self.imageView.layer addAnimation:transformAnima forKey:@"A"];
```
fillMode属性的理解该属性定义了你的动画在开始和结束时的动作。默认值是 kCAFillModeRemoved。
>kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态。因为有可能出现fromValue不是目前layer的初始状态的情况，如果fromValue就是layer当前的状态，则这个参数就没太大意义。
kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.

####Animation Easing的使用
也即是属性timingFunction值的设定，有种方式来获取属性值
（1）使用方法functionWithName:
这种方式很简单，这里只是简单说明一下取值的含义：
>kCAMediaTimingFunctionLinear 传这个值，在整个动画时间内动画都是以一个相同的速度来改变。也就是匀速运动。
kCAMediaTimingFunctionEaseIn 使用该值，动画开始时会较慢，之后动画会加速。
kCAMediaTimingFunctionEaseOut 使用该值，动画在开始时会较快，之后动画速度减慢。
kCAMediaTimingFunctionEaseInEaseOut 使用该值，动画在开始和结束时速度较慢，中间时间段内速度较快。

####动画的实现
```
CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
positionAnima.fromValue = @(self.imageView.center.y);
positionAnima.toValue = @(self.imageView.center.y-30);
positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:
kCAMediaTimingFunctionEaseIn];
CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
transformAnima.fromValue = @(0);
transformAnima.toValue = @(M_PI);
transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
animaGroup.duration = 2.0f;
animaGroup.fillMode = kCAFillModeForwards;
animaGroup.removedOnCompletion = NO;
animaGroup.animations = @[positionAnima,transformAnima];[self.imageView.layer addAnimation:animaGroup forKey:@"Animation"];
```
动画开始和结束时的事件为了获取动画的开始和结束事件，需要实现协议
```
positionAnima.delegate = self;
```
代理方法实现
```
//动画开始时- (void)animationDidStart:(CAAnimation *)anim{ 
NSLog(@"开始了");
}
//动画结束时- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
 //方法中的flag参数表明了动画是自然结束还是被打断,比如调用了removeAnimationForKey:方法
或removeAnimationForKey方法，flag为NO，如果是正常结束，flag为YES。
 NSLog(@"结束了");
}
```
其实比较重要的是有多个动画的时候如何在代理方法中区分不同的动画两种方式
方式一：
如果我们添加动画的视图是全局变量，可使用该方法。添加动画时，我们使用了
```
[self.imageView.layer addAnimation:animaGroup forKey:@"Animation"];
```
所以，可根据key来区分不同的动画
```
//动画开始时- (void)animationDidStart:(CAAnimation *)anim{
 if ([anim isEqual:[self.imageView.layer animationForKey:@"Animation"]]) { 
NSLog(@"动画组执行了");
 }
}
```
**Note:把动画存储为一个属性然后再回调中比较，用来判定是哪个动画是不可行的。应为委托传入的动画参数是原始值的一个深拷贝，不是同一个值**
方式二
添加动画的视图是局部变量时，可使用该方法添加动画给动画设置key-value对
```
[positionAnima setValue:@"PositionAnima" forKey:@"AnimationKey"];
[transformAnima setValue:@"TransformAnima" forKey:@"AnimationKey"];
```
所以，可以根据key中不同的值来进行区分不同的动画
```
//动画结束时- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
 if ([[anim valueForKey:@"AnimationKey"]isEqualToString:@"PositionAnima"]) { 
        NSLog(@"位置移动动画执行结束");
 } else if ([[anim valueForKey:@"AnimationKey"]isEqualToString:@"TransformAnima"]){ 
        NSLog(@"旋转动画执行结束");
 }}
```
####一些常用的animationWithKeyPath值的总结
![animationWithKeyPath值](http://upload-images.jianshu.io/upload_images/1968278-ecdcae93423d30aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###UIBezierPath

使用UIBezierPath可以创建基于矢量的路径，此类是Core Graphics框架关于路径的封装。使用此类可以定义简单的形状，如椭圆、矩形或者有多个直线和曲线段组成的形状等。

UIBezierPath是CGPathRef数据类型的封装。如果是基于矢量形状的路径，都用直线和曲线去创建。我们使用直线段去创建矩形和多边形，使用曲线去创建圆弧（arc）、圆或者其他复杂的曲线形状。

![87FE4D73-A87A-4B8C-9A0E-73941FA532EC.png](http://upload-images.jianshu.io/upload_images/1968278-cd183582ea9a9402.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
+ (instancetype)bezierPath;
```
这个使用比较多，因为这个工厂方法创建的对象，我们可以根据我们的需要任意定制样式，可以画任何我们想画的图形。
```
+ (instancetype)bezierPathWithRect:(CGRect)rect;
```
这个工厂方法根据一个矩形画贝塞尔曲线。
```
+ (instancetype)bezierPathWithOvalInRect:(CGRect)rect;
```
这个工厂方法根据一个矩形画内切曲线。通常用它来画圆或者椭圆。
```
+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
```
第一个工厂方法是画矩形，但是这个矩形是可以画圆角的。第一个参数是矩形，第二个参数是圆角大小。
第二个工厂方法功能是一样的，但是可以指定某一个角画成圆角。像这种我们就可以很容易地给UIView扩展添加圆角的方法了。
```
+ (instancetype)bezierPathWithArcCenter:(CGPoint)center
 radius:(CGFloat)radius
 startAngle:(CGFloat)startAngle
 endAngle:(CGFloat)endAngle
 clockwise:(BOOL)clockwise;
```
这个工厂方法用于画弧，参数说明如下：
center: 弧线中心点的坐标
radius: 弧线所在圆的半径
startAngle: 弧线开始的角度值
endAngle: 弧线结束的角度值
clockwise: 是否顺时针画弧线

```
- (void)closePath;//闭合弧线
```
 
 
###CAShapeLayer
CAShapeLayer是在其坐标系统内绘制贝塞尔曲线(UIBezierPath)的。因此，使用CAShapeLayer需要与UIBezierPath一起使用。

它有一个path属性，而UIBezierPath就是对CGPathRef类型的封装，因此这两者配合起来使用才可以的哦！
CAShapeLayer与UIBezierPath的关系：
>CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
贝塞尔曲线可以创建基于矢量的路径，而UIBezierPath类是对CGPathRef的封装
贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
用于CAShapeLayer的贝塞尔曲线作为path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线

####CAShapeLayer与UIBezierPath画圆
```
- (CAShapeLayer *)drawCircle {
CAShapeLayer *circleLayer = [CAShapeLayer layer];
 // 指定frame，只是为了设置宽度和高度
 circleLayer.frame = CGRectMake(0, 0, 200, 200);
 // 设置居中显示
 circleLayer.position = self.view.center; 
 // 设置填充颜色
 circleLayer.fillColor = [UIColor clearColor].CGColor;
 // 设置线宽
 circleLayer.lineWidth = 2.0;
 // 设置线的颜色
 circleLayer.strokeColor = [UIColor redColor].CGColor;
 // 使用UIBezierPath创建路径
 CGRect frame = CGRectMake(0, 0, 200, 200);
 UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:frame]; 
// 设置CAShapeLayer与UIBezierPath关联
 circleLayer.path = circlePath.CGPath;
 // 将CAShaperLayer放到某个层上显示
 [self.view.layer addSublayer:circleLayer]; return circleLayer;}
```

登录例子下载地址：
[demo下载地址](https://github.com/a130785/iosAnimationDemo)

如果你都看到这里了，请给我**点个赞**吧，你的喜欢是我坚持原创的不竭动力。
参考资料：
[iOS 动画效果：Core Animation & Facebook](http://www.cocoachina.com/ios/20151223/14739.html)
[拍电影与CABasicAnimation](http://www.jianshu.com/p/cd1bc0e82f4d)
[标哥的技术博客](http://www.jianshu.com/p/734b34e82135)
[CABasicAnimation使用总结](http://www.jianshu.com/p/02c341c748f9)
[苹果文档](https://developer.apple.com/search/?q=CABasicAnimation&platform=iOS)
[放肆的使用UIBezierPath和CAShapeLaye](http://www.jianshu.com/p/c5cbb5e05075)
