//
//  ViewController.m
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "CategoriesViewController.h"

@implementation CategoriesViewController

-(id)init {
	if (self = [super initWithNibName:@"View" bundle:nil]) {
		self.data = [Category getAll];
		[NETWORKING_MANAGER.delegates addObject:self];
	}
	return self;
}

- (void)syncCompleted:(NSArray *)categories {
	self.loadingView.hidden = YES;
	[self.data setArray:categories];
	[self reload];
}

- (void)stripCategories {
	for (Category *category in self.data.mutableCopy) {
		if ([category.name isEqualToString:@"Trade Me Motors"] ||
			[category.name isEqualToString:@"Trade Me Property"] ||
			[category.name isEqualToString:@"Trade Me Jobs"]) {
			[self.data removeObject:category];
		}
	}
}

-(void)reload {
	[self stripCategories];
	[self.tableView reloadData];
}

#pragma mark - View Callbacks

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Browse";
}

- (void)viewWillAppear:(BOOL)animated {
	if (!self.data || self.data.count == 0) {
		self.loadingView.hidden = NO;
	}
	[NETWORKING_MANAGER startSync];
	
	[self reload];
}

#pragma mark - Table Functions

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = [NSString stringWithFormat:@"CategoryCell%d",indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (indexPath.row >= 0 && indexPath.row < self.data.count) {
		Category *category = self.data[indexPath.row];
		
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
		}
		
		cell.textLabel.text = category.name;
		if (category.subCategories.count > 0) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
	} else {
		[[NSException exceptionWithName:@"Tim has a dumb!" reason:@"Code does the brokeing!" userInfo:nil] raise];
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
