//
//  SearchViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "SearchViewController_iPhone.h"
#import "CardDetails_iPhone.h"
#import "FlashCard.h"
#import "DBAccess.h"


@implementation SearchViewController_iPhone
@synthesize _tableView;
@synthesize cards;
@synthesize _searchBar;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
	[super viewDidLoad];
	self.navigationItem.title=@"Search Cards";
	
	UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	[leftView addSubview:leftButtonImg];
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftView] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	[leftView release];
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db searchCardsByName:@""];
	
}


- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	/*
	if ([searchText isEqualToString:@""]) {
		return;
	}
	
	[cards removeAllObjects];	 
	cards=[[AppDelegate_iPhone getDBAccess] searchCardsByName:searchText];
	[_tableView reloadData];
	 */
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
	NSString *searchText=[searchBar text];
	//if ([searchText isEqualToString:@""]) {
	//	return;
	//}
	
	[cards removeAllObjects];
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db searchCardsByName:searchText];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];

}


- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
	[cards removeAllObjects];	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db searchCardsByName:@""];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
    if ([cards count]==0) {
		return 1;
	}
	
	return [cards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
	if ([cards count]==0) {
		cell.textLabel.text = @"No Search Result Found!";
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}else {
		FlashCard* card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		NSString *cellValue = [card cardName];
		
		cell.textLabel.text = cellValue;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		UIImage* myImage=[UIImage imageNamed:@"blue_arw.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];		
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		//This allows for multiple lines
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		/*
		CGSize maximumSize = CGSizeMake(1000, 9999);
		CGSize myStringSize = [cellValue sizeWithFont:cell.textLabel.font 
								   constrainedToSize:maximumSize 
										lineBreakMode:UILineBreakModeClip];
		NSLog(@"String - %@, Height - %f, Width - %f",cellValue,myStringSize.height,myStringSize.width);
		 */
	}

	
	
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	CGSize labelSize = CGSizeMake(272.0f, 20.0);
	if ([cards count]!=0) {
		FlashCard* card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		NSString * strCardName = [card cardName];
		if ([strCardName length] > 0)
			labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
	}
	return 24.0 + labelSize.height;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	int iQuotient = 0;
	CGSize myStringSize;
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;

	if([cards count] != 0)
	{
		CGSize maximumSize = CGSizeMake(300, 9999);
		FlashCard* card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		NSString * strCardName = [card cardName];
		myStringSize = [strCardName sizeWithFont:[UIFont systemFontOfSize:18] 
								  constrainedToSize:maximumSize 
									  lineBreakMode:UILineBreakModeWordWrap];
		//iQuotient = (myStringSize.width / 270);
//		float iRemainder = (myStringSize.width/270) - iQuotient;
//		if (iQuotient > 0 && iRemainder > 0.7) {
//			iQuotient++;
//		}
//NSLog(@"String - %@, Width - %f, Multiple - %f, Adder - %d",strCardName,myStringSize.width,(myStringSize.width / 270),iQuotient);
	}
	return myStringSize.height+20;
		//return 40 + (iQuotient * 20);
}
 */

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([cards count]==0) {
		return;
	}
	
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
	[self.navigationController pushViewController:detail animated:YES];
	
	detail._selectedCardIndex=indexPath.row;
	detail._searchText=[_searchBar text];
	[detail loadArrayOfCards:cards];
	[detail release];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[_tableView release];
	[_searchBar release];
	[cards release];
    [super dealloc];
}


@end

