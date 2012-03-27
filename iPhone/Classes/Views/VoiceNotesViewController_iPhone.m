//
//  VoiceNotesViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "VoiceNotesViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "VoiceRecordingViewController_iPhone.h"
#import "DBAccess.h"


@implementation VoiceNotesViewController_iPhone

@synthesize _tableView;
@synthesize voiceNotes;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	voiceNotes=[db getCardVoiceNotes:flashCardId];
	
}

-(void) setFlashCardId:(NSInteger)cardId{
	flashCardId=cardId;
}

-(void) setParent:(CardDetails_iPhone*)parent{
	_parent=parent;
}

-(void) fetchVoiceNotes{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	voiceNotes=[db getCardVoiceNotes:flashCardId];
	[_tableView reloadData];
}

-(IBAction) addNewNote{
	VoiceRecordingViewController_iPhone* viewController = [[VoiceRecordingViewController_iPhone alloc] initWithNibName:@"VoiceRecordingView_iPhone" bundle:nil];
	[viewController setFlashCardId:flashCardId];
	[viewController setParentController:self];
	[self presentModalViewController:viewController animated:YES];
	[viewController release];
}


-(IBAction) closeNotes{
	// Stop if playing....
	if (avPlayer!=nil && [avPlayer isPlaying]) {
		[avPlayer stop];
	}
	
	[self dismissModalViewControllerAnimated:YES];
	[_parent updateNavBar];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [voiceNotes count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{    
	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		VoiceNote* note=(VoiceNote*)[voiceNotes objectAtIndex:indexPath.row];
		DBAccess*db=[AppDelegate_iPhone getDBAccess];
		BOOL result=[db deleteVoiceNote:note.voiceNoteId];
		
		if (result==YES) {
			[voiceNotes removeObjectAtIndex:indexPath.row];
			[_tableView reloadData];
		}		
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		
		/*cell.backgroundView  = [[[UIImageView alloc] 
		 initWithImage:[UIImage imageNamed:@"all_cards_bg.png"]] autorelease];*/
		
		UIImage* myImage=[UIImage imageNamed:@"yel_arw.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];
	}
	
	
	
	NSString *cellValue = [[voiceNotes objectAtIndex:indexPath.row] title];
	cell.textLabel.text = cellValue;
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Stop if playing....
	if (avPlayer!=nil && [avPlayer isPlaying]) {
		[avPlayer stop];
	}
	
	// Play the note
	VoiceNote* note=[voiceNotes objectAtIndex:indexPath.row];
	NSString* msg=[NSString stringWithFormat:@"Playing...%@",note.title];
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"Voice Note" message:msg delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	alertView.tag=1;
	[alertView show];
	[alertView release];
	
	avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:note.recordedFileURL error:&error];
	[avPlayer prepareToPlay];
	[avPlayer play];
	
}

// Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
	// Stop if playing....
	if (avPlayer!=nil && [avPlayer isPlaying]) {
		[avPlayer stop];
		[avPlayer dealloc];
	}
	
}

- (void)dealloc {
	[_tableView release];
	[voiceNotes release];
	[super dealloc];
}


@end
