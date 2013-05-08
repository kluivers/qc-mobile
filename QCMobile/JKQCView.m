//
//  JKQCView.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/8/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKQCView.h"
#import "JKComposition.h"


@implementation JKQCView

- (void) drawRect:(CGRect)rect
{
    NSLog(@"%s", __func__);
    [self.composition render];
}

@end
