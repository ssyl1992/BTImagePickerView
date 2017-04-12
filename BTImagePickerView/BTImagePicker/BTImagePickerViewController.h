//
//  BTImagePickerViewController.h
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CompletedButtonClick)(NSArray *images);

@interface BTImagePickerViewController : UIViewController

@property (nonatomic, copy) CompletedButtonClick completed;
@property (nonatomic, assign) NSInteger maxCount;

@end
