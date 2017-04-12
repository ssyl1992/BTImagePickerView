//
//  SelectedItem.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/12.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "SelectedItem.h"

#define DeleteWH 20.0f

@interface SelectedItem()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *delete;
@property (nonatomic, copy) DeleteClick click;

@end

@implementation SelectedItem


- (instancetype)initWithImage:(UIImage *)image deleteClick:(DeleteClick)deleteClick {
    if (self = [super init]) {
        
        [self loadViews];
        self.imageView.image = image;
        self.click = deleteClick;
    }
    
    return self;
}



- (void)loadViews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"itemdelete"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.delete = button;

}

- (void)layoutSubviews {
    self.imageView.frame = self.bounds;
    self.delete.frame = CGRectMake(self.bounds.size.width - DeleteWH, 0, DeleteWH, DeleteWH);

}

- (void)deleteButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
    self.click(self);
}


@end
