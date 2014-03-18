//
//  WE_DrowingViewController.m
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 18..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.

#import "WE_DrowingViewController.h"

@interface WE_DrowingViewController ()

@end

@implementation WE_DrowingViewController
@synthesize collectionViews, assets;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [collectionViews setDelegate:self];
    [collectionViews setDataSource:self];
    
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
                
                NSLog(@"AssetURL : %@",[result valueForProperty:ALAssetPropertyAssetURL]);
                NSLog(@"Date : %@",[result valueForProperty:ALAssetPropertyDate]);
                NSLog(@"Duration : %@",[result valueForProperty:ALAssetPropertyDuration]);
                NSLog(@"Location : %@",[result valueForProperty:ALAssetPropertyLocation]);
                NSLog(@"Orientation : %@",[result valueForProperty:ALAssetPropertyOrientation]);
                NSLog(@"Representations : %@",[result valueForProperty:ALAssetPropertyRepresentations]);
                NSLog(@"Type : %@",[result valueForProperty:ALAssetPropertyType]);
                NSLog(@"URLs : %@",[result valueForProperty:ALAssetPropertyURLs]);
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


// Section for Item Count...
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
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

@end
