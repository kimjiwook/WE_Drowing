//
//  ImageEditingViewController.h
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 28..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"

@interface ImageEditingViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void) initWithImageView :(UIImage *)image;

@end
