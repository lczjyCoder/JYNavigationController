//
//  SecondViewController.m
//  JYNavigationController
//
//  Created by zjy on 2017/2/7.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[[ThirdViewController alloc] init] animated:YES];
}

@end
