//
//  FiltersViewController.m
//  Yelp
//
//  Created by Ali YAZDAN PANAH on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "Categories.h"
#import "DynamicCell.h"
#import "SwitchingCell.h"

@interface FiltersViewController ()

//Type def for sections
typedef NS_ENUM(NSInteger, sections) {
  sortBySection,
  distanceSection,
  otherSection,
  categorySection
};


//Check to see if the sections are open or not
@property (assign, nonatomic) BOOL isSortByOpen;
@property (assign, nonatomic) BOOL isDistanceOpen;
@property (assign, nonatomic) BOOL isCategoriesOpen;
//Track number of categories that are open
@property (assign, nonatomic) NSInteger const categoriesCountOpen;
//Track selected items from sections
@property (assign, nonatomic) NSInteger selectedSortByIndex;
@property (assign, nonatomic) NSInteger selectedDistanceIndex;
//Items in each section
@property (strong, nonatomic) NSArray const* sortByItems;
@property (strong, nonatomic) NSArray const* distanceItems;
@property (strong, nonatomic) NSArray const* switchItems;
//Misc objects here
@property (strong, nonatomic) Categories const* categories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary* filters;
@property (strong, nonatomic) NSArray const* sections;
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.categories = [[Categories alloc] init];
    self.filters = [[NSMutableDictionary alloc] init];
    self.sections = @[@"Sort by", @"Distance", @"Most Popular", @"Category"];
    self.sortByItems =  @[@"Best matched", @"Distance", @"Highest Rated"];
    self.distanceItems = @[@[@0,@"Auto"], @[@1.0,@"1 mile"], @[@5.0,@"5 miles"], @[@20.0,@"20 miles"]];
    self.switchItems = @[@[@"deals_filter",@"Offering a Deal"]];
    self.categoriesCountOpen = 5;
    self.selectedSortByIndex = 0;
    self.selectedDistanceIndex = 0;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  //Add nav buttons
  UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(cancelFilter)];
  UIBarButtonItem *searchButton= [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(confirmFilter)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = searchButton;
  
  //Setup tableview
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  UINib *switchingCellNib = [UINib nibWithNibName:@"SwitchingCell" bundle:nil];
  [self.tableView registerNib:switchingCellNib forCellReuseIdentifier:@"SwitchingCell"];
  
  UINib *dynamicCellNib = [UINib nibWithNibName:@"DynamicCell" bundle:nil];
  [self.tableView registerNib:dynamicCellNib forCellReuseIdentifier:@"DynamicCell"];
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainTableViewCell"];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"seeAllCategoriesCell"];
  
}

- (void) setDelegate:(id<FiltersDelegate>)delegate
{
  _delegate = delegate;
  [self.filters removeAllObjects];
  
  [self changeDictionaryValue:self.filters key:@"term" value:delegate.filters[@"term"]];
  [self changeDictionaryValue:self.filters key:@"location" value:delegate.filters[@"location"]];
  [self changeDictionaryValue:self.filters key:@"radius_filter" value:delegate.filters[@"radius_filter"]];
  [self changeDictionaryValue:self.filters key:@"sort" value:delegate.filters[@"sort"]];
  [self changeDictionaryValue:self.filters key:@"deals_filter" value:delegate.filters[@"deals_filter"]];
  
  self.selectedSortByIndex = [self.filters[@"sort"] integerValue];
  self.selectedDistanceIndex = 0;
  
  for (int k = 1; k < self.distanceItems.count; ++k) {
    if (self.filters[@"radius_filter"] && [self.distanceItems[k][0] isEqualToNumber:self.filters[@"radius_filter"]]) {
      self.selectedDistanceIndex = k;
    }
  }
  
  if (delegate.filters[@"category_filter"]) {
    self.categories = [[Categories alloc] initWithParams:delegate.filters[@"category_filter"]];
  }
  
}

- (void)changeDictionaryValue:(NSMutableDictionary*)dict key:(id)key value:(id)value
{
  if (value) {
    dict[key] = value;
  } else {
    [dict removeObjectForKey:key];
  }
}

- (void)didToggleSwitch:(UISwitch*)sender
{
  NSString* filterKey = self.switchItems[sender.tag][0];
  if (sender.on) {
    self.filters[filterKey] = @YES;
  } else {
    [self.filters removeObjectForKey:filterKey];
  }
}

- (void)cancelFilter
{
  [self.delegate cancelFilter];
}

