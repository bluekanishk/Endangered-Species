//
//  CardComment.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CardComment : NSObject {

	NSInteger commentId;
	NSInteger cardId;
	NSString *comments;
}

@property (nonatomic) NSInteger commentId;
@property (nonatomic) NSInteger cardId;
@property (nonatomic,retain) NSString* comments;

@end
