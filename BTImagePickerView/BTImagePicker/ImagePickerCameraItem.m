//
//  ImagePickerCameraItem.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "ImagePickerCameraItem.h"



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
    imageView.image = [UIImage imageNamed:@"checked"];
    self.imageView = imageView;
    [self.contentView bringSubviewToFront:imageView];
    

}

- (void)layoutSubviews {
    
    self.imageView.frame = CGRectMake(0, 0, 40, 40);
    self.imageView.center = self.center;
    
}
@end
