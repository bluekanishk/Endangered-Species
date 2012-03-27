//
//  DeckViewController.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeckCell_iPhone.h"
#import "CardDetails_iPhone.h"
#import "AppDelegate_iPhone.h"

#import "FlashCard.h"
#import "CardList_iPhone.h"
#import "ModalViewCtrl_iPhone.h"

#import "DeckViewController_iPhone.h"
#import "SearchViewController_iPhone.h"
#import "IndexViewController_iPhone.h"
#import "MyCommentsViewController_iPhone.h"
#import "MyVoiceNotesViewController_iPhone.h"
#import "TwittSpriteViewController.h"

//#import "FBConnect/FBConnect.h"
//#import "FBConnect/FBSession.h"

//static NSString *facebookAppId=@"153061968092263";
//static NSString *facebookAppSecretKey=@"5c0f38edb94a13f9592f2df6f46ca202";
// this app id is for spearhead flash cards
//static NSString *facebookAppId=@"136422206434654";
//static NSString *facebookAppSecretKey=@"d9b94a7b6157859be29f2556d00fadde";



@implementation DeckViewController_iPhone
@synthesize cardDecks = _cardDecks;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	[_tableView setBackgroundColor:[UIColor clearColor]];
	/*
	UIImage *image = [UIImage imageNamed: @"footer_bar_bg.png"];
	UIImageView *imageview = [[UIImageView alloc] initWithImage: image];
	imageview.frame = CGRectMake(0.0,0.0,320.0,44.0);
	self.navigationItem.titleView = imageview;
	*/
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.delegate = self;
	//self.title = @"Antibiotic Manual";
	//self.title = [Utils getValueForVar:kHeaderTitle];
	UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
	tlabel.text=[Utils getValueForVar:kHeaderTitle];
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
	tlabel.font = [UIFont boldSystemFontOfSize:21];
	[tlabel setTextAlignment:UITextAlignmentCenter];
    self.navigationItem.titleView=tlabel;
	twittView = [[TwittSpriteViewController alloc] init];
	
	
	// Facebook Session
	/*
	if (self.session == nil){
		self.session = [FBSession sessionForApplication:[Utils getValueForVar:kFacebookAppID] secret:[Utils getValueForVar:kFacebookAppSecretKey] delegate:self];
	}*/
	
}

- (void)dealloc
{
    [super dealloc];
	[_indexView release];
}

