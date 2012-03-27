//
//  HTMLDisplayController.h
//  TigerTesterUni
//
//  Created by Abhinav Kumar on 2/24/12.
//  Copyright 2012 Spearhead Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTMLDisplayController : UIViewController<UIWebViewDelegate> {

}
@property(nonatomic,retain)IBOutlet UIWebView* wvContainer;
@property(nonatomic,retain)IBOutlet UINavigationBar* nbTopBar;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView* aiLoading;
-(IBAction)popView;
-(void) setPageContent:(NSString *)strURL withTitle:(NSString *)strTitle;
@end
