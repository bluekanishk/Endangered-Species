//
//  SearchViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckViewController_iPhone.h"
#import "AppDelegate_iPhone.h"

@interface SearchViewController_iPhone : UIViewController<UISearchBarDelegate,UINavigationControllerDelegate> {

	IBOutlet UITableView*	_tableView;
	IBOutlet UISearchBar*	_searchBar;
	NSMutableArray* cards;
}

@property (nonatomic,retain) IBOutlet UITableView*	_tableView;
@property (nonatomic,retain) IBOutlet UISearchBar*	_searchBar;
@property (nonatomic, retain) NSMutableArray* cards;

-(void) popView;


@end
