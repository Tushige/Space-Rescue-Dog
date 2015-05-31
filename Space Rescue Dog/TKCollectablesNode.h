//
//  TKCollectablesNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TKCollectablesNode : SKSpriteNode

@property(nonatomic)NSInteger scrollingSpeed;
-(void)moveToPosition:(CGPoint)position;
+(instancetype) collectableInFrame:(CGRect)frame;

@end
