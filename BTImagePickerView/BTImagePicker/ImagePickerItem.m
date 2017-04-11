//
//  ImagePickerItem.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "ImagePickerItem.h"

#define kButtonPadding 10.0f
#define kButtonWH 30.0f

@interface ImagePickerItem()

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation ImagePickerItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self loadViews];

    }
    return self;
}

- (void)loadViews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [self.contentView bringSubviewToFront:imageView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    self.selectedButton = button;
    [button setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    button.selected = self.btnSelect;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    self.imageView.frame = self.bounds;
    self.selectedButton.frame = CGRectMake(width - kButtonWH - kButtonPadding, kButtonPadding, kButtonWH, kButtonWH);
}

- (void)setBtnSelect:(BOOL)btnSelect {
    _btnSelect = btnSelect;
    self.selectedButton.selected = btnSelect;
}
@end
