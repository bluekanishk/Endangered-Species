//
//  CardDetails.h
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "VideoGallaryViewController.h"
#import "DeckViewController.h"
#import "TapDetectingWindow.h"
#import "ActionViewController.h"


@class CustomWebView;
@class DeckViewController;
@class VideoGallaryViewController;

@interface CardDetails : UIViewController <AVAudioPlayerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, TapDetectingWindowDelegate>
{	
	IBOutlet UIScrollView*		_scrlView;
	IBOutlet UIButton*			_playAudioFileButton;
	IBOutlet UIButton*			_playVideoFileButton;
	IBOutlet UIImageView*		_favorite;
	IBOutlet UIImageView*		_know;
	IBOutlet UINavigationItem*	_extraNavigationItem;
	
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
	
	VideoGallaryViewController*	_moviePlayer;
	
	BOOL						_isDragging;
	
	CardType					_cardType;//Back or Front
	CustomWebView*				_viewTurnedBack;
	
	int							_totalCard;
	
	DeckViewController*			_parentView;
	NSMutableArray*				_arrayOfpages;
	
	NSTimer*					_cardTimer;
	
	NSString*					_searchText;
	TapDetectingWindow*			mWindow;
	BOOL						basicCall;
}

@property (nonatomic)			NSInteger _selectedCardIndex;
@property (nonatomic,retain)	NSString* _searchText;
@property (nonatomic,retain)	DeckViewController*	 _parentView;
@property (nonatomic,retain)	TapDetectingWindow*	 mWindow;
@property (nonatomic)	BOOL	 basicCall;
@property (nonatomic, retain)   UIPopoverController *popoverController;



- (void)loadArrayOfCards:(NSArray*)cards withParentViewC:(DeckViewController*) prntViewC;
- (IBAction)loadNextCardDetails;
- (IBAction)loadPrevCardDetails;
- (IBAction)bookMarked;
- (IBAction)playAudioFile;
- (IBAction)playVideoFile;
- (IBAction)cardKnownUnKnown;
- (IBAction)showCardBack;
- (void) showActionSheet:(id)sender;


- (void) updateFlashCard;
- (void) updateCardDetails;
- (void) updateNavBar;
- (void) showBarButtonItem;
- (void) updateFlashDetails;
- (void) updateFlashCardAtIndex:(int) index;

- (void) updateActionImage;
- (void) resetKnownUnknown;
- (void) resetBookmarked;
- (void) resetBoth;
- (void) setParentViewCtrl:(DeckViewController*) parentView;


@end

