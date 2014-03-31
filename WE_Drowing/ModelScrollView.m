//
//  ModelScrollView.m
//  WE_Drowing
//
//  Created by JWMAC on 2014. 3. 31..
//  Copyright (c) 2014년 KimJiWook. All rights reserved.
//

#import "ModelScrollView.h"

@implementation ModelScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - View lifecycle
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview touchesMoved:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview touchesCancelled:touches withEvent:event];
}

@end
