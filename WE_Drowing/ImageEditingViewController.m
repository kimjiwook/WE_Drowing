//
//  ImageEditingViewController.m
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 28..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.
//

#import "ImageEditingViewController.h"

@interface ImageEditingViewController ()

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2;

@end

@implementation ImageEditingViewController
@synthesize imageView;
@synthesize scrollView;

@synthesize lastPoint;
@synthesize prePreviousPoint;
@synthesize previousPoint;
@synthesize lineWidth;
@synthesize currentColor;

- (void) initWithImageView :(UIImage *)image {
    NSLog(@"image Size : %lf,%lf",image.size.width,image.size.height);
    
    CGRect rect = self.view.bounds;
    
    self.scrollView = [[ModelScrollView alloc] initWithFrame:rect];
    self.scrollView.bouncesZoom = YES;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 2.5f;
//    [self.scrollView setShowsVerticalScrollIndicato:NO];
    
    [self.scrollView setDelegate:self];
    [self.scrollView setScrollEnabled:NO];
//    [self.view addSubview:self.scrollView];
    

    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    CGSize toSize = [ImageHelper fitSize:image.size inSize:imageView.frame.size];
    rect.size = toSize;
    rect.origin.x = 100;
    rect.origin.y = 100;
    [self.imageView setFrame:CGRectMake(100, 100, rect.size.width, rect.size.height)];
    self.imageView.image = [ImageHelper image:image fitInView:self.imageView];
    [self.imageView setBackgroundColor:[UIColor blackColor]];
//    [self.scrollView addSubview:self.imageView];
    
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    
    [self.view addSubview:imageView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    prePreviousPoint = CGPointZero;
    previousPoint = CGPointZero;
    lineWidth = 1.0;
    currentColor = [UIColor redColor];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"DidScroll");
}

//입력인자로 들어온 scrollView 객체에서 스크롤이 시작되기 직전에 호출되는 메시지
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (IBAction)tempAcc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    self.previousPoint = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
    UITouch *touch = [touches anyObject];
    
    self.prePreviousPoint = self.previousPoint;
    self.previousPoint = [touch previousLocationInView:self.view];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    // calculate mid point
    CGPoint mid1 = [self calculateMidPointForPoint:self.previousPoint andPoint:self.prePreviousPoint];
    CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:self.previousPoint];
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[self currentColor] setStroke];
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, self.previousPoint.x, self.previousPoint.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGFloat xDist = (previousPoint.x - currentPoint.x); //[2]
    CGFloat yDist = (previousPoint.y - currentPoint.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    
    distance = distance / 10;
    
    if (distance > 10) {
        distance = 10.0;
    }
    
    distance = distance / 10;
    distance = distance * 3;
    
    if (4.0 - distance > self.lineWidth) {
        lineWidth = lineWidth + 0.3;
    } else {
        lineWidth = lineWidth - 0.3;
    }
    
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextStrokePath(context);
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    [self setLineWidth:1.0];
    
    if ([touch tapCount] == 1) {
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [[self currentColor] setStroke];
        
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
        CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
        
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        
        CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextSetLineWidth(context, 4.0);
        
        CGContextStrokePath(context);
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}


@end
