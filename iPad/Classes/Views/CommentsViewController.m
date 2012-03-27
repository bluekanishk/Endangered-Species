    //
//  CommentsViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "CommentsViewController.h"
#import "DBAccess.h"
#import "AppDelegate_iPad.h"

@implementation CommentsViewController

@synthesize textView;
@synthesize flashCardId;
@synthesize comment;
@synthesize editButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	textView.editable=NO;
	
	// Initialize Comment Object.
	comment=[[CardComment alloc] init];
	
	NSInteger count=[[  AppDelegate_iPad getDBAccess] getCommentsCount:flashCardId];
	if (count==0) {
		comment.commentId=-1;
		comment.cardId=flashCardId;
		comment.comments=@"";
		editButton.title = @"Add";
	}else{
		comment=[[AppDelegate_iPad getDBAccess] getCardComments:flashCardId];
		[textView setText:[comment comments]];
		editButton.title = @"Edit";
	}

}

-(void) setParent:(CardDetails*)parent{
	_parent=parent;
}

-(IBAction) editComments{
	
	if ([editButton.title isEqualToString:@"Add"] || [editButton.title isEqualToString:@"Edit"]) {
		textView.editable=YES;
		editButton.title=@"Done";
		
		[textView becomeFirstResponder];
	
	}else{
		textView.editable=NO;
		editButton.title=@"Edit";
		comment.comments=textView.text;
		[[AppDelegate_iPad getDBAccess] updateComments:comment];
	}
	
}

-(IBAction) closeComments{
	[self.view removeFromSuperview];
	[_parent updateNavBar];
}


-(void) setFlashCardId:(NSInteger)cardId{
	flashCardId=cardId;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];	
}


@end
