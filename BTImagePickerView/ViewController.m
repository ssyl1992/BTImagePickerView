//
//  ViewController.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "ViewController.h"

#import "BTImagePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)click:(id)sender {
    BTImagePickerViewController *ipVC = [[BTImagePickerViewController alloc] init];
    ipVC.completed = ^(NSArray *images){
        NSLog(@"%@",images);
    };
    
    
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ipVC];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}

@end
