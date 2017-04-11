//
//  BTImagePickerViewController.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "BTImagePickerViewController.h"



#define kCollectionViewH kScreenH - kSelectViewH
#define KScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height
#define kSelectViewH 120.0f
#define ItemSpace 1.0f

@interface BTImagePickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end



@implementation BTImagePickerViewController
{
    UICollectionView *imageCollectionView;
    UIButton *finishedButton;
    UIScrollView *selectedView;
    UILabel *finishedLabel;
    UILabel *capacityLabel;
}




- (instancetype)init {
    if (self = [super init]) {
        
        [self layoutCollectionView];
        [self layoutFinishedButton];
        [self layoutSelectionView];
        
        
    }
    return self;
}

- (void)layoutFinishedButton {
    
    finishedButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    finishedButton.frame = CGRectMake(KScreenW - kSelectViewH * 0.5, kCollectionViewH, kSelectViewH * 0.5, kSelectViewH);
    finishedButton.backgroundColor = [UIColor redColor];
    [finishedButton addTarget:self action:@selector(finishedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishedButton];
    
    finishedLabel = [[UILabel alloc] init];
    finishedLabel.frame = CGRectMake(0, kSelectViewH * 0.5, kSelectViewH * 0.5, 20);
    finishedLabel.textColor = [UIColor whiteColor];
    finishedLabel.font = [UIFont systemFontOfSize:16];
    finishedLabel.textAlignment = NSTextAlignmentCenter;
    finishedLabel.text = @"完成";
    [finishedButton addSubview:finishedLabel];
    
    
    capacityLabel = [[UILabel alloc] init];
    capacityLabel.frame = CGRectMake(0, kSelectViewH * 0.5 - 20, kSelectViewH * 0.5, 20);
    capacityLabel.textColor = [UIColor whiteColor];
    capacityLabel.font = [UIFont systemFontOfSize:14];
    capacityLabel.textAlignment = NSTextAlignmentCenter;
    capacityLabel.text = @"6/12";
    [finishedButton addSubview:capacityLabel];
    
    
}

- (void)layoutSelectionView {
    selectedView = [[UIScrollView alloc] init];
    selectedView.frame = CGRectMake(0, kCollectionViewH, KScreenW - kSelectViewH * 0.5, kSelectViewH);
    selectedView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:selectedView];
    
}

- (void)layoutCollectionView {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, kCollectionViewH) collectionViewLayout:flowLayout];
    imageCollectionView.delegate = self;
    imageCollectionView.dataSource = self;
    imageCollectionView.backgroundColor = [UIColor greenColor];
    [imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:imageCollectionView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有照片";
//    self.view.backgroundColor = [UIColor redColor];
}

#pragma mark -- collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    return cell;
    
}

#pragma mark -- collection delegate

#pragma mark -- collection layoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        return CGSizeMake((KScreenW - ItemSpace) * 0.5, (KScreenW - ItemSpace) * 0.5);
    }
    return CGSizeMake((KScreenW - 2 * ItemSpace) / 3, (KScreenW - 2 * ItemSpace) / 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ItemSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ItemSpace;
}


#pragma mark --- click
- (void)finishedButtonClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
}

@end
