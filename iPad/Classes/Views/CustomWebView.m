//
//  CustomWebView.m
//  FlashCardDB
//
//  Created by Friends on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomWebView.h"
#import "Utils.h"


@implementation CustomWebView

@synthesize searchText,parent;


- (void)loadClearBgHTMLString:(NSString *)str
{
	self.opaque = NO;
	self.scalesPageToFit = YES;
	self.dataDetectorTypes = UIDataDetectorTypeNone;
	self.allowsInlineMediaPlayback = YES;
	self.backgroundColor = [UIColor clearColor];
	NSRange range = [str rangeOfString:@"<html"];
	
	if (range.length > 0) 
	{
		[self loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor = transparent><font face=\"Arial\"><font size=\"4\">%@</font></html>", str] baseURL:nil];
	}
	
	else
	{
		
		NSString* fName = [[NSBundle mainBundle] pathForResource:[Utils getFileName:str] ofType:nil inDirectory:nil];
		
		//NSString* str = [[NSBundle mainBundle] pathForResource:@"front" ofType:@"html"];
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fName];
		if (fileExists == YES) {
			
		
			NSURL* url = [[NSURL alloc] initFileURLWithPath:fName];
			NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
			
			//NSLog(@"%@, %@", str, fName);
			
			[self loadRequest:req];
			self.delegate = self;
		}
		else {
			[self loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor = transparent><font face=\"Arial\"><font size=\"40\">%@</font></html>",str] baseURL:nil];
		}

	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[act stopAnimating];
	
	if (searchText!=nil && [searchText length] > 0) {
		[self highlightAllOccurencesOfString:searchText];
	}
	
}

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
	NSString* jsCode=[Utils getJSCode];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
	
    NSString *startSearch = [NSString stringWithFormat:@"FC_HighlightAllOccurencesOfString('%@')",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
	
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"FC_SearchResultCount"];
    NSLog(@"Match Found ....%@",result);
	
	return 0;
	
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"FC_RemoveAllHighlights()"];
}

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return [vcParentViewController handleShouldStartLoadWithWebView:webView withRequest:request navigationType:navigationType];
}
*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) //&& (parent != nil && [parent respondsToSelector:@selector(handleShouldStartLoadWithWebView)])) 
	{
		
		NSDictionary* dicParamDetails = [[NSDictionary alloc] initWithObjectsAndKeys:webView, @"webview",request,@"request",navigationType,@"navigationType",nil];
		//[[NSNotificationCenter defaultCenter] postNotificationName:kEventCustomWebViewStartLoad object:nil userInfo:dicParamDetails];
		[parent performSelector:@selector(handleShouldStartLoadWithWebView:) withObject:dicParamDetails];
		[dicParamDetails release];
		return NO;
	}
	
	return YES;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[act stopAnimating];
}

@end
