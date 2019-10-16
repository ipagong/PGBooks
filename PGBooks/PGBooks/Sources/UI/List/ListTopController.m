//
//  ListTopController.m
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "ListTopController.h"
#import "BookSimpleCell.h"
#import "UserDataService.h"

@interface ListTopController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray<PGBook*>* data;

@end

@implementation ListTopController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataLoad];
}

#pragma mark - tableview delegate & datasoruces

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BookSimpleCell * cell = [tableView dequeueReusableCellWithIdentifier:[BookSimpleCell identifier] forIndexPath:indexPath];
    [cell bindData:[self.data objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PGBook *book = [self.data objectAtIndex:indexPath.row];
    [BookDetailController showWithBook:book target:self];
}

#pragma mark -

- (void)setupUI
{
    self.title = @"Glance";
    
    self.data = [NSMutableArray array];
    
    self.tableview.delegate   = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    
    [BookSimpleCell registOnTableView:self.tableview];
}

- (void)dataLoad {
    self.data = [UserDataService glanceBooks];
    
    [self.tableview reloadData];
}

@end
