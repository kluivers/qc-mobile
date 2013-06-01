//
//  JKDetailViewController.h
//  QCDemos
//
//  Created by Joris Kluivers on 5/31/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKComposition;

@interface JKCompositionViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) JKComposition *composition;

@end
