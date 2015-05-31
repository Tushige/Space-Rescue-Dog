//
//  TKUtil.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKUtil.h"

@implementation TKUtil
+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max
{
    //max - min returns a number within that range
    //however, it might get below min, so we add min
    return arc4random() % (max - min) + min;
}
@end
