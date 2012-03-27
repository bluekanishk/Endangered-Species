//
//  TwittSpriteViewController.h
//  SpriteDemo
//
//  Created by Devender Antil on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "MGTwitterEngine.h"

@class SA_OAuthTwitterEngine;

@interface TwittSpriteViewController : UIViewController <UITextFieldDelegate, SA_OAuthTwitterControllerDelegate, MGTwitterEngineDelegate>
{ 
	IBOutlet UITextView *tweetTextField;
	
	SA_OAuthTwitterEngine *_engine;
	NSString *textPost;
	NSMutableDictionary *dict;
	UIViewController *parentView;
	NSString *tweetMsg;
}

@property(nonatomic, retain) UITextView *tweetTextField;
@property(nonatomic, retain) NSString *tweetMsg;

-(void)updateTwitter:(NSString*)sender; 
-(IBAction)twitterCheckIn;
-(void)login:(UIViewController *)parent message:(NSString*)tweet;
- (IBAction) goBack;


@end
