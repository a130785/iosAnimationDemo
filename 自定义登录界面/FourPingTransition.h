//
//  FourPingTransition.h
//  控制器专场动画集合
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XWPresentOneTransitionType) {
    XWPresentOneTransitionTypePresent = 0,//管理present动画
    XWPresentOneTransitionTypeDismiss//管理dismiss动画
};

@interface FourPingTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) XWPresentOneTransitionType type;

+ (instancetype)transitionWithTransitionType:(XWPresentOneTransitionType)type;
- (instancetype)initWithTransitionType:(XWPresentOneTransitionType)type;

@end
