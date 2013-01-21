//
//  SearchResultTableCell.m
//  TradeMe
//
//  Created by Timothy Robb on 21/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "ListingTableCell.h"
#import "Listing.h"
#import "UIImageView+AFNetworking.h"

@interface ListingTableCell ()

@property (nonatomic, retain) IBOutlet UIView *tableCellView;

@property (nonatomic, retain) IBOutlet UIImageView *auctionImageView;
@property (nonatomic, retain) IBOutlet UILabel *auctionTitleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *listingNewIcon;
@property (nonatomic, retain) IBOutlet UIImageView *payNowIcon;

@property (nonatomic, retain) IBOutlet UILabel *bidPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *buyNowLabel;

@property (nonatomic, retain) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, retain) IBOutlet UILabel *bidTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

@end

@implementation ListingTableCell

static UIImage *defaultImage;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [[NSBundle mainBundle] loadNibNamed:@"ListingTableCell" owner:self options:nil];
		
		if (!defaultImage) {
            defaultImage = [UIImage imageNamed:@"cameraPlaceholder"];
        }
        
        [self.contentView addSubview:self.tableCellView];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.text = @"";
    }
    
    return self;
}

-(void)fetchImage:(NSURL *)url {
	[self.auctionImageView setImageWithURL:url placeholderImage:defaultImage];
}

- (void)reload:(Listing*)listing {
	if (listing.image) {
		self.auctionImageView.image = listing.image;
	} else {
		if (listing.imageURL) {
			[self fetchImage:listing.imageURL];
		} else {
			self.auctionImageView.image = defaultImage;
		}
	}
	
	self.auctionTitleLabel.text = listing.title;
	self.listingNewIcon.hidden = !listing.isNew;
	self.payNowIcon.hidden = !listing.hasPayNow;
	
	self.bidPriceLabel.text = listing.bidPrice;
	self.buyNowLabel.text = listing.buyNowPrice;
	
	if (listing.timeLeftInt < (60 * 60 * 12)) { // Less than 12 hours
		self.timeLeftLabel.textColor = [UIColor redColor];
	} else {
		self.timeLeftLabel.textColor = [UIColor blackColor];
	}
	self.timeLeftLabel.text = listing.timeLeft;
	self.bidTotalLabel.text = listing.totalBids;
	self.locationLabel.text = listing.location;
}

@end
