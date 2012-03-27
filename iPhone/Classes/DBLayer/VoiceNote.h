//
//  VoiceNote.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VoiceNote : NSObject {
	NSInteger flashCardId;
	NSInteger voiceNoteId;
	NSString* title;
	NSURL* recordedFileURL;
}

@property (nonatomic) NSInteger flashCardId;
@property (nonatomic) NSInteger voiceNoteId;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSURL* recordedFileURL;

@end
