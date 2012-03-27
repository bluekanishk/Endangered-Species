//
//  CommentsViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashCard.h"
#import "CardComment.h"
#import "CardDetails.h"

@interface CommentsViewController : UIViewController {
	NSInteger flashCardId;
	CardComment* comment;
	IBOutlet UITextView* textView;
	IBOutlet UIBarButtonItem *editButton;
	
	CardDetails* _parent;
}

@property(nonatomic, retain) UITextView* textView;
@property(nonatomic) NSInteger flashCardId;
@property(nonatomic, retain) CardComment* comment;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *editButton;


-(void) setFlashCardId:(NSInteger)cardId;
-(void) setParent:(CardDetails*)parent;

-(IBAction) editComments;
-(IBAction) closeComments;

@end
