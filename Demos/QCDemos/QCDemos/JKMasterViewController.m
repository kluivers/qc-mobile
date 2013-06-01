//
//  JKMasterViewController.m
//  QCDemos
//
//  Created by Joris Kluivers on 5/31/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKMasterViewController.h"

#import "JKCompositionViewController.h"

#import "JKComposition.h"

@interface JKMasterViewController ()
@property(nonatomic, strong) NSArray *compositions;
@end

@implementation JKMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Demos", nil);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (JKCompositionViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSMutableArray *compositions = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSDirectoryEnumerator *resourceEnum = [fileManager enumeratorAtPath:resourcePath];
    
    NSString *file;
    while ((file = [resourceEnum nextObject])) {
        if ([[file pathExtension] isEqualToString:@"qtz"]) {
            [compositions addObject:[resourcePath stringByAppendingPathComponent:file]];
        }
    }
    
    self.compositions = compositions;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.compositions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *file = self.compositions[indexPath.row];
    cell.textLabel.text = [file lastPathComponent];
    return cell;
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSString *compositionPath = self.compositions[indexPath.row];
        JKComposition *composition = [[JKComposition alloc] initWithPath:compositionPath];
        
        self.detailViewController.composition = composition;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSString *compositionPath = self.compositions[indexPath.row];
        JKComposition *composition = [[JKComposition alloc] initWithPath:compositionPath];
        
        ((JKCompositionViewController *)[segue destinationViewController]).composition = composition;
    }
}

@end
