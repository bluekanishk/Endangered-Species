//
//  IndexViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckViewController.h"
#import "FlashCard.h"


@interface IndexViewController : UIViewController<UIAlertViewDelegate> {
	
	NSMutableArray *cards;
    NSMutableArray *indices;
	IBOutlet UITableView*	_tableView;
	DeckViewController* _parentView;
	NSString* _source;
}

@property(nonatomic,retain) IBOutlet UITableView* _tableView;
@property(nonatomic, retain) NSMutableArray *cards;
@property(nonatomic, retain) NSMutableArray *indices;


-(void) setParentViewCtrl:(DeckViewController*) parentView;
-(IBAction) closeIndex:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forDeck:(FlashCardDeck *)objDeck;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forBookmarkedDeck:(BOOL)bIsBookmarkedDeck;

@end
