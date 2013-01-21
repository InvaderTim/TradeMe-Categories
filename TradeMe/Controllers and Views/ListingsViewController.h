//
//  SearchResultsViewController.h
//  TradeMe
//
//  Created by Timothy Robb on 21/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

@interface ListingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain) ODRefreshControl *refreshControl;

@property (nonatomic, retain) Category *selectedCategory;
@property (nonatomic, retain) NSMutableArray *results;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *lastSearchTerms;
@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, assign) NSInteger loadedPagesCount;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;

@property (nonatomic, assign) BOOL searchShouldReplace;

-(id)initWithCategory:(Category*)selectedCategory;

@end