#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	if(section == 3)
		return _cardDecks.flashCardDeckList.count + 1;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 3 && indexPath.row == 0)
		return 33;
	
	return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DeckCell_iPhone* cell = nil;
	
	if(indexPath.section == 3 && indexPath.row == 0)
	{
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"deck_top_bg.png"]] autorelease];
		
		//cell.textLabel.text = @"Decks By Antibiotics:";
		cell.textLabel.text = [Utils getValueForVar:kDeckHeader];
		//cell.textLabel.textColor =[UIColor colorWithRed:0 green:95 blue:111 alpha:1.0];
		
		cell.textLabel.textColor = [Utils colorFromString:[Utils getValueForVar:kDeckHeaderTextColor]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	
	switch (indexPath.section) 
	{
		case 0:
			tableView.separatorColor = nil;
			cell = [DeckCell_iPhone creatCellViewWithText:@"Introduction" withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
			cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]];
			break;
			
		case 1:
			tableView.separatorColor = nil;
			cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
			break;
			
		case 2:
			tableView.separatorColor = nil;
			cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
			break;
			
		case 3:
			tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
			cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
			break;
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(indexPath.section == 3 && indexPath.row == 0)
		return;
	
	NSMutableArray* deckArray;
	
	switch (indexPath.section) 
	{
		case 0:
			[self displayGlossary];
			break;
			
		case 1:
			[AppDelegate_iPhone delegate].isBookMarked = NO;
			deckArray = [_cardDecks.allCardDeck  getCardsList];
			break;
			
		case 2:
			[AppDelegate_iPhone delegate].isBookMarked = YES;
			deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
			break;
			
		case 3:
			[AppDelegate_iPhone delegate].isBookMarked = NO;
			deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1]  getCardsList];
			break;
	}
	
	if (indexPath.section == 2 && (deckArray == nil || deckArray.count <= 0))
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarked items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	// This section will only be executed if the first section i.e. "Introduction" hasn't been clicked
	if(indexPath.section != 0)
	{
		// If anything apart from "All Cards" deck has been clicked and "CardList" flag is set then show the card list
		if (indexPath.section != 1 && [[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"]) 
		{
			if (indexPath.section == 3) {
				[self showIndexViewForDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1]];
			}else if (indexPath.section == 2) {
				[self showIndexViewForBookmarkedDeck];
			}
		}
		else // Else show the cards for the corresponding deck 
		{
			CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
			[self.navigationController pushViewController:detail animated:YES];
			if([AppDelegate_iPhone delegate].isRandomCard == 1)
			{
				[Utils randomizeArray:deckArray];
			}
			[detail loadArrayOfCards:deckArray];
			[detail release];
		}
	}
	
	/*
	if(indexPath.section != 0)
	{
		if (indexPath.section != 1 && [[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"]) 
		{
			CardListIPhone* cardListView = [[CardListIPhone alloc] initWithNibName:@"CardList_iPhone" bundle:nil];
			[self.navigationController pushViewController:cardListView animated:YES];
			[cardListView showCardsForDeck:indexPath.row - 1];
			[cardListView release];
		}
	}
	else 
	{
		CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
		[self.navigationController pushViewController:detail animated:YES];
		if([AppDelegate_iPhone delegate].isRandomCard == 1)
		{
			[Utils randomizeArray:deckArray];
		}
		[detail loadArrayOfCards:deckArray];
		[detail release];
	}
	*/
}


- (IBAction)displaySettings
{
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeSetting];
	[model setParentCtrl:self];
	[self presentModalViewController:model animated:YES];
	[model release];
}

- (IBAction)displayHelp
{
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeHelp];
	[model setParentCtrl:self];
	//[self presentModalViewController:model animated:YES];
	[self.navigationController pushViewController:model animated:YES];
	[model release];
}

- (IBAction)displayInfo
{
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeInfo];
	[model setParentCtrl:self];
	//[self presentModalViewController:model animated:YES];
	[self.navigationController pushViewController:model animated:YES];
	[model release];
}

- (void)displayGlossary
{
	ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeGlossary];
	[model setParentCtrl:self];
	//[self presentModalViewController:model animated:YES];
	[self.navigationController pushViewController:model animated:YES];
	[model release];
	
}

- (IBAction)searchCards
{
	SearchViewController_iPhone* searchView = [[SearchViewController_iPhone alloc] initWithNibName:@"SearchView_iPhone" bundle:nil];
	[self.navigationController pushViewController:searchView animated:YES];
	[searchView release];
}


- (IBAction)cardIndex
{
	IndexViewController_iPhone* indexView = [[IndexViewController_iPhone alloc] initWithNibName:@"IndexView_iPhone" bundle:nil forDeck:nil];
	[self.navigationController pushViewController:indexView animated:YES];
	[indexView release];
}

- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck
{
	IndexViewController_iPhone* indexView = [[IndexViewController_iPhone alloc] initWithNibName:@"IndexView_iPhone" bundle:nil forDeck:objDeck];
	[self.navigationController pushViewController:indexView animated:YES];
	[indexView release];
}

- (void) showIndexViewForBookmarkedDeck
{
	IndexViewController_iPhone* indexView = [[IndexViewController_iPhone alloc] initWithNibName:@"IndexView_iPhone" bundle:nil forBookmarkedDeck:YES];
	[self.navigationController pushViewController:indexView animated:YES];
	[indexView release];
	
	//[self presentModalViewController:_indexView animated:YES]; 
}


