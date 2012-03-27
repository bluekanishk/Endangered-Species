//
//  TapDetectingWindow.h
//  AandP_PlusIPad
//
//  Created by Chandan Kumar on 11/09/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol TapDetectingWindowDelegate
- (void)userDidTapWebView:(id)tapPoint;
@end
@interface TapDetectingWindow : UIWindow {
    UIView *viewToObserve;
    id <TapDetectingWindowDelegate> controllerThatObserves;
}
@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <TapDetectingWindowDelegate> controllerThatObserves;


@end
