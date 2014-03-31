//
//  Size_ViewController.m
//  ViewSize
//
//  Created by JWMAC on 13. 9. 27..
//  Copyright (c) 2013년 Kim Ji Wook. All rights reserved.
//

#import "Size_ViewController.h"

@interface Size_ViewController ()

@end

@implementation Size_ViewController

- (void) viewWillLayoutSubviews{
    self.view.backgroundColor = [UIColor blackColor];

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
    } else {
        // Load resources for iOS 7 or later
        CGRect rect = [[UIScreen mainScreen] applicationFrame];
        rect.origin.y = 20;  //y좌표를 20내리고
        rect.size.height -= 20;  //높이를 20줄인다.
        self.view.frame = rect;
    }
    
    [super viewWillLayoutSubviews];
}

@end
