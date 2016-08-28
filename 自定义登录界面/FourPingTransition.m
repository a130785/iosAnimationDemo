//
//  FourPingTransition.m
//  控制器专场动画集合
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "FourPingTransition.h"

@implementation FourPingTransition


+ (instancetype)transitionWithTransitionType:(XWPresentOneTransitionType)type
{
    return [[self alloc]initWithTransitionType:type];
}
- (instancetype)initWithTransitionType:(XWPresentOneTransitionType)type
{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

#pragma - mark UIViewControllerAnimatedTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.55;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XWPresentOneTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case XWPresentOneTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

//
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //我们可以利用viewControllerForKey: 方法知道是从哪个controller变换到哪个controller
    UINavigationController *fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *temp = fromVC.viewControllers.lastObject;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //拿到button
    UIButton *button = temp.view.subviews.lastObject;
    
    UIView *containerView = [transitionContext containerView]; //这个UIView就是执行动画的地方
    //我们还要确保controller的view都必须是这个containerView的subview
    [containerView addSubview:toVC.view];
    
    //画圆
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    CGFloat x = MAX(button.frame.origin.x,containerView.frame.size.width - button.frame.origin.x); //182
    CGFloat y = MAX(button.frame.origin.y, containerView.frame.size.height - button.frame.origin.y);//488

    //求出半径
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2)); //520
    
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    //
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animation];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(endCycle.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *temp = toVC.viewControllers.lastObject;
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view atIndex:0];
    //画两个圆路径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:temp.view.subviews.lastObject.frame];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    switch (_type) {
        case XWPresentOneTransitionTypePresent:{
          id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            //更新内部视图控制器状态的转换在转换结束
            [transitionContext completeTransition:YES];
            [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
        }
            break;
            
        case XWPresentOneTransitionTypeDismiss:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
        default:
            break;
    }
}
@end
