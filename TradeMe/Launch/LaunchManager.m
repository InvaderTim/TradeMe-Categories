//
//  LaunchManager.m
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "LaunchManager.h"
#import "CategoriesViewController.h"

@implementation LaunchManager

static LaunchManager *instance;

+ (LaunchManager *) getInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	
	return instance;
}

#pragma mark - Launch Functions

-(void)preload {
	[self applyRestyling];
}

-(id)getLaunchController {
	CategoriesViewController *viewController = [[CategoriesViewController alloc] initWithCategory:nil];
	[NETWORKING_MANAGER.delegates addObject:viewController];
	[NETWORKING_MANAGER startSync];
	return viewController;
}

#pragma mark - Load Functions

-(void)applyRestyling {
	NSMutableDictionary *navigationTextAttributes = [NSMutableDictionary dictionary];
	NSMutableDictionary *buttonTextAttributes = [NSMutableDictionary dictionary];
	NSMutableDictionary *pressedButtonTextAttributes = [NSMutableDictionary dictionary];
		
	
	UIEdgeInsets backInsets = {0, 22, 0, 5};
	UIEdgeInsets normalInsets = {0, 5, 0, 5};
	UIEdgeInsets fieldInsets = {0, 10, 0, 10};
	
	UIImage *navigationBackground = [UIImage imageNamed:@"titlebg"];
	
	UIImage *backBackground = [[UIImage imageNamed:@"backbutton"] resizableImageWithCapInsets:backInsets];
	UIImage *backBackgroundPressed = [[UIImage imageNamed:@"backbuttonpressed"] resizableImageWithCapInsets:backInsets];
	
	UIImage *normalBackground = [[UIImage imageNamed:@"barbutton"] resizableImageWithCapInsets:normalInsets];
	UIImage *normalBackgroundPressed = [[UIImage imageNamed:@"barbuttonpressed"] resizableImageWithCapInsets:normalInsets];
	
	UIImage *searchBackground = [UIImage imageNamed:@"searchbg"];
	UIImage *fieldBackground = [[UIImage imageNamed:@"searchfield"] resizableImageWithCapInsets:fieldInsets];
	
	UIImage *searchIcon = [UIImage imageNamed:@"searchicon"];
	
	navigationTextAttributes[UITextAttributeTextColor] = [UIColor colorWithRed:0.76f green:0.435f blue:0.04f alpha:1];
	navigationTextAttributes[UITextAttributeTextShadowColor] = [UIColor colorWithWhite:1 alpha:1];
	navigationTextAttributes[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(1, 1)];
	
	buttonTextAttributes[UITextAttributeTextColor] = [UIColor colorWithRed:0.76f green:0.435f blue:0.04f alpha:1];
	buttonTextAttributes[UITextAttributeTextShadowColor] = [UIColor colorWithWhite:1 alpha:1];
	buttonTextAttributes[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(1, 1)];
	
	pressedButtonTextAttributes[UITextAttributeTextColor] = [UIColor colorWithRed:0.82f green:0.62f blue:0.08f alpha:0];
	pressedButtonTextAttributes[UITextAttributeTextShadowColor] = [UIColor colorWithWhite:1 alpha:1];
	pressedButtonTextAttributes[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(1, 1)];
	
	[[UINavigationBar appearance] setBackgroundImage:navigationBackground forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setTitleTextAttributes:navigationTextAttributes];
	
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBackground
													  forState:UIControlStateNormal
													barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBackgroundPressed
													  forState:UIControlStateHighlighted
													barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-3, 0)
														 forBarMetrics:UIBarMetricsDefault];
	
	[[UIBarButtonItem appearance] setBackgroundImage:normalBackground
											forState:UIControlStateNormal
										  barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackgroundImage:normalBackgroundPressed
											forState:UIControlStateHighlighted
										  barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setTitleTextAttributes:buttonTextAttributes forState:UIControlStateNormal];
	[[UIBarButtonItem appearance] setTitleTextAttributes:buttonTextAttributes forState:UIControlStateHighlighted];
	
	[[UISearchBar appearance] setBackgroundImage:searchBackground];
	[[UISearchBar appearance] setSearchFieldBackgroundImage:fieldBackground forState:UIControlStateNormal];
	[[UISearchBar appearance] setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

@end
