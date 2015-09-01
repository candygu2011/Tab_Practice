//
//  DeleteTableViewController.m
//  ScrollerVC
//
//  Created by hi on 15/7/16.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "DeleteTableViewController.h"
#import "FMDBDemoViewController.h"

@interface DeleteTableViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;


@end

@implementation DeleteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"数据11",@"数据12",@"数据13",@"数据14",@"数据15",nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMDBDemoViewController *demoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FMDBDemoViewController"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:demoVC animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataArray removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {

    
    }
}



@end
