//
//  ModalViewCtrl.h
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLDisplayController.h"

@class DeckViewController;

@interface ModalViewCtrl : UIViewController 
{
	IBOutlet UIWebView*			_webView;
	IBOutlet UITableView*		_tableView;
	IBOutlet UINavigationItem*	_navItem;
	
	ContentType					_contentType;
	DeckViewController*			_parentCtrl;
	NSMutableArray*				_settingButtons;
	Boolean						_isRandomOption;
	HTMLDisplayController *		vcHTMLDisplayer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentType:(ContentType) type;
- (IBAction) done:(id) sender;
- (void) setParentCtrl: (DeckViewController*) ctrl;
- (void)switchRandomChange:(id) sender;

@end
