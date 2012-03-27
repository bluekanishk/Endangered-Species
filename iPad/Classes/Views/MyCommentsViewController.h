//
//  MyCommentsViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCommentsViewController : UIViewController<UITableViewDelegate> {

	IBOutlet UITableView* _tableView;
	NSMutableArray* myComments;
}

@property (nonatomic,retain) IBOutlet UITableView* _tableView;
@property (nonatomic,retain) NSMutableArray* myComments;


- (void)popView;
- (IBAction) close:(id) sender;

@end