- (void) confirmFilter
{
  self.filters[@"category_filter"] = self.categories.getParams;
  [self.delegate invokeFilter:self.filters];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return self.sections[section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case sortBySection:
      return self.isSortByOpen ? self.sortByItems.count : 1;
    case distanceSection:
      return self.isDistanceOpen ? self.distanceItems.count : 1;
    case otherSection:
      return self.switchItems.count;
    case categorySection:
      return self.isCategoriesOpen ? [self.categories getCount] : self.categoriesCountOpen + 1;
    default:
      return 0;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case sortBySection: {
      self.isSortByOpen = !self.isSortByOpen;
      [self.tableView beginUpdates];
      [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      
      if (self.isSortByOpen) {
        [self.tableView insertRowsAtIndexPaths:[self changedIndexPathsForSection:indexPath.section
                                                                        startRow:0
                                                                          endRow:self.sortByItems.count
                                                                         exclude:self.selectedSortByIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
      } else {
        self.selectedSortByIndex = indexPath.row;
        self.filters[@"sort"] = [NSNumber numberWithInteger:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[self changedIndexPathsForSection:indexPath.section
                                                                        startRow:0
                                                                          endRow:self.sortByItems.count
                                                                         exclude:indexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      [self.tableView endUpdates];
      break;
    }
      
    case distanceSection: {
      self.isDistanceOpen = !self.isDistanceOpen;
      [self.tableView beginUpdates];
      
      [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      if (self.isDistanceOpen) {
        
        [self.tableView insertRowsAtIndexPaths:[self changedIndexPathsForSection:indexPath.section
                                                                        startRow:0
                                                                          endRow:self.distanceItems.count
                                                                         exclude:self.selectedDistanceIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
      } else {
        self.selectedDistanceIndex = indexPath.row;
        
        [self.filters removeObjectForKey:@"radius_filter"];
        if (indexPath.row >= 1) {
          self.filters[@"radius_filter"] = self.distanceItems[indexPath.row][0];
        }
        [self.tableView deleteRowsAtIndexPaths:[self changedIndexPathsForSection:indexPath.section
                                                                        startRow:0
                                                                          endRow:self.distanceItems.count
                                                                         exclude:indexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      [self.tableView endUpdates];
      break;
    }
      
    case categorySection: {
      if (!self.isCategoriesOpen && indexPath.row == self.categoriesCountOpen) {
        self.isCategoriesOpen = !self.isCategoriesOpen;
      } else {
        if ([self.categories isCategorySelectedAtIndex:indexPath.row]) {
          [self.categories selectCategoryAtIndex:indexPath.row selected:NO];
        } else {
          [self.categories selectCategoryAtIndex:indexPath.row selected:YES];
        }
      }
      [self.tableView reloadData];
      break;
    }
  }
}

- (NSArray*) changedIndexPathsForSection:(NSInteger)section startRow:(NSInteger)start endRow:(NSInteger)end exclude:(NSInteger)exclude
{
  NSMutableArray* tempArray = [[NSMutableArray alloc] init];
  for (int row = start; row < end; ++row) {
    if (row != exclude) {
      NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:section];
      [tempArray addObject:path];
    }
  }
  return tempArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case sortBySection: {
      if (self.isSortByOpen) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"];
        cell.textLabel.text = self.sortByItems[indexPath.row];
        if (self.selectedSortByIndex == indexPath.row) {
          cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
      } else {
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
        cell.textLabel.text = self.sortByItems[self.selectedSortByIndex];
        return cell;
      }
    }
    case distanceSection: {
      if (self.isDistanceOpen) {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"];
        cell.textLabel.text = self.distanceItems[indexPath.row][1];
        if (self.selectedDistanceIndex == indexPath.row) {
          cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
      } else {
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
        cell.textLabel.text = self.distanceItems[self.selectedDistanceIndex][1];
        return cell;
      }
    }
    case otherSection: {
      SwitchingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchingCell"];
      cell.textLabel.text = self.switchItems[indexPath.row][1];
      NSString* filterKey = self.switchItems[indexPath.row][0];
      if (self.filters[filterKey]) {
        cell.switchSwitch.on = YES;
      } else {
        cell.switchSwitch.on = NO;
      }
      cell.switchSwitch.tag = indexPath.row;
      [cell.switchSwitch removeTarget:self action:@selector(didToggleSwitch:) forControlEvents:UIControlEventValueChanged];
      [cell.switchSwitch addTarget:self action:@selector(didToggleSwitch:) forControlEvents:UIControlEventValueChanged];
      return cell;
    }
    case categorySection: {
      if (!self.isCategoriesOpen && indexPath.row == self.categoriesCountOpen) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seeAllCategoriesCell"];
        cell.textLabel.text = @"See All";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        return cell;
      } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"];
        cell.textLabel.text = [self.categories categoryAtIndex:indexPath.row];
        
        if ([self.categories isCategorySelectedAtIndex:indexPath.row]) {
          cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
      }
    }
  }
  return [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


@end
