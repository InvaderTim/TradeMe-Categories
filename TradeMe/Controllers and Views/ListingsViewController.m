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
	
	
	[self.refreshControl endRefreshing];
	self.results = newResults;
	if (self.currentPage == 1) {
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	} else {
		[self.tableView insertRowsAtIndexPaths:insertedRows withRowAnimation:UITableViewRowAnimationNone];
	}
}

-(void)performSearch {
	self.currentPage++;
	[[TradeMeClient getInstance] getPath:@"Search/General.json"
							  parameters:@{
											 @"category" : self.selectedCategory.uid,
											 @"page" : @(self.currentPage),
											 @"search_string" : self.searchBar.text,
											 @"rows" : @25
										 }
								 success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
								 }
								 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
									 [self.refreshControl endRefreshing];
									 
									 
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
	self.searchShouldReplace = YES;
	self.currentPage = 0;
	[self performSearch];
	[self.searchBar resignFirstResponder];
}

#pragma mark - Refresh View Delegate

-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)control {
	self.searchShouldReplace = YES;
	self.currentPage = 0;
	[self performSearch];
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
	if (self.searchBar.text && self.searchBar.text.length > 0) {
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
		label.textColor = [UIColor blackColor];
		if (nextPageSize == 0) {
			label.text = @"No More Results";
		} else {
			label.text = [NSString stringWithFormat:@"Show Next %d...",nextPageSize];	
		}
		
		return cell;
	} else {
		static NSString *cellIdentifier = @"ListingCell";
		ListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (indexPath.row >= 0 && indexPath.row < self.results.count) {
			Listing *listing = self.results[indexPath.row];
			
			if (!cell) {
				cell = [[ListingTableCell alloc] initWithReuseIdentifier:cellIdentifier];
			}
			
			[cell reload:listing];
			
		} else {
			[[NSException exceptionWithName:@"Tim has a dumb!" reason:@"Code does the brokeing!" userInfo:nil] raise];
		}
		
		return cell;
	}
	
	return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == self.results.count) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		UILabel *label = (UILabel*)[cell viewWithTag:1];
		label.textColor = [UIColor lightGrayColor];
		[self performSearch];
	}
}

@end
