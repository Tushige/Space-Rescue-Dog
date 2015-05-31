//
//  TKCollectablesNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKCollectablesNode.h"
#import "TKUtil.h"

@interface TKCollectablesNode()

@property(nonatomic)NSArray *textures;
@property(nonatomic)SKAction *animate;

@end
@implementation TKCollectablesNode

+(instancetype) collectableInFrame:(CGRect)frame
{
    TKCollectablesNode *collectable;

    collectable = [self spriteNodeWithImageNamed:@"astro1"];
    collectable.anchorPoint = CGPointMake(0.5, 0.5);
    collectable.name = @"collectable";
    [collectable physicsBodySetup];
    [collectable addPosition:frame];
    [collectable setupAnimation];
    return collectable;
}
-(void)setupAnimation
{
    self.textures = @[[SKTexture textureWithImageNamed:@"astro1"], [SKTexture textureWithImageNamed:@"astro2"]];
    self.animate = [SKAction animateWithTextures:self.textures timePerFrame:0.25];
    SKAction *animateRepeat = [SKAction repeatActionForever:_animate];
    [self runAction:animateRepeat withKey:@"animation"];
}
-(void)physicsBodySetup
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.2;
    self.physicsBody.dynamic = YES;
    self.physicsBody.linearDamping = 0.0;
    
    //physicsbody category bitmask assignment
    self.physicsBody.categoryBitMask = TKCollisionCategoryCollectable;
    
    //collides with nothing
    self.physicsBody.collisionBitMask = 0;
    
    //contact relationship with the character
    self.physicsBody.contactTestBitMask = TKCollisionCategoryCharacter;
}
-(void)addPosition:(CGRect)frame
{
    float randomPositionX = [TKUtil randomWithMin:-frame.size.width / 2.0 max:frame.size.width / 2.0];
    float randomPositionY = [TKUtil randomWithMin:frame.size.height max:frame.size.height + frame.size.height / 2.0];
    
    self.position = CGPointMake(randomPositionX,randomPositionY );
}
-(void)moveToPosition:(CGPoint)position
{
    SKAction *moveMeteorite = [SKAction moveTo:position duration:TKCollectableMovementDuration];
    [self runAction:moveMeteorite completion:^{
        [self removeFromParent];
    }];
}
@end
