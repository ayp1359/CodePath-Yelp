//
//  Categories.h
//  Yelp
//
//  Created by Ali YAZDAN PANAH on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject
- (void) selectCategoryAtIndex:(NSInteger)index selected:(BOOL)selected;
- (BOOL) isCategorySelectedAtIndex:(NSInteger)index;
- (id) initWithParams: (NSString*) param;
- (NSString*) getParams;
- (NSInteger) getCount;
- (NSString*) categoryAtIndex:(NSInteger)index;
@end
