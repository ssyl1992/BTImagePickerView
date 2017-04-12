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
#import "SelectedItem.h"




#define kCollectionViewH kScreenH - kSelectViewH
#define KScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height
#define kSelectViewH 120.0f
#define ItemSpace 1.0f

@interface BTImagePickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PHPhotoLibraryChangeObserver,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, copy) NSMutableArray *images;
@property (nonatomic, copy) NSMutableArray *selectedIndexPath;
@property (nonatomic, copy) NSMutableArray *selectedImages;

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
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain  target:self action:@selector(cancelButtonClick:)];
    }
    return self;
}

- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)selectedImages {
    if (_selectedImages == nil) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
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
    selectedView.backgroundColor = [UIColor blackColor];
   
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
    [self.images removeAllObjects];
    [self getAllAssetInPhotoAblumWithAscending:NO];
  
   
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
                [self.images addObject:asset];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               [imageCollectionView reloadData];
            });
            
        }else {
            NSLog(@"获取相册权限失败");
        }
    }];
   
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
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        if ([self.selectedIndexPath containsObject:indexPath]) {
            [self.selectedIndexPath removeObject:indexPath];
            self.currentCount -= 1;
        }else {
            if (self.selectedIndexPath.count < self.maxCount) {
                [self.selectedIndexPath addObject:indexPath];
                self.currentCount += 1;
            }else{
                return;
            }
        }
    }

    [collectionView reloadData];
    [self settupScrollView];

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
    self.completed(self.selectedImages);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //通过判断picker的sourceType，如果是拍照则保存到相册去
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSMutableArray *updateIndexPaths = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selectedIndexPath) {
     NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        [updateIndexPaths addObject:newIndexPath];
        
    }
    self.selectedIndexPath = updateIndexPaths;
    
    
    
}

#pragma mark --- settupScrollView
- (void)settupScrollView {
    
    [self.selectedImages removeAllObjects];
    [selectedView removeFromSuperview];
    [self layoutSelectionView];
    
    CGFloat itemWH = kSelectViewH - 2 * ItemSpace;
    
    for (int i = 0; i < self.selectedIndexPath.count; i++) {
        NSIndexPath *indexPath = self.selectedIndexPath[i];
        PHAsset *asset = [self.images objectAtIndex:indexPath.row-1];
        UIImage *image = [self fetchImageFromAssets:asset];
        [self.selectedImages addObject:image];
        
        SelectedItem *item = [[SelectedItem alloc] initWithImage:image deleteClick:^(UIView *view) {
            [self.selectedIndexPath removeObject:indexPath];
            [self.selectedImages removeObject:image];
            if (self.currentCount != 0) {
                self.currentCount -= 1;
            }
            [imageCollectionView reloadData];
            [self settupScrollView];
            
        }];
        item.frame = CGRectMake(ItemSpace + (itemWH + ItemSpace) * i, ItemSpace, itemWH, itemWH);
        
        [selectedView addSubview:item];
        
        selectedView.contentSize = CGSizeMake((itemWH + ItemSpace) * i + itemWH, kSelectViewH);
        if ((itemWH + ItemSpace) * i + itemWH > selectedView.frame.size.width) {
             selectedView.contentOffset = CGPointMake((itemWH + ItemSpace) * i + itemWH - selectedView.frame.size.width, 0);
        }
       

    }
    
  
}




@end
