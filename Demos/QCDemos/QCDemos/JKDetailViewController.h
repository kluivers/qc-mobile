//
//  JKDetailViewController.h
//  QCDemos
//
//  Created by Joris Kluivers on 5/31/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
