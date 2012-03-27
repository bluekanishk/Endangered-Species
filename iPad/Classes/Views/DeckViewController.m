    //
//  DeckViewController.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeckCell.h"
#import "CardDetails.h"
#import "AppDelegate_iPad.h"

#import "FlashCard.h"
#import "ModalViewCtrl.h"

#import "DeckViewController.h"
#import "SearchViewController.h"
#import "IndexViewController.h"
#import "MyCommentsViewController.h"
#import "MyVoiceNotesViewController.h"
#import "TwittSpriteViewControlleriPad.h"

#import "Utils.h"

//#import "FBConnect/FBConnect.h"
//#import "FBConnect/FBSession.h"


@implementation CustomNavigationBar

- (void) drawRect:(CGRect) rect
{
	UIImage* img = [UIImage imageNamed:@"TopBar"];
	[img drawInRect:rect];
}

@end


@implementation DeckViewController


@synthesize cardDecks = _cardDecks;
//@synthesize session;
@synthesize _detail,_navLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidAppear:(BOOL)animated
{
	[_extraNavigationBar setNeedsDisplay];
	[super viewDidAppear:animated];
}

// This method will display the card details page for a particular index
- (void) showDetailViewWithArray:(NSMutableArray*) array cardIndex:(NSInteger) index caller:(NSString *)strCaller
{
	
	_detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil];
	if ([strCaller isEqualToString:@"self"]) {
		_detail.basicCall = YES;
	}
	else {
		_detail.basicCall = NO;
	}

	[_detail setParentViewCtrl:self];
	_detail._selectedCardIndex=index;
	_detail.view.frame = CGRectMake(384, 44, kDetailViewWidth, 724);
	[_detail loadArrayOfCards:array withParentViewC:self];
	[self.view addSubview:_detail.view];
}



- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck
{
	_indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forDeck:objDeck];
	
	[_indexView setParentViewCtrl:self];
	_indexView.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:_indexView.view];
}

- (void) showIndexViewForBookmarkedDeck
{
	_indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forBookmarkedDeck:YES];
	
	[_indexView setParentViewCtrl:self];
	_indexView.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:_indexView.view];
}

- (void) showSearchViewForDeck:(NSMutableArray*) array cardIndex:(NSInteger) index search:(NSString *)text
{
	
	_detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil];
	_detail.basicCall = NO;
	[_detail setParentViewCtrl:self];
	_detail._selectedCardIndex=index;
	_detail._searchText=text;
	_detail.view.frame = CGRectMake(384, 44, kDetailViewWidth, 724);
	_detail.basicCall = NO;
	[_detail loadArrayOfCards:array withParentViewC:self];
	[self.view addSubview:_detail.view];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];

	UIImageView* imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftBackground.png"]] autorelease];
	[_tableView setBackgroundView:imgView];
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.delegate = self;
	//self.title = @"Meggs";
	self.title = [Utils getValueForVar:kHeaderTitle];
	_navLabel.text = [Utils getValueForVar:kHeaderTitle];
	[self performSelector:@selector(openFirstView) withObject:self afterDelay:0.3];
	
	// Facebook Session
	//if (self.session == nil){
		//self.session = [FBSession sessionForApplication:facebookAppId secret:facebookAppSecretKey delegate:self];
	//	self.session = [FBSession sessionForApplication:[Utils getValueForVar:kFacebookAppID]  secret:[Utils getValueForVar:kFacebookAppSecretKey] delegate:self];
	//}
	
		
}

- (void) openFirstView
{
	[AppDelegate_iPad delegate].isBookMarked = NO;
	NSMutableArray* deckArray = [_cardDecks.allCardDeck  getCardsList];
	
	[self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

- (void)dealloc
{
    [super dealloc];
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
	DeckCell* cell = nil;

	if(indexPath.section == 3 && indexPath.row == 0)
	{
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"deck_top_bg.png"]] autorelease];
		
		//cell.textLabel.text = @"Decks By Alphabets:";
		cell.textLabel.text = [Utils getValueForVar:kDeckHeader];
		//cell.textLabel.textColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		cell.textLabel.textColor = [Utils colorFromString:[Utils getValueForVar:kDeckHeaderTextColor]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}

	switch (indexPath.section) 
	{
		case 0:
			tableView.separatorColor = nil;
			cell = [DeckCell creatCellViewWithText:@"Introduction" withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
			cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]];
			break;
			
		case 1:
			tableView.separatorColor = nil;
			cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
			break;
			
		case 2:
			tableView.separatorColor=nil;
			cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
			break;
			
		case 3:
			tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
			cell = [DeckCell creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
			break;
	}
		
	return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.322 blue:0.369 alpha:1.0];
