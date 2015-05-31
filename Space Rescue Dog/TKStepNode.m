//
//  TKStepNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKStepNode.h"

@implementation TKStepNode

+(instancetype) stepAtPosition:(CGPoint)position
{
    TKStepNode *step = [self spriteNodeWithImageNamed:@"stepper"];
    step.name = @"step";
    step.position = position;
    [step physicsBodySetup];
    return step;
}
-(void)physicsBodySetup
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
}

@end
