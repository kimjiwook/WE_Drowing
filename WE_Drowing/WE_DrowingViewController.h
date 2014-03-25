//
//  WE_DrowingViewController.h
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 18..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WE_DrowingViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionViews;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) NSArray *assets;

@end
