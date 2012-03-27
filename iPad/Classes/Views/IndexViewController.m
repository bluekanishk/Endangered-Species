//
//  IndexViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "IndexViewController.h"
#import "AppDelegate_iPad.h"
#import "FlashCard.h"
#import "CardDetails.h"
#import "DBAccess.h"

@implementation IndexViewController

@synthesize _tableView;
@synthesize cards;
@synthesize indices;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forDeck:(FlashCardDeck *)objDeck 
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	// Create a transparent label for showing the header
	UILabel* lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(66, 13, 500, 20)];
	lblHeader.font = [UIFont boldSystemFontOfSize:22];
	lblHeader.backgroundColor = [UIColor clearColor];
	[lblHeader setTextAlignment:UITextAlignmentCenter];
	
	// Check whether the call has been made from the index button on deck view controller or the click of the card deck
	if (objDeck != nil) {
		// Set the label text to the title of the deck and also get the list of cards for that deck
		lblHeader.text= objDeck.deckTitle;
		cards = [[objDeck getCardsList] retain];
		if([AppDelegate_iPad delegate].isRandomCard == 1)
		{
			[Utils randomizeArray:cards];
		}
		_source = @"DeckCard";
		indices = [[NSMutableArray alloc] initWithObjects:@"   ",nil];
	}
	else 
	{
		// Header is set and 
		lblHeader.text=@"Cards Index";
		_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
		cards=[[AppDelegate_iPad getDBAccess] getCardsByAlphabets];
		indices=[[NSMutableArray alloc] init];
		
		for(int i=0;i<[cards count];i++)
		{
			char alphabet = [[cards objectAtIndex:i] characterAtIndex:0];
			NSString *uniChar = [NSString stringWithFormat:@"%C", alphabet];
			if (![indices containsObject:uniChar])
			{            
				[indices addObject:uniChar];
			} 
		}
		[indices addObject:@""];
	}
	[self.view addSubview:lblHeader];
	[lblHeader release];
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forBookmarkedDeck:(BOOL)bIsBookmarkedDeck
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	// Create a transparent label for showing the header
	UILabel* lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(66, 13, 500, 20)];
	lblHeader.font = [UIFont boldSystemFontOfSize:22];
	lblHeader.backgroundColor = [UIColor clearColor];
	[lblHeader setTextAlignment:UITextAlignmentCenter];
	
	// Set the label text to the title of the deck and also get the list of cards for that deck
	lblHeader.text= @"Bookmarked Cards";
	_source = @"BookmarkedCards";
	cards = [[[AppDelegate_iPad getDBAccess] getCardListForDeckType:kCardDeckTypeBookMark withId:-1] retain];
	/*
	if([AppDelegate_iPad delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:cards];
	}
	*/
	indices = [[NSMutableArray alloc] initWithObjects:@"   ",nil];
	
	[self.view addSubview:lblHeader];
	[lblHeader release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDetailsViewUnloaded) name:kEventCardDetailsUnloaded object:nil ];
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

-(void) setParentViewCtrl:(DeckViewController*) parentView{
	_parentView=parentView;
}


-(IBAction) closeIndex:(id)sender{
	[self.view removeFromSuperview];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int iSectionCount = -1;
	if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) 
	{
		iSectionCount = 1;
	}
	else {
		iSectionCount = [indices count];
	}

	return iSectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int iRowSCount = -1;
    if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
		iRowSCount = [cards count];
	}
	else {
		NSString *alphabet = [indices objectAtIndex:section];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
		NSArray *flashCards = [cards filteredArrayUsingPredicate:predicate];
		iRowSCount = [flashCards count];
	}
    return iRowSCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	NSString* strHeaderTitle = @"";
	if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
		strHeaderTitle = @"";
	}
	else {
		strHeaderTitle = [indices objectAtIndex:section];
	}

	return strHeaderTitle;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect tableRect = self.view.frame;
	tableRect.origin.x = 0; 
	tableView.frame = tableRect;
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
		cell.textLabel.font = [UIFont systemFontOfSize:18];
		
		UIImage* myImage=[UIImage imageNamed:@"blue_arw.png"];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];
		[imageView release];
		
	}
	
	if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
		Card* card = (Card *)[[cards objectAtIndex:indexPath.row] getCardOfType: kCardTypeFront];
		NSString *cellValue = card.cardName;
        cell.textLabel.text = cellValue;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	}
	else
	{
		NSString *alphabet = [indices objectAtIndex:[indexPath section]];
		
		//---get all states beginning with the letter---
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
		NSArray *flashCards = [cards filteredArrayUsingPredicate:predicate];
		
		if ([flashCards count]>0) {
			//---extract the relevant state from the states object---
			NSString *cellValue = [flashCards objectAtIndex:indexPath.row];
			cell.textLabel.text = cellValue;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		}
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSArray *flashCards;
	CGSize labelSize = CGSizeMake(450.0f, 20.0);
	if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
		if([cards count] > 0)
		{
			NSString * strCardName = @"";
			if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
				Card* card =  (Card *)[[cards objectAtIndex:indexPath.row] getCardOfType: kCardTypeFront];
				strCardName = card.cardName;
				
			}else {
				strCardName = [cards objectAtIndex:indexPath.row];
			}

			if ([strCardName length] > 0)
				labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 18.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
			
		}
	}
	else 
	{
		NSString *alphabet = [indices objectAtIndex:[indexPath section]];
		//---get all states beginning with the letter---
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
		flashCards = [cards filteredArrayUsingPredicate:predicate];
		if([flashCards count] > 0)
		{
			NSString * strCardName = [flashCards objectAtIndex:indexPath.row];
			if ([strCardName length] > 0)
				labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 18.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
			
		}
	}
	return 24.0 + labelSize.height;
}


//---set the index for the table---
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indices;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray* deckArray;
	NSUInteger row = 0;
	if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
		deckArray = [cards retain];
		row = indexPath.row;
	}
	else
	{
		deckArray=[[AppDelegate_iPad getDBAccess] getFlashCardForQuery:SELECT_Alphabetical_DECK_CARD_QUERY];
		// Calculate Row index.
		NSUInteger sect = indexPath.section;
		for (NSUInteger i = 0; i < sect; ++ i)
			row += [_tableView numberOfRowsInSection:i];
		row += indexPath.row;
	}
	[_parentView showDetailViewWithArray:deckArray cardIndex:row caller:@"index"];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

#pragma mark -
#pragma mark Bookmark delegate
-(void)cardDetailsViewUnloaded
{
	cards = [[[AppDelegate_iPad getDBAccess] getCardListForDeckType:kCardDeckTypeBookMark withId:-1] retain];
	[_tableView reloadData];
	
	if (![cards count] && [_source isEqualToString:@"BookmarkedCards"] ) {
		UIAlertView* avNoCards = [[UIAlertView alloc] initWithTitle:@"No Bookmarks" message:@"No bookmarked cards to show." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[avNoCards show];
		[avNoCards release];
	}
}
#pragma mark -
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	[self closeIndex:nil];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[_tableView release];
	[cards release];
	[indices release];
	[_source release];
	[super dealloc];
}


@end

