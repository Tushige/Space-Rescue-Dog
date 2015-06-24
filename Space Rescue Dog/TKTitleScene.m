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
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"titleBackground"];
        self.anchorPoint = CGPointMake(0.5,0.5);
        //set background image position
        self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.background];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self showPlayLabel:TK_LABEL_PAD];
            [self showBestScore:TK_TITLE_PAD];
            [self showRankLabel:TK_LABEL_PAD];
        }
        else {
            [self showPlayLabel:TK_LABEL_PHONE];
            [self showBestScore:TK_TITLE_PHONE];
            [self showRankLabel:TK_LABEL_PHONE];
        }
        [self soundSetup];
        [self addAstronaut];
    }
    return self;
}
-(void)showPlayLabel:(int)fontSize
{
    self.playLogo = [TKLogosNode LogoAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self.playLogo addLabel:CGPointMake(CGRectGetMidX(self.frame), self.playLogo.position.y + self.playLogo.frame.size.height / 12.0) andName:@"play" andText:@"PLAY" andFontSize:fontSize];

    [self addChild:self.playLogo];
}
-(void)showRankLabel:(int)fontSize
{
    self.rankLogo = [TKLogosNode LogoAtPosition:CGPointMake(CGRectGetMidX(self.frame), self.playLogo.position.y - self.playLogo.frame.size.height / 0.5)];
    [self.rankLogo addLabel:CGPointMake(CGRectGetMidX(self.frame), - CGRectGetMidY(self.frame) + self.rankLogo.frame.size.height/12.0) andName:@"rank" andText:@"RANK" andFontSize:fontSize];
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
    // if rank button was pressed, show rank in game center
    else if([node.name isEqualToString:@"rank"])
    {
        // user logged in to game center
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
        // user not logged in to game center
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
-(void)showBestScore:(int)fontSize
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

        bestScoreLabel.fontSize = fontSize;

        bestScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), (self.titleCollectable.position.y + self.titleCollectable.frame.size.height/2.0 + self.rankLogo.position.y)/2.0 );
        [self addChild:bestScoreLabel];
    }];
    [self runAction:showBestScore];
}
@end
