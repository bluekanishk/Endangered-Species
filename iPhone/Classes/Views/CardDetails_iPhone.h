//
//  CardDetails.h
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "VideoGallaryViewController_iPhone.h"
#import "TapDetectingWindow.h"

@class CustomWebView_iPhone;
@class VideoGallaryViewController_iPhone;

@interface CardDetails_iPhone : UIViewController <AVAudioPlayerDelegate, UIActionSheetDelegate, 
UIScrollViewDelegate, TapDetectingWindowDelegate>
{	
	IBOutlet UIScrollView*		_scrlView;
	IBOutlet UIButton*			_playAudioFileButton;
	IBOutlet UIButton*			_playVideoFileButton;
	IBOutlet UIImageView*		_favorite;
	IBOutlet UIImageView*		_know;
	
	IBOutlet UIButton*			_toggleFavButton;
	IBOutlet UIButton*			_toggleKnowUnKnownButton;
	
	IBOutlet UIButton*			_prevButton;
	IBOutlet UIButton*			_nextButton;
	
	UIImageView*				favImg;
	UIImageView*				knowDontKnowImg;
	UIButton*					aduioImg;
	UIButton*					videoImg;
	UIButton*					actionImg;
	
	UIActivityIndicatorView*	_act;

	NSMutableArray*				_arrayOfCards;
	NSInteger				    _selectedCardIndex;
	
	VideoGallaryViewController_iPhone*	_moviePlayer;

	BOOL						_isDragging;
		
	CardType					_cardType;//Back or Front
	CustomWebView_iPhone*				_viewTurnedBack;
	
	int							_totalCard;

	NSMutableArray*				_arrayOfpages;
	
	NSString*					_searchText;
	TapDetectingWindow*			mWindow;
}

@property (nonatomic) NSInteger _selectedCardIndex;
@property (nonatomic,retain) NSString* _searchText;
@property (nonatomic,retain)	TapDetectingWindow*	 mWindow;

- (void)loadArrayOfCards:(NSArray*)cards;
- (IBAction)loadNextCardDetails;
- (IBAction)loadPrevCardDetails;
- (IBAction)bookMarked;
- (IBAction)playAudioFile;
- (IBAction)playVideoFile;
- (IBAction)cardKnownUnKnown;
- (IBAction)showCardBack;
- (void) showActionSheet;

- (void) updateFlashCard;
- (void) updateCardDetails;
- (void) updateNavBar;
- (void) showBarButtonItem;
- (void) updateFlashDetails;
- (void) updateFlashCardAtIndex:(int) index;

@end

