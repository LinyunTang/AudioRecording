//
//  TableViewController123.m
//  Audio Recording
//
//  Created by Annabelle on 7/8/16.
//  Copyright © 2016 Annabelle Tang. All rights reserved.
//

#import "TableViewController123.h"


@interface TableViewController123 ()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@end

@implementation TableViewController123
@synthesize anotherList;
@synthesize player;

//overwrite initWithCoder:
//so that you can do something when you go to the view instantly
-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
   self.anotherList = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  AVAudioSession* audioSession = [AVAudioSession sharedInstance];
  NSError* err = nil;
  [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
  if (err){
    NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
    return;
  }
  err = nil;
  [audioSession setActive:YES error:&err];
  if(err){
    NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
    return;
  }
  NSLog(@"Hello Table View!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) play: (Recording*) aRecording
{
  // NSLog(@"Playing %@", aRecording.name);

  NSAssert([[NSFileManager defaultManager] fileExistsAtPath: aRecording.path], @"Doesn't exist");
  NSError *error;
  //allocate player
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL: aRecording.url error:&error];
  if(error){
    NSLog(@"playing audio: %@ %ld %@", [error domain], [error code], [[error userInfo] description]);
    return;
  }else{
    self.player.delegate = self;
  }
  if([self.player prepareToPlay] == NO){
    NSLog(@"Not prepared to play!");
    return;
  }
  [player play];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


//shows the number of rows of list
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.anotherList count];
}


//insert the text for each textlabel for the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
  Recording* r =[self.anotherList objectAtIndex: indexPath.row];
  
  // Configure the cell...
  cell.textLabel.text = [NSString stringWithFormat:@"%@", r.date];
  return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // play the audio file that maps onto the cell
   Recording* z = [self.anotherList objectAtIndex: indexPath.row];
 
   [self play: z];
  
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
  NSLog(@"finished playing");
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
