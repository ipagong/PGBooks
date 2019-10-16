//
//  SearchTopController.m
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "SearchTopController.h"
#import "BookSimpleCell.h"
#import "SearchHistoryCell.h"

#import "ITBookService.h"
#import "UserDataService.h"

typedef NS_ENUM(NSInteger, SearchMode) {
    SearchModeEdit = 0,
    SearchModeDone
};

typedef NS_ENUM(NSInteger, SearchSection) {
    SearchSectionQuery = 0,
    SearchSectionHistory,
};

@interface SearchData : NSObject
@property (nonatomic, assign) SearchMode mode;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSMutableArray<NSArray<PGBook*>*> * data;
@end

@implementation SearchData
- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }
    self.data = [NSMutableArray array];
    self.totalCount = NSNotFound;
    return self;
}

- (NSInteger)page {
    return (_data.count + 1);
}

- (BOOL)hasNext {
    if (_totalCount == 0) { return NO; }
    if (_totalCount == NSNotFound) { return YES; }
    
    NSInteger count = 0;
    
    for (NSArray *arr in _data.objectEnumerator) {
        count += arr.count;
    }
    
    return (count < _totalCount);
}

@end

@interface SearchTopController ()
<UITableViewDelegate, UITableViewDataSource,
 UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) NSArray<NSString*> * cacheQuery;
@property (nonatomic, strong) NSArray<PGBook*>   * cacheResults;

@property (nonatomic, strong) SearchData * searchData;

@property (nonatomic, strong) NSString * searchText;

@end

@implementation SearchTopController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

#pragma mark -

- (void)setupUI {
    self.title = @"Search";
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.tableview.delegate   = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    
    [BookSimpleCell registOnTableView:self.tableview];
    [SearchHistoryCell registOnTableView:self.tableview];
}

#pragma mark -

- (NSArray<NSString *> *)cacheQuery {
    return [UserDataService queryHistory];
}

- (NSArray<PGBook *> *)cacheResults {
    return [UserDataService searchedBooks];
}

- (void)setSearchText:(NSString *)searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([_searchText isEqualToString:searchText] == YES) { return; }
    
    _searchText = searchText;
    
    if (self.searchData == nil || self.searchData.totalCount != NSNotFound) {
        self.searchData = [[SearchData alloc] init];
    }
}

#pragma mark - tableview delegate & datsoruce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.isActive == YES) {
        return self.searchData.data.count;
    } else {
        return SearchSectionHistory + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive == YES) {
        switch (self.searchData.mode) {
            case SearchModeEdit:
                return self.cacheQuery.count;
            case SearchModeDone:
                return [self.searchData.data objectAtIndex:section].count;
        }
    } else {
        switch (section) {
            case SearchSectionQuery:
                return self.cacheQuery.count;
            case SearchSectionHistory:
                return self.cacheResults.count;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.isActive == NO)                 { return; }
    if (self.searchData.mode != SearchModeDone)               { return; }
    if (self.searchData.data.count < 1)                       { return; }
    if ((self.searchData.data.count -1) != indexPath.section) { return; }
    if ((self.searchData.data.count -1) != indexPath.section) { return; }
    
    NSArray * sections = [self.searchData.data objectAtIndex:indexPath.section];
    
    if ((sections.count - 1) != indexPath.row) { return; }
    
    [self dataLoad];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.searchController.isActive == YES) {
        switch (self.searchData.mode) {
            case SearchModeEdit:
            {
                SearchHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:[SearchHistoryCell identifier] forIndexPath:indexPath];
                if (self.cacheQuery.count > indexPath.row) {
                    [cell bindData:[self.cacheQuery objectAtIndex:indexPath.row]];
                }
                return cell;
            }
            case SearchModeDone:
            {
                BookSimpleCell * cell = [tableView dequeueReusableCellWithIdentifier:[BookSimpleCell identifier] forIndexPath:indexPath];
                if (self.searchData.data.count > indexPath.section && [self.searchData.data objectAtIndex:indexPath.section].count > indexPath.row) {
                    NSArray * sections = [self.searchData.data objectAtIndex:indexPath.section];
                    [cell bindData:[sections objectAtIndex:indexPath.row]];
                }
                return cell;
            }
        }
    } else {
        switch (indexPath.section) {
            case SearchSectionQuery:
            {
                SearchHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:[SearchHistoryCell identifier] forIndexPath:indexPath];
                if (self.cacheQuery.count > indexPath.row) {
                    [cell bindData:[self.cacheQuery objectAtIndex:indexPath.row]];
                }
                return cell;
            }
                
            case SearchSectionHistory:
            {
                BookSimpleCell * cell = [tableView dequeueReusableCellWithIdentifier:[BookSimpleCell identifier] forIndexPath:indexPath];
                if (self.cacheResults.count > indexPath.row) {
                    [cell bindData:[self.cacheResults objectAtIndex:indexPath.row]];
                }
                return cell;
            }
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.isActive == YES) {
        switch (self.searchData.mode) {
            case SearchModeEdit:
            {
                NSString * value = [self.cacheQuery objectAtIndex:indexPath.row];
                
                _searchController.active = YES;
                _searchController.searchBar.text = value;
                
                [self dataLoad];
                return;
            }
            case SearchModeDone:
            {
                NSArray * sections = [self.searchData.data objectAtIndex:indexPath.section];
                PGBook * book = [sections objectAtIndex:indexPath.row];
                [BookDetailController showWithBook:book target:self];
                return;
            }
        }
    } else {
        switch (indexPath.section) {
            case SearchSectionQuery:
            {
                NSString * value = [self.cacheQuery objectAtIndex:indexPath.row];
                
                _searchController.active = YES;
                _searchController.searchBar.text = value;
                
                [self dataLoad];
                return;
            }
                
            case SearchSectionHistory:
            {
                PGBook *book = [self.cacheResults objectAtIndex:indexPath.row];;
                [BookDetailController showWithBook:book target:self];
                return;
            }
        }
    }
}

#pragma mark - search

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.searchText = searchController.searchBar.text;
    self.searchData.mode = SearchModeEdit;
    [self.tableview reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self dataLoad];
}

#pragma mark - data load

- (void)dataLoad {
    if ([self.searchData hasNext] == NO) { return; }
    
    if (_searchText.length == 0) {
        [self.tableview reloadData];
        return;
    }
    
    if (self.searchData.page == 1) {
        [UserDataService removeAllSearchedBooks];
    }
    
    self.searchData.mode = SearchModeDone;
    
    __weak __typeof(self)weakSelf = self;
    [ITBookService getSearchBooksWithKeyword:_searchText
                                        page:self.searchData.page
                                  completion:^(NSArray<PGBook *> * _Nonnull books, NSInteger total, NSError * _Nonnull error) {
                                      __strong __typeof(self)strongSelf = weakSelf;
                                      if (total > 0) { [UserDataService addSearchQuery:strongSelf.searchText]; }
                                      
                                      [strongSelf.searchData.data addObject:books];
                                      strongSelf.searchData.totalCount = total;
                                      
                                      for (PGBook *book in books.objectEnumerator) {
                                          [UserDataService addSearchedBook:book];
                                      }
                                      
                                      [strongSelf.tableview reloadData];
                                  }];
}

@end
