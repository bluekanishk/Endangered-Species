//
//  CardDetails.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "FlashCard.h"
#import "CustomWebView.h"
#import "AppDelegate_iPad.h"
#import "VideoGallaryViewController.h"
#import "VoiceNotesViewController.h"
#import "CommentsViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CardDetails.h"
#import "HTMLDisplayController.h"

@implementation CardDetails

@synthesize _selectedCardIndex;
@synthesize _searchText;
@synthesize _parentView;
@synthesize mWindow;
@synthesize basicCall;
@synthesize popoverController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchDown];
	
	//UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	//self.navigationItem.leftBarButtonItem=leftButton;
	if (basicCall == NO) {
		[self.view addSubview:leftButtonImg];
	}
	
	
	
	[_prevButton setNeedsDisplay];
	_act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_act.center = self.view.center;
	
	UIView* topRightBarView = [[UIView alloc] init];
	topRightBarView.frame = CGRectMake(90, 0, 130, 44);
	
	favImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarkTop_ic.png"]];
	[favImg setFrame:CGRectMake(0, 8, 30, 30)];
	
	knowDontKnowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iknowTop_ic.png"]];
	[knowDontKnowImg setFrame:CGRectMake(32, 8, 30, 30)];
	knowDontKnowImg.hidden = YES;
	
	aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(64, 9, 30, 30)];
	[aduioImg setImage:[UIImage imageNamed:@"audio.png"] forState:UIControlStateNormal];
	[aduioImg addTarget:self action:@selector(playAudioFile) forControlEvents:UIControlEventTouchUpInside];
	aduioImg.hidden = YES;
	
	videoImg = [[UIButton alloc] initWithFrame:CGRectMake(-32, 8, 30, 30)];
	[videoImg setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	[videoImg addTarget:self action:@selector(playVideoFile) forControlEvents:UIControlEventTouchUpInside];
	videoImg.hidden = YES;
	
	actionImg = [[UIButton alloc] initWithFrame:CGRectMake(96, 8, 30, 30)];
	[actionImg setImage:[UIImage imageNamed:@"exter_window_ic.png"] forState:UIControlStateNormal];
	[actionImg addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
	
	[topRightBarView addSubview:favImg];
	[topRightBarView addSubview:knowDontKnowImg];
	[topRightBarView addSubview:aduioImg];
	[topRightBarView addSubview:videoImg];
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled || [AppDelegate_iPad delegate].isCommentsEnabled) {
		[topRightBarView addSubview:actionImg];
	}
	
	
	_extraNavigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:topRightBarView] autorelease];
	
	[self showBarButtonItem];
    [super viewDidLoad];
	
	[self updateCardDetails];
	_prevButton.enabled = NO;
	
	//_selectedCardIndex = 0;
	_cardType = kCardTypeFront;
	[topRightBarView release];
	
	if ([[[Utils getValueForVar:kTapToFlip] lowercaseString] isEqualToString:@"yes"]) {
		mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
		mWindow.controllerThatObserves = self;
	}
	[leftButtonImg release];
	// Subscribing for the event kEventCustomWebViewStartLoad so that it is notified when the custom web view inside it starts loading
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShouldStartLoadWithWebView:) name:kEventCustomWebViewStartLoad object:nil ];
}

- (void)popView{
	//[self.navigationController popViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:kEventCardDetailsUnloaded object:nil];
	[self.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[_scrlView setContentOffset:CGPointZero];
	[self updateCardDetails];
} 

- (void)showBarButtonItem
{
	UIImage* img = [UIImage imageNamed:@"back_btn.png"];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 54, 30);
	[button setImage:img forState:UIControlStateNormal];
	[button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc]initWithCustomView:button] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

