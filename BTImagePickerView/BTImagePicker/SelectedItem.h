//
//  SelectedItem.h
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/12.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteClick)(UIView *view);


@interface SelectedItem : UIView
@property (nonatomic, strong) UIImage *image;


- (instancetype)initWithImage:(UIImage *)image deleteClick:(DeleteClick)deleteClick;
@end
