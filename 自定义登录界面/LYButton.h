//
//  LYButton.h
//  自定义登录界面
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)();

@interface LYButton : UIView

@property (nonatomic,copy) finishBlock translateBlock;

@end
