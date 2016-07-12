//
//  Recording.h
//  Audio Recording
//
//  Created by Annabelle on 7/6/16.
//  Copyright © 2016 Annabelle Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Recording : NSObject <NSCoding>
@property (strong, nonatomic) NSDate* date;
//always save in ~/Documents/yyyymmddhhmmss
//don’t need to synthesize the read only property
@ property (readonly, nonatomic) NSString* path;
@ property (readonly, nonatomic) NSURL* url;
//@property () NSString* name; → look up the NSDate formatter to generate the name to be reader friendly

//@property (strong, nonatomic) AVAudioPlayer* player;
//@property (strong, nonatomic) AVPlayer* aPlayer;


-(Recording*) initWithDate: (NSDate*) aDate;
//interface class method
//+(Recording*) sharedRecordingInstance;

//-(void*) play: (Recording*) aRecording;

@end
