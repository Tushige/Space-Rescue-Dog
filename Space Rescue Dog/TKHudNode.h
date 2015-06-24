//
//  TKHudNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TKHudNode : SKNode

@property(nonatomic)NSInteger lives;
@property(nonatomic)NSInteger score;
@property(nonatomic)NSInteger bestScore;
+(instancetype)hudAtPosition:(CGPoint)position inFrame:(CGRect) frame andScoreFont:(int)scoreFont andOffset:(int)offset;
-(void)addPoints:(NSInteger)points;
-(void)LoseLife;
-(BOOL)isGameOver;
@end
