//
//  CardList.h
//  SchlossExtra
//
//  Created by Chandan Kumar on 16/08/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPhone.h"

@interface CardListIPhone : UIViewController {
	
	NSMutableArray* arrCards;
	IBOutlet UITableView* tblCardNames;
}


@property (nonatomic, retain) NSMutableArray* arrCards;
@property (nonatomic,retain) IBOutlet UITableView*	tblCardNames;

- (void) showCardsForDeck:(int) DeckId;
- (void)popView;
@end
