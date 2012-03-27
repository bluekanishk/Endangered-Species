//
//  CardWrapper.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 18/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CardWrapper : NSObject {
	NSString* cardName;
	NSInteger flashCardId;
}

@property(nonatomic,retain) NSString* cardName;
@property(nonatomic) NSInteger flashCardId;

@end
