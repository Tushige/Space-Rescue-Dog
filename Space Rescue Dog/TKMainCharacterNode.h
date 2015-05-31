//
//  TKMainCharacterNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TKMainCharacterNode : SKSpriteNode

@property(nonatomic)SKEmitterNode *fire;
+(instancetype) mainCharacterAtPosition:(CGPoint) position andFrame:(CGRect)frame;
-(void)destroyMainCharacter;

@end