//
//}

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
			[AppDelegate_iPad delegate].isBookMarked = NO;
			deckArray = [_cardDecks.allCardDeck  getCardsList];
			break;
			
		case 2:
			[AppDelegate_iPad delegate].isBookMarked = YES;
			deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
			if (deckArray == nil || deckArray.count <= 0)
			{
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarked items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			break;
			
		case 3:
			[AppDelegate_iPad delegate].isBookMarked = NO;
			deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1]  getCardsList];
			break;
	}
	
	// If the section 3 (any of the card decks) has been clicked, then check whether "CardList" option is set. If yes, then produce the card list
	// view or take to the card details view
	if(indexPath.section != 0)
	{
		if (indexPath.section != 1 && [[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"]) 
		{
			if (indexPath.section == 3) {
				[self showIndexViewForDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1]];
			}else if (indexPath.section == 2) {
				[self showIndexViewForBookmarkedDeck];
			}
		}
		else 
		{
			// Randomize the cards if the random property is set
			if([AppDelegate_iPad delegate].isRandomCard == 1)
			{
				[Utils randomizeArray:deckArray];
			}
			[self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
		}
	}
	
}

- (IBAction)displaySettings
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeSetting];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:model.view];
}

- (IBAction)displayHelp
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeHelp];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(382, 44, kDetailViewWidth+2, 724);
	[self.view addSubview:model.view];
	
}

- (IBAction)displayInfo
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeInfo];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(382, 44, kDetailViewWidth+2, 724);
	[self.view addSubview:model.view];
	
}

- (void)displayGlossary
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeGlossary];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(382, 44, kDetailViewWidth+2, 724);
	[self.view addSubview:model.view];
	
}





- (IBAction)searchCards
{
	SearchViewController* searchView = [[SearchViewController alloc] initWithNibName:@"SearchViewiPad" bundle:nil];
	[searchView setParentViewCtrl:self];
	searchView.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:searchView.view];
}


- (IBAction)cardIndex
{
	IndexViewController* indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forDeck:nil];
	[indexView setParentViewCtrl:self];
	indexView.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:indexView.view];
	

}


- (void) myComments{
	
	MyCommentsViewController* commentsView = [[MyCommentsViewController alloc] initWithNibName:@"MyCommentsViewiPad" bundle:nil];
	commentsView.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:commentsView.view];
	
}

- (void) myVoiceNotes{
	
	MyVoiceNotesViewController* notesView = [[MyVoiceNotesViewController alloc] initWithNibName:@"MyVoiceNotesViewiPad" bundle:nil];
	notesView.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
	[self.view addSubview:notesView.view];
	
}


/* Added By Ravindra */
-(IBAction) showActionSheet{
	
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	[actionSheet addButtonWithTitle:@"About this App"];
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"My Voice Notes"];
	}
	
	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"My Comments"];
	}
	
	
	if ([AppDelegate_iPad delegate].isFacebookEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Facebook"];
	}
	
	if ([AppDelegate_iPad delegate].isTwitterEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Twitter"];
	}
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	
	[actionSheet showFromRect:CGRectMake(200, 700, 300, 100) inView:self.view animated:YES];
	[actionSheet release]; 	

	
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex==-1) return;
	
	
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
	
	//[self.session resume];
	/*FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:self.session] retain];
	dialog.delegate=self;
	[dialog show];
	*/
	
	[[AppDelegate_iPad delegate] postFacebook];
}


/*- (void)session:(FBSession*)session didLogin:(FBUID)uid {
    
	//NSString* message=[NSString stringWithFormat:@"My Overall Proficiency is %.01f %% out of %d cards" , [_cardDecks allCardDeck].proficiency, [_cardDecks allCardDeck].cardCount];
	
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.userMessagePrompt = @"Message to publish";
	//dialog.attachment = [[NSString alloc] initWithFormat:@"{\"name\":\"%@\",\"description\":\"%@\"}",[Utils getValueForVar:kFacebookHeader],message];
	dialog.attachment = @"{\"name\":\"I'm working on becoming an expert on Endangered Animals.\",""\"href\":\"http://itunes.apple.com/us/app/endangered-animals/id505822281?ls=1&mt=8\"}";
	dialog.delegate=self;
	[dialog show];
	
}
*/

-(void) publishToTwitter{
	
	//NSString* message=[NSString stringWithFormat:@"My Overall Proficiency is %.01f %% out of %d cards" , [_cardDecks allCardDeck].proficiency, [_cardDecks allCardDeck].cardCount];
	NSString* message = @"I'm working on becoming an expert on Endangered Animals. http://itunes.apple.com/us/app/endangered-animals/id505822281?ls=1&mt=8";
	
	TwittSpriteViewControlleriPad* twittView = [[TwittSpriteViewControlleriPad alloc] initWithNibName:@"TwitterViewControlleriPad" bundle:nil];
	//TwittSpriteViewController* twittView = [[TwittSpriteViewController alloc] init];
	[twittView login:self message:message];
	
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


- (void) clearView{
	[_detail.view removeFromSuperview];
}

- (void) setSelectedIndex:(NSInteger) index{
	_detail._selectedCardIndex=index;
}

@end
