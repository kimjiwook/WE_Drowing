//
//  ImageEditingViewController.h
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 28..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"
//#import "JCDrawView.h"
#import "ModelScrollView.h"
#import "Size_ViewController.h"

@interface ImageEditingViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ModelScrollView *scrollView;

@property (nonatomic, strong) UIColor *currentColor;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint prePreviousPoint;
@property (nonatomic) CGPoint previousPoint;
@property (nonatomic) CGFloat lineWidth;


- (void) initWithImageView :(UIImage *)image;

@end
