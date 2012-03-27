//
//  CommentsViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "CommentsViewController_iPhone.h"
#import "DBAccess.h"
#import "AppDelegate_iPhone.h"

@implementation CommentsViewController_iPhone

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
	
	NSInteger count=[[AppDelegate_iPhone getDBAccess] getCommentsCount:flashCardId];
	if (count==0) {
		comment.commentId=-1;
		comment.cardId=flashCardId;
		comment.comments=@"";
		editButton.title = @"Add";
		
		
	}else{
		comment=[[AppDelegate_iPhone getDBAccess] getCardComments:flashCardId];
		[textView setText:[comment comments]];
		editButton.title = @"Edit";
	}
	
}

-(void) setParent:(CardDetails_iPhone*)parent{
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
		[[AppDelegate_iPhone getDBAccess] updateComments:comment];
	}
	
}

-(IBAction) closeComments{
	[self dismissModalViewControllerAnimated:YES];
	[_parent updateFlashCard];	
	[_parent updateNavBar];
}


-(void) setFlashCardId:(NSInteger)cardId{
	flashCardId=cardId;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	[textView release];
	[comment release];
}


@end
