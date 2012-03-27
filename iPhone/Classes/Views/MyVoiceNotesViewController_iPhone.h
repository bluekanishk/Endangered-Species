//
//  MyVoiceNotesViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyVoiceNotesViewController_iPhone : UIViewController<UITableViewDelegate> {

	IBOutlet UITableView* _tableView;
	NSMutableArray* myVoiceNotes;
}

@property (nonatomic,retain) IBOutlet UITableView* _tableView;
@property (nonatomic,retain) NSMutableArray* myVoiceNotes;


- (void)popView;

@end
