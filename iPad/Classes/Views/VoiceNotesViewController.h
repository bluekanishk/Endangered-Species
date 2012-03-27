//
//  VoiceNotesViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "VoiceNote.h"
#import "CardDetails.h"


@interface VoiceNotesViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate>{
	IBOutlet UITableView* _tableView;
	NSMutableArray* voiceNotes;
	IBOutlet UIBarButtonItem *addButton;
	NSInteger flashCardId;

	AVAudioPlayer *avPlayer;
	NSError * error;
	
	CardDetails* _parent;
}

@property (nonatomic,retain) IBOutlet UITableView* _tableView;
@property (nonatomic,retain) NSMutableArray* voiceNotes;

-(void) setFlashCardId:(NSInteger)cardId;
-(void) setParent:(CardDetails*)parent;

-(IBAction) addNewNote;
-(IBAction) closeNotes;
-(void) fetchVoiceNotes;

@end
