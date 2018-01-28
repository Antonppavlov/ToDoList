//
//  MainTableViewController.m
//  ToDoList
//
//  Created by Anton Pavlov on 23.11.2017.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

#import "MainTableViewController.h"
#import "DetailViewController.h"

@interface MainTableViewController ()

@property(nonatomic, strong) NSMutableArray *arrayEvent;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadTableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"NewEvent" object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTableView {
    [self.arrayEvent removeAllObjects];

    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.arrayEvent = [[NSMutableArray alloc] initWithArray:array];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayEvent.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];


    UILocalNotification *notification = [self.arrayEvent objectAtIndex:indexPath.row];
    NSDictionary *dictionary = notification.userInfo;


    cell.textLabel.text = [dictionary objectForKey:@"eventInfo"];
    cell.detailTextLabel.text = [dictionary objectForKey:@"eventDate"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];


    UILocalNotification *notification = [self.arrayEvent objectAtIndex:indexPath.row];
    NSDictionary *dictionary = notification.userInfo;


    detailViewController.eventInfo = [dictionary objectForKey:@"eventInfo"];
    detailViewController.eventDate = notification.fireDate;
    detailViewController.isDetail = YES;

    [self.navigationController pushViewController:detailViewController animated:YES];


}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UILocalNotification *notification = [self.arrayEvent objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        [self.arrayEvent removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


@end
