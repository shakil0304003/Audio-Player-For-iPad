

#import "AudioPlayer.h"

@implementation AudioPlayer

//Width 581 Height 310
#pragma mark Main
- (void)baseInit {
    _width = [[NSNumber alloc]initWithFloat: self.frame.size.width];
    _height = [[NSNumber alloc]initWithFloat: self.frame.size.height];

    //UIImage *newImage = [UIImage imageNamed:@"audio_background"];
    _backgroundImage = [[UIImageView alloc] init];
    _backgroundImage.backgroundColor = [UIColor grayColor];
    [_backgroundImage setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_backgroundImage];
    
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
    _titleLabel.text = @"";
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFrame:CGRectMake(240, 60, self.frame.size.width - 265, 50)];
    [self addSubview:_titleLabel];
    
    _subTitleTextView = [[UITextView alloc] init];
    _subTitleTextView.text = @"";
    [_subTitleTextView setBackgroundColor:[UIColor clearColor]];
    _subTitleTextView.editable = FALSE;
    [_subTitleTextView setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    [_subTitleTextView setFrame:CGRectMake(240, 100, self.frame.size.width - 265, 100)];
    [self addSubview:_subTitleTextView];    
    
    _btnGo = [[UIButton alloc] init];
    [_btnGo setBackgroundColor:[UIColor clearColor]];
    UIImage *newImage2 = [UIImage imageNamed:@"green_play"];
    [_btnGo setImage:newImage2 forState:UIControlStateNormal];
    [_btnGo setImage:newImage2 forState:UIControlStateHighlighted];
    [_btnGo setImage:newImage2 forState:UIControlStateSelected];
    [_btnGo setFrame:CGRectMake(25, 35, 170, 170)];
    [_btnGo addTarget:self action:@selector(BtnGoClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnGo.hidden = TRUE;
    [self addSubview:_btnGo]; 
    
    _currentTimeLabel = [[UILabel alloc] init];
    [_currentTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [_currentTimeLabel setTextColor:[UIColor whiteColor]];
    _currentTimeLabel.text = @"00:00";
    [_currentTimeLabel setBackgroundColor:[UIColor clearColor]];
    [_currentTimeLabel setFrame:CGRectMake(40, 225, 60, 50)];
    [self addSubview:_currentTimeLabel];
    
    _totalTimeLabel = [[UILabel alloc] init];
    [_totalTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [_totalTimeLabel setTextColor:[UIColor whiteColor]];
    _totalTimeLabel.text = @"00:00";
    [_totalTimeLabel setBackgroundColor:[UIColor clearColor]];
    [_totalTimeLabel setFrame:CGRectMake(490, 225, 60, 50)];
    [self addSubview:_totalTimeLabel];
    
    _progressBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_long_bar"]];
    [_progressBarImage setFrame:CGRectMake(110, 240, 365, 24)];
    [self addSubview:_progressBarImage];
    
    _isPlaying = FALSE;
    _barImages = [[NSMutableArray alloc] init];
    int currentX = 110;
    
    for (int i=0; i<51; i++) {
        if(i==0)
        {
            UIImage *tempImage = [UIImage imageNamed:@"green_left"];  
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:tempImage];
            [tempImageView setFrame:CGRectMake(currentX, 240, 11, 24)];
            tempImageView.hidden = TRUE;
            [self addSubview:tempImageView];
            [_barImages addObject:tempImageView];
            currentX+=11;
            tempImage = nil;
        }
        else if(i==50)
        {
            UIImage *tempImage = [UIImage imageNamed:@"green_right"];  
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:tempImage];
            [tempImageView setFrame:CGRectMake(currentX, 240, 11, 24)];
            tempImageView.hidden = TRUE;
            [self addSubview:tempImageView];
            [_barImages addObject:tempImageView];
            currentX+=11;
            tempImage = nil;
        }
        else
        {
            UIImage *tempImage = [UIImage imageNamed:@"green_repeated"];  
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:tempImage];
            [tempImageView setFrame:CGRectMake(currentX, 240, 7, 24)];
            tempImageView.hidden = TRUE;
            [self addSubview:tempImageView];
            [_barImages addObject:tempImageView];
            currentX+=7;
            tempImage = nil;
        }
    }
    
    _tuneStartX = 110;
    _tuneEndX = 433;
    UIImage *newImage3 = [UIImage imageNamed:@"tune"]; 
    _tuneImage = [[UIImageView alloc] initWithImage:newImage3];
    [_tuneImage setFrame:CGRectMake(_tuneStartX, 230, 42, 43)];
    [self addSubview:_tuneImage];
    
    _userIsScrubbing = NO;
    _progressBarClick = NO;
    
    //newImage = nil;
    newImage2 = nil;
    newImage3 = nil;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];        
    }
    return self;
}

