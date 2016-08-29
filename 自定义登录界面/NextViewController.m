//
//  NextViewController.m
//  自定义登录界面
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "NextViewController.h"
#import "FourPingTransition.h"

@interface NextViewController ()<UIViewControllerTransitioningDelegate>

@property(nonatomic ,strong)CAShapeLayer *loadingLayer;
@property(nonatomic ,strong)NSTimer *timer;

@end

@implementation NextViewController

-(instancetype)init{
    if(self = [super init]){
        self.transitioningDelegate = self;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1.jpg"]];
    imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pop:)];
    [imageView addGestureRecognizer:tap];
    //有兴趣的可以把上面注释，把这里放开，看看效果
//    [self drawCircle];
//    [self drawHalfCircle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}

-(void)pop:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma -mark 画loading
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
    return circleLayer;
}

- (void)drawHalfCircle {
    self.loadingLayer = [self drawCircle];
    
    // 这个是用于指定画笔的开始与结束点
    self.loadingLayer.strokeStart = 0.0;
    self.loadingLayer.strokeEnd = 0.1;
    // 将CAShaperLayer放到某个层上显示
    [self.view.layer addSublayer:_loadingLayer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateCircle)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateCircle {
    self.loadingLayer.strokeEnd += 0.1;
    
    if (self.loadingLayer.strokeEnd >= 1) {
        self.loadingLayer.strokeEnd = 0;
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
