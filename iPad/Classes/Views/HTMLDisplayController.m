    //
//  HTMLDisplayController.m
//  TigerTesterUni
//
//  Created by Abhinav Kumar on 2/24/12.
//  Copyright 2012 Spearhead Software Solutions. All rights reserved.
//

#import "HTMLDisplayController.h"

@implementation HTMLDisplayController

@synthesize wvContainer,nbTopBar,aiLoading;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.wvContainer.scalesPageToFit = YES;
	wvContainer.delegate = self;
}

-(IBAction)popView
{
	[wvContainer stopLoading];
	[wvContainer release];
	wvContainer=nil;
	[self.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) setPageContent:(NSString *)strURL withTitle:(NSString *)strTitle
{
	self.navigationItem.title = strTitle;
	nbTopBar.topItem.title = strTitle;
	[wvContainer  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]]];
	
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	aiLoading.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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
