//
//  ViewController.h
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NetworkingDelegate>

@property (nonatomic, retain) Category *parentCategory;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(id)initWithCategory:(Category*)category;

@end