- (void) myComments{
	MyCommentsViewController_iPhone* commentsView = [[MyCommentsViewController_iPhone alloc] initWithNibName:@"MyCommentsView_iPhone" bundle:nil];
	[self.navigationController pushViewController:commentsView animated:YES];
	[commentsView release];
	
}

- (void) myVoiceNotes{
	
	MyVoiceNotesViewController_iPhone* notesView = [[MyVoiceNotesViewController_iPhone alloc] initWithNibName:@"MyVoiceNotesView_iPhone" bundle:nil];
	[self.navigationController pushViewController:notesView animated:YES];
	[notesView release];
}


/* Added By Ravindra */

-(IBAction) showActionSheet{
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	[actionSheet addButtonWithTitle:@"About this App"];
	
	if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"My Voice Notes"];
	}
	
	if ([AppDelegate_iPhone delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"My Comments"];
	}
	
	
	if ([AppDelegate_iPhone delegate].isFacebookEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Facebook"];
	}
	
	if ([AppDelegate_iPhone delegate].isTwitterEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Twitter"];
	}
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;

	[actionSheet showInView:self.view];
	[actionSheet release]; 	
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"About this App"]) {
		[self displayInfo];
	}
	
	else if ([title isEqualToString:@"Publish to Facebook"]) {
		[self publishToFacebook];
	}
	
	else if ([title isEqualToString:@"Publish to Twitter"]) {
		[self publishToTwitter];
	}
	
	else if ([title isEqualToString:@"My Voice Notes"]) {
		[self myVoiceNotes];
	}
	
	else if ([title isEqualToString:@"My Comments"]) {
		[self myComments];
	}
	
	[title release];
}

-(void) publishToFacebook{
	
	/*
	//[self.session resume];
	FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:self.session] retain];
	dialog.delegate=self;
	[dialog show];
	*/
	
	
	[[AppDelegate_iPhone delegate] postFacebook];
}

/*
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
    /*
	NSString* message=[NSString stringWithFormat:@"I just tested myself on the history of graphic design"];
	NSString* message1=[NSString stringWithFormat:@"<a href='www.spearheadinc.com'>I just tested myself on the history of graphic design</a>"];
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	//dialog.userMessagePrompt = @"Message to publish";
	dialog.userMessagePrompt = message;
	
		
	//dialog.attachment = [[NSString alloc] initWithFormat:@"{\"name\":\"Antibiotic Manual Proficiency\",\"description\":\"%@\"}",message];
	dialog.attachment = [[NSString alloc] initWithFormat:@"{\"name\":\"%@\",\"description\":\"%@\"}",[Utils getValueForVar:kFacebookHeader],message];
	dialog.delegate=self;
	[dialog show];*/

	/*
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.userMessagePrompt = @"Message to publish";
	dialog.attachment = @"{\"name\":\"I'm working on becoming an expert on the history of graphic design.\",""\"href\":\"http://itunes.apple.com/us/app/meggs-history-graphic-design/id476018481?ls=1&mt=8\"}";
	[dialog show];
}

*/

-(void) publishToTwitter{
	
	//NSString* message=[NSString stringWithFormat:@"My Overall Proficiency is %.01f %% out of %d cards" , [_cardDecks allCardDeck].proficiency, [_cardDecks allCardDeck].cardCount];
	NSString* message = @"I'm working on becoming an expert on the history of graphic design. http://itunes.apple.com/us/app/meggs-history-graphic-design/id476018481?ls=1&mt=8";
	
	TwittSpriteViewController* twittView1 = [[TwittSpriteViewController alloc] init];
	[twittView1 login:self message:message];
	
}

/* End of Updated Code By Ravindra */

- (void)updateInfo
{
	[_cardDecks updateProficiency];
	[_tableView reloadData];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController == self)
		[self updateInfo];
}


@end
