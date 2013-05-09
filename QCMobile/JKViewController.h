//
//  JKViewController.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/5/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKQCView;

@interface JKViewController : UIViewController

@property(nonatomic, weak) IBOutlet JKQCView *qcView;
@property(nonatomic, weak) IBOutlet UILabel *rateLabel;

- (IBAction) toggle:(id)sender;

@end
