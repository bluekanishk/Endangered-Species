//
//  ActionViewController.m
//  Procedure
//
//  Created by Amitabh on 04/09/11.
//  Copyright 2011 getiphonedeveloper@gmail.com . All rights reserved.
//

#import "ActionViewController.h"



@implementation ActionViewController


#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self setTitle:@"Actions"];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setContentSizeForViewInPopover:CGSizeMake(320, 480)];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		
    }
    
    // Configure the cell...
	switch (indexPath.section) {
		case 0:
			[cell.textLabel setText:@"My Voice Notes"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		case 1:
			[cell.textLabel setText:@"My Written Notes"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		case 2:
			[cell.textLabel setText:@"Post to Facebook"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		case 3:
			[cell.textLabel setText:@"Post to Twitter"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		case 4:
			[cell.textLabel setText:@"About us"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		default:
			[cell.textLabel setText:@"Help"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
	}
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0:
			//NSLog(@"voiceNotes");
			break;
		case 1:
			//NSLog(@"notes");
			break;
		case 2:
			//NSLog(@"facebookPost");
			break;
		case 3:
			//NSLog(@"twitterPost");
			break;
		case 4:
			//NSLog(@"aboutUs");
			break;
		default:
			//NSLog(@"help");
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}


@end


