//
//  IndexViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckViewController_iPhone.h"
#import "FlashCard.h"

@interface IndexViewController_iPhone : UIViewController<UIAlertViewDelegate> {
	
	NSMutableArray *cards;
	NSMutableArray *indices;
	IBOutlet UITableView*	_tableView;
	NSString* _source;
}

@property(nonatomic,retain) IBOutlet UITableView* _tableView;
//@property(nonatomic, retain) NSMutableArray *cards;
@property(nonatomic, retain) NSMutableArray *indices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forDeck:(FlashCardDeck *)objDeck;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forBookmarkedDeck:(BOOL)bIsBookmarkedDeck;

-(void) popView;

@end
