//
//  Utils.h
//  FlashCardDB
//
//  Created by Friends on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"



@interface Utils : NSObject 
{
	
}

+ (NSString*) getFileName:(NSString*) audioFile;
+ (UIColor*) colorFromString: (NSString*) colorStr;
+ (NSString *) getEncodedText:(NSString *) strText;
+ (NSString *) getJSCode;
+ (NSString *) getValueForVar:(NSString *) strVar;
+ (void) randomizeArray:(NSMutableArray *) arrValues;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end

@interface UINavigationBar (CustomNavigationBar)


@end

@interface ColorNavigationBar : UINavigationBar
{
}

@end

@interface ColorInfoNavigationBar : UINavigationBar
{
}


@end

@interface CustomToolBar : UIToolbar{
}


@end
@interface CustomDeckToolBar : UIToolbar
{
}


@end


