//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,FiltersDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic,strong) NSArray *businesses;
@property (nonatomic, strong) NSMutableDictionary *filters;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    self.filters = [[NSMutableDictionary alloc] initWithDictionary:@{@"term":@"food", @"location":@"San Francisco"}];
    
    [self performSearch];
    
  }
  return self;
}

-(void)performSearch{
  [self.client search:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
    NSArray *businessDictionaries = response[@"businesses"];
    self.businesses = [Business businessesWithDictionaries:businessDictionaries];
    [self.tableView reloadData];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error: %@", [error description]);
  }];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  [self.tableView addGestureRecognizer:gestureRecognizer];
  gestureRecognizer.cancelsTouchesInView = NO;
  
  self.searchBar = [[UISearchBar alloc] init];
  [self.searchBar sizeToFit];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Filter"
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(onFilter)];
  
  
  self.searchBar.delegate = self;
  [self.searchBar setPlaceholder:@"Search..."];
  self.searchBar.barTintColor = [UIColor whiteColor];
  self.searchBar.backgroundColor = [UIColor clearColor];
  self.searchBar.translucent = YES;
  self.navigationItem.titleView = self.searchBar;
  
  self.tableView.delegate =self;
  self.tableView.dataSource = self;
  
  [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
  
  self.tableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)onFilter{
  FiltersViewController *fvc = [[FiltersViewController alloc]init];
  fvc.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:fvc] animated:YES completion: nil];
}

- (void)invokeFilter:(NSDictionary*)filters{
  [self.tableView reloadData];
  self.filters = [filters mutableCopy];
  [self dismissViewControllerAnimated:YES completion:nil];
  [self performSearch];
}

- (void)cancelFilter{
  [self.tableView reloadData];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
  if([self.searchBar isFirstResponder]){
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
  }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  self.searchBar.showsCancelButton = NO;
  self.filters[@"term"] = searchBar.text;
  [self performSearch];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  BusinessCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
  cell.business = self.businesses[indexPath.row];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
  
}


@end
