//
//  Business.m
//  Yelp
//
//  Created by Ali YAZDAN PANAH on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

-(id)initWithDictionary:(NSDictionary*)dictionary{
  self = [super init];
  if (self){
    
    NSArray *categories =  dictionary[@"categories"];
    NSMutableArray *categoryNames = [NSMutableArray array];
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      [categoryNames addObject:obj[0]];
    }];
    NSArray* allAddresses = dictionary[@"location"][@"display_address"];
    NSString* thisAddress = allAddresses[0];
    if ([allAddresses count]>2)
    {
      if(allAddresses[2]){
        thisAddress = [thisAddress stringByAppendingString:@", "];
        thisAddress = [thisAddress stringByAppendingString:allAddresses[2]];
      }
    }
    self.address = thisAddress;
    self.categories = [categoryNames componentsJoinedByString:@", "];
    self.name = dictionary[@"name"];
    self.imageUrl = dictionary[@"image_url"];
    self.numReviews = [dictionary[@"review_count"] integerValue];
    self.ratingImageUrl = dictionary[@"rating_img_url"];
    float milesPerMeter = 0.000621371;
    self.distance = [dictionary[@"distance"] integerValue]*milesPerMeter;
    
  }
  return self;
}


+(NSArray*) businessesWithDictionaries:(NSArray *)dictionaries{
  
  NSMutableArray *businesses = [[NSMutableArray alloc]init];
  
  for (NSDictionary *dictionary in dictionaries){
    Business *business = [[Business alloc]initWithDictionary:dictionary];
    [businesses addObject:business];
  }
  
  return businesses;
}


@end
