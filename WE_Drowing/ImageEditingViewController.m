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

- (void) initWithImageView :(UIImage *)image {
    CGRect rect = self.view.bounds;
    rect.size.height = self.view.bounds.size.height-60-20;
    rect.origin.y = self.view.bounds.origin.y +20;
    
    self.imageView = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.image = [ImageHelper image:image fitInView:self.imageView];
    [self.imageView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.imageView];
    
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

- (IBAction)tempAcc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
