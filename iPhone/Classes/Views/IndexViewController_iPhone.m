//
//  IndexViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "IndexViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "FlashCard.h"
#import "CardDetails_iPhone.h"
#import "DBAccess.h"

@implementation IndexViewController_iPhone

@synthesize _tableView;
//@synthesize cards;
@synthesize indices;

#pragma mark -
#pragma mark View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forDeck:(FlashCardDeck *)objDeck 
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kEventCardDetailsUnloaded object:nil];
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	self.navigationItem.title=@"Cards Index";
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
	// Check whether the call has been made from the index button on deck view controller or the click of the card deck
	if (objDeck != nil) {
		// Set the label text to the title of the deck and also get the list of cards for that deck
		self.navigationItem.title = objDeck.deckTitle;
		cards = [[objDeck getCardsList] retain];
		if([AppDelegate_iPhone delegate].isRandomCard == 1)
		{
			[Utils randomizeArray:cards];
		}
		_source = @"DeckCard";
		indices = [[NSMutableArray alloc] initWithObjects:@"   ",nil];
		
	}
	else 
	{
		// Header is set and 
		self.navigationItem.title=@"Cards Index";
		_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
		DBAccess* db=[AppDelegate_iPhone getDBAccess];
		cards=[db getCardsByAlphabets];
		indices=[[NSMutableArray alloc] init];
		_source = @"IndexCard";
		
		for(int i=0;i<[cards count];i++){
			
			char alphabet = [[cards objectAtIndex:i] characterAtIndex:0];
			NSString *uniChar = [NSString stringWithFormat:@"%C", alphabet];
			if (![indices containsObject:uniChar])
			{            
				[indices addObject:uniChar];
			} 
		}
		
	}
	
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forBookmarkedDeck:(BOOL)bIsBookmarkedDeck
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
	// Set the label text to the title of the deck and also get the list of cards for that deck
	self.navigationItem.title= @"Bookmarked Cards";
	_source = @"BookmarkedCards";
	cards = [[[AppDelegate_iPhone getDBAccess] getCardListForDeckType:kCardDeckTypeBookMark withId:-1] retain];
	
	/*
	 if([AppDelegate_iPad delegate].isRandomCard == 1)
	 {
	 [Utils randomizeArray:cards];
	 }
	 */
	indices = [[NSMutableArray alloc] initWithObjects:@"   ",nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDetailsViewUnloaded) name:kEventCardDetailsUnloaded object:nil ];
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

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
		DBAccess* db=[AppDelegate_iPhone getDBAccess];
		NSMutableArray *flashCards=[db getCardsByAlphabet:alphabet];
		
		//NSLog(@"Alphabet : %@, Section : %d, Rows : %d",alphabet, section,[flashCards count]);
		
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
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
		//cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
		/*cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"all_cards_bg.png"]] autorelease];*/
		
		
		UIImage* myImage=[UIImage imageNamed:@"blue_arw.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		[cell setAccessoryView:imageView];
		
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
		
		//NSLog(@"For alphabet %@, no. of cards : %d",alphabet,[flashCards count]);
		
		if ([flashCards count]>0) {
			//---extract the relevant state from the states object---
			NSString *cellValue = [flashCards objectAtIndex:indexPath.row];
			cell.textLabel.text = cellValue;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
	}
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *alphabet = [indices objectAtIndex:[indexPath section]];
	CGSize labelSize = CGSizeMake(195.0f, 20.0);
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
		//---get all states beginning with the letter---
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
		NSArray *flashCards = [cards filteredArrayUsingPredicate:predicate];
		
		if([flashCards count] > 0)
		{
			NSString * strCardName = [flashCards objectAtIndex:indexPath.row];
			if ([strCardName length] > 0)
				labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
			
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
	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
	NSMutableArray* deckArray;
	NSUInteger row = 0;
	if ([_source isEqualToString:@"DeckCard"] || [_source isEqualToString:@"BookmarkedCards"]) {
		deckArray = [cards retain];
		row = indexPath.row;
	}
	else
	{
		deckArray=[db getFlashCardForQuery:SELECT_Alphabetical_DECK_CARD_QUERY];
		
		
		// Calculate Row index.
		NSUInteger row = 0;
		 NSUInteger sect = indexPath.section;
		 for (NSUInteger i = 0; i < sect; ++ i)
		 {
			//NSLog(@"No. of rows in section %d is %d",i,[_tableView numberOfRowsInSection:i]);
			row += [_tableView numberOfRowsInSection:i];
		 }
		 row += indexPath.row;
	}
	[self.navigationController pushViewController:detail animated:YES];
	detail._selectedCardIndex=row;
	[detail loadArrayOfCards:deckArray];
	[detail release];
	
}

#pragma mark -
#pragma mark Bookmark delegate
-(void)cardDetailsViewUnloaded
{
	cards = [[[AppDelegate_iPhone getDBAccess] getCardListForDeckType:kCardDeckTypeBookMark withId:-1] retain];
	[_tableView reloadData];
	
	//NSLog(@"Source is : %@",_source);
	
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
	[self popView];
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

