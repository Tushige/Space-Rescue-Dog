//
//  TKGameplayScene.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TKGameplayScene.h"
#import <CoreMotion/CoreMotion.h>

@interface TKGameplayScene : SKScene <SKPhysicsContactDelegate>

@property(nonatomic)CMMotionManager *motionManager;

@end
