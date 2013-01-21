//
//  Listing.m
//  TradeMe
//
//  Created by Timothy Robb on 21/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "Listing.h"

@implementation Listing

-(NSDictionary *)getNetworkingData {
	// Listings are not uploaded
	return @{};
}

-(void)setWithNetworkingData:(NSDictionary *)data {
	if (data[@"ListingId"] && data[@"ListingId"] != [NSNull null]) {
		self.backendID = [data[@"ListingId"] integerValue];
	}
	
	if (data[@"PictureHref"] && data[@"PictureHref"] != [NSNull null]) {
		self.imageURL = [NSURL URLWithString:data[@"PictureHref"]];
	}
	if (data[@"Title"] && data[@"Title"] != [NSNull null]) {
		self.title = data[@"Title"];
	}
	
	if (data[@"IsNew"] && data[@"IsNew"] != [NSNull null]) {
		self.isNew = [data[@"IsNew"] boolValue];
	}
	if (data[@"HasPayNow"] && data[@"HasPayNow"] != [NSNull null]) {
		self.hasPayNow = [data[@"HasPayNow"] boolValue];
	}
	
	if (data[@"PriceDisplay"] && data[@"PriceDisplay"] != [NSNull null]) {
		self.bidPrice = data[@"PriceDisplay"];
	}
	if (data[@"BuyNowPrice"] && data[@"BuyNowPrice"] != [NSNull null]) {
		self.buyNowPrice = [NSString stringWithFormat:@"Buy Now: $%d",[data[@"BuyNowPrice"] intValue]];
	}
	
	if (data[@"EndDate"] && data[@"EndDate"] != [NSNull null]) {
		NSDateFormatter *JSONDateTimeFormatter = [[NSDateFormatter alloc] init];
		[JSONDateTimeFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"]; // 2012-01-01T00:00:00Z
		[JSONDateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
		
		NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
		[dayFormatter setDateFormat:@"EEE dd MMM"]; // Wed 23 Jan
		
		NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
		[hourFormatter setDateFormat:@"h'hrs'"]; // 12hrs
		
		NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
		[minuteFormatter setDateFormat:@"m'm' s's'"]; // 1m 23s
		
		NSString *endDateString = data[@"EndDate"];
		NSString *clippedDateString = [endDateString substringWithRange:(NSRange){6,endDateString.length-(6+2+3)}]; // 6 beginning, 2 end, 3 extra numbers
		NSTimeInterval endStamp = [clippedDateString doubleValue];
		NSTimeInterval nowStamp = [[NSDate date] timeIntervalSince1970];
		self.timeLeftInt = endStamp - nowStamp;
		NSDate *differenceDate = [NSDate dateWithTimeIntervalSince1970:self.timeLeftInt];
		
		if (self.timeLeftInt < (60 * 60)) { // = 1 hour
			self.timeLeft = [minuteFormatter stringFromDate:differenceDate];
		} else if (self.timeLeftInt < (60 * 60 * 24)) { // = 24 hours
			self.timeLeft = [hourFormatter stringFromDate:differenceDate];
		} else {
			self.timeLeft = [dayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endStamp]];
		}
	}
	
	self.totalBids = @"No bids";
	if (data[@"BidCount"] && data[@"BidCount"] != [NSNull null]) {
		if ([data[@"BidCount"] intValue] > 0) {
			self.totalBids = [NSString stringWithFormat:@"%d bids",[data[@"BidCount"] intValue]];
		}
	}
	if (data[@"Region"] && data[@"Region"] != [NSNull null]) {
		self.location = data[@"Region"];
	}
}

@end
