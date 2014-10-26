//
//  FiltersViewController.h
//  Yelp
//
//  Created by Ali YAZDAN PANAH on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FiltersDelegate <NSObject>
- (NSDictionary*) filters;
- (void)invokeFilter:(NSDictionary*)filters;
- (void)cancelFilter;
@end

@interface FiltersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) id<FiltersDelegate> delegate;
@end

