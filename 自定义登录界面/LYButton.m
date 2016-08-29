
//
#import "LYButton.h"

@interface LYButton()

//渲染层
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) CAShapeLayer *loadingLayer;

@property (nonatomic,strong) CAShapeLayer *clickCicrleLayer;

@property (nonatomic,strong) UIButton *button;

@end


@implementation LYButton

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _shapeLayer = [self drawMask:frame.size.height/2];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.lineWidth = 2;
        [self.layer addSublayer:_shapeLayer];
        
        [self.layer addSublayer:self.maskLayer];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        [_button setTitle:@"SIGN IN" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:_button];
        [_button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(CAShapeLayer *)maskLayer{
    if(!_maskLayer){
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.opacity = 0;
        _maskLayer.fillColor = [UIColor whiteColor].CGColor;
        _maskLayer.path = [self drawBezierPath:self.frame.size.width/2].CGPath;
    }
    return _maskLayer;
}

-(void)clickBtn{
    [self clickAnimation];
}

//点击出现白色圆形
-(void)clickAnimation{
    CAShapeLayer *clickCicrleLayer = [CAShapeLayer layer];
    clickCicrleLayer.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 5, 5);
    clickCicrleLayer.fillColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.path = [self drawclickCircleBezierPath:0].CGPath;
    [self.layer addSublayer:clickCicrleLayer];
    
    //放大变色圆形
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.5;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(self.bounds.size.height - 10*2)/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;

    [clickCicrleLayer addAnimation:basicAnimation forKey:@"clickCicrleAnimation"];
    
    _clickCicrleLayer = clickCicrleLayer;
    
    //执行下一个动画
    [self performSelector:@selector(clickNextAnimation) withObject:self afterDelay:basicAnimation.duration];
}

//
-(void)clickNextAnimation{
    //圆形变圆弧
    _clickCicrleLayer.fillColor = [UIColor clearColor].CGColor;
    _clickCicrleLayer.strokeColor = [UIColor whiteColor].CGColor;
    _clickCicrleLayer.lineWidth = 10;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    //圆弧变大
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.5;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(self.bounds.size.height - 10*2)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    //变透明
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.5;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    [_clickCicrleLayer addAnimation:animationGroup forKey:@"clickCicrleAnimation1"];

    [self performSelector:@selector(startMaskAnimation) withObject:self afterDelay:animationGroup.duration];
    
}

//半透明的登录按钮的背景
-(void)startMaskAnimation{
    _maskLayer.opacity = 0.5;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.25;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.frame.size.height/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_maskLayer addAnimation:basicAnimation forKey:@"maskAnimation"];
    
    [self performSelector:@selector(dismissAnimation) withObject:self afterDelay:basicAnimation.duration+0.2];
}

//登录按钮合拢并消失（透明）
-(void)dismissAnimation{
    [self removeSubViews];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.2;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.frame.size.width/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.2;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    animationGroup.duration = basicAnimation1.beginTime+basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [_shapeLayer addAnimation:animationGroup forKey:@"dismissAnimation"];
    
    [self performSelector:@selector(loadingAnimation) withObject:self afterDelay:animationGroup.duration];
}

//菊花
-(void)loadingAnimation{
    _loadingLayer = [CAShapeLayer layer];
    _loadingLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _loadingLayer.fillColor = [UIColor clearColor].CGColor;
    _loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
    _loadingLayer.lineWidth = 2;
    _loadingLayer.path = [self drawLoadingBezierPath].CGPath;
    [self.layer addSublayer:_loadingLayer];

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = 0.5;
    basicAnimation.repeatCount = LONG_MAX;
    [_loadingLayer addAnimation:basicAnimation forKey:@"loadingAnimation"];
    
    [self performSelector:@selector(removeAllAnimation) withObject:self afterDelay:2];

}

-(void)removeSubViews{
    [_button removeFromSuperview];
    [_maskLayer removeFromSuperlayer];
    [_loadingLayer removeFromSuperlayer];
    [_clickCicrleLayer removeFromSuperlayer];
}

-(void)removeAllAnimation{
    [self removeSubViews];
    if(self.translateBlock){
        self.translateBlock();
    }
}


-(CAShapeLayer *)drawMask:(CGFloat)x{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = [self drawBezierPath:x].CGPath;
    return shapeLayer;
}

//
-(UIBezierPath *)drawBezierPath:(CGFloat)x{
    CGFloat radius = self.bounds.size.height/2 - 3;
    CGFloat right = self.bounds.size.width-x;
    CGFloat left = x;

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    //右边圆弧
    [bezierPath addArcWithCenter:CGPointMake(right, self.bounds.size.height/2) radius:radius startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
    //左边圆弧
    [bezierPath addArcWithCenter:CGPointMake(left, self.bounds.size.height/2) radius:radius startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
    //闭合弧线
    [bezierPath closePath];
    
    return bezierPath;
}


-(UIBezierPath *)drawLoadingBezierPath{
    CGFloat radius = self.bounds.size.height/2 - 3;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:M_PI/2 endAngle:M_PI/2+M_PI/2 clockwise:YES];
    return bezierPath;
}

//画圆
-(UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    /**
     *  center: 弧线中心点的坐标
     radius: 弧线所在圆的半径
     startAngle: 弧线开始的角度值
     endAngle: 弧线结束的角度值
     clockwise: 是否顺时针画弧线
     *
     */
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return bezierPath;
}
@end
