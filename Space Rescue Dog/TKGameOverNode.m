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
@property(nonatomic)int labelSize;
@end

@implementation TKGameOverNode

+(instancetype)gameOverAtPosition:(CGPoint)position andFontSize:(int)fontSize
{
    TKGameOverNode *gameOver = [self node];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtrabold"];
    gameOverLabel.name = @"GameOver" ;
    gameOverLabel.text  = @"Game Over";
    gameOverLabel.fontColor = [UIColor redColor];
    gameOverLabel.fontSize = fontSize;
    gameOverLabel.position = position;
    gameOver.labelSize = fontSize;
    
    [gameOver addChild:gameOverLabel];
    [gameOver showRank];
    
    return gameOver;
}
-(void)showRank
{
    TKLogosNode *rankLogo = [TKLogosNode LogoAtPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 150)];
    [rankLogo addLabel:CGPointMake(CGRectGetMidX(self.frame), - CGRectGetMidY(self.frame) +rankLogo.frame.size.height/12.0) andName:@"rank" andText:@"RANK" andFontSize:self.labelSize-16];
    [self addChild:rankLogo];
}
// called when game is over
-(void)performAnimation:(NSInteger)score andBestScore:(NSInteger)bestScore
{
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"GameOver"];
    label.xScale = 0;
    label.yScale = 0;
    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.25f];
    SKAction *scaleUp = [SKAction scaleTo:1.4 duration:0.75];
    
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
        scoreLabel.fontSize = self.labelSize / 3;
        scoreLabel.position = CGPointMake(label.position.x, label.position.y - label.frame.size.height);
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
        bestScoreLabel.fontSize = self.labelSize/3;
        bestScoreLabel.position = CGPointMake(label.position.x, label.position.y - label.frame.size.height * 2);
        [self addChild:bestScoreLabel];
    }];
    
    // 'Play Again' label
    SKAction *restart = [SKAction runBlock:^{
        SKLabelNode *restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        restartLabel.text = @"Play Again";
        restartLabel.name = @"play again";
        restartLabel.fontSize = self.labelSize/2;
        restartLabel.fontColor = [UIColor yellowColor];
        restartLabel.position = CGPointMake(label.position.x, label.position.y - label.frame.size.height*3);
        [self addChild:restartLabel];
    }];
    
    //makes the 'play again' label fade in and out
    SKAction *sequence = [SKAction sequence:@[scaleUp, scaleDown, restart]];
    [label runAction:sequence completion:^{
        SKLabelNode *restartLabel = (SKLabelNode *)[self childNodeWithName:@"restartLabel"];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0];
        SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
        SKAction *fadeSequence = [SKAction sequence:@[fadeOut, fadeIn]];
        SKAction *repSequence = [SKAction sequence:@[fadeSequence, fadeSequence, fadeSequence, fadeSequence, fadeSequence, fadeSequence]];
        [restartLabel runAction:repSequence];
    }];
    //runs the actions in the order
    SKAction *finalSequence = [SKAction sequence:@[scaleUp, scaleDown, restart,showScore, showBestScore, sequence]];
    [label runAction:finalSequence];
}
@end
