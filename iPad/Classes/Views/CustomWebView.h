//
//  CustomWebView.h
//  FlashCardDB
//
//  Created by Friends on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomWebView : UIWebView <UIWebViewDelegate>
{
	UIActivityIndicatorView* act;
	NSString* searchText;
	UIViewController* parent;
}

@property (nonatomic,retain) NSString* searchText;
@property (nonatomic,retain) UIViewController* parent;


///- (void)loadHTMLString:(NSString *)str;

- (void)loadClearBgHTMLString:(NSString *)str;
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
