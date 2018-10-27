//
//  InformationViewController.m
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "InformationViewController.h"
#import "Information.h"


@interface InformationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray<Information* >* informations;

@end


@implementation InformationViewController

- (void) loadView {
  [super loadView];
  
  self.navigationItem.title = @"Account information";
  
  CGRect frame = self.view.bounds;
  frame.origin = CGPointZero;
  
  UITableView* tableView = [[UITableView alloc] initWithFrame:frame
                                                        style:UITableViewStyleGrouped];
  tableView.autoresizingMask =
                     UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
  tableView.delegate = self;
  tableView.dataSource = self;
  
  [self.view addSubview:tableView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return [self.groupsArray count];
  return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* identifier = @"Cell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:identifier];
  }
  
//  Information* information = self.informations[indexPath.row];
//  cell.textLabel.text = information.accountNumber;
//  cell.detailTextLabel.text = information.sum;
  NSString* text = @"232323";
  cell.textLabel.text = [NSString stringWithFormat:@"Account number: %@", text];
  NSString* text2 = @"khkhkjhkjh";
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Sum: %@", text2];
  
  return cell;
}

@end
