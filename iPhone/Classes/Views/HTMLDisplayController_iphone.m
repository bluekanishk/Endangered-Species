//
//  HTMLDisplayController_iphone.m
//  SaveTheAnimalsUni
//
//  Created by Chandan Kumar on 25/02/12.
//  Copyright 2012 Interglobe Technologies. All rights reserved.
//

#import "HTMLDisplayController_iphone.h"


@implementation HTMLDisplayController_iphone

@synthesize wvContainer,nbTopBar,aiLoading;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.wvContainer.scalesPageToFit = YES;
	self.wvContainer.delegate = self;
}


-(void) setPageContent:(NSString *)strURL withTitle:(NSString *)strTitle
{
	self.navigationItem.title = strTitle;
	nbTopBar.topItem.title = strTitle;
	aiLoading.hidden = NO;
	[aiLoading startAnimating];
	[wvContainer  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]]];
}

-(void)popView
{
	[self dismissModalViewControllerAnimated:YES];
	[wvContainer stopLoading];
	[wvContainer release];
	wvContainer=nil;
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	aiLoading.hidden = NO;
	[aiLoading startAnimating];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[aiLoading stopAnimating];
	aiLoading.hidden = YES;
}

- (void)dealloc {
	[wvContainer stopLoading];	
	[wvContainer release];
	[nbTopBar release];
	[aiLoading release];
    [super dealloc];
}


@end
