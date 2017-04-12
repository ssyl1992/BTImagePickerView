//
//  ImagePickerCameraItem.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "ImagePickerCameraItem.h"

@interface ImagePickerCameraItem()
@property (nonatomic, weak) UILabel *label;

@end


@implementation ImagePickerCameraItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self loadViews];
        
    }
    return self;
}

- (void)loadViews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"camera"];
    self.imageView = imageView;
//    [self.contentView bringSubviewToFront:imageView];
    
    UILabel *label = [[UILabel alloc] init];
   
    label.text = @"拍照";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    self.label = label;
    
    
    

}

- (void)layoutSubviews {
    
    self.imageView.frame = CGRectMake(0, 0, 40, 40);
    self.imageView.center = self.center;
    self.label.frame = CGRectMake(0, self.imageView.frame.size.height + self.imageView.frame.origin.y, self.bounds.size.width, 20);
    
}
@end
