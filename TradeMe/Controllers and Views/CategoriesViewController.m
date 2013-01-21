//
//  ViewController.m
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "CategoriesViewController.h"
#import "ListingsViewController.h"

@implementation CategoriesViewController

-(id)initWithCategory:(Category*)category {
	if (self = [super initWithNibName:@"CategoriesView" bundle:nil]) {
		self.parentCategory = category;
		[self reload];
	}
	return self;
}

- (void)syncCompleted {
	self.loadingView.hidden = YES;
	self.data = [Category getAll];
	[self reload];
}

- (void)syncFailed {
	self.loadingView.hidden = YES;
	self.errorView.hidden = NO;
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
	if (self.parentCategory) {
		self.data = [self.parentCategory getOrderedSubCategories].mutableCopy;
	}
	[self stripCategories];
	[self.tableView reloadData];
}

-(void)reloadPressed {
	self.errorView.hidden = YES;
	self.loadingView.hidden = NO;
	
	[NETWORKING_MANAGER startSync];
}

-(void)displaySearch {
	ListingsViewController *viewController = [[ListingsViewController alloc] initWithCategory:self.selectedCategory];
	[self.navigationController pushViewController:viewController animated:YES];
}

-(void)browse {
	self.selectedCategory = self.parentCategory;
	[self displaySearch];
}

#pragma mark - View Callbacks

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.reloadButton setBackgroundImage:[LAUNCH_MANAGER getButtonImagePressed:NO] forState:UIControlStateNormal];
	[self.reloadButton setBackgroundImage:[LAUNCH_MANAGER getButtonImagePressed:YES] forState:UIControlStateHighlighted];
	
	self.title = self.parentCategory ? self.parentCategory.name : NSLocalizedString(@"BROWSE", @"");
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
	backButton.title = @"Back";
	[self.navigationItem setBackBarButtonItem:backButton];
	
	if (self.parentCategory) {
		UIBarButtonItem *browseButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BROWSE", @"")
																		 style:UIBarButtonItemStylePlain
																		target:self
																		action:@selector(browse)];
		[self.navigationItem setRightBarButtonItem:browseButton];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	if (!self.data || self.data.count == 0) {
		self.loadingView.hidden = NO;
	}
	
	[self reload];
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		[[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"Over18"];
		[self displaySearch];
	}
}

#pragma mark - Table Functions

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"CategoryCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
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
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedCategory = nil;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row >= 0 && indexPath.row < self.data.count) {
		Category *category = self.data[indexPath.row];
		
		if (category.subCategories.count > 0) {
			id viewController = [[[self class] alloc] initWithCategory:category];
			[self.navigationController pushViewController:viewController animated:YES];
		} else {
			self.selectedCategory = category;
			
			if (category.isRestricted && [[NSUserDefaults standardUserDefaults] valueForKey:@"Over18"] != @YES) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RESTRICTED_TITLE", @"")
																	message:NSLocalizedString(@"RESTRICTED_BODY", @"")
																   delegate:self
														  cancelButtonTitle:NSLocalizedString(@"CANCEL", @"")
														  otherButtonTitles:NSLocalizedString(@"CONTINUE", @""), nil];
				[alertView show];
			} else {
				[self displaySearch];
			}
		}
	}
}

@end
