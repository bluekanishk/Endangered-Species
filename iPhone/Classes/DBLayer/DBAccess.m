//
//  DBAccess.m
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"
#import "sqlite3.h"
#import "DBAccess.h"
#import "Utils.h"


@implementation DBAccess

- (void) createDatabaseIfNeeded
{
	BOOL success;
	NSError* error;
	
	NSFileManager* FileManager = [NSFileManager defaultManager];
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDir = [paths objectAtIndex:0];
	
	NSString *strDBName = [Utils getValueForVar:kDBName];
	//_databasePath = [[documentDir stringByAppendingPathComponent:DBNAME] retain];
	_databasePath = [[documentDir stringByAppendingPathComponent:strDBName] retain];
	success = [FileManager fileExistsAtPath:_databasePath];
	
	if (success) return;
	
	NSString* dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:strDBName];
	
	success = [FileManager copyItemAtPath:dbPath toPath:_databasePath error:&error];
	
	if (!success)
	{
		NSAssert( @"Failed to copy the database. Error:%@.", [error localizedDescription]);
	}
	else {
		[Utils addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:[_databasePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}

}


#pragma mark -
#pragma mark HelpText and InfoText Access Functions
#pragma mark -

- (NSString*) GetHelpString
{
	sqlite3 *database;
	
	// Init the animals Array
	NSString* helpString = nil;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"select HelpText from m_ConfigDetails"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				helpString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return helpString;
	
}

- (NSString*) GetInfoString
{
	sqlite3 *database;
	
	// Init the animals Array
	NSString* infoString = nil;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"select Info from m_ConfigDetails"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				infoString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return infoString;		
}


#pragma mark -
#pragma mark CardDeck Access Functions
#pragma mark -

- (FlashCardDeck *) getFlashCardDeckByDeckId:(int)iDeckId
{
	sqlite3 *database;
	
	// Init the animals Array
	FlashCardDeck* deck = [[FlashCardDeck alloc] init];
	deck.deckId = -1;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"select pk_FlashCardDeckId, DeckTitle, DeckImage, DeckColor from m_FlashCardDecks where pk_FlashCardDeckId = %d",iDeckId] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				deck.deckId = sqlite3_column_int(compiledStatement, 0);
				deck.deckTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				deck.deckType = kCardDeckTypeAlfabaticallly;
				deck.deckImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				deck.deckColor = [Utils colorFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return deck;
}



- (NSArray*) getFlashCardDeckList
{
	sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray* decsArray = [NSMutableArray array];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"select pk_FlashCardDeckId, DeckTitle, DeckImage, DeckColor from m_FlashCardDecks"] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				FlashCardDeck* deck = [[FlashCardDeck alloc] init];
				
				deck.deckId = sqlite3_column_int(compiledStatement, 0);
				deck.deckTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				deck.deckType = kCardDeckTypeAlfabaticallly;
				deck.deckImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				deck.deckColor = [Utils colorFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]];
				// Add the animal object to the animals Array
				[decsArray addObject:deck];
				
				[deck release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return decsArray;
}

- (NSUInteger) getCardCountForDeckType:(CardDeckType)type withId:(NSUInteger) deckId
{
	sqlite3 *database;
	
	// Init the animals Array
	NSUInteger cardCount = 0;
	NSString* query = nil;
	switch (type)
	{
		case kCardDeckTypeAlfabaticallly:
			query = [NSString stringWithFormat:@"select count(*) from m_FlashCard where fk_FlashCardDeckId = %d", deckId];
			break;
		case kCardDeckTypeAll:
			query = [NSString stringWithFormat:@"select count(*) from m_FlashCard"];
			break;
		case kCardDeckTypeBookMark:
			query = [NSString stringWithFormat:@"select count(*) from m_FlashCard where ISBookMarked = 1"];
			break;
	}
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		const char *sqlStatement = [query UTF8String];
		// Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				cardCount = sqlite3_column_int(compiledStatement, 0);
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cardCount;
}

