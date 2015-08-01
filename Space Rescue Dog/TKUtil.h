//
//  TKUtil.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

//image factor x
static const int TK_img_x = 414;
static const int TK_img_y = 736;

//background scrolling speed
static const int TKScrollingSpeedPhone = 4;
static const int TKScrollingSpeedPad = 5;

//the time the meteorite has to cover the distance it travels
static const int TKMeteoriteMovementDurationPhone = 7.5;
static const int TKMeteoriteMovementDurationPAD = 5.1;

//dog movement speed
static const int TK_DOG_SPEED_PAD = 17;
static const int TK_DOG_SPEED_PHONE = 8;

//the time the collectables have to cover the distance it travels
static const int TKCollectableMovementDuration = 5.5;
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

static const int TK_HUD_OFFSET_PAD = 40;
static const int TK_HUD_OFFSET_IPHONE = 20;

//Label sizes
static const int TK_GAMEOVER_FONT_PHONE = 65;
static const int TK_GAMEOVER_FONT_PAD = 90;

static const int TK_SCORE_PAD = 48;
static const int TK_SCORE_PHONE = 24;

static const int TK_LABEL_PHONE = 32;
static const int TK_LABEL_PAD = 64;

static const int TK_TITLE_PHONE = 20;
static const int TK_TITLE_PAD = 40;

static const int TK_POINT_PHONE = 20;
static const int TK_POINT_PAD = 40;

typedef NS_OPTIONS(uint32_t, TKCollisionCategory) {
    TKCollisionCategoryCharacter          = 1 << 0,//0000
    TKCollisionCategoryMeteorite       = 1 << 1,//0010
    TKCollisionCategoryCollectable       = 1 << 2,//0100
};
@interface TKUtil : NSObject
+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;

+(UIImage *) resizeWithImage:(UIImage *)img scale:(CGSize) newSize;
    
@end
