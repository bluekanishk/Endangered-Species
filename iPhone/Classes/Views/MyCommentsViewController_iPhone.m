//
//  MyCommentsViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "MyCommentsViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "CardDetails_iPhone.h"
#import "CommentsViewController_iPhone.h"
#import "CardWrapper.h"
#import "DBAccess.h"


@implementation MyCommentsViewController_iPhone

@synthesize _tableView;
@synthesize myComments;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title=@"My Comments";
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	myComments=[db getAllComments];
	
}

- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if ([myComments count]==0) {
		return 1;
	}
	
    return [myComments count];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{    
	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		CardWrapper* card=(CardWrapper*)[myComments objectAtIndex:indexPath.row];
		DBAccess *db=[AppDelegate_iPhone getDBAccess];
		
		BOOL result=[db deleteComments:card.flashCardId];
		if (result==YES) {
			[myComments removeObjectAtIndex:indexPath.row];
			[_tableView reloadData];
		}		
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if ([myComments count]==0) {
		cell.textLabel.text = @"No Comments Found!";
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.backgroundColor=[UIColor clearColor];
		
	}else {
		cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		UIImage* myImage=[UIImage imageNamed:@"yel_arw.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];
		
		NSString *cellValue = [[myComments objectAtIndex:indexPath.row] cardName];
		cell.textLabel.text = cellValue;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([myComments count]==0) {
		return;
	}
	
	//Load Comments View
	CommentsViewController_iPhone *detailViewController = [[CommentsViewController_iPhone alloc] initWithNibName:@"CommentsView_iPhone" bundle:nil];
	[detailViewController setFlashCardId:[[myComments objectAtIndex:indexPath.row] flashCardId]];
	[self.navigationController presentModalViewController:detailViewController animated:YES];
	[detailViewController release];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[_tableView release];
	[myComments release];
    [super dealloc];
}


@end

