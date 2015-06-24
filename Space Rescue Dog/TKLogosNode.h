//
//  TKLogosNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 8/20/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TKLogosNode : SKSpriteNode

+(instancetype) LogoAtPosition:(CGPoint) position;
-(void)addLabel:(CGPoint)position andName:(NSString *)name andText:(NSString *)text andFontSize:(int)fontSize;
@property(nonatomic)SKLabelNode* label;

@end
