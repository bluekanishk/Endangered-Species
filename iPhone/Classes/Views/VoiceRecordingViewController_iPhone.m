    //
//  VoiceRecordingViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 21/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "VoiceRecordingViewController_iPhone.h"
#import "VoiceNote.h"
#import "AppDelegate_iPhone.h"
#import "DBAccess.h"


@implementation VoiceRecordingViewController_iPhone


@synthesize recordingName;
@synthesize activityIndicator;
@synthesize recordingMsg;
@synthesize recordingButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	recordingMsg.hidden=YES;
	activityIndicator.hidden=YES;
	
	//Instanciate an instance of the AVAudioSession object.
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	
	//Activate the session
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
	[audioSession setActive:YES error: &error];
}

-(void) setParentController:(VoiceNotesViewController_iPhone*)parent{
	_parentController=parent;
}

-(IBAction) hideKeypad:(id)sender{
	[recordingName resignFirstResponder];
}

-(IBAction) startRecording:(id)sender{
	
	if ([[recordingButton currentTitle] isEqualToString:@"Start Recording"]) {
		
		if ([[recordingName text] isEqualToString:@""]) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter voice note title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		
		//[recordingButton setImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
		[recordingButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
		recordingMsg.hidden=NO;
		activityIndicator.hidden=NO;
		[activityIndicator startAnimating];
		
		
		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
		[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
		
		recordedFileName=[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		recordedTmpFile = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:recordedFileName]];
		recorder = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
		[recorder setDelegate:self];
		[recorder prepareToRecord];
		
		//Start the actual Recording
		[recorder record];
		
		
	}else if ([[recordingButton currentTitle] isEqualToString:@"Stop Recording"]) {
		
		//[recordingButton setImage:[UIImage imageNamed:@"btn_bg_blue.png"] forState:UIControlStateNormal];
		[recordingButton setTitle:@"Done" forState:UIControlStateNormal];
		recordingMsg.hidden=YES;
		activityIndicator.hidden=YES;
		[activityIndicator stopAnimating];
		
		//Start the actual Recording
		[recorder stop];
		
		// Create Voice Note
		VoiceNote* note=[[VoiceNote alloc] init];
		note.title=[recordingName text];
		note.recordedFileURL=recordedTmpFile;
		note.flashCardId=flashCardId;
		
		// Insert in the database.
		DBAccess* db=[AppDelegate_iPhone getDBAccess];
		[db addVoiceNote:note];
	
	}else if ([[recordingButton currentTitle] isEqualToString:@"Done"]) {
		[self goBack:self];
	}
}

-(IBAction) goBack:(id)sender{
	
	if ([recorder isRecording]) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Recording is running, Do you want to cancel it?" 
													   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
		[alert show];
		[alert release];
	}else {
		[self dismissModalViewControllerAnimated:YES];
		[_parentController fetchVoiceNotes];
	}

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1){
		[recorder stop];
		NSFileManager * fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[recordedTmpFile path] error:&error];
	
		[self dismissModalViewControllerAnimated:YES];
		[_parentController fetchVoiceNotes];
	}
}


-(void) setFlashCardId:(NSInteger)cardId{
	flashCardId=cardId;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