- (void)dealloc {
    
    _width = nil;
    _height = nil;
    _titleLabel = nil;
    _subTitleTextView = nil;
    _backgroundImage = nil;
    _btnGo = nil;
    _currentTimeLabel = nil;
    _totalTimeLabel = nil;
    _progressBarImage = nil;
    _barImages = nil;
    _tuneImage = nil;
    _audioUrl = nil;
    _player = nil;
	_playbackTimer = nil;
    
    //[super dealloc];
}

#pragma mark Refresh + ReLayout

- (void)layoutSubviews {
    [super layoutSubviews];        
}

#pragma mark Setting Properties
-(void)SetTitle:(NSString *)title
{
    [_titleLabel setText:title];
}

-(void)SetSubTitle:(NSString *)subTitle
{
    [_subTitleTextView setText:subTitle];
}

-(void)AudioUrl:(NSString *)url Title:(NSString *)title SubTitle:(NSString *)subTitle
{
    _audioUrl = url;
    
    if(title != Nil)
        [_titleLabel setText:title];
    
    if(subTitle != Nil)
        [_subTitleTextView setText:subTitle];
    
    _btnGo.hidden = TRUE;
    [_tuneImage setFrame:CGRectMake(_tuneStartX, 230, 42, 43)];
    
    for (int i=0; i<51; i++) {
        UIImageView *imageView = [_barImages objectAtIndex:i];
        imageView.hidden = TRUE;
    }
    
    UIImage *newImage = [UIImage imageNamed:@"green_play"];
    [_btnGo setImage:newImage forState:UIControlStateNormal];
    [_btnGo setImage:newImage forState:UIControlStateHighlighted];
    [_btnGo setImage:newImage forState:UIControlStateSelected];
    
    [self  setUpAVPlayerForURL:[NSURL URLWithString:_audioUrl]];
}

-(void)Play
{
    UIImage *newImage = [UIImage imageNamed:@"green_pause"];
    [_btnGo setImage:newImage forState:UIControlStateNormal];
    [_btnGo setImage:newImage forState:UIControlStateHighlighted];
    [_btnGo setImage:newImage forState:UIControlStateSelected];
    _isPlaying = TRUE;
    
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    
    [_player play];
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    if (newTaskId != UIBackgroundTaskInvalid && bgTaskId != UIBackgroundTaskInvalid)
        [[UIApplication sharedApplication] endBackgroundTask: bgTaskId];
    
    bgTaskId = newTaskId;
    
    newImage = nil;
}

-(void)Pause
{
    UIImage *newImage = [UIImage imageNamed:@"green_play"];
    [_btnGo setImage:newImage forState:UIControlStateNormal];
    [_btnGo setImage:newImage forState:UIControlStateHighlighted];
    [_btnGo setImage:newImage forState:UIControlStateSelected];
    [_player pause];
    _isPlaying = FALSE;
    newImage = nil;
}

-(IBAction)BtnGoClick:(id)sender
{
    if(_isPlaying == FALSE)
    {
        [self Play];
    }
    else
    {
        [self Pause];
    }
}

-(void) createPlaybackTimer {
	if (_playbackTimer) {
		[_playbackTimer invalidate];
	}
	_playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
													  target:self
													selector:@selector(playerTimerUpdate:)
													userInfo:nil
													 repeats:YES];
}

-(void) setUpAVPlayerForURL: (NSURL*) url {
	_player = [[AVPlayer alloc] initWithURL: url];
	if (_player) {
        [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
		[self performSelectorOnMainThread:@selector (createPlaybackTimer)
							   withObject:nil
							waitUntilDone:YES];
	}
}

//Used to detect when the player is ready so it can enable the button. This lets the player load before you can play...
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _player && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerStatusReadyToPlay) {
            _btnGo.hidden = NO;
        }
    }
}

