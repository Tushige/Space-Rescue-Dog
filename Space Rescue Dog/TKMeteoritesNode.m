//
//  TKMeteoritesNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKMeteoritesNode.h"
#import "TKUtil.h"

@implementation TKMeteoritesNode

+(instancetype) meteoriteInFrame:(CGRect)frame andType:(TKMeteoriteType) type  andScrollingDuration:(NSInteger)scrollingDuration;
{
    TKMeteoritesNode *meteorite;
    if(type == TKMeteoriteTypeA)
    {
        meteorite = [self spriteNodeWithImageNamed:@"meteorite_A_1"];

        //type information
        meteorite.MeteoriteType = TKMeteoriteTypeA;
    }
    else if(type == TKMeteoriteTypeB)
    {
        meteorite = [self spriteNodeWithImageNamed:@"meteorite_A_2"];
 
        //type information
        meteorite.MeteoriteType = TKMeteoriteTypeB;
    }
    meteorite.scrollingDuration = scrollingDuration;
    meteorite.anchorPoint = CGPointMake(0.5, 0.5);
    meteorite.name = @"meteorite";
    [meteorite physicsBodySetup];
    [meteorite addPosition:frame];
    return meteorite;
}
-(void)physicsBodySetup
{
    //initializes the physicsBody
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 2.0];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = YES;
    self.physicsBody.mass = 0.5;
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.dynamic = YES;
    
    self.physicsBody.categoryBitMask = TKCollisionCategoryMeteorite;
    
    //astronaut doesn't collide with anything
    self.physicsBody.collisionBitMask = 0;
    
    //contact relationship with the meteorites and collectables
    self.physicsBody.contactTestBitMask = TKCollisionCategoryCharacter;
}

//@param frame ; frame of the scene
-(void)addPosition:(CGRect)frame
{
    float randomPositionX = [TKUtil randomWithMin:-frame.size.width / 2.0 max:frame.size.width / 2.0];
    float randomPositionY = [TKUtil randomWithMin:frame.size.height max:frame.size.height + frame.size.height / 2.0];
   
    self.position = CGPointMake(randomPositionX,randomPositionY );
}
-(void)moveToPosition:(CGPoint)position
{
    SKAction *moveMeteorite = [SKAction moveTo:position duration:self.scrollingDuration];
    [self runAction:moveMeteorite completion:^{
        [self removeFromParent];
    }];
}

@end
