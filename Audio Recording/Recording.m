//
//  Recording.m
//  Audio Recording
//
//  Created by Annabelle on 7/6/16.
//  Copyright © 2016 Annabelle Tang. All rights reserved.
//

#import "Recording.h"

@implementation Recording
@synthesize date;
//@synthesize player;
//@synthesize aPlayer;
//@synthesize ListOfRecordings;

//static Recording* record;

/*implement secret person class method
+(Recording*) sharedRecordingInstance
{
  
  //if secretPerson doesn't exist, we need to do something to make it exit *** nil
  if(record == nil){
    record = [[Recording alloc] init];
  }
  //if it exist, return the person
  return record;
}*/

//description is a way to convert to string
-(NSString*) description
{
  return [NSString stringWithFormat:@ "%p %@", self, self.date];
  
}

-(Recording*) initWithDate: (NSDate*) aDate
{
  //initialize our parents
 	self = [super init];
  //check to see whether we exist: check to make sure it is not nil
  if(self){
    self.date = aDate;
  }
  return self;
}


-(NSString*) path
{
  //return your home directory as a NSString
  NSString* home = NSHomeDirectory();
  
  //create the formatter object
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  
  //look up the documentation of NSDateformatter: feed an object, and come out a string
  [formatter  setDateFormat: @"yyyMMddHHmmss"];
  
  //put the date in and return a string
  NSString* dateString = [formatter stringFromDate: self.date];
  return [NSString stringWithFormat: @"%@/Documents/%@.caf", home, dateString];
}

//return a NSURL that describe the path
//use the path to get the url
-(NSURL*) url
{
  //give path to an initializer to get back the url
  return[NSURL URLWithString: self.path ];
  //return [NSURL FileURLWithPath: self.path];
  
  
}

- (Recording*)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if(self){
    self.date = [decoder decodeObjectOfClass: [Recording class] forKey: @"date"];
 
  }
  return self;
  
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject: self.date forKey: @"date"];
 
}




@end