/*
- (void)popView
{
	[self.navigationController popViewControllerAnimated:YES];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

- (void)dealloc 
{
	[favImg release];
	[knowDontKnowImg release];
	[aduioImg release];
	[videoImg release];
	[_act release];
	
	[_scrlView release];
	[_playAudioFileButton release];
	[_playVideoFileButton release];
	[_favorite release];
	[_know release];
	
	[_toggleFavButton release];
	[_toggleKnowUnKnownButton release];
	
	[_prevButton release];
	[_nextButton release];
	
	[_viewTurnedBack release];
	
	[_arrayOfpages release];
	
	if(_moviePlayer != nil)
		[_moviePlayer release];
	
	[_arrayOfCards release];
    [super dealloc];
}

#pragma mark -
#pragma mark Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[player release];
}

- (IBAction)playAudioFile
{
	NSError* err = nil;
	Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
	
	NSString* audioFileName = card.audioFile;
	
	if (audioFileName == nil)
		return;
	
	audioFileName = [[NSBundle mainBundle] pathForResource:audioFileName ofType:nil inDirectory:nil];
	
	//NSLog(@"%@", audioFileName);
	
	if (audioFileName == nil)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:
							 [NSURL fileURLWithPath:audioFileName] 
																   error:&err];
	player.delegate = self;
	[player play];
}

- (IBAction)playVideoFile
{
	Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
	NSString* videoFileName = card.vedioFile;
	
	if (videoFileName == nil)
		return;
	
	// Setup the player
	_moviePlayer = [[VideoGallaryViewController alloc] init];
	
	videoFileName = [[NSBundle mainBundle] pathForResource:videoFileName ofType:nil inDirectory:nil];
	
	//NSLog(@"%@", videoFileName);
	
	if(videoFileName == nil)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSURL* url = [NSURL fileURLWithPath:videoFileName];
	
	_moviePlayer.movieURL = url;
	
	[_moviePlayer readyPlayer];
	
	[self presentModalViewController:_moviePlayer animated:YES];
}

- (void)loadArrayOfCards:(NSArray*)cards withParentViewC:(DeckViewController*) prntViewC
{
	_arrayOfCards = (NSMutableArray*)[cards retain];
	_parentView = prntViewC;
	
	if (_arrayOfpages == nil)
	{
		_arrayOfpages = [[NSMutableArray alloc] initWithCapacity:3];
	}
	
	_totalCard = [_arrayOfCards count];
	
	int count = (_arrayOfCards.count > 3) ? 3 : _arrayOfCards.count;
	[_scrlView setContentSize:CGSizeMake(kDetailViewWidth * [_arrayOfCards count], _scrlView.frame.size.height)];
	///	_scrlView.scrollEnabled = NO;
	
	NSInteger index;
	NSInteger tempIndex=_selectedCardIndex;
	
	
	if (_selectedCardIndex >= 1 && _selectedCardIndex >= [_arrayOfCards count]-2) {
		tempIndex=_selectedCardIndex-1;
	}
	
	if (_totalCard > 2 && _selectedCardIndex > 1) {
		tempIndex=_selectedCardIndex-2;
	}

	
	for (int i = 0; i < count; i++) 
	{
		index = tempIndex	+ i;
		
		Card* card = [[_arrayOfCards objectAtIndex:index] getCardOfType: kCardTypeFront];
		CustomWebView* page = [[CustomWebView alloc] initWithFrame:CGRectMake(kDetailViewWidth * i, 0, kDetailViewWidth, _scrlView.frame.size.height)];
		//page.delegate = self;
		page.parent = self;
		page.tag = 1100 + i;
		[page loadClearBgHTMLString:card.cardTitle];
		[_scrlView addSubview:page];
		[_arrayOfpages addObject:page];
		
		if (_searchText!=nil && [_searchText length] > 0) {
			page.searchText=_searchText;
		}
		
		if (i == 0 && [[[Utils getValueForVar:kTapToFlip] lowercaseString] isEqualToString:@"yes"]) 
		{
			mWindow.viewToObserve = page;
		}
		
		[page release];
	}
	
	
	_scrlView.showsHorizontalScrollIndicator = NO;
	
	_nextButton.enabled = YES;
	_prevButton.enabled = NO;
	
	_extraNavigationItem.title = [NSString stringWithFormat:@"%d of %d", _selectedCardIndex + 1, [_arrayOfCards count]];
	
	//scrollview
	[self updateCardDetails];
	
	
	if (_totalCard >= 2 && _selectedCardIndex >= 1) {
		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0) animated:YES];
		[self updateFlashDetails];
		
	}else if (_totalCard==1) {
		_nextButton.enabled=NO;
	}
	
	
}

- (void)userDidTapWebView:(id)tapPoint
{
	[self showCardBack];
}


- (void)updateCardDetails
{	
	if ([_arrayOfCards count]==0) {
		return;
	}
	
	Card* card = [[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType];
	
	aduioImg.hidden = YES;
	_playAudioFileButton.hidden = YES;
	videoImg.hidden = YES;
	_playVideoFileButton.hidden = YES;
	
	if(card.audioFile != nil)
	{
		aduioImg.hidden = NO;
		_playAudioFileButton.hidden = NO;
	}
	
	if(card.vedioFile != nil)
	{
		videoImg.hidden = NO;
		_playVideoFileButton.hidden = NO;
	}
	
	[self updateNavBar];
}

- (void) updateFlashCardAtIndex:(int) index
{
	NSInteger tempIndex=(index % 3);
	CustomWebView* webView = (CustomWebView*)[_arrayOfpages objectAtIndex:tempIndex];
	webView.parent = self;
	//webView.delegate = self;
	webView.frame = CGRectMake(kDetailViewWidth * index, 0, kDetailViewWidth, _scrlView.frame.size.height);
	webView.tag = 1100 + index;
	if ([[[Utils getValueForVar:kTapToFlip] lowercaseString] isEqualToString:@"yes"]) 
	{
		mWindow.viewToObserve = webView;
	}
	[webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:index] getCardOfType: _cardType].cardTitle];
	
	if (_searchText!=nil && [_searchText length] > 0) {
		webView.searchText=_searchText;
	}

}

- (void) updateFlashCard
{	
	_isDragging = NO;
	(_selectedCardIndex > 0) ? [self updateFlashCardAtIndex:(_selectedCardIndex - 1)] : -99;
	(_selectedCardIndex < (_totalCard - 1)) ? [self updateFlashCardAtIndex:(_selectedCardIndex + 1)] : -99;
	[self updateFlashCardAtIndex:_selectedCardIndex];
}


- (IBAction)loadNextCardDetails
{
	_isDragging = NO;
	
	if(_selectedCardIndex + 1 < [_arrayOfCards count])
	{
		++_selectedCardIndex;
		_cardType = kCardTypeFront;
		
		[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0) animated:YES];
		[_cardTimer invalidate];
		[_cardTimer release];
		_cardTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateFlashCard) userInfo:nil repeats:NO] retain];
		[self updateFlashDetails];
	}
	
}

- (IBAction)loadPrevCardDetails
{
	_isDragging = NO;
	if(_selectedCardIndex - 1 >= 0)
	{
		--_selectedCardIndex;
		_cardType = kCardTypeFront;
		
		[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0) animated:YES];
		[_cardTimer invalidate];
		[_cardTimer release];
		_cardTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateFlashCard) userInfo:nil repeats:NO] retain];
		[self updateFlashDetails];
	}
}

- (IBAction)showCardBack
{
	_cardType = (_cardType == kCardTypeBack) ? kCardTypeFront : kCardTypeBack;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.8];
	
	[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromLeft)
						   forView:_scrlView cache:NO];
	
	int tagVal = 1100 + _scrlView.contentOffset.x / kDetailViewWidth;
	CustomWebView* webView = (CustomWebView*)[_scrlView viewWithTag:tagVal];
	webView.parent = self;
	//webView.delegate = self;
	[webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType].cardTitle];
	
	[UIView commitAnimations];
	[self updateCardDetails];
	///	[self updateFlashDetails];
	
	if (_searchText!=nil && [_searchText length] > 0) {
		webView.searchText=_searchText;
	}
}

- (IBAction)bookMarked
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isBookMarked = !card.isBookMarked;
	[self updateCardDetails];
	
	[[AppDelegate_iPad getDBAccess] setBookmarkedCard:((card.isBookMarked) ? 1 : 0) ForCardId:card.cardID];
	
	if ([AppDelegate_iPad delegate].isBookMarked && !card.isBookMarked)
	{
		if (_arrayOfCards.count>1)
		{
			[_arrayOfCards removeObjectAtIndex:_selectedCardIndex];
			
			--_totalCard;
			_selectedCardIndex = ((_selectedCardIndex - 1) < 0) ? 0 : (_selectedCardIndex - 1);
			
			[_scrlView setContentSize:CGSizeMake(kDetailViewWidth * [_arrayOfCards count], _scrlView.frame.size.height)];
			[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0) animated:YES];
			
			[self updateFlashDetails];
			[self updateFlashCard];
		}
		else
		{
			[_parentView openFirstView];
		}
		
	}
	
	[_parentView updateInfo];
	
}

- (IBAction)cardKnownUnKnown
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isKnown = !card.isKnown ;
	[self updateCardDetails];
	[[AppDelegate_iPad getDBAccess] setProficiency:((card.isKnown) ? 1 : 0) ForCardId:card.cardID];
	[_parentView updateInfo];
}

- (void)updateNavBar
{
	if(_selectedCardIndex < 0)
		return;
	
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	
	if(card.isBookMarked)
	{
		_favorite.hidden = NO;
		favImg.hidden = NO;
		[_toggleFavButton setImage:[UIImage imageNamed:@"unmark.png"] forState:UIControlStateNormal];
	}
	else
	{
		_favorite.hidden = YES;
		favImg.hidden = YES;
		[_toggleFavButton setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
	}
	
	if(card.isKnown)
	{
		knowDontKnowImg.hidden = NO;
		[_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"dnt_knw.png"] forState:UIControlStateNormal];
		[_know setImage:[UIImage imageNamed:@"know.png"]];
	}
	else
	{
		knowDontKnowImg.hidden = YES;
		[_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"know.png"] forState:UIControlStateNormal];
		[_know setImage: [UIImage imageNamed:@"dnt_knw.png"]];
	}
	
	if (card.cardID!=0 && [[AppDelegate_iPad getDBAccess] isCommentOrNotesAvailable:card.cardID]) {
		[actionImg setImage:[UIImage imageNamed:@"exter_window_ic.png"] forState:UIControlStateNormal];
		
	}else {
		[actionImg setImage:[UIImage imageNamed:@"exter_window_yellow.png"] forState:UIControlStateNormal];
		
	}

	
}

- (void) updateActionImage{
	[actionImg setImage:[UIImage imageNamed:@"exter_window_yellow.png"] forState:UIControlStateNormal];
}


- (void) updateFlashDetails
{
	if(_selectedCardIndex == 0)
	{
		_nextButton.enabled = YES;
		_prevButton.enabled = NO;
	}
	else if(_selectedCardIndex >= _arrayOfCards.count - 1)
	{
		_prevButton.enabled = YES;
		_nextButton.enabled = NO;
	}
	else
	{
		_nextButton.enabled = YES;
		_prevButton.enabled = YES;
	}
	
	[self updateNavBar];
	[self updateCardDetails];
	if(_selectedCardIndex < 0)
		return;
	
	_extraNavigationItem.title = [NSString stringWithFormat:@"%d of %d", _selectedCardIndex + 1, [_arrayOfCards count]];
}


- (void)hideLoading
{
	[_act stopAnimating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
	_isDragging = YES;
	if([scrollView isKindOfClass:[UITableView class]] == NO)
	{
		if (_isDragging)
		{
			[_cardTimer invalidate];
			[_cardTimer release];
			_cardTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(slidingAction:) userInfo:scrollView repeats:NO] retain];
		}		
	}
}

- (void) slidingAction:(NSTimer*)timer
{
	UIScrollView* scrollView = [timer userInfo];
	_selectedCardIndex = scrollView.contentOffset.x / kDetailViewWidth;
	_cardType = kCardTypeFront;
	[self updateFlashCard];	
	[self updateFlashDetails];
	_isDragging = NO;
}



-(void) showActionSheet:(id)sender
{
	
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"Voice Notes"];
	}
	
	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"Comments"];
	}
	
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	
	//[actionSheet showFromRect:CGRectMake(800, 50, 100, 50) inView:self.view animated:YES];
	//[actionSheet showFromRect:CGRectMake(1080, -15, -200, 100) inView:self.view animated:YES];
    [actionSheet showFromRect:CGRectMake(578, -60, 100, 100) inView:self.view animated:YES];
	//[actionSheet showFromRect:CGRectMake(450, 8, 30, 30) inView:self.view animated:YES];
	//[actionSheet showFromRect:[sender frame] inView:self.view animated:YES];
	[actionSheet release]; 	
	
	/*
	NSMutableArray* arrItems = [[NSMutableArray alloc] init];
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[arrItems addObject:@"Voice Notes"];
	}
	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[arrItems addObject:@"Comments"];
	}
	if ([self.popoverController isPopoverVisible]) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	[[UIPrintInteractionController sharedPrintController] dismissAnimated:YES];
	ActionViewController *nextView = [[ActionViewController alloc] initWithNibName:@"ActionViewController" bundle:nil];
	UINavigationController *nextController = [[UINavigationController alloc] initWithRootViewController:nextView];
	UIPopoverController *tempController = [[UIPopoverController alloc] initWithContentViewController:nextController];
	[nextView setContentSizeForViewInPopover:CGSizeMake(320, 480)];
	[tempController setPopoverContentSize:CGSizeMake(320, 516)];
	[tempController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	//[tempController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[self setPopoverController:tempController];
	[nextView release];
	[nextController release];
	[tempController release];
	*/
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex==-1) return;
	
	
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([title isEqualToString:@"Voice Notes"]) {
		
		// Load Voice Notes View
		VoiceNotesViewController *detailViewController = [[VoiceNotesViewController alloc] initWithNibName:@"VoiceNotesViewiPad" bundle:nil];
		FlashCard* card=[_arrayOfCards objectAtIndex:_selectedCardIndex];
		[detailViewController setFlashCardId:[card cardID]];
		[detailViewController setParent:self];
		
		detailViewController.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
		[[_parentView view] addSubview:detailViewController.view];
		
	}
	
	else if ([title isEqualToString:@"Comments"]) {
		
		//Load Comments View
		CommentsViewController *detailViewController = [[CommentsViewController alloc] initWithNibName:@"CommentsViewiPad" bundle:nil];
		[detailViewController setFlashCardId:[[_arrayOfCards objectAtIndex:_selectedCardIndex] cardID]];
		[detailViewController setParent:self];
		
		detailViewController.view.frame = CGRectMake(382, 44, kDetailViewWidth, 724);
		[[_parentView view] addSubview:detailViewController.view];
		
	}
	
	[title release];
}

