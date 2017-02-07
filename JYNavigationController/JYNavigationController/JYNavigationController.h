//
//  ZJYNavigationController.h
//  LVMMTest
//
//  Created by zjy on 2017/2/6.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJYNavigationController : UINavigationController <UIGestureRecognizerDelegate>
- (void)removePanGesture;
- (void)addPanGesture;
@end
