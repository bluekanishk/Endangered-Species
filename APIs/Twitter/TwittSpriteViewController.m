//
//  TwittSpriteViewController.m
//  SpriteDemo
//
//  Created by Devender Antil on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwittSpriteViewController.h"
#import "SA_OAuthTwitterEngine.h"


/* Define the constants below with the Twitter 
 Key and Secret for your application. Create
 Twitter OAuth credentials by registering your
 application as an OAuth Client here: http://twitter.com/apps/new
 */

// this is the key for Spearhead Study Flash Cards
//#define kOAuthConsumerKey				@"UG4DriHffRt2Aq9CaBI3cw"	                         //REPLACE With Twitter App OAuth Key  
//#define kOAuthConsumerSecret			@"Jmf1Cot4iDlAA6NgwJlCjbS5ZemabgLA9h1HIbLU"		//REPLACE With Twitter App OAuth Secret



@implementation TwittSpriteViewController

@synthesize tweetTextField,tweetMsg; 

#pragma mark Custom Methods


-(void)updateTwitter:(NSString*)text
{
	//Twitter Integration Code Goes Here
	[_engine sendUpdate:text];
}

#pragma mark ViewController Lifecycle

-(void)login:(UIViewController *)parent message:(NSString*)tweet
{
	self.tweetMsg=tweet;
	tweetTextField.text=tweet;
	parentView=[parent retain];
	
	
	if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = [Utils getValueForVar:kTwitterConsumerKey];  
        _engine.consumerSecret = [Utils getValueForVar:kTwitterConsumerSecret]; 
    }  	
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [parent presentModalViewController:controller animated: YES];  
        }  
    } 
	else
	{	
		[parent presentModalViewController:self animated:YES];   

			//	[self twitterCheckIn:@"NCLEX-RN"];


	}
}	

-(IBAction)twitterCheckIn
{
	if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        //_engine.consumerKey    = kOAuthConsumerKey;  
        //_engine.consumerSecret = kOAuthConsumerSecret;  
		_engine.consumerKey    = [Utils getValueForVar:kTwitterConsumerKey];  
        _engine.consumerSecret = [Utils getValueForVar:kTwitterConsumerSecret]; 
    }  	
	if([_engine isAuthorized]){  
		[self updateTwitter:tweetTextField.text];
	}
	[self dismissModalViewControllerAnimated:YES];

}

- (void)viewDidLoad // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
{
	
	tweetTextField.text=tweetMsg;
	[tweetTextField becomeFirstResponder];


}

- (void)viewDidUnload {	
	[tweetTextField release];
	tweetTextField = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[_engine release];
	[tweetTextField release];
    [super dealloc];
}


	//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject:@"YES" forKey:@"twitterConfigration"];
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
	[self dismissModalViewControllerAnimated:NO];

	//[self twitterCheckIn:@"NCLEX-RN"];
	//[self dismissModalViewControllerAnimated:NO];
	[self performSelector:@selector(twitterPost) withObject:nil afterDelay:2];



}

-(void)twitterPost
{
	[parentView presentModalViewController:self animated:YES];   

	
}

- (IBAction) goBack {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

	//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//NSLog(@"Request %@ succeeded", requestIdentifier);

}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}




@end
