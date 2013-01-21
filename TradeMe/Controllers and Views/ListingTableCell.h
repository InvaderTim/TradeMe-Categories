//
//  SearchResultTableCell.h
//  TradeMe
//
//  Created by Timothy Robb on 21/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

@class Listing;

@interface ListingTableCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)reload:(Listing*)listing;

@end
