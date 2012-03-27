//
//  LaunchView.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"

#import "DeckViewController_iPhone.h"

#import "LaunchView_iPhone.h"

@implementation LaunchView_iPhone

- (void)viewWillAppear:(BOOL)animated
{
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height)];
	if ([[[Utils getValueForVar:kStartSound] lowercaseString] isEqualToString:@"yes"]) 
	{
		NSError* err = nil;
		NSString *strAudioFileName = [[NSBundle mainBundle] pathForResource:[Utils getValueForVar:kStartSoundFile] ofType:nil inDirectory:nil];
		
		//NSLog(@"%@", strAudioFileName);
		
		if (strAudioFileName == nil)
		{
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else 
		{
			avStartSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strAudioFileName] error:&err];
			avStartSoundPlayer.delegate = self;
			[avStartSoundPlayer play];
		}
	}
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


- (void)dealloc 
{
    [super dealloc];
}

- (void)loadHomeScreen
{
	_imgButton.hidden = YES;
	FlashCardDeckList* deckList = [[FlashCardDeckList alloc] init];
	DeckViewController_iPhone* controller = [[DeckViewController_iPhone alloc] initWithNibName:@"DeckViewController_iPhone" bundle:nil];	
	
	controller.cardDecks = deckList;
	[self.navigationController pushViewController:controller animated:YES];

	[deckList release];
	[controller release];
}

- (IBAction)openHomeView
{
	if (avStartSoundPlayer != nil) {
		[avStartSoundPlayer stop];
	}
	UIActivityIndicatorView* indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	[indicator setFrame:CGRectMake(140, 265, 40, 40)];
	[indicator startAnimating];
	[_imgButton addSubview:indicator];
	[self loadHomeScreen];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	avStartSoundPlayer = nil;
	[player release];
}
@end
