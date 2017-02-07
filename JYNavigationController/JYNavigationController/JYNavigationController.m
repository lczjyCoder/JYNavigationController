//
//  ZJYNavigationController.m
//  LVMMTest
//
//  Created by zjy on 2017/2/6.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "JYNavigationController.h"
#import <objc/runtime.h>

@interface JYNavigationController ()
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) CGPoint startTouch; // 开始触碰点
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *blackMask;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) NSUInteger screenWidth; // 屏幕宽度
@property (nonatomic, assign) NSUInteger screenWidth20; // 20倍屏宽
@property (nonatomic, strong) UIImageView *lastScreenShotView; // 屏幕快照
@end

@implementation JYNavigationController

-(void)removePanGesture {
    self.panGesture.enabled = NO;
}

-(void)addPanGesture {
    self.panGesture.enabled = YES;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenWidth20 = self.screenWidth *20;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController:)];
    self.panGesture.delegate = self;
    self.panGesture.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:self.panGesture];
    self.interactivePopGestureRecognizer.enabled = NO;// 关闭系统自带滑动返回
}

/*
 重写pushViewController方法,动态给控制器添加screenShot属性
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!viewController) return;
    UIViewController *vc = (UIViewController *)self.topViewController;
    objc_setAssociatedObject(vc, "screenShot", [self capture], OBJC_ASSOCIATION_RETAIN);
    [super pushViewController:viewController animated:animated];
}

/*
 手势滑动返回方法
 */
- (void)popViewController:(UIPanGestureRecognizer *)recognnizer{
    if (self.viewControllers.count <= 1) return;
    CGPoint touchPoint = [recognnizer locationInView:[UIApplication sharedApplication].keyWindow];
    if (recognnizer.state == UIGestureRecognizerStateBegan) {// 手势开始
        _isMoving = YES;
        self.startTouch = touchPoint;
        if (!self.backgroundView) {
            CGRect frame = self.view.frame;
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            self.blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            self.blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:self.blackMask];
        }
        self.backgroundView.hidden = NO;
        if (self.lastScreenShotView) {
            [self.lastScreenShotView removeFromSuperview];
        }
        
        self.lastScreenShotView = [self screenShot];
        [self.backgroundView insertSubview:self.lastScreenShotView belowSubview:self.blackMask];
    } else if (recognnizer.state == UIGestureRecognizerStateEnded) {// 手势结束
        if (touchPoint.x - self.startTouch.x > 50) {
            [UIView animateWithDuration:0.2 animations:^{
                [self moveViewWithX:self.screenWidth];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
                self.backgroundView.hidden = YES;
                
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
    } else if (recognnizer.state == UIGestureRecognizerStateCancelled) {// 手势取消
        [UIView animateWithDuration:0.2 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
    }
    
    if (_isMoving) {
        [self moveViewWithX:(touchPoint.x - self.startTouch.x)];
    }
}

/*
 随手势移动页面
 */
- (void)moveViewWithX:(float)x {
    x = x>self.screenWidth?self.screenWidth:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/self.screenWidth20)+0.95;
    float alpha = 0.4 - (x/800);
    
    self.lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    self.blackMask.alpha = alpha;
    
}

- (id)capture {
    return [self.view snapshotViewAfterScreenUpdates:NO]; //截取屏幕快照
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *view = touch.view;
    CGPoint touchPoint = [touch locationInView:view];
    if (touchPoint.x < 40) {
        return YES;
    } else {
        return NO;
    }
}

- (id)screenShot{// 动态取出上页面快照
    id scress =nil;
    NSArray *vs = self.viewControllers;
    UIViewController *vc = ((UIViewController *)vs[MAX(0, vs.count - 2)]);
    scress = objc_getAssociatedObject(vc, "screenShot");
    return scress;
}


@end
