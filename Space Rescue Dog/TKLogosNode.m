//
//  TKLogosNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 8/20/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKLogosNode.h"

@implementation TKLogosNode
+(instancetype) LogoAtPosition:(CGPoint) position
{
    TKLogosNode *Logo = [self spriteNodeWithImageNamed:@"playLogo"];
    Logo.anchorPoint = CGPointMake(0.5, 0.0);
    Logo.position = position;
    return Logo;
}
-(void)addLabel:(CGPoint)position andName:(NSString *)name andText:(NSString *)text andFontSize:(int)fontSize
{
    self.label = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtrabol"];
    self.label.name = name;
    self.label.text  = text;
    self.label.fontColor = [UIColor blackColor];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.label.fontSize = 64;
    } else {
        self.label.fontSize = 32;
    }
    self.label.position = position;
    [self addChild:self.label];
}
@end
