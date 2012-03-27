//
//  ModalViewCtrl.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "DeckViewController.h"
#import "AppDelegate_iPad.h"
#import "Appirater.h"
#import "CardDetails.h"
#import "CustomWebView.h"
#import "HTMLDisplayController.h"
#import "ModalViewCtrl.h"


@implementation ModalViewCtrl


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentType:(ContentType) type
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_contentType = type;
	}
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_contentType = type;
	}
	
	_settingButtons=[[NSMutableArray alloc] init];
	
	[_settingButtons addObject:@"Clear \"I Know\""];
	[_settingButtons addObject:@"Clear All Bookmarks"];
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[_settingButtons addObject:@"Clear All Voice Notes"];
	}
	
	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[_settingButtons addObject:@"Clear All Comments"];
	}
	
	[_settingButtons addObject:@"Reset Application"];
	[_settingButtons addObject:@"Application Rating"];
	
    return self;
}

- (void) setParentCtrl: (DeckViewController*) ctrl;
{
	_parentCtrl = ctrl;
}



- (void)viewDidLoad 
{	
	
	[super viewDidLoad];
	
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow_bg_iPad.png"]] autorelease];
	_tableView.backgroundColor=[UIColor clearColor];
	//NSString* fName;
	//BOOL fileExists;
	CustomWebView* wvHTMLPage = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 44, kDetailViewWidth, 680)];
	wvHTMLPage.parent = self;
	// Subscribing for the event kEventCustomWebViewStartLoad so that it is notified when the custom web view inside it starts loading
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShouldStartLoadWithWebView:) name:kEventCustomWebViewStartLoad object:nil ];
	switch(_contentType)
	{
		case kContentTypeSetting:
			_navItem.title = @"Settings";
			_tableView.hidden = NO;
			_webView.hidden = YES;
			break;
			
		case kContentTypeHelp:
			_navItem.title = @"Help";
			[wvHTMLPage loadClearBgHTMLString:[[AppDelegate_iPad getDBAccess] GetHelpString]];
			/*
			//[_webView loadHTMLString:[[AppDelegate_iPad getDBAccess] GetHelpString] baseURL:nil];
			fName = [[NSBundle mainBundle] pathForResource:[[AppDelegate_iPad getDBAccess] GetHelpString] ofType:nil inDirectory:nil];
			fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fName];
			if (fileExists == YES) {
				NSURL* url = [[NSURL alloc] initFileURLWithPath:fName];
				NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
				[_webView loadRequest:req];
			}
			else {
				[_webView loadHTMLString:@"File not found" baseURL:nil];
			}
			*/
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
			
		case kContentTypeInfo:
			_navItem.title = @"About this App";
			[wvHTMLPage loadClearBgHTMLString:[[AppDelegate_iPad getDBAccess] GetInfoString]];
			/*
			//[_webView loadHTMLString:[[AppDelegate_iPad getDBAccess] GetInfoString] baseURL:nil];
			fName = [[NSBundle mainBundle] pathForResource:[[AppDelegate_iPad getDBAccess] GetInfoString] ofType:nil inDirectory:nil];
			fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fName];
			if (fileExists == YES) {
				NSURL* url = [[NSURL alloc] initFileURLWithPath:fName];
				NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
				[_webView loadRequest:req];
			}
			else {
				[_webView loadHTMLString:@"File not found" baseURL:nil];
			}
			*/
			_tableView.hidden = YES;
			_webView.hidden = YES;
			break;
		case kContentTypeGlossary:
			_navItem.title = @"Introduction";
			[wvHTMLPage loadClearBgHTMLString:@"intro.html"];
			_tableView.hidden = YES;
			_webView.hidden = YES;
			break;

	}	
	wvHTMLPage.dataDetectorTypes = UIDataDetectorTypeLink;
	if (_contentType != kContentTypeSetting) {
		[self.view addSubview:wvHTMLPage];
	}
	[wvHTMLPage release];
	if ([[[Utils getValueForVar:kRandomOption] lowercaseString] isEqualToString:@"yes"]) {
		_isRandomOption = YES;
	}
	else {
		_isRandomOption = NO;
	}

	
}

- (IBAction) done:(id) sender
{
	//[self dismissModalViewControllerAnimated:YES];
	[self.view removeFromSuperview];
	[(CardDetails *)_parentCtrl._detail updateNavBar];
	
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[_webView release];
	[_tableView release];
	[vcHTMLDisplayer release];
    [super dealloc];
}


