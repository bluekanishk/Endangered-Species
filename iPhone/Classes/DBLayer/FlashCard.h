//
//  FlashCard.h
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* RowImages[];

@interface Card : NSObject 
{
	NSString*	_htmlFile;
	NSString*	_audioFile;	
	NSString*	_vedioFile;
	NSString*	_imageFile;

	NSString*	_cardTitle;
	NSString*   _cardName;
}

@property (nonatomic, readonly) NSString*		htmlFile;
@property (nonatomic, readonly) NSString*		audioFile;	
@property (nonatomic, readonly) NSString*		vedioFile;
@property (nonatomic, readonly) NSString*		imageFile;

@property (nonatomic, copy) NSString*			cardTitle;
@property (nonatomic, copy) NSString*			cardName;

- (void) setResourceType:(ResourceType) type resource:(NSString*) str;

@end


@interface FlashCard : NSObject 
{
	Card*	_frontCard;
	Card*	_backCard;
	
	BOOL	_isKnown;
	BOOL	_isBookMarked;

	NSUInteger	_cardID;
	NSUInteger	_internalCardId;
	NSString*	_cardName;

}

@property (nonatomic, readonly) Card*		frontCard;
@property (nonatomic, readonly) Card*		backCard;
@property (nonatomic) BOOL				isKnown;
@property (nonatomic) BOOL				isBookMarked;
@property (nonatomic) NSUInteger		cardID;
@property (nonatomic) NSUInteger		internalCardId;
@property (nonatomic,retain) NSString*	cardName;


- (Card*) getCardOfType:(CardType) type;

@end


@interface FlashCardDeck : NSObject 
{
	NSArray*		_flashCardList;
	UIColor*		_deckColor;
	NSString*		_deckImage;
	NSString*		_deckTitle;
	
	NSUInteger		_deckId;
	NSUInteger		_cardCount;
	CGFloat			_proficiency;
	
	CardDeckType	_deckType;
}

@property (nonatomic, retain) UIColor*		deckColor;
@property (nonatomic, copy) NSString*		deckTitle;
@property (nonatomic, copy) NSString*		deckImage;

@property (nonatomic) NSUInteger		deckId;
@property (nonatomic) NSUInteger		cardCount;

@property (nonatomic) CGFloat			proficiency;

@property (nonatomic) CardDeckType		deckType;

- (NSMutableArray*) getCardsList;

@end

@interface FlashCardDeckList : NSObject 
{
	FlashCardDeck*		_allCardDeck;
	FlashCardDeck*		_bookMarkedCardDeck;
	NSMutableArray*		_flashCardDeckList;
}

@property (nonatomic, readonly) FlashCardDeck*		allCardDeck;
@property (nonatomic, readonly) FlashCardDeck*		bookMarkedCardDeck;
@property (nonatomic, readonly) NSMutableArray*		flashCardDeckList;

- (void) updateProficiency;

@end
