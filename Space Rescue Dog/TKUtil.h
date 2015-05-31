//
//  TKUtil.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
//background scrolling speed
static const int TKScrollingSpeed = 3;
//the time the meteorite has to cover the distance it travels
static const int TKMeteoriteMovementDuration = 4.5;
//the time the collectables have to cover the distance it travels
static const int TKCollectableMovementDuration = 4.5;
//the number of lives
static const int TKMaxLives = 5;
//points to give for each rescue
static const int TKPoints = 1;
//distance point animation moves
static const int TKPointDistance = 70;
//key name for game "best Score"
static NSString* const TKBestScore = @"highScore";
//key name for the player with the highest score
static NSString* const TKPlayerName = @"player name";
//banner height
static const int bannerHeight = 50;
//banner width
static const int bannerWidth= 320;
typedef NS_OPTIONS(uint32_t, TKCollisionCategory) {
    TKCollisionCategoryCharacter          = 1 << 0,//0000
    TKCollisionCategoryMeteorite       = 1 << 1,//0010
    TKCollisionCategoryCollectable       = 1 << 2,//0100
};
@interface TKUtil : NSObject
+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;
@end