#pragma mark -
#pragma mark UITableView delegates
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	if(_isRandomOption == YES)
	{
		return [_settingButtons count]+1;
	}
	return [_settingButtons count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	if (indexPath.row < [_settingButtons count]) 
	{
		cell.textLabel.font = [UIFont systemFontOfSize:20];
		
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"grey_btn.png"]] autorelease];
		
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text=[_settingButtons objectAtIndex:indexPath.row];
	}
	else if(_isRandomOption == YES)
	{
		cell.textLabel.font = [UIFont systemFontOfSize:20];
		
		cell.backgroundColor = [UIColor clearColor];
		
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"grey_btn.png"]] autorelease];	
		UILabel *objLabelRandom = [[[UILabel alloc] initWithFrame:CGRectMake(200,17,180,25)] autorelease];
		objLabelRandom.font = [UIFont systemFontOfSize:20];
		objLabelRandom.backgroundColor = [UIColor clearColor];
		objLabelRandom.text = @"Randomize Cards";
		UISwitch *objSwitchRandom=[[[UISwitch alloc] initWithFrame:CGRectMake(380,17,100,25)] autorelease];
		objSwitchRandom.tag=20;
		int iRandom = [AppDelegate_iPad delegate].isRandomCard;	
		if (iRandom == 1) 
		{
			objSwitchRandom.on = YES;
		}
		else 
		{
			objSwitchRandom.on = NO;
		}
		objSwitchRandom.enabled =  YES;
		[objSwitchRandom addTarget:self action:@selector(switchRandomChange:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:objLabelRandom];
		[cell addSubview:objSwitchRandom];
		//[objSwitchRandom release];
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row < [_settingButtons count]) {
		NSString* button=[_settingButtons objectAtIndex:indexPath.row];
		
		if ([button isEqualToString:@"Clear \"I Know\""]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 0;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Clear All Bookmarks"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all bookmarks?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 1;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Clear All Voice Notes"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all voice notes?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 3;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Clear All Comments"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all comments?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 2;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Reset Application"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset application contents?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 4;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Application Rating"]) {
			
			[Appirater rateApp];
			
		}
	
	}
}

#pragma mark -
#pragma mark UIAlertView Delagates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		switch (alertView.tag) 
		{
			case 0:
				[[AppDelegate_iPad getDBAccess] clearAllProficiency];
				[(CardDetails *) _parentCtrl._detail resetKnownUnknown];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedCards" object:nil userInfo:nil];
				break;
				
			case 1:
				[[AppDelegate_iPad getDBAccess] clearAllBookmarkedCards];
				[(CardDetails *) _parentCtrl._detail resetBookmarked];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedCards" object:nil userInfo:nil];
				break;
				
			case 2:
				[[AppDelegate_iPad getDBAccess] clearAllComments];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedComments" object:nil userInfo:nil];
				break;
				
			case 3:
				
				[[AppDelegate_iPad getDBAccess] clearAllVoiceNotes];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedVoiceNotes" object:nil userInfo:nil];
				break;
				
			case 4:
				
				[[AppDelegate_iPad getDBAccess] clearAllBookmarkedCards];
				[[AppDelegate_iPad getDBAccess] clearAllProficiency];
				[[AppDelegate_iPad getDBAccess] clearAllComments];
				[[AppDelegate_iPad getDBAccess] clearAllVoiceNotes];
				[(CardDetails *) _parentCtrl._detail resetBoth];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"ResetApplication" object:nil userInfo:nil];
				break;
				
			default:
				break;
		}
	}
	[(DeckViewController *) _parentCtrl updateInfo];
	//[(CardDetails *) _parentCtrl._detail updateNavBar];
}

- (void)switchRandomChange:(id)sender
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"features.plist"];
	NSMutableDictionary* featuresDict=[[NSMutableDictionary alloc]initWithContentsOfFile:docPath];
	
	//NSLog(@"Value of Random : %d",[[featuresDict objectForKey:@"Random"] intValue]);
	
	if ([sender isOn]) {
		[AppDelegate_iPad delegate].isRandomCard = 1;
	}
	else {
		[AppDelegate_iPad delegate].isRandomCard = 0;
	}
	[featuresDict setObject:[NSNumber numberWithInt: [AppDelegate_iPad delegate].isRandomCard] forKey:@"Random"];
	[featuresDict writeToFile:docPath atomically:YES];
}


#pragma mark -------
#pragma mark UIWebView delegates
- (BOOL) handleShouldStartLoadWithWebView:(NSDictionary *)notification
{
	//UIWebView * webView = (UIWebView *)[notification.userInfo objectForKey:@"webview"];
	NSURLRequest * request = (NSURLRequest *)[notification objectForKey:@"request"];
	//UIWebViewNavigationType navigationType = [[notification.userInfo objectForKey:@"navigationType"] intValue];
	vcHTMLDisplayer = [[HTMLDisplayController alloc] initWithNibName:@"HTMLDisplayController" bundle:nil];
	[self.view addSubview:vcHTMLDisplayer.view];
	[vcHTMLDisplayer setPageContent:[[request URL] absoluteString] withTitle:@""];
	//[vcHTMLDisplayer release];
	return NO;
	
}

@end
