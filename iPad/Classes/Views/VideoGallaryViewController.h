//
//  VideoGallaryViewController.h
//  PhotoGallary
//
//  Created by JAYANT SAXENA on 17/10/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoGallaryViewController : UIViewController
{
	MPMoviePlayerController*				mp;
	NSURL 									*movieURL;
	UIActivityIndicatorView*				_activity;
}

@property (nonatomic, retain) NSURL*	movieURL;
- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;


@end
