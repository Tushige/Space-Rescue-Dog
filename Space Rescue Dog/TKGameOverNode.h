//
//  TKGameOverNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TKLogosNode.h"

@interface TKGameOverNode : SKNode
@property(nonatomic) TKLogosNode * rankLogo;
+(instancetype)gameOverAtPosition:(CGPoint)position andFontSize:(int)fontSize;
-(void)performAnimation:(NSInteger)score andBestScore:(NSInteger)bestScore;

@end