-(void) playerTimerUpdate: (NSTimer*) timer {
    if(_isPlaying)
    {
	// playback time label
	CMTime currentTime = _player.currentTime;
	UInt64 currentTimeSec = currentTime.value / currentTime.timescale;
	UInt32 minutes = currentTimeSec / 60;
	UInt32 seconds = currentTimeSec % 60;
    _currentTimeLabel.text = [NSString stringWithFormat: @"%02d:%02d", minutes, seconds];
    
    // playback slider
	if (_player) {
		CMTime endTime = CMTimeConvertScale (_player.currentItem.asset.duration,
											 currentTime.timescale,
											 kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        
        
        
        
        //duation
        UInt64 dcurrentTimeSec = endTime.value / endTime.timescale;
        UInt32 dminutes = dcurrentTimeSec / 60;
        UInt32 dseconds = dcurrentTimeSec % 60;
        
        //durationLabel.text = [NSString stringWithFormat: @"%02d:%02d", dminutes, dseconds];
        if (dminutes < 125) {
            _totalTimeLabel.text = [NSString stringWithFormat: @"%02d:%02d", dminutes, dseconds];
        } else {
            _totalTimeLabel.text = @"00:00";
        }
        
        
        
        //		NSLog (@"currentTime.value = %lld, endTime.value = %lld",
        //			   currentTime.value, endTime.value);
		if (endTime.value != 0) {
			// float slideTime = currentTime.value / endTime.value; // assuming scales are the same
			double tuneX = (((double) currentTime.value / (double) endTime.value)*(double)(_tuneEndX + 21 - _tuneStartX)) + (double)_tuneStartX;
            
            for (int i=0; i<51; i++) {
                UIImageView *imageView = [_barImages objectAtIndex:i];
                
                if(imageView.frame.origin.x + imageView.frame.size.width <=tuneX)
                {
                    imageView.hidden = FALSE;
                }
                else
                    imageView.hidden = TRUE;
                
                imageView = nil;
            }
            
            if(!_userIsScrubbing)
            {
                tuneX -= (double)21;
            
                if(tuneX<_tuneStartX)
                    tuneX = _tuneStartX;
                if(tuneX>_tuneEndX)
                    tuneX = _tuneEndX;
                
                [_tuneImage setFrame:CGRectMake(tuneX, 230, 42, 43)];
            }
            //			NSLog (@"played %f", slideTime);
			//playbackSlider.value = slideTime;
		}
	}
    }
}

#pragma mark Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if(touchLocation.x>=_tuneImage.frame.origin.x && touchLocation.x <= _tuneImage.frame.origin.x + _tuneImage.frame.size.width
       && touchLocation.y>=_tuneImage.frame.origin.y && touchLocation.y <= _tuneImage.frame.origin.y + _tuneImage.frame.size.height)
    {
        _offsetX = touchLocation.x - _tuneImage.frame.origin.x;
        _userIsScrubbing = TRUE;
    }
    else if(touchLocation.x >= _progressBarImage.frame.origin.x && touchLocation.x <= _progressBarImage.frame.origin.x + _progressBarImage.frame.size.width
            && touchLocation.y >= _progressBarImage.frame.origin.y && touchLocation.y <= _progressBarImage.frame.origin.y + _progressBarImage.frame.size.height)
    {
        _progressBarClick = TRUE;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if(_userIsScrubbing)
    {
        CGFloat currentX = touchLocation.x - _offsetX;
        
        if(currentX<_tuneStartX)
            currentX = _tuneStartX;
        if(currentX>_tuneEndX)
            currentX = _tuneEndX;
        
        [_tuneImage setFrame:CGRectMake(currentX, 230, 42, 43)];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        if(_userIsScrubbing==TRUE)
        {
            [_player pause];
            
            CMTime seekTime = _player.currentItem.asset.duration;
            
            CGFloat currentX = ((_tuneImage.frame.origin.x + _offsetX) - (CGFloat)_tuneStartX);
            currentX = (currentX/(CGFloat)(_tuneEndX - _tuneStartX + 21));
            seekTime.value = seekTime.value * currentX;
            seekTime = CMTimeConvertScale (seekTime, _player.currentTime.timescale,
                                           kCMTimeRoundingMethod_RoundHalfAwayFromZero);
            [_player seekToTime:seekTime];
            
            [self Play];
            
            _userIsScrubbing = FALSE;
        }
        else if(_progressBarClick == TRUE)
        {
            UITouch *touch = [touches anyObject];
            CGPoint touchLocation = [touch locationInView:self];
            
            if(touchLocation.x >= _progressBarImage.frame.origin.x && touchLocation.x <= _progressBarImage.frame.origin.x + _progressBarImage.frame.size.width
                    && touchLocation.y >= _progressBarImage.frame.origin.y && touchLocation.y <= _progressBarImage.frame.origin.y + _progressBarImage.frame.size.height)
            {
                CMTime seekTime = _player.currentItem.asset.duration;
                
                CGFloat currentX = (touchLocation.x - (CGFloat)_tuneStartX);
                currentX = (currentX/(CGFloat)(_tuneEndX - _tuneStartX + 21));
                seekTime.value = seekTime.value * currentX;
                seekTime = CMTimeConvertScale (seekTime, _player.currentTime.timescale,
                                               kCMTimeRoundingMethod_RoundHalfAwayFromZero);
                [_player seekToTime:seekTime];
                
                [self Play];
            }
            
            _progressBarClick = FALSE;
        }
   }

@end