- (void) resetKnownUnknown
{
	FlashCard* card;
	for (int i = 0; i < [_arrayOfCards count]; i++) {
		card = [_arrayOfCards objectAtIndex:i];
		card.isKnown = NO;
	}
}
- (void) resetBookmarked
{
	FlashCard* card;
	for (int i = 0; i < [_arrayOfCards count]; i++) {
		card = [_arrayOfCards objectAtIndex:i];
		card.isBookMarked = NO;
	}
	
}
- (void) resetBoth
{
	[self resetKnownUnknown];
	[self resetBookmarked];
}

-(void) setParentViewCtrl:(DeckViewController *)parentView
{
	_parentView = parentView;
}

#pragma mark -------
#pragma mark UIWebView delegates
/*
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
- (BOOL) handleShouldStartLoadWithWebView:(UIWebView *)webView withRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"NSURLRequest : %@",request.URL );
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[request URL] absoluteString]]];
		HTMLDisplayController *vcHTMLDisplayer = [[HTMLDisplayController alloc] initWithNibName:@"HTMLDisplayController" bundle:nil];
		[self.view addSubview:vcHTMLDisplayer.view];
		[vcHTMLDisplayer setPageContent:[[request URL] absoluteString] withTitle:@""];
		return NO;
	}
	
	return YES;
}
*/
#pragma mark -------
#pragma mark UIWebView delegates
- (BOOL) handleShouldStartLoadWithWebView:(NSDictionary *)notification
{
	//UIWebView * webView = (UIWebView *)[notification.userInfo objectForKey:@"webview"];
	NSURLRequest * request = (NSURLRequest *)[notification objectForKey:@"request"];
	//UIWebViewNavigationType navigationType = [[notification.userInfo objectForKey:@"navigationType"] intValue];
	HTMLDisplayController *vcHTMLDisplayer = [[HTMLDisplayController alloc] initWithNibName:@"HTMLDisplayController" bundle:nil];
	[self.view addSubview:vcHTMLDisplayer.view];
	[vcHTMLDisplayer setPageContent:[[request URL] absoluteString] withTitle:@""];
	//[vcHTMLDisplayer release];
	
	return NO;
}

@end

