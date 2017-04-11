//
//  ImagePickerItem.h
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerItem : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) BOOL btnSelect;

@end
