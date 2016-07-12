//
//  ViewController.h
//  Audio Recording
//
//  Created by Annabelle on 7/6/16.
//  Copyright © 2016 Annabelle Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController<AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) Recording* currentRecording; //this one could be nil, as when you are not recording, it does not exist.
@property (strong, nonatomic) NSMutableArray* listOfRecordings; //this one never should be nil: even if there is no recording in the list, the list still exist   //need to allocate the memory before startbutton pressed
@property (strong, nonatomic)AVAudioRecorder* recorder;
@property (strong, nonatomic) NSTimer* timer;


- (IBAction)startButton:(id)sender;

- (IBAction)stopButton:(id)sender;

@end

