//
//  TableViewController123.h
//  Audio Recording
//
//  Created by Annabelle on 7/8/16.
//  Copyright © 2016 Annabelle Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
#import <AVFoundation/AVFoundation.h>


@interface TableViewController123 : UITableViewController <AVAudioPlayerDelegate>
@property NSMutableArray* anotherList;
@property (strong, nonatomic) AVAudioPlayer* player;
//@property (strong, nonatomic) AVPlayer* aPlayer;



@end
