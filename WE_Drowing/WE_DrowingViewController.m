//
//  WE_DrowingViewController.m
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 18..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.

#import "WE_DrowingViewController.h"

#define we_HeaderHeight   100

@interface WE_DrowingViewController ()

@end

@implementation WE_DrowingViewController
@synthesize collectionViews, assets, headerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    collectionViews = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectionViews setBackgroundColor:[UIColor whiteColor]];
    [collectionViews registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [collectionViews registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    [collectionViews setDelegate:self];
    [collectionViews setDataSource:self];
    [self.view addSubview:collectionViews];
    
    [self assetsLibrayCreate];
}

- (void) assetsLibrayCreate {
    assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    
    ALAssetsLibrary *assetsLibrary = [WE_DrowingViewController defaultAssetsLibrary];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result) {
                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
                
                [tmpDic setObject:result forKey:@"ALAsset"];
                [tmpDic setObject:[result valueForProperty:ALAssetPropertyDate] forKey:ALAssetPropertyDate];
                
                [tmpAssets addObject:tmpDic];
            }
        }];
        // NO => date desc , YES => date asc
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:ALAssetPropertyDate ascending:NO];
        [tmpAssets sortUsingDescriptors:@[sort]];
        self.assets = tmpAssets;
        
        [self.collectionViews reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Header
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// Section for Item Count...
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// Cell Size
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(106, 106);
}

// CollectionViewCell Item Create...
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    ALAsset *asset = [self.assets[indexPath.row] valueForKey:@"ALAsset"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    imgView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
    [cell.contentView addSubview:imgView];
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"@@@@@@@@@");
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *rView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, we_HeaderHeight)];
        [rView setBackgroundColor:[UIColor brownColor]];
        
//        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, we_HeaderHeight)];
//        [headerView setBackgroundColor:[UIColor brownColor]];

        
        return rView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int offset = we_HeaderHeight - 320;
    int y = scrollView.contentOffset.y;
    if (y <= offset) {
        [scrollView setContentOffset:CGPointMake(0, offset)];
    }
    
    if (y <= 0 && y >= offset) {
        self.headerView.frame = CGRectMake(0, (offset - y) / 2, 320, 320);
    } else if (y >= 0) {
        self.headerView.frame = CGRectMake(0, offset / 2 - y, 320, 320);
    }
}

@end
