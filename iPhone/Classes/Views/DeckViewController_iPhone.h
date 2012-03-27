//
//  DeckViewController.h
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FBConnect/FBConnect.h";
#import "TwittSpriteViewController.h"

@class FlashCardDeckList;
@class FlashCardDeck;
@class IndexViewController_iPhone;

@interface DeckViewController_iPhone : UIViewController <UITableViewDelegate, 
												UITableViewDataSource, 
												UINavigationControllerDelegate,
												UIActionSheetDelegate>
{
	IBOutlet UITableView*	_tableView;
	FlashCardDeckList*		_cardDecks;
	TwittSpriteViewController *twittView;
	IndexViewController_iPhone*	_indexView;
}

@property (nonatomic, retain) FlashCardDeckList*	cardDecks;

- (IBAction)displaySettings;
- (IBAction)displayHelp;
- (IBAction)displayInfo;
- (IBAction)showActionSheet;
- (IBAction)searchCards;
- (IBAction)cardIndex;
- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck;
- (void) showIndexViewForBookmarkedDeck;
- (void) displayGlossary;

- (void)updateInfo;
- (void) publishToFacebook;
- (void) publishToTwitter;
- (void) myComments;
- (void) myVoiceNotes;

@end
