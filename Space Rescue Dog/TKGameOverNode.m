//
//  TKGameOverNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/28/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKGameOverNode.h"
#import "TKHudNode.h"
#import "TKLogosNode.h"

@interface TKGameOverNode  ()

@property(nonatomic)NSString* scoreText;

@end

@implementation TKGameOverNode

+(instancetype)gameOverAtPosition:(CGPoint)position
{
    TKGameOverNode *gameOver = [self node];
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtrabold"];
    gameOverLabel.name = @"GameOver" ;
    gameOverLabel.text  = @"Game Over";
    gameOverLabel.fontColor = [UIColor redColor];
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;
    [gameOver addChild:gameOverLabel];
    [gameOver showRank];
    return gameOver;
}
-(void)showRank
{
    TKLogosNode *rankLogo = [TKLogosNode LogoAtPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 150)];
    [rankLogo addLabel:CGPointMake(CGRectGetMidX(self.frame), - CGRectGetMidY(self.frame) +rankLogo.frame.size.height/12.0) andName:@"rank" andText:@"RANK"];
    [self addChild:rankLogo];
}
-(void)performAnimation:(NSInteger)score andBestScore:(NSInteger)bestScore
{
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"GameOver"];
    label.xScale = 0;
    label.yScale = 0;
    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.25f];
    SKAction *scaleUp = [SKAction scaleTo:1.4 duration:0.75];
    
    //shows "touch to restart" label
    SKAction *restart = [SKAction runBlock:^{
        SKLabelNode *restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        restartLabel.text = @"Play Again";
        restartLabel.name = @"play again";
        restartLabel.fontSize = 24;
        restartLabel.fontColor = [UIColor yellowColor];
        restartLabel.position = CGPointMake(label.position.x, label.position.y - 120);
        [self addChild:restartLabel];
    }];
    
    //makes the restart label fade in and out
    SKAction *sequence = [SKAction sequence:@[scaleUp, scaleDown, restart]];
    [label runAction:sequence completion:^{
        SKLabelNode *restartLabel = (SKLabelNode *)[self childNodeWithName:@"restartLabel"];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0];
        SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
        SKAction *fadeSequence = [SKAction sequence:@[fadeOut, fadeIn]];
        SKAction *repSequence = [SKAction sequence:@[fadeSequence, fadeSequence, fadeSequence, fadeSequence, fadeSequence, fadeSequence]];
        [restartLabel runAction:repSequence];
    }];
    //shows the total score at the end of the game
    SKAction *showScore = [SKAction runBlock:^{
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        if(score == 1)
        {
            self.scoreText = [NSString stringWithFormat:@"Score: %ld rescue", (long)score];
        }
        else
        {
            self.scoreText = [NSString stringWithFormat:@"Score: %ld rescues", (long)score];
        }
        scoreLabel.text = self.scoreText;
        scoreLabel.fontSize = 24;
        scoreLabel.position = CGPointMake(label.position.x, label.position.y - 40);
        [self addChild:scoreLabel];
    }];
    SKAction *showBestScore = [SKAction runBlock:^{
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        if(score == 1)
        {
            self.scoreText = [NSString stringWithFormat:@"High Score: %ld rescue", (long)bestScore];
        }
        else
        {
            self.scoreText = [NSString stringWithFormat:@"High Score: %ld rescues", (long)bestScore];
        }
        bestScoreLabel.text = self.scoreText;
        bestScoreLabel.fontSize = 24;
        bestScoreLabel.position = CGPointMake(label.position.x, label.position.y - 80);
        [self addChild:bestScoreLabel];
    }];
    
    //runs the actions in the order
    SKAction *finalSequence = [SKAction sequence:@[scaleUp, scaleDown, restart,showScore, showBestScore, sequence]];
    [label runAction:finalSequence];
}
@end
