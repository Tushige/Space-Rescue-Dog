//
//  TKMainCharacterNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKMainCharacterNode.h"
#import "TKUtil.h"

@implementation TKMainCharacterNode

+(instancetype) mainCharacterAtPosition:(CGPoint) position andFrame:(CGRect)frame
{
    //initialize the astronaut object
    TKMainCharacterNode *mainCharacter = [self spriteNodeWithImageNamed:@"rescueDog_normal"];
    
    //set astronaut's anchor point
    mainCharacter.anchorPoint = CGPointMake(0.5 , 0.5);
    
    //set astronaut's position to be in the center of the scene
    mainCharacter.position = position;
    
    //set astronaut's name property
    mainCharacter.name = @"astronaut";
    
    //astronaut's physicsBody setup helper method
    [mainCharacter physicsBodySetup];

    //return the astronaut object
    return mainCharacter;
}
-(void)physicsBodySetup
{
    //initialize the physics body
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 2.0];
    
    //astronaut is not affected by gravity
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = YES;
    
    //add mass to make the movement seem natural
    self.physicsBody.mass = 0.2;
    
    //prevents air drag
    self.physicsBody.linearDamping = 0.0;
    
    //astronaut has 0 velocity
    self.physicsBody.velocity = CGVectorMake(0, 0);
    
    self.physicsBody.categoryBitMask = TKCollisionCategoryCharacter;
    
    //astronaut doesn't collide with anything
    self.physicsBody.collisionBitMask = 0;
    
    //contact relationship with the meteorites and collectables
    self.physicsBody.contactTestBitMask = TKCollisionCategoryMeteorite | TKCollisionCategoryCollectable;
}
-(void)destroyMainCharacter
{
    SKAction *scaleDown = [SKAction scaleTo:0.0 duration:2.0];
    SKAction *rotate = [SKAction rotateToAngle:45 duration:2.0];
    SKAction *move = [SKAction moveToY:self.position.y  - 30 duration:1.0];
    [self runAction:rotate];
    [self runAction:move];
    [self runAction:scaleDown completion:^{
        [self removeFromParent];
    }];
}

@end
