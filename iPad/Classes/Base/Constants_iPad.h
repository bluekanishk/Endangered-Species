//
//  Constants.h
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDetailViewWidth	642

#define DBNAME		@"SchlossbergNew.db3"

#define DECKTABLE	@"m_FlashCardDecks"

#define kInfoRowBackgroundColor				[UIColor colorWithRed:0.0 green:0.322 blue:0.369 alpha:1.0];
#define kDeckRowAllBackgroundColor			[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
//#define kDeckRowBookMarkedBackgroundColor	[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];

#define SELECT_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId ",			\
@"and a.fk_FlashCardDeckId = %d) m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]

#define SELECT_All_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId ",			\
@") m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]


#define SELECT_Alphabetical_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId order by a.CardName ",			\
@") m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]



#define SELECT_BOOK_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId ",			\
@"and a.ISBookMarked = 1) m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]


typedef enum tagCardDeckType
{
	kCardDeckTypeAlfabaticallly = 0,
	kCardDeckTypeBookMark,
	kCardDeckTypeAll
	
}CardDeckType;


typedef enum tagContentType
{
	kContentTypeSetting = 0,
	kContentTypeHelp,
	kContentTypeInfo,
	kContentTypeVoiceNotes,
	kContentTypeComments
	
}ContentType;

typedef enum tagCardType
{
	kCardTypeNone = 0,
	kCardTypeFront,
	kCardTypeBack	
	
}CardType;

typedef enum tagResourceType
{
	kResourceTypeNone = 0,
	kResourceTypeText,
	kResourceTypeAudio,
	kResourceTypeVedio,
	kResourceTypeImage
	
}ResourceType;

