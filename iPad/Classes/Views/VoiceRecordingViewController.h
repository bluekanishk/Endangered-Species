//
//  VoiceRecordingViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 21/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "VoiceNotesViewController.h"


@interface VoiceRecordingViewController : UIViewController<UITextViewDelegate,UITableViewDelegate, AVAudioRecorderDelegate> {
	
	IBOutlet UITextField* recordingName;
	IBOutlet UIActivityIndicatorView* activityIndicator;
	IBOutlet UILabel* recordingMsg;
	IBOutlet UIButton* recordingButton;
	
	NSInteger flashCardId;
	
	NSURL *recordedTmpFile;
	NSString *recordedFileName;
	
	AVAudioRecorder *recorder;
	NSError * error;
	
	VoiceNotesViewController* _parentController;
	
}

@property(nonatomic,retain)  IBOutlet UITextField* recordingName;
@property(nonatomic,retain)  IBOutlet UIActivityIndicatorView* activityIndicator;
@property(nonatomic,retain)  IBOutlet UILabel* recordingMsg;
@property(nonatomic,retain)  IBOutlet UIButton* recordingButton;


-(IBAction) startRecording:(id)sender;
-(IBAction) goBack:(id)sender;
-(IBAction) hideKeypad:(id)sender;

-(void) setFlashCardId:(NSInteger)cardId;
-(void) setParentController:(VoiceNotesViewController*)parent;

@end
