//
//  MasterViewController.m
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "WeekViewFlowLayout.h"
#import "WeekView.h"

#import "UIView+Borders.h"
#import "NSDate+Extended.h"

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    @private
        WeekView *weekView;
        UIView *weekViewSelectionView;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    // Week View
    WeekViewFlowLayout *weekViewLayout = [[WeekViewFlowLayout alloc] init];
    weekViewLayout.flowLayoutCellSpacing = 0;

    weekView = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, 0, 65) collectionViewLayout:weekViewLayout];
    weekView.delegate = self;
    weekView.dataSource = self;

    int nextYear = (int)[[NSDate date] year] +1;
    [weekView setStartDate:[NSDate date] endDate:[NSDate dateWithYear:nextYear month:1 day:1 hour:1 minute:1 second:1]];
    [weekView setCurrentDate:[NSDate date] animated:NO];

    weekView.showsHorizontalScrollIndicator = NO;
    [weekView registerClass:[WeekViewCell class] forCellWithReuseIdentifier:@"WeekViewCellIdentifier"];

    self.tableView.tableHeaderView = weekView;

    // Bottom Border
    UIColor *borderColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];
    float borderWidth = .5;

    [self.tableView.tableHeaderView addBottomBorderWithHeight:borderWidth andColor:borderColor]; // FIXME: Border doesn't resize when scrolling headerView
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];

    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(WeekView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [collectionView.weekViewDays count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float widthOfCell = 76;
    float heightOfCell = collectionView.frame.size.height-20;

    return CGSizeMake(heightOfCell, widthOfCell);
}

- (WeekViewCell *)collectionView:(WeekView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekViewCell *cell = (WeekViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WeekViewCellIdentifier" forIndexPath:indexPath];
    WeekViewDay *cellDay = (WeekViewDay *)[collectionView.weekViewDays objectAtIndex:indexPath.row];

    cell.dayNameLabel.text = cellDay.name;
    cell.dayDateLabel.text = [NSString stringWithFormat:@"%@",cellDay.day];

    [cell setNeedsDisplay];

    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)showWeekViewSelectionViewTo:(WeekView *)collectionView cellAtIndexPath:(NSIndexPath *)indexPath
{
    WeekViewCell *selectedCell = (WeekViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    selectedCell.dayNameLabel.textColor = [UIColor whiteColor];
    selectedCell.dayDateLabel.textColor = [UIColor whiteColor];

    // WeekViewSelectionView
    weekViewSelectionView = [[UIView alloc] initWithFrame:CGRectMake(5, 5+3, selectedCell.frame.size.width-10, selectedCell.frame.size.height-18)];
    weekViewSelectionView.backgroundColor = [UIColor colorWithRed:0.45 green:0.54 blue:0.67 alpha:1];
    weekViewSelectionView.layer.cornerRadius = 9;
    weekViewSelectionView.layer.masksToBounds = YES;

    [selectedCell addSubview:weekViewSelectionView];
    [selectedCell sendSubviewToBack:weekViewSelectionView];
}

-(void)deselectCollectionView:(WeekView *)collectionView cellAtIndexPath:(NSIndexPath *)indexPath
{
    WeekViewCell *selectedCell = (WeekViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    selectedCell.dayNameLabel.textColor = [UIColor blackColor];
    selectedCell.dayDateLabel.textColor = [UIColor blackColor];

    [weekViewSelectionView removeFromSuperview];
    weekViewSelectionView = nil;
}

- (BOOL)collectionView:(WeekView *)collectionView
        shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(WeekView *)collectionView
        shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)collectionView:(WeekView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showWeekViewSelectionViewTo:collectionView cellAtIndexPath:indexPath];
}

-(void)collectionView:(WeekView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectCollectionView:collectionView cellAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewFlowLayout Delegate

- (UIEdgeInsets)collectionView:(WeekView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][(NSUInteger) section];
    return [sectionInfo numberOfObjects];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}

@end