- (NSUInteger) getKnownCardCountForDeckType:(CardDeckType)type withId:(NSUInteger) deckId
{
	sqlite3 *database;
	
	// Init the animals Array
	NSUInteger cardCount = 0;
	NSString* query = nil;
	switch (type)
	{
		case kCardDeckTypeAlfabaticallly:
			query = [NSString stringWithFormat:@"select count(*) from m_FlashCard where fk_FlashCardDeckId = %d and ISKnown = 1", deckId];
			break;
		case kCardDeckTypeAll:
			query = [NSString stringWithFormat:@"select count(*) from m_FlashCard where ISKnown = 1"];
			break;
		case kCardDeckTypeBookMark:
			query = [NSString stringWithFormat:@"select count(*) from m_FlashCard where  ISBookMarked = 1 and ISKnown = 1"];
			break;
	}
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		const char *sqlStatement = [query UTF8String];
		// Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				cardCount = sqlite3_column_int(compiledStatement, 0);
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cardCount;
}

#pragma mark -
#pragma mark clearAllProficiency and clearAllBookmarkedCards
#pragma mark -

- (void) clearAllProficiency
{
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"update m_FlashCard set ISKnown = 0"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}

- (void) clearAllBookmarkedCards
{
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"update m_FlashCard set ISBookMarked = 0"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}


- (void) clearAllComments
{
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"delete from m_FlashCardComments"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			if(sqlite3_step(compiledStatement) == SQLITE_DONE){
				NSLog(@"Done...Delete Comments.");
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}



- (void) clearAllVoiceNotes
{
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"delete from m_FlashCardVoiceNotes"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			NSFileManager *fm = [NSFileManager defaultManager];
			NSMutableArray* files=[self getAllAudioFiles:0];
			
			if(sqlite3_step(compiledStatement) == SQLITE_DONE){
				NSLog(@"Done...Delete FlashCards");
				for (int i=0; i<[files count]; i++) {
					NSString* filePath=[files objectAtIndex:i];
					NSURL* fileURL=[[NSURL alloc] initWithString:filePath];
					[fm removeItemAtPath:[fileURL path] error:nil];
				}
			}
			
			[files release];
			[fm release];
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}


#pragma mark -
#pragma mark Set bookMark and proficiency
#pragma mark -

- (void) setProficiency:(NSUInteger)proff  ForCardId:(NSUInteger)cardId
{
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"update m_FlashCard set ISKnown = %d where pk_FlashCardId = %d", proff, cardId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}

- (void) setBookmarkedCard:(NSUInteger)bookMark  ForCardId:(NSUInteger)cardId
{
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"update m_FlashCard set ISBookMarked = %d where pk_FlashCardId = %d", bookMark, cardId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}


#pragma mark -
#pragma mark Flash Card Access Functions
#pragma mark -

+ (FlashCard*) getIndexOfCardWithId:(NSUInteger)cardId inArray:(NSArray*) arr
{
	for (int i = 0; i < arr.count; ++i) 
	{
		FlashCard* card = [arr objectAtIndex:i];
		if (card.cardID == cardId)
			return card;
	}

	return nil;
}

/// cardId, internalCardId, Front/Back, titleData, FlashCardDeckId, ResourceType, resourceData, isKnown, isBookMarked

- (NSMutableArray*) getFlashCardForQuery:(NSString*)query
{
	
	
	sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray* cardArray = [NSMutableArray array];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [query UTF8String];

		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				int cardId = sqlite3_column_int(compiledStatement, 0);
				FlashCard* fCard = [DBAccess getIndexOfCardWithId:cardId inArray:cardArray];
				
				if (fCard == nil)
				{
					fCard = [[FlashCard alloc] init];
					[cardArray addObject:fCard];
					[fCard release];
				}
				
				fCard.cardID = cardId;
				fCard.internalCardId = sqlite3_column_int(compiledStatement, 1);
				fCard.isKnown = (sqlite3_column_int(compiledStatement, 5) == 0)? NO : YES;
				fCard.isBookMarked = (sqlite3_column_int(compiledStatement, 6) == 0)? NO : YES;
				fCard.cardName = [Utils getEncodedText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]];
				
				
				Card* card = [fCard getCardOfType:sqlite3_column_int(compiledStatement, 2)];
				card.cardTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				card.cardName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
				
				if (sqlite3_column_text(compiledStatement, 9) ==nil) {
					[[fCard getCardOfType:sqlite3_column_int(compiledStatement, 2)] setResourceType:(sqlite3_column_int(compiledStatement, 8)) 
																						   resource: @""];
				}else {
					[[fCard getCardOfType:sqlite3_column_int(compiledStatement, 2)] setResourceType:(sqlite3_column_int(compiledStatement, 8)) 
																						   resource: [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)]];
				}

								
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cardArray;
}

