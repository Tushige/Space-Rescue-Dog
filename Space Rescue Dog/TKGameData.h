//
//  TKGameData.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/30/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKGameData : NSObject <NSCoding>

@property(nonatomic)NSInteger bestScore;
@property(nonatomic)NSString* playerName;

+ (instancetype)sharedGameData;

-(void)save;
@end
