//
//  DBAccess.h
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardComment.h"
#import "VoiceNote.h"
#import "CardWrapper.h"
#import "FlashCard.h"

@interface DBAccess : NSObject 
{
	NSString*	_databasePath;
}

- (void) createDatabaseIfNeeded;

- (FlashCardDeck*) getFlashCardDeckByDeckId:(int)iDeckId;
- (NSMutableArray*) getFlashCardDeckList;
- (NSUInteger) getCardCountForDeckType:(CardDeckType)type withId:(NSUInteger) deckId;
- (NSUInteger) getKnownCardCountForDeckType:(CardDeckType)type withId:(NSUInteger) deckId;

- (NSString*) GetHelpString;
- (NSString*) GetInfoString;

- (void) clearAllProficiency;
- (void) clearAllBookmarkedCards;

- (void) setProficiency:(NSUInteger)proff  ForCardId:(NSUInteger)cardId;
- (void) setBookmarkedCard:(NSUInteger)bookMark  ForCardId:(NSUInteger)cardId;

- (NSMutableArray*) getCardListForDeckType:(CardDeckType)type withId:(NSUInteger) deckId;

- (CardComment*) getCardComments:(NSInteger) cardId;
- (void) updateComments:(CardComment*) comments;
- (NSUInteger) getCommentsCount:(NSUInteger) cardId;

- (BOOL) deleteComments:(NSInteger)flashCardId;
- (void) clearAllComments;
- (void) addVoiceNote:(VoiceNote *)voiceNote;
- (BOOL) deleteVoiceNote:(NSInteger)voiceNoteId;
- (BOOL) deleteAllVoiceNotes:(NSInteger)flashCardId;

- (void) clearAllVoiceNotes;
- (NSMutableArray*) getCardVoiceNotes:(NSInteger) cardId;
- (NSMutableArray*) getAllVoiceNotes;
- (NSMutableArray*) getAllAudioFiles:(NSInteger) cardId;
- (NSString*) getAudioFile:(NSInteger) voiceNoteId;
- (BOOL) isCommentOrNotesAvailable:(NSInteger) flashCardId;

- (NSMutableArray*) getCardsByAlphabets;
- (NSMutableArray*) getCardsByAlphabet:(NSString *)alphabet;
- (NSMutableArray*) searchCardsByName:(NSString *)searchText;
- (NSMutableArray*) getAllComments;

- (NSMutableArray*) getFlashCardForQuery:(NSString*)query;


@end
