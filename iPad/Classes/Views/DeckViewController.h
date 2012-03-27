//
//  DeckViewController.h
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FBConnect/FBConnect.h"
#import "TwittSpriteViewControlleriPad.h"


@class CardDetails;
@class FlashCardDeckList;
@class FlashCardDeck;
@class IndexViewController;

@interface CustomNavigationBar : UINavigationBar
{
}


@end


@interface DeckViewController : UIViewController <UITableViewDelegate, 
												UITableViewDataSource, 
												UINavigationControllerDelegate,
												UIActionSheetDelegate>
{
	IBOutlet UITableView*			_tableView;
	IBOutlet UINavigationItem*		_extraNavigationItem;
	IBOutlet CustomNavigationBar*	_extraNavigationBar;
	IBOutlet UILabel *_navLabel;

	CardDetails*			_detail;
	IndexViewController*	_indexView;
	FlashCardDeckList*		_cardDecks;
	//FBSession *session;
}

@property (nonatomic, retain) FlashCardDeckList* cardDecks;
//@property (nonatomic, retain) FBSession *session;
@property (nonatomic, retain) CardDetails*	_detail;
@property (nonatomic, retain) UILabel *_navLabel;

- (IBAction)displaySettings;
- (IBAction)displayHelp;
- (IBAction)displayInfo;
- (void)displayGlossary;
- (IBAction)showActionSheet;
- (IBAction)searchCards;
- (IBAction)cardIndex;

- (void) showDetailViewWithArray:(NSMutableArray*) array cardIndex:(NSInteger) index caller:(NSString *)strCaller;
- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck;
- (void) showIndexViewForBookmarkedDeck;
- (void) showSearchViewForDeck:(NSMutableArray*)array cardIndex:(NSInteger) index search:(NSString *)text;

- (void) updateInfo;
- (void) publishToFacebook;
- (void) publishToTwitter;
- (void) myComments;
- (void) myVoiceNotes;
- (void) openFirstView;
- (void) clearView;
- (void) setSelectedIndex:(NSInteger) index;

@end
