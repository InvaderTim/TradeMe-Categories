//
//  ViewController.h
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
