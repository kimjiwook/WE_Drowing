//
//  ImageEditingViewController.m
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 28..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.
//

#import "ImageEditingViewController.h"

@interface ImageEditingViewController ()

@end

@implementation ImageEditingViewController
@synthesize imageView;
@synthesize scrollView;

- (void) initWithImageView :(UIImage *)image {
    CGRect rect = self.view.bounds;
    rect.size.height = self.view.bounds.size.height-60-20;
    rect.origin.y = self.view.bounds.origin.y +20;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.scrollView.bouncesZoom = YES;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 2.5f;
    
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.image = [ImageHelper image:image fitInView:self.imageView];
    [self.imageView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:self.imageView];
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-60, 110, 60)];
    [tempBtn setBackgroundColor:[UIColor grayColor]];
    [tempBtn setTitle:@"NEW" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(tempAcc:) forControlEvents:UIControlEventTouchUpInside];
    [tempBtn setHidden:NO];
    [self.view addSubview:tempBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//입력인자로 들어온 scrollView 객체에서 스크롤이 시작되기 직전에 호출되는 메시지
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (IBAction)tempAcc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
