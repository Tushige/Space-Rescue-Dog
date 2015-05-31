//
//  TKMeteoritesNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, TKMeteoriteType) {
    TKMeteoriteTypeA = 0,
    TKMeteoriteTypeB = 1
};

@interface TKMeteoritesNode : SKSpriteNode

@property(nonatomic)NSInteger scrollingDuration;
@property(nonatomic)TKMeteoriteType MeteoriteType;
-(void)moveToPosition:(CGPoint)position;
+(instancetype) meteoriteInFrame:(CGRect)frame andType:(TKMeteoriteType) type andScrollingDuration:(NSInteger)scrollingDuration;

@end
