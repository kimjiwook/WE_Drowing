//
//  WE_DrowingViewController.m
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 18..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.

#import "WE_DrowingViewController.h"

#define we_HeaderHeight   80

@interface WE_DrowingViewController ()

@end

@implementation WE_DrowingViewController
@synthesize collectionViews, assets;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    StretchyHeaderCollectionViewLayout *layout = [[StretchyHeaderCollectionViewLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.view.bounds.size.width, we_HeaderHeight)];
    [layout setHeaderReferenceSize:CGSizeMake(self.view.bounds.size.width, we_HeaderHeight)];
    
    collectionViews = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height+20) collectionViewLayout:layout];
    [collectionViews setBackgroundColor:[UIColor whiteColor]];
    
    [collectionViews registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [collectionViews registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    [collectionViews setAlwaysBounceVertical:YES];
    [collectionViews setShowsVerticalScrollIndicator:NO];
    [collectionViews setDelegate:self];
    [collectionViews setDataSource:self];
    [self.view addSubview:collectionViews];
    
    [self assetsLibrayCreate];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self viewDidLoad];
    [self.collectionViews reloadData];
//    [self.collectionViews performBatchUpdates:^{
//        [self.collectionViews reloadSections:[NSIndexSet indexSetWithIndex:0]];
//        NSLog(@"viewWillAppear");
//    }completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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
    return 1;
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
    return CGSizeMake(79.25f, 79.25f);
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

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *rView = [collectionViews dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        [rView setBackgroundColor:[UIColor purpleColor]];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-25, we_HeaderHeight/2-20, 50, 50)];
        [btn setImage:[UIImage imageNamed:@"Menu_Icon.png"] forState:UIControlStateNormal];
        [btn setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [rView addSubview:btn];

        return rView;
    }
    
    return nil;
}

// Select Item...
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ImageEditingView" bundle:nil];
    
    imageEditingViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageEditingViewController"];
    ALAsset *asset = [self.assets[indexPath.row] valueForKey:@"ALAsset"];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    [imageEditingViewController initWithImageView:[UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0]];
    [self.navigationController pushViewController:imageEditingViewController animated:YES];
}

@end
