

#import <UIKit/UIKit.h>

//-------
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AudioToolbox/AudioToolbox.h>
//-------

@class AudioPlayer;

@interface AudioPlayer : UIView {
    NSNumber *_width;
    NSNumber *_height;
    UILabel *_titleLabel;
    UITextView *_subTitleTextView;
    UIImageView *_backgroundImage;
    UIButton *_btnGo;
    UILabel *_currentTimeLabel;
    UILabel *_totalTimeLabel;
    UIImageView *_progressBarImage;
    BOOL _isPlaying;
    NSMutableArray *_barImages;
    UIImageView *_tuneImage;
    int _tuneStartX;
    int _tuneEndX;
    NSString *_audioUrl;
    AVPlayer *_player;
	NSTimer *_playbackTimer;
    BOOL _userIsScrubbing;
    CGFloat _offsetX;
    BOOL _progressBarClick;
    
    UIBackgroundTaskIdentifier bgTaskId;
}

-(void)SetTitle:(NSString *)title;
-(void)SetSubTitle:(NSString *)subTitle;
-(void)AudioUrl:(NSString *)url Title:(NSString *)title SubTitle:(NSString *)subTitle;
-(IBAction)BtnGoClick:(id)sender;
-(void)setUpAVPlayerForURL: (NSURL*) url;
-(void)Play;
-(void)Pause;

@end