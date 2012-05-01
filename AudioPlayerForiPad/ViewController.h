//
//  ViewController.h
//  AudioPlayerForiPad
//
//  Created by USER on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface ViewController : UIViewController {
    AudioPlayer *_audioPlayer;
}

@property (retain) IBOutlet AudioPlayer *audioPlayer;

@end