- (NSMutableArray*) getCardListForDeckType:(CardDeckType)type withId:(NSUInteger) deckId
{
	switch (type)
	{
		case kCardDeckTypeAlfabaticallly:
			return [self  getFlashCardForQuery:[NSString stringWithFormat:SELECT_DECK_CARD_QUERY, deckId]];

		case kCardDeckTypeAll:
			return [self  getFlashCardForQuery:SELECT_All_DECK_CARD_QUERY];

		case kCardDeckTypeBookMark:
			return [self  getFlashCardForQuery:SELECT_BOOK_DECK_CARD_QUERY];
	}

	return nil;
}


- (NSMutableArray*) getCardsByAlphabets{
	
	
	sqlite3 *database;
	NSMutableArray *cards=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT DISTINCT cards.CardName FROM m_FlashCard cards,m_FlashCardFrontBackDetails details where cards.pk_FlashCardId=details.fk_FlashCardId order by cards.CardName"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSString *name=[Utils getEncodedText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];
				[cards addObject:name];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cards;

}


- (NSMutableArray*) getCardsByAlphabet:(NSString *)alphabet{
	
	
	sqlite3 *database;
	NSMutableArray *cards=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"select distinct cardname from m_flashcard where cardname like '%@%%'",alphabet] UTF8String];
		//NSLog(@"The query is : %@",sqlStatement);
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSString *name=[Utils getEncodedText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];
				[cards addObject:name];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cards;
	
}


- (NSMutableArray*) searchCardsByName:(NSString*) searchText
{

	sqlite3 *database;
	NSMutableArray *cards=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack from (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack,b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId and b.fk_FlashCardId in (select  fk_FlashCardId from  m_FlashCardFrontBackDetails where FileContent like '%%%@%%') ) m LEFT OUTER JOIN m_FlashCardInternalDetails p on m.pk_FlashCardId = p.fk_FlashCardId order by CardName",searchText] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				int cardId = sqlite3_column_int(compiledStatement, 0);
				FlashCard* fCard = [DBAccess getIndexOfCardWithId:cardId inArray:cards];
				
				if (fCard == nil)
				{
					fCard = [[FlashCard alloc] init];
					[cards addObject:fCard];
					[fCard release];
				}
				
				fCard.cardID = cardId;
				fCard.internalCardId = sqlite3_column_int(compiledStatement, 1);
				fCard.isKnown = (sqlite3_column_int(compiledStatement, 5) == 0)? NO : YES;
				fCard.isBookMarked = (sqlite3_column_int(compiledStatement, 6) == 0)? NO : YES;
				fCard.cardName = [Utils getEncodedText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]];
				
				Card* card = [fCard getCardOfType:sqlite3_column_int(compiledStatement, 2)];
				card.cardTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				card.cardName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
				if(sqlite3_column_text(compiledStatement, 9) !=nil){
					[[fCard getCardOfType:sqlite3_column_int(compiledStatement, 2)] setResourceType:(sqlite3_column_int(compiledStatement, 8)) 
																						   resource: [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)]];
				}
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cards;
}



- (NSMutableArray*) getAllComments{


	sqlite3 *database;
	NSMutableArray *cards=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT cards.CardName,comments.fk_FlashCardId FROM m_flashcard cards,m_FlashCardFrontBackDetails details, m_FlashCardComments comments where details.fk_FlashCardId=comments.fk_FlashCardId and pk_flashcardid = details.fk_FlashCardId  group by comments.fk_FlashCardId"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				CardWrapper* card=[[CardWrapper alloc] init];
				card.cardName=[Utils getEncodedText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];
				card.flashCardId=sqlite3_column_int(compiledStatement, 1);
				
				[cards addObject:card];
			}
		}
		sqlite3_finalize(compiledStatement);
	
	}
	sqlite3_close(database);
	
	return cards;
}


- (CardComment*) getCardComments:(NSInteger) cardId{

	sqlite3 *database;
	CardComment *comment=nil;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"select * from m_FlashCardComments where fk_FlashCardId=%d", cardId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				comment=[[CardComment alloc] retain];
				comment.commentId=sqlite3_column_int(compiledStatement, 0);
				comment.cardId=sqlite3_column_int(compiledStatement, 1);
				comment.comments=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return comment;
}


