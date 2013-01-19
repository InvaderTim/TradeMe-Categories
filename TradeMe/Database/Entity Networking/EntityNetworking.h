//
//  EntityNetworking.h
//
//  Created by Timothy Robb on 4/12/12.
//  Copyright (c) 2012 Timothy Robb. All rights reserved.
//

#ifndef Entity_Networking_h
#define Entity_Networking_h

@protocol EntityNetworking <NSObject>

-(NSDictionary *)getNetworkingData;
-(void)setWithNetworkingData:(NSDictionary *)data;

@end

#endif
