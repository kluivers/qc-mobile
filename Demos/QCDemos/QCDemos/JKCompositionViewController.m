//
//  JKDetailViewController.m
//  QCDemos
//
//  Created by Joris Kluivers on 5/31/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKCompositionViewController.h"

#import "JKComposition.h"
#import "JKQCView.h"


@interface JKCompositionViewController ()
@property (nonatomic, weak) IBOutlet JKQCView *compositionView;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation JKCompositionViewController

#pragma mark - Managing the detail item

- (void) setComposition:(JKComposition *)newComposition
{
    if (_composition != newComposition) {
        _composition = newComposition;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.composition) {
        self.compositionView.composition = self.composition;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.compositionView.context = context;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.compositionView startAnimation];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.compositionView stopAnimation];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
