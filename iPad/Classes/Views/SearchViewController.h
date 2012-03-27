//
//  SearchViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckViewController.h"
#import "AppDelegate_iPad.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate,UINavigationControllerDelegate> {

	IBOutlet UITableView*	_tableView;
	IBOutlet UISearchBar*	_searchBar;
	NSMutableArray* cards;
	DeckViewController* _parentView;
}

@property (nonatomic,retain) IBOutlet UITableView*	_tableView;
@property (nonatomic,retain) IBOutlet UISearchBar*	_searchBar;
@property (nonatomic, retain) NSMutableArray* cards;

-(void) popView;
-(void) setParentViewCtrl:(DeckViewController*) parentView;
-(IBAction) closeSearch:(id)sender;

@end
