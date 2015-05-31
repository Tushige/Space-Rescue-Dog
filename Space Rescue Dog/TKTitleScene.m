//
//  TKTitleScene.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKTitleScene.h"
#import "TKGameplayScene.h"
#import "TKGameData.h"
#import <AVFoundation/AVFoundation.h>
#import "TKUtil.h"
#import "TKViewController.h"
#import "TKLogosNode.h"

@interface TKTitleScene()

@property(nonatomic)NSString* scoreText;
@property(nonatomic)AVAudioPlayer* backgroundMusic;
@property(nonatomic)SKSpriteNode* background;
@property(nonatomic)SKAction* sceneSwitchSFX;
@property(nonatomic)TKLogosNode* playLogo;
@property(nonatomic)TKLogosNode* rankLogo;
@property(nonatomic)TKCollectablesNode *titleCollectable;

@end
@implementation TKTitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //set the background image
        NSString* imageName;
        if(self.frame.size.height > 500 )
        {
            imageName = @"titleBackground_A";
        }
        else{
            imageName = @"titleBackground_B";
        }
        self.background = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        self.anchorPoint = CGPointMake(0.5,0.5);
        //set background image position
        self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.background];
        [self showPlayLabel];
        [self showBestScore];
        [self soundSetup];
        [self addAstronaut];
        [self showRankLabel];
    }
    return self;
}
-(void)showPlayLabel
{
    self.playLogo = [TKLogosNode LogoAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self.playLogo addLabel:CGPointMake(CGRectGetMidX(self.frame), self.playLogo.position.y + self.playLogo.frame.size.height / 12.0) andName:@"play" andText:@"PLAY"];
    [self addChild:self.playLogo];
}
-(void)showRankLabel
{
    self.rankLogo = [TKLogosNode LogoAtPosition:CGPointMake(CGRectGetMidX(self.frame), self.playLogo.position.y - self.playLogo.frame.size.height / 0.5)];
    [self.rankLogo addLabel:CGPointMake(CGRectGetMidX(self.frame), - CGRectGetMidY(self.frame) + self.rankLogo.frame.size.height/12.0) andName:@"rank" andText:@"RANK"];
    [self addChild:self.rankLogo];
}

-(void)soundSetup
{
    //setup background musics
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Intro" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];

    self.sceneSwitchSFX = [SKAction playSoundFileNamed:@"sceneSwitch.caf" waitForCompletion:NO];
}
-(void)addAstronaut
{
    self.titleCollectable = [TKCollectablesNode collectableInFrame:self.frame];
    [self addChild:self.titleCollectable];
    self.titleCollectable.physicsBody.dynamic = NO;
    SKAction *scaleUp = [SKAction scaleTo:2.0 duration:1];
    self.titleCollectable.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height / 3.0);
    [self.titleCollectable runAction:scaleUp];
}
-(void)didMoveToView:(SKView *)view
{
    [self.backgroundMusic play];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if 'PLAY button touched, switch to gameplay scene
    if ([node.name isEqualToString:@"play"])
    {
        [self runAction:self.sceneSwitchSFX completion:^{
            SKAction *terminate = [SKAction runBlock:^{
                //replace 'play' label with 'loading' label
                //[self.playLogo.label setText:@"Loading..."];
                
                [self.backgroundMusic stop];
                
                //create an instance of our gameplay scene
                TKGameplayScene *gameplayScene = [TKGameplayScene sceneWithSize:self.frame.size];
                
                //specify the transition from the title scene to the gameplay scene
                SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];
                
                [self.view presentScene:gameplayScene transition:transition];
            }];
            [self runAction:terminate completion:^{
                [self cleanUp];
                [(TKViewController*)self.view.window.rootViewController  hideAds];
            }];
        }];
    }
    else if([node.name isEqualToString:@"rank"])
    {
        if ([GKLocalPlayer localPlayer].authenticated)
        {
            // Get the default leaderboard identifier.
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error)
             {
                 if (error != nil)
                 {
                     NSLog(@"%@", [error localizedDescription]);
                 }
                 else
                 {
                     //calls the method "showLeaderboard" on the viewController
                     [(TKViewController*)self.view.window.rootViewController  showLeaderboard];
                 }
             }];
        }
        //if user is not logged in
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user is not logged in to Game Center" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
}

#pragma mark - helper methods

-(void)cleanUp
{
    for(SKNode *node in [self children])
    {
        if(node != self.background)
        {
            [node removeFromParent];  
        }
    }
}
-(void)showBestScore
{
    SKAction *showBestScore = [SKAction runBlock:^{
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        if([TKGameData sharedGameData].bestScore == 1)
        {
            self.scoreText = [NSString stringWithFormat:@"High Score: %ld rescue", (long)[TKGameData sharedGameData].bestScore];
        }
        else
        {
            self.scoreText = [NSString stringWithFormat:@"High Score: %ld rescues", (long)[TKGameData sharedGameData].bestScore];
        }
        bestScoreLabel.text = self.scoreText;
        bestScoreLabel.fontSize = 16;
        bestScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.rankLogo.position.y - self.rankLogo.frame.size.height / 0.5);
        [self addChild:bestScoreLabel];
    }];
    [self runAction:showBestScore];
}
@end