- (NSUInteger) getCommentsCount:(NSUInteger) cardId
{
	sqlite3 *database;
	NSUInteger commentCount = 0;
	NSString* query=nil;
	
	if (cardId!=0) {
		query=[NSString stringWithFormat:@"select count(*) from m_FlashCardComments where fk_FlashCardId=%d", cardId];
	}else {
		query=[NSString stringWithFormat:@"select count(*) from m_FlashCardComments"];
	}

	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		const char *sqlStatement = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				commentCount = sqlite3_column_int(compiledStatement, 0);
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return commentCount;
}



- (void) updateComments:(CardComment*) comment{

	sqlite3 *database;
	char *updateQuery=nil;
	
	BOOL updateFlag=YES;
	if (comment.commentId==-1) {
		updateQuery="insert into m_FlashCardComments (pk_CommentId,fk_FlashCardId,Comments) values(?,?,?)";
		updateFlag=NO;
	}else {
		updateQuery="update m_FlashCardComments set Comments=? where pk_CommentId=?";
	}
	
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		if(sqlite3_prepare_v2(database, updateQuery, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			if (updateFlag==NO) {
				NSInteger commentsCount=[self getCommentsCount:0];
				
				sqlite3_bind_int(compiledStatement, 1, commentsCount+1);
				sqlite3_bind_int(compiledStatement, 2, [comment cardId]);
				sqlite3_bind_text(compiledStatement, 3, [[comment comments] UTF8String], -1, NULL);
			
			}else {
				sqlite3_bind_text(compiledStatement, 1, [[comment comments] UTF8String], -1, NULL);
				sqlite3_bind_int(compiledStatement, 2, [comment commentId]);
			}
			
			if (sqlite3_step(compiledStatement) != SQLITE_DONE){
				NSLog(@"COULDNT RUN QUERY: %s\n", sqlite3_errmsg(database));  
			}else {
				NSLog(@"Comments Added Successfully !");  
			}

		}else {
			NSLog(@"COULDNT RUN QUERY: %s\n", sqlite3_errmsg(database));  
		}
	}

	sqlite3_finalize(compiledStatement);
	sqlite3_close(database);
	
}


- (void) addVoiceNote:(VoiceNote*) voiceNote{
	sqlite3 *database;
	char *updateQuery="insert into m_FlashCardVoiceNotes(fk_FlashCardId,audioTitle,audioFile) values(?,?,?)";
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		
		if(sqlite3_prepare_v2(database, updateQuery, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			sqlite3_bind_int(compiledStatement, 1, [voiceNote flashCardId]);
			sqlite3_bind_text(compiledStatement, 2, [[voiceNote title] UTF8String], -1, NULL);
			sqlite3_bind_text(compiledStatement, 3, [[[voiceNote recordedFileURL] absoluteString] UTF8String], -1, NULL);
			
			if (sqlite3_step(compiledStatement) != SQLITE_DONE){
				NSLog(@"COULDNT RUN QUERY: %s\n", sqlite3_errmsg(database));  
			}else {
				NSLog(@"VoiceNotes Added Successfully !");  
			}
			
		}else {
			NSLog(@"COULDNT RUN QUERY: %s\n", sqlite3_errmsg(database)); 
		}

	}else {
		NSLog(@"COULDNT RUN QUERY: %s\n", sqlite3_errmsg(database));  
	}
	
	sqlite3_finalize(compiledStatement);
	sqlite3_close(database);

}


- (NSMutableArray*) getCardVoiceNotes:(NSInteger) cardId{

	sqlite3 *database;
	NSMutableArray *notes=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"select * from m_FlashCardVoiceNotes where fk_FlashCardId=%d", cardId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				VoiceNote *note=[[VoiceNote alloc] init];
				note.voiceNoteId=sqlite3_column_int(compiledStatement, 0);
				note.flashCardId=sqlite3_column_int(compiledStatement, 1);
				note.title=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString* fileURL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				note.recordedFileURL=[[NSURL alloc] initWithString:fileURL];
				[notes addObject:note];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return notes;
}


