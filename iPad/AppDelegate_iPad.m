	//
	//  AppDelegate_iPad.m
	//  FlashCardDB
	//
	//  Created by Friends on 1/27/11.
	//  Copyright __MyCompanyName__ 2011. All rights reserved.
	//

#import "DBAccess.h"
#import "LaunchView.h"
#import "AppDelegate_iPad.h"
#import "Utils.h"

@implementation AppDelegate_iPad

@synthesize dbAccess = _dbAccess;
@synthesize window = _window;
@synthesize isBookMarked = _isBookMarked;


@synthesize isFacebookEnabled;
@synthesize isTwitterEnabled;
@synthesize isVoiceNotesEnabled;
@synthesize isCommentsEnabled;
@synthesize isSearchingEnabled;
@synthesize isIndexingEnabled;
@synthesize isRandomCard;
@synthesize facebook;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{   
	[_window addSubview:_launchView.view];
    [_window makeKeyAndVisible];
	
	_dbAccess = [[DBAccess alloc] init];
	[_dbAccess createDatabaseIfNeeded];
	
		// Initialize Features
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"features" ofType:@"plist"];
	NSMutableDictionary *featuresDict;
	//NSMutableDictionary *featuresDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	
	BOOL success;
	NSError* error;
	
	NSFileManager* FileManager = [NSFileManager defaultManager];
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDir = [paths objectAtIndex:0];
	
	NSString *_databasePath = [[documentDir stringByAppendingPathComponent:@"features.plist"] retain];
	success = [FileManager fileExistsAtPath:_databasePath];
	
	if (!success)
	{
		//NSString* dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"features.plist"];
		success = [FileManager copyItemAtPath:filePath toPath:_databasePath error:&error];
		if (!success)
		{
			NSAssert( @"Failed to copy the plist. Error:%@.", [error localizedDescription]);
			exit(1);
		}
	}
	featuresDict = [NSMutableDictionary dictionaryWithContentsOfFile:_databasePath];
	
	isVoiceNotesEnabled=[[featuresDict objectForKey:@"VoiceNotes"] boolValue];
	isCommentsEnabled=[[featuresDict objectForKey:@"Comments"] boolValue];
	isTwitterEnabled=[[featuresDict objectForKey:@"Twitter"] boolValue];
	isFacebookEnabled=[[featuresDict objectForKey:@"Facebook"] boolValue];
	isSearchingEnabled=[[featuresDict objectForKey:@"Searching"] boolValue];
	isIndexingEnabled=[[featuresDict objectForKey:@"Indexing"] boolValue];
	isRandomCard=[[featuresDict objectForKey:@"Random"] intValue];
	
	//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    return YES;
}

+ (DBAccess*) getDBAccess
{
	return ((AppDelegate_iPad*)[[UIApplication sharedApplication] delegate]).dbAccess;
}

+ (AppDelegate_iPad*) delegate
{
	return (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];
}





-(void) postFacebook{
	
	facebook = [[Facebook alloc] initWithAppId:[Utils getValueForVar:kFacebookAppID] andDelegate:self];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
	
	if (![facebook isSessionValid]) {
		[facebook authorize:nil];
		
	}else {
		
		[self postMessage];
	}
	
}

-(void) postMessage{
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"Endangered Animals", @"name",
								   @"I'm working on becoming an expert on the history of graphic design.", @"caption",
								   @"http://itunes.apple.com/us/app/meggs-history-graphic-design/id476018481?ls=1&mt=8", @"link",
								   @"http://a5.mzstatic.com/us/r1000/091/Purple/e4/94/34/mzl.dusvlfms.175x175-75.jpg", @"picture",
								   nil];
	
	[facebook dialog:@"feed"
		   andParams:params
		 andDelegate:self];
	
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	return [facebook handleOpenURL:url]; 
	
}


- (void)fbDidLogin {
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	[self postMessage];
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [facebook extendAccessTokenIfNeeded];
}

-(void) fbSessionInvalidated{
	[facebook authorize:nil];
}

-(void) fbDidNotLogin:(BOOL)cancelled{
	
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Facebook Login" message:@"Facebook Login failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	[alert release];
}

-(void) fbDidLogout{
	[facebook logout];
}

-(void) fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
	[_launchView release];
	[_window release];
	[super dealloc];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[player release];
}
@end

