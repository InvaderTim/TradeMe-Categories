//
//  SearchResultsViewController.m
//  TradeMe
//
//  Created by Timothy Robb on 21/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "ListingsViewController.h"
#import "Listing.h"
#import "ListingTableCell.h"
#import "TradeMeClient.h"

@implementation ListingsViewController

-(id)initWithCategory:(Category*)selectedCategory {
    if (self = [super initWithNibName:@"ListingsView" bundle:nil]) {
		self.selectedCategory = selectedCategory;
        self.results = [NSMutableArray array];
    }
    return self;
}

#pragma mark - View Callbacks

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
	[self.refreshControl addTarget:self
					   action:@selector(dropViewDidBeginRefreshing:)
			 forControlEvents:UIControlEventValueChanged];
	
	self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){{0,0},{320,44}}];
	self.searchBar.placeholder = [NSString stringWithFormat:@"Search in %@",self.selectedCategory.name];
	self.searchBar.delegate = self;
	self.tableView.tableHeaderView = self.searchBar;
	
	self.title = self.selectedCategory.name;
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.searchBar.text = @"";
	[self performSearch];
}

#pragma mark - Search Bar Delegate

-(void)cancelSearch {
	self.searchBar.text = self.lastSearchTerms;
	[self.searchBar resignFirstResponder];
}

-(void)freshSearch {
	self.searchShouldReplace = YES;
	self.currentPage = 0;
	[self performSearch];
}

-(void)handleSearchResults:(NSArray *)results {
	NSMutableArray *newResults = self.results;
	
	if (self.searchShouldReplace) {
		self.searchShouldReplace = NO;
		newResults = [NSMutableArray array];
	}
	
	NSMutableArray *insertedRows = [NSMutableArray array];
	for (id listingObject in results) {
		Listing *listing = [[Listing alloc] init];
		[listing setWithNetworkingData:listingObject];
		[newResults addObject:listing];
		[insertedRows addObject:[NSIndexPath indexPathForRow:[newResults indexOfObject:listing] inSection:0]];
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		self.results = newResults;
		if (self.currentPage == 1) {
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
		} else {
			[self.tableView insertRowsAtIndexPaths:insertedRows withRowAnimation:UITableViewRowAnimationNone];
		}
		[self.refreshControl endRefreshing];
	});
}

-(void)performSearch {
	self.currentPage++;
	__block dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[[TradeMeClient getInstance] getPath:@"Search/General.json"
							  parameters:@{
											 @"category" : self.selectedCategory.uid,
											 @"page" : @(self.currentPage),
											 @"search_string" : self.searchBar.text,
											 @"rows" : @25
										 }
								 success:^(AFHTTPRequestOperation *operation, id responseObject) {
									 self.errorMode = NO;
									 dispatch_async(backgroundQueue,^{
										 if (responseObject && ![responseObject isEqual:[NSNull null]]) {
											 NSDictionary *response = responseObject;
											 
											 self.lastSearchTerms = self.searchBar.text;
											 
											 NSNumber *totalCount = response[@"TotalCount"];
											 if (totalCount && ![totalCount isEqual:[NSNull null]]) {
												 self.totalResults = [totalCount integerValue];
												 self.totalPages = ceilf((float)self.totalResults/25.0f);
											 }
											 
											 NSArray *list = response[@"List"];
											 if (list && ![list isEqual:[NSNull null]]) {
												 [self handleSearchResults:list];
											 }
										 }
									 });
								 }
								 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
									 self.errorMode = YES;
									 [self.refreshControl endRefreshing];
									 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
												   withRowAnimation:UITableViewRowAnimationNone];
								 }];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self.searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	[self.searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self cancelSearch];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self freshSearch];
	[self.searchBar resignFirstResponder];
}

#pragma mark - Refresh View Delegate

-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)control {
	[self freshSearch];
}

#pragma mark - Table Functions

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.searchBar.isFirstResponder) {
		[self cancelSearch];
	}
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.results.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){{0,0},{320,20}}];
	
	headerView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
	
	UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){{0,0},{320,20}}];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:12.0f];
	label.textColor = [UIColor blackColor];
	label.textAlignment = NSTextAlignmentCenter;
	if (self.errorMode) {
		label.text = @"Error Loading Content";
	} else if (self.totalResults == 0) {
		label.text = @"Loading...";
	} else if (self.searchBar.text && self.searchBar.text.length > 0) {
		label.text = [NSString stringWithFormat:@"%d %@ in %@ for \"%@\"",self.totalResults,
																		(self.totalResults == 1) ? @"result" : @"results",
																		self.selectedCategory.name,
																		self.searchBar.text];
	} else {
		label.text = [NSString stringWithFormat:@"%d %@ in %@",self.totalResults,
															   (self.totalResults == 1) ? @"result" : @"results",
															   self.selectedCategory.name];
	}
	
	[headerView addSubview:label];
	
	return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == self.results.count) {
		static NSString *cellIdentifer = @"PagenationCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
		
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
			
			UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){{0,0},{320,75}}];
			label.textAlignment = NSTextAlignmentCenter;
			label.font = [UIFont systemFontOfSize:19.0f];
			label.tag = 1;
			[cell addSubview:label];
		}
		
		NSInteger lastPageSize = self.totalResults % 25;
		NSInteger nextPageSize = (self.currentPage == self.totalPages-1) ? lastPageSize : 25;
		
		UILabel *label = (UILabel*)[cell viewWithTag:1];
		label.textColor = [UIColor lightGrayColor];
		if (self.errorMode) {
			label.text = @"Reload";
		} else if (self.currentPage == self.totalPages) {
			label.text = @"No More Results";
		} else {
			label.textColor = [UIColor blackColor];
			label.text = [NSString stringWithFormat:@"Show Next %d...",nextPageSize];	
		}
		
		return cell;
	} else {
		static NSString *cellIdentifier = @"ListingCell";
		ListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		Listing *listing = self.results[indexPath.row];
		
		if (!cell) {
			cell = [[ListingTableCell alloc] initWithReuseIdentifier:cellIdentifier];
		}
		
		[cell reload:listing];
		
		return cell;
	}
	
	return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == self.results.count) {
		if (self.errorMode) {
			[self freshSearch];
		} else {
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			UILabel *label = (UILabel*)[cell viewWithTag:1];
			label.textColor = [UIColor lightGrayColor];
			[self performSearch];
		}
	}
}

@end
