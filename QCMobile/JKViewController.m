//
//  JKViewController.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKViewController.h"
#import "JKComposition.h"
#import "JKQCView.h"

@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.qcView.context = context;
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmptyTest" ofType:@"qtz"];
    
    JKComposition *composition = [[JKComposition alloc] initWithPath:path];
    
    self.qcView.composition = composition;
    [self.qcView setNeedsDisplay];
    
    NSLog(@"Context: %@", self.qcView.context);
}


@end
