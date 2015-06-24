//
//  TKHudNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKHudNode.h"
#import "TKUtil.h"
@interface TKHudNode()

@property(nonatomic)SKLabelNode *scoreLabel;

@end
@implementation TKHudNode

+(instancetype)hudAtPosition:(CGPoint)position inFrame:(CGRect)frame andScoreFont:(int)scoreFont andOffset:(int)offset
{
    TKHudNode *hud = [self node];
    hud.name = @"hud";
    //set HUD position
    hud.position = position;
    //z index - how far or near the node is placed from the user; higher = closer
    hud.zPosition = 11;
    
    //initialize doghead
    SKSpriteNode *dogHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUDImage"];
    dogHead.position = CGPointMake(offset,0);
    
    dogHead.zPosition = 12;
    //add dogHead as hud's child node
    [hud addChild:dogHead];
    
    //sets the lives = (constant)TKMaxLives;
    hud.lives = TKMaxLives;
    
    //represents the lifebar that was added last
    SKSpriteNode *lastLifeBar;
    
    //displays all the lifebars
    for(int i=0; i < hud.lives; i++)
    {
        SKSpriteNode *lifeBar = [SKSpriteNode spriteNodeWithImageNamed:@"lifeBar"];
        lifeBar.zPosition = 13;
        lifeBar.anchorPoint = CGPointMake(0.5, 0.5);
        //set the name, so we can delete individual bars from loselife method -gives access to bars
        lifeBar.name= [NSString stringWithFormat:@"Life%d", i+1];
        
        //the first lifeBar positioning
        if(lastLifeBar == nil)
        {
            lifeBar.position = CGPointMake(dogHead.position.x + dogHead.frame.size.width/2.0 +lifeBar.frame.size.width, dogHead.position.y);
        }
        else
        {
            //subsequent lifeBar positioning
            lifeBar.position = CGPointMake(lastLifeBar.position.x+lifeBar.frame.size.width, lastLifeBar.position.y);
        }
        //update lastLifeBar
        lastLifeBar = lifeBar;
        
        //add lifeBar as a child Node to hud
        [hud addChild:lifeBar];
    }
    //create scoreLabel
    hud.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    hud.scoreLabel.name = @"Score";
    hud.scoreLabel.zPosition = 13;
    hud.scoreLabel.text = @"0";
    hud.scoreLabel.fontSize = scoreFont;
    hud.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    NSLog(@"hud origin x is %f", hud.scoreLabel.frame.origin.x);
    hud.scoreLabel.position = CGPointMake(frame.size.width/2.0, lastLifeBar.position.y - lastLifeBar.frame.size.height / 2.0);
    [hud addChild:hud.scoreLabel];
    
    return hud;
}
-(void)addPoints:(NSInteger)points
{
    //update the score
    self.score +=points;
    
    //update the text with the score
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
}
-(void)LoseLife
{
    //check if there is life left to remove
    if(self.lives != 0)
    {
        NSString *lifeBarName = [NSString stringWithFormat:@"Life%ld", (long)self.lives];
        SKSpriteNode *lifeBar = (SKSpriteNode *)[self childNodeWithName:lifeBarName];
        [lifeBar removeFromParent];
        
        //update remaining lives
        self.lives--;
    }
}
-(BOOL)isGameOver
{
    BOOL returnVal = NO;
    if(self.lives == 0)
    {
        returnVal = YES;
    }
    return returnVal;
}
@end
