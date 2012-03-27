//
//  LaunchView.h
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LaunchView_iPhone : UIViewController<AVAudioPlayerDelegate>
{
	IBOutlet UIButton* _imgButton;
	AVAudioPlayer*		avStartSoundPlayer; 
}

- (IBAction)openHomeView;
@end
