//
//  DeckCell.h
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlashCardDeck;

@interface DeckCell_iPhone : UITableViewCell 
{
	FlashCardDeck*		_deck;
}

+ (DeckCell_iPhone*) creatCellViewWithFlashCardDeck:(FlashCardDeck*) deck withTextColor:(UIColor*) textColor;
+ (DeckCell_iPhone*) creatCellViewWithText:(NSString*)strText withTextColor:(UIColor*) textColor;
@end
