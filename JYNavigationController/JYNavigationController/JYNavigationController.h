//
//  ZJYNavigationController.h
//  LVMMTest
//
//  Created by zjy on 2017/2/6.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNavigationController : UINavigationController <UIGestureRecognizerDelegate>
- (void)removePanGesture; // 关闭手势返回
- (void)addPanGesture; // 打开手势返回
@end
