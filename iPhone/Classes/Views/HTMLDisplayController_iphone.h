//
//  HTMLDisplayController_iphone.h
//  SaveTheAnimalsUni
//
//  Created by Chandan Kumar on 25/02/12.
//  Copyright 2012 Interglobe Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTMLDisplayController_iphone : UIViewController<UIWebViewDelegate> {

}
@property(nonatomic,retain)IBOutlet UIWebView* wvContainer;
@property(nonatomic,retain)IBOutlet UINavigationBar* nbTopBar;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView* aiLoading;

-(IBAction)popView;
-(void) setPageContent:(NSString *)strURL withTitle:(NSString *)strTitle;
@end
