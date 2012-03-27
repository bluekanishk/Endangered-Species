//
//  CardList.m
//  SchlossExtra
//
//  Created by Chandan Kumar on 16/08/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//

#import "CardList_iPhone.h"
#import "CardDetails_iPhone.h"
#import "FlashCard.h"
#import "DBAccess.h"

@implementation CardListIPhone
@synthesize arrCards;
@synthesize tblCardNames;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	tblCardNames.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) showCardsForDeck:(int) iDeckId
{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	FlashCardDeck* objFlashCardDeck = [db getFlashCardDeckByDeckId:iDeckId];
	UILabel *lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(-20, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont boldSystemFontOfSize:20.0];
	lblDeckName.textColor = [UIColor whiteColor];
	lblDeckName.text = objFlashCardDeck.deckTitle;
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAlfabaticallly withId:iDeckId] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
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
    if ([arrCards count]==0) {
		return 1;
	}
	
	return [arrCards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
		
	}
    
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
	NSString *cellValue = [card cardName];
		
	cell.textLabel.text = cellValue;
	UIImage* myImage=[UIImage imageNamed:@"blue_arw.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
	[cell setAccessoryView:imageView];
	cell.textLabel.font = [UIFont systemFontOfSize:18];
	//This allows for multiple lines
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	//cell.textLabel.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];

	
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	CGSize labelSize = CGSizeMake(272.0f, 20.0);
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
	
	NSString * strCardName = [card cardName];
	if ([strCardName length] > 0)
		labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 18.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
	return 24.0 + labelSize.height;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([arrCards count]==0) {
		return;
	}
	
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
	[self.navigationController pushViewController:detail animated:YES];
	
	detail._selectedCardIndex=indexPath.row;
	[detail loadArrayOfCards:arrCards];
	[detail release];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}


@end
