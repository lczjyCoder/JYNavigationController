//
//  FirstViewController.m
//  JYNavigationController
//
//  Created by zjy on 2017/2/7.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES];
}

@end
