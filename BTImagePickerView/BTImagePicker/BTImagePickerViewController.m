//
//  BTImagePickerViewController.m
//  BTImagePickerView
//
//  Created by 滕跃兵 on 2017/4/11.
//  Copyright © 2017年 tyb. All rights reserved.
//

#import "BTImagePickerViewController.h"
#import "ImagePickerItem.h"
#import <Photos/Photos.h>
#import "ImagePickerCameraItem.h"




#define kCollectionViewH kScreenH - kSelectViewH
#define KScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height
#define kSelectViewH 120.0f
#define ItemSpace 1.0f

@interface BTImagePickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PHPhotoLibraryChangeObserver>

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, copy) NSMutableArray *images;
@property (nonatomic, copy) NSMutableArray *selectedIndexPath;

@end



@implementation BTImagePickerViewController
{
    UICollectionView *imageCollectionView;
    UIButton *finishedButton;
    UIScrollView *selectedView;
    UILabel *finishedLabel;
    UILabel *capacityLabel;
    PHPhotoLibrary *library;
}




- (instancetype)init {
    if (self = [super init]) {
        [self layoutCollectionView];
        [self layoutFinishedButton];
        [self layoutSelectionView];
        self.maxCount = 12;
        self.currentCount = 0;
    }
    return self;
}

- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)selectedIndexPath {
    if (_selectedIndexPath == nil) {
        _selectedIndexPath = [NSMutableArray array];
    }
    return _selectedIndexPath;
}

- (void)setCurrentCount:(NSInteger)currentCount {
    _currentCount = currentCount;
    capacityLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentCount,self.maxCount];
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
    imageCollectionView.backgroundColor = [UIColor blackColor];
    [imageCollectionView registerClass:[ImagePickerItem class] forCellWithReuseIdentifier:@"cell"];
    [imageCollectionView registerClass:[ImagePickerCameraItem class] forCellWithReuseIdentifier:@"camera"];
    [self.view addSubview:imageCollectionView];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有照片";
    library = [PHPhotoLibrary sharedPhotoLibrary];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self getAllAssetInPhotoAblumWithAscending:NO];
//    [self fetchImageFromAssets:assets];
}


- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"%@",changeInstance);
   
}

- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending {
    
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
            PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];

            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAsset *asset = (PHAsset *)obj;
                NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
                [self.images addObject:asset];
            }];
     
        }else {
            NSLog(@"获取相册权限失败");
        }
    }];
    [imageCollectionView reloadData];
    return assets;
}

- (UIImage *)fetchImageFromAssets:(PHAsset *)asset {
 
    __block UIImage *fetchImage;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //仅显示缩略图，不控制质量显示
    /**
     PHImageRequestOptionsResizeModeNone,
     PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
     */
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    CGSize size = CGSizeMake(KScreenW * 0.5, KScreenW * 0.5);

    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            fetchImage = image;
        }];
    

    return fetchImage;
}




#pragma mark -- collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ImagePickerCameraItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"camera" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }else{
        ImagePickerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.btnSelect = [self.selectedIndexPath containsObject:indexPath];
        cell.imageView.image = [self fetchImageFromAssets:[self.images objectAtIndex:indexPath.row - 1 ]];
        return cell;
    }
  
}

#pragma mark -- collection delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果选择拍照
    if (indexPath.row == 0) {
        
        NSLog(@"拍照");
        
    }else {
        if ([self.selectedIndexPath containsObject:indexPath]) {
            [self.selectedIndexPath removeObject:indexPath];
            self.currentCount -= 1;
            
        }else {
            [self.selectedIndexPath addObject:indexPath];
             self.currentCount += 1;
        }
        [collectionView reloadData];
    }
    


}

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
