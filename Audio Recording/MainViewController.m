//
//  ViewController.m
//  Audio Recording
//
//  Created by Annabelle on 7/6/16.
//  Copyright © 2016 Annabelle Tang. All rights reserved.
//

#import "MainViewController.h"
#import "TableViewController123.h"

@interface MainViewController ()
@end


@implementation MainViewController
@synthesize currentRecording;
@synthesize listOfRecordings;
@synthesize timer;


- (void)viewDidLoad {
  [super viewDidLoad];
  self.progressView.progress =0.0;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//we will need to overwrite initWithCoder in our own program
//to read the list, need to be initialize before you start the program
//initWithCoder is the first thing a program does
-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
    //name the archive, give it a path
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/recordingArchive", NSHomeDirectory()];
   
          if([[NSFileManager defaultManager] fileExistsAtPath: archive])
    {
      //if the list exists, pull up the original lists from archive
      self.listOfRecordings = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
      
    }else{
      //if it's your first time using the file, allocate the list
      self.listOfRecordings = [[NSMutableArray alloc] init];
    }

    NSLog(@"archive path %@", [archive description]);
    NSLog(@"contents of listOfRecordings %@",[self.listOfRecordings description]);
  }
  return self;
}



-(void) viewWillAppear:(BOOL)animated
{
  NSLog(@"Archive my list of recordings to a file!!!");
}

//segue the orange to purple
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  TableViewController123* tvc = (TableViewController123*)segue.destinationViewController;
  //send the list from main to table
  tvc.anotherList = self.listOfRecordings;
}

-(void) handleTimer{
  self.progressView.progress += 0.04;
}

/*1.	Make a Recording Object
       a.	Need a pointer in the view controller to point to the r object
 2.	Set currentRecording to new Recording
 3.	Insert currentRecording into recordingList
 4.	Set up recording session
 5.	Set up timer to update progressView to expire the Recording session
 a.	Create a timer that could update the UIProgressView
*/
- (IBAction)startButton:(id)sender
{
   //set up recording environment
  AVAudioSession* audioSession = [AVAudioSession sharedInstance];
  NSError* err = nil;
  [audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
  if(err){
    NSLog(@"audioSession: %@ %ld %@",
          [err domain], [err code], [[err userInfo] description]);
    return;
  }
  err = nil;
  [audioSession setActive:YES error:&err];
  if(err){
    NSLog(@"audioSession: %@ %ld %@",
          [err domain], [err code], [[err userInfo] description]);
    return;
  }
  
  NSMutableDictionary* recordingSettings = [[NSMutableDictionary alloc] init];
  
  [recordingSettings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
  [recordingSettings setValue:@44100.0 forKey:AVSampleRateKey];
  [recordingSettings setValue:@1 forKey:AVNumberOfChannelsKey];
  [recordingSettings setValue:@16 forKey:AVLinearPCMBitDepthKey];
  [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
  [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
  [recordingSettings setValue:@(AVAudioQualityHigh)
                       forKey:AVEncoderAudioQualityKey];
  
 //make a recording object
  NSDate* now = [NSDate date];
  self.currentRecording = [[Recording alloc] initWithDate: now];
  
  //insert currentRecording to list
  [self.listOfRecordings addObject: self.currentRecording];
  
   //set up recording session
  err = nil;
  self.recorder = [[AVAudioRecorder alloc]
                   initWithURL:self.currentRecording.url
                   settings:recordingSettings
                   error:&err];
  
  //check to see whether something went wrong when you try to set up the recorder
  if(!self.recorder){
    NSLog(@"recorder: %@ %ld %@",
          [err domain], [err code], [[err userInfo] description]);
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Warning"
                                message:[err localizedDescription]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}
  
  //prepare to record//
  //self means view controller here
  [self.recorder setDelegate:self];
  [self.recorder prepareToRecord];
  self.recorder.meteringEnabled = YES;
  
  BOOL audioHWAvailable = audioSession.inputAvailable;
  if( !audioHWAvailable ){
    UIAlertController* cantRecordAlert = [UIAlertController
              alertControllerWithTitle:@"Warning"
                               message:@"Audio input hardware not available."
                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    
    [cantRecordAlert addAction:defaultAction];
    [self presentViewController:cantRecordAlert animated:YES completion:nil];
    
    return;
  }
  
  // start recording
  [self.recorder recordForDuration:(NSTimeInterval)5];
  self.statusLabel.text = @"Recording...";
  self.progressView.progress = 0.0;
  self.timer = [NSTimer
                scheduledTimerWithTimeInterval:0.2
                target:self
                selector:@selector(handleTimer)
                userInfo:nil
                repeats:YES];
}


- (IBAction)stopButton:(id)sender
{
  //6.	Turn off the timer for progressView
  //7.	Clean up Recording session
  //8.	Set currentRecorrding to nil
  //9.	Reset progress bar
  
  //[self.recorder stop];
  /*[self.timer invalidate];
  self.statusLabel.text = @"Stopped";
  self.progressView.progress = 1.0;

  if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
    NSLog(@"File exists");
  }else{
    NSLog(@"File does not exist");
  }*/
  
  [self audioRecorderDidFinishRecording:self.recorder successfully:YES];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag
{
  //1.	Turn off the timer for progressView
  //2.	Clean up Recording session
  //3.	Set currendRecording to nil
  //4.	Reset ProgressView for reset progressView
  
  NSLog(@"audioRecorderDidFinishRecording:successfully:");
  //[self.recorder stop];
  
  [timer invalidate];
  self.statusLabel.text = @"Stopped";
  self.progressView.progress = 1.0;

  if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
    NSLog(@"File exists");
  }else{
   
    NSLog(@"File does not exist");
  }
}



-(void) viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:(BOOL) animated];

  //save the file
  NSString* archive = [NSString stringWithFormat:@"%@/Documents/recordingArchive", NSHomeDirectory()];

  NSLog(@"hi%@",[self.listOfRecordings description]);
  [NSKeyedArchiver archiveRootObject: self.listOfRecordings toFile: archive];
}


@end
