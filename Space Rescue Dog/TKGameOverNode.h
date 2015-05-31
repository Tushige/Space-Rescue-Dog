//
//  TKGameOverNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TKGameOverNode : SKNode

+(instancetype)gameOverAtPosition:(CGPoint)position;
-(void)performAnimation:(NSInteger)score andBestScore:(NSInteger)bestScore;

@end