- (BOOL) deleteVoiceNote:(NSInteger)voiceNoteId{
	
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"delete from m_FlashCardVoiceNotes where pk_VoiceNoteId=%d",voiceNoteId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			NSFileManager *fm = [NSFileManager defaultManager];
			NSString* file=[self getAudioFile:voiceNoteId];
			
			if(sqlite3_step(compiledStatement) == SQLITE_DONE){
				NSURL* fileURL=[[NSURL alloc] initWithString:file];
				[fm removeItemAtPath:[fileURL path] error:nil];
			}
			[fm release];
			[file release];
			
		}else {
			return NO;
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
	
	return YES;
	
}


- (BOOL) deleteAllVoiceNotes:(NSInteger)flashCardId{

	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"delete from m_FlashCardVoiceNotes where fk_FlashCardId=%d",flashCardId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			
			NSFileManager *fm = [NSFileManager defaultManager];
			NSMutableArray* files=[self getAllAudioFiles:flashCardId];
			
			if(sqlite3_step(compiledStatement) == SQLITE_DONE){
				for (int i=0; i<[files count]; i++) {
					NSString* filePath=[files objectAtIndex:i];
					NSURL* fileURL=[[NSURL alloc] initWithString:filePath];
					[fm removeItemAtPath:[fileURL path] error:nil];
				}
			}
			
			[fm release];
			[files release];
			
		}else {
			return NO;
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
	
	return YES;
}



- (BOOL) deleteComments:(NSInteger)flashCardId{
	
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		
		const char *sqlStatement = [[NSString stringWithFormat:@"delete from m_FlashCardComments where fk_FlashCardId=%d",flashCardId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			if(sqlite3_step(compiledStatement) == SQLITE_DONE){
				NSLog(@"Deleting Comments for FlashCardId....%d",flashCardId);
			}
		}else {
			return NO;
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(database);
	
	return YES;
}




- (NSMutableArray*) getAllVoiceNotes{
	
	sqlite3 *database;
	NSMutableArray *cards=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT cards.CardName,notes.fk_FlashCardId FROM m_flashcard cards,m_FlashCardFrontBackDetails details, m_FlashCardVoiceNotes notes where notes.fk_FlashCardId=details.fk_FlashCardId and pk_flashcardid = details.fk_FlashCardId group by notes.fk_FlashCardId"] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				CardWrapper* card=[[CardWrapper alloc] init];
				card.cardName=[Utils getEncodedText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];
				card.flashCardId=sqlite3_column_int(compiledStatement, 1);
				
				[cards addObject:card];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	return cards;
	
}

- (NSString*) getAudioFile:(NSInteger) voiceNoteId{
	
	sqlite3 *database;
	NSString *file=[[NSMutableArray alloc] autorelease];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement=[[NSString stringWithFormat:@"SELECT audioFile FROM m_FlashCardVoiceNotes where pk_VoiceNoteId=%d",voiceNoteId] UTF8String];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				file=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	return file;
}

- (NSMutableArray*) getAllAudioFiles:(NSInteger) cardId{
	
	sqlite3 *database;
	NSMutableArray *files=[[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement;
		if (cardId==0) {
			sqlStatement=[[NSString stringWithFormat:@"SELECT audioFile FROM m_FlashCardVoiceNotes"] UTF8String];
		}else {
			sqlStatement=[[NSString stringWithFormat:@"SELECT audioFile FROM m_FlashCardVoiceNotes where fk_FlashCardId=%d",cardId] UTF8String];
		}

		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				NSString* file=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				[files addObject:file];
			}
		}
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	return files;
}



- (BOOL) isCommentOrNotesAvailable:(NSInteger) flashCardId{

	sqlite3 *database;
	
	NSUInteger cardCount = 0;
	NSString* query1 =[NSString stringWithFormat:@"select count(*) from m_FlashCardVoiceNotes where fk_FlashCardId = %d", flashCardId];
	NSString* query2 =[NSString stringWithFormat:@"select count(*) from m_FlashCardComments where fk_FlashCardId = %d", flashCardId];
	
	// Open the database from the users filessytem
	if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK)
	{
		const char *sqlStatement = [query1 UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				cardCount = sqlite3_column_int(compiledStatement, 0);
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
		if (cardCount==0) {
			sqlStatement = [query2 UTF8String];
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
			{
				// Loop through the results and add them to the feeds array
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
				{
					cardCount = sqlite3_column_int(compiledStatement, 0);
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
		}
	}
	sqlite3_close(database);
	
	if(cardCount>0){
		return NO;
	}
	else {
		return YES;
	}
}

@end
