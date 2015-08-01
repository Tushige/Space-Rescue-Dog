//
//  TKGameplayScene.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKGameplayScene.h"
#import "TKScrollingNode.h"
#import "TKMeteoritesNode.h"
#import "TKMainCharacterNode.h"
#import "TKStepNode.h"
#import "TKUtil.h"
#import "TKCollectablesNode.h"
#import "TKHudNode.h"
#import "TKGameOverNode.h"
#import "TKGameData.h"
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>
#import "TKViewController.h"
#import "TKViewController.h"

@interface TKGameplayScene ()

@property(nonatomic)NSTimeInterval lastUpdateTimeInterval;
@property(nonatomic)NSTimeInterval timeSinceLastMeteorite;
@property(nonatomic)NSTimeInterval timeSinceLastCollectable;
@property(nonatomic)NSTimeInterval lastUpdateAI;
@property(nonatomic)NSTimeInterval totalGameTime;

@property(nonatomic)TKScrollingNode *background;
@property(nonatomic)TKMainCharacterNode *mainCharacter;
@property(nonatomic)TKMeteoritesNode *meteorite;
@property(nonatomic)TKCollectablesNode *collectable;
@property(nonatomic)TKStepNode *stepNode;
@property(nonatomic)TKHudNode *hud;
@property(nonatomic)TKGameOverNode *gameOverNode;
@property(nonatomic)TKGameData *gameData;

@property(nonatomic)double meteoriteScrollingDuration;
@property(nonatomic)NSInteger numberOfCollectablesCollected;
@property(nonatomic)NSInteger bestScore;
@property(nonatomic)NSInteger explosion_xOffset;
@property(nonatomic)NSInteger explosion_yOffset;
@property(nonatomic)double xFactor;
@property(nonatomic)double yFactor;
@property(nonatomic)BOOL doneCharacterSetup;
@property(nonatomic)BOOL doneCharacterDestruction;
@property(nonatomic)BOOL gameOver;
@property(nonatomic)BOOL restart;
@property(nonatomic)BOOL gameOverDisplay;
@property(nonatomic)BOOL turnedLeft;
@property(nonatomic)BOOL turnedRight;
@property(nonatomic)BOOL noTurn;

@property(nonatomic)SKLabelNode* complementLabel;
@property(nonatomic)SKLabelNode* gameoverLabel;
@property(nonatomic)SKLabelNode* restartLabel;
@property(nonatomic)SKLabelNode* pointLabel;

@property(nonatomic)SKAction *restartAction;

@property(nonatomic)SKTexture* dogLeft;
@property(nonatomic)SKTexture* dogRight;
@property(nonatomic)SKTexture* dogNormal;

@property(nonatomic)SKAction *takeOffSFX;
@property(nonatomic)SKAction *collectSFX;
@property(nonatomic)SKAction *gameOverSFX;
@property(nonatomic)SKAction *explodeSFX;
@property(nonatomic)SKAction* moveCharLeft;
@property(nonatomic)SKAction* moveCharRight;
@property(nonatomic)SKEmitterNode *smoke;

@property(nonatomic)AVAudioPlayer *backgroundMusic;

@end

@implementation TKGameplayScene

/*GLOBAL VARIABLES*/
CGSize dogLeft_size;
CGSize dogRight_size;
CGSize dogNormal_size;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])
    {
        //property initialization
        _lastUpdateTimeInterval = 0;
        self.lastUpdateAI = 0;
        self.totalGameTime = 0;
        self.timeSinceLastMeteorite = 0;
        self.timeSinceLastCollectable = 0;
        self.numberOfCollectablesCollected = 0;
        self.gameOverDisplay = NO;
        self.doneCharacterDestruction = NO;
        self.bestScore = 0;
        
        //mainCharacter position BOOL
        self.turnedLeft = NO;
        self.turnedRight = NO;
        self.noTurn = NO;
        
        //setup the anchor point of the scene
        self.anchorPoint = CGPointMake(0.5 , 0.5);
        
        //game scene physicsWorld setup
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        //indicates that self is a delegate of contactDelegate
        self.physicsWorld.contactDelegate = self;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        [self loadObjects];
    }
    return self;
}
-(void)loadObjects {
    int speed;
    
    //iPad UI
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _xFactor = 1;
        _yFactor = 1;
        _explosion_xOffset = self.frame.size.width/2.0;
        _explosion_yOffset = self.frame.size.height/2.0;
        self.meteoriteScrollingDuration = TKMeteoriteMovementDurationPAD;
        [self addBackground:TKScrollingSpeedPad];
        [self addHUD:TK_HUD_OFFSET_PAD andScoreFont:TK_SCORE_PAD];
        //sets up the gameOver display
        [self setGameovernode:TK_GAMEOVER_FONT_PAD];
        self.complementLabel.fontSize = TK_POINT_PAD;
        self.pointLabel.fontSize = TK_POINT_PAD;
        speed = TK_DOG_SPEED_PAD;
    }
    // iPhone UI
    else {
        _xFactor = self.frame.size.width / TK_img_x;
        _yFactor = self.frame.size.height / TK_img_y;
        _explosion_xOffset = 0;
        _explosion_yOffset = 0;
        self.meteoriteScrollingDuration = TKMeteoriteMovementDurationPhone;
        [self addBackground:TKScrollingSpeedPhone];
        [self addHUD:TK_HUD_OFFSET_IPHONE andScoreFont:TK_SCORE_PHONE];
        //sets up the gameOver display
        [self setGameovernode:TK_GAMEOVER_FONT_PHONE * _xFactor];
        self.complementLabel.fontSize = TK_POINT_PHONE;
        self.pointLabel.fontSize = TK_POINT_PHONE;
        speed = TK_DOG_SPEED_PHONE;
    }
    
    //3 types of dog images
    _dogLeft = [SKTexture textureWithImageNamed:@"rescueDog_left"];
    _dogRight = [SKTexture textureWithImageNamed:@"rescueDog_right"];
    _dogNormal = [SKTexture textureWithImageNamed:@"rescueDog_normal"];
    dogLeft_size = CGSizeMake(_dogLeft.size.width*_xFactor, _dogLeft.size.height*_xFactor);
    dogRight_size = CGSizeMake(_dogRight.size.width*_xFactor, _dogRight.size.height*_xFactor);
    dogNormal_size = CGSizeMake(_dogNormal.size.width*_xFactor, _dogNormal.size.height*_xFactor);
    
    [self addMainCharacter];
    //initializes the motion manager object
    self.motionManager = [[CMMotionManager alloc] init];
    [self startMonitoringAcceleration];
    
    //sound setup
    [self soundSetup];
    
    //initialize an object of gameData
    self.gameData = [TKGameData sharedGameData];
    
    //character movement setup
    self.moveCharLeft = [SKAction moveByX:-speed y:0 duration:0.001];
    self.moveCharRight = [SKAction moveByX:speed y:0 duration:0.001];
}
#pragma mark - creation of the spriteNodes
-(void)soundSetup
{
    //setup background musics
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    //plays infinitely
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    
    //sound effect setup
    self.takeOffSFX = [SKAction playSoundFileNamed:@"takeOff.caf" waitForCompletion:NO];
    self.gameOverSFX = [SKAction playSoundFileNamed:@"GameoverSound.caf" waitForCompletion:NO];
    self.collectSFX = [SKAction playSoundFileNamed:@"collectSound.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
}
-(void)didMoveToView:(SKView *)view
{
    [self.backgroundMusic play];
    
}
-(void)addBackground:(int)scrollingSpeed
{
    self.background = [TKScrollingNode scrollingNodeWithImageNamed:@"gameBackground" inFrame:self.frame];
    self.background.xScale = _xFactor;
    self.background.yScale = _yFactor;
    //adjust initial speed of meteorites based on device type
    self.meteoriteScrollingDuration = (double)(self.meteoriteScrollingDuration * _yFactor);
    self.background.name = @"background";
    //set the speed of scrolling
    [self.background setScrollingSpeed:scrollingSpeed];
    [self addChild:self.background];
}
-(void)addHUD:(int)hud_offset andScoreFont:(int)scoreFont
{
    self.hud = [TKHudNode hudAtPosition:CGPointMake(-self.frame.size.width/2.0, -self.frame.size.height /2.0 + hud_offset) inFrame:self.frame andScoreFont:scoreFont andOffset:hud_offset];
    [self addChild:self.hud];
}
-(void )setGameovernode:(int)fontSize
{
    //initializes the gameOverNode at the beginning of the game so there's no lag later on
    self.gameOverNode = [TKGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.height / 4.0) andFontSize:fontSize];
    self.gameOverNode.rankLogo.xScale = _xFactor;
    self.gameOverNode.rankLogo.yScale = _xFactor;
    self.gameOverNode.rankLogo.label.fontSize *= _xFactor;
}

-(void) addMeteorites
{
    // select between 2 different meteorites
    NSInteger randomNumber = [TKUtil randomWithMin:0 max:2];
    self.meteorite = [TKMeteoritesNode meteoriteInFrame:self.frame andType:randomNumber andScrollingDuration:self.meteoriteScrollingDuration];
    self.meteorite.xScale = _xFactor;
    self.meteorite.yScale = _xFactor;
    self.meteorite.zPosition = 20;
    [self addChild:self.meteorite];
    //randomize destination coordinates
    NSInteger randomX = [TKUtil randomWithMin:-self.frame.size.width / 2.0 max:self.frame.size.width / 2.0];
    [self.meteorite moveToPosition:CGPointMake(randomX, -self.frame.size.height)];
}
-(void)addMainCharacter
{
    //point on the step node
    CGPoint characterPosition = CGPointMake(0, -self.frame.size.height/2.0);
    //initialize the mainCharacter object
    self.mainCharacter = [TKMainCharacterNode mainCharacterAtPosition:characterPosition andFrame:self.frame];
    self.mainCharacter.fire.position = CGPointMake(self.mainCharacter.position.x, self.mainCharacter.position.y - self.mainCharacter.size.height / 2.0);
    self.mainCharacter.xScale = _xFactor;
    self.mainCharacter.yScale = _xFactor;
    //add it as a child to the game play scene
    [self addChild:self.mainCharacter];
    
    //move the character to the middle of the screen
    [self moveToMiddleOfScreen];
}
-(void)addCollectable
{
    self.collectable = [TKCollectablesNode collectableInFrame:self.frame];
    self.collectable.xScale = _xFactor;
    self.collectable.yScale = _xFactor;
    [self addChild:self.collectable];
    //chooses a random x coordinate as the destination point
    NSInteger randomX = [TKUtil randomWithMin:-self.frame.size.width / 2.0 max:self.frame.size.width / 2.0];
    [self.collectable moveToPosition:CGPointMake(randomX, -self.frame.size.height)];
}
#pragma mark - touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if 'Play Again' button touched, restart game
    if ([node.name isEqualToString:@"play again"])
    {
        [self restartGame];
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
//Handles nodes contact
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    CGPoint collidedAt;
    //first body will always have the lower value of TKCollisionCategory
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    //simulator version
    collidedAt = CGPointMake(contact.contactPoint.x - _explosion_xOffset, contact.contactPoint.y - _explosion_yOffset);
    //character collides with meteorite
    if(firstBody.categoryBitMask == TKCollisionCategoryCharacter && secondBody.categoryBitMask == TKCollisionCategoryMeteorite)
    {
        TKMeteoritesNode *meteorite = (TKMeteoritesNode *)secondBody.node;
        [meteorite removeFromParent];
        //[character removeFromParent];
        [self createExplosion:collidedAt];
        [self createSmoke:collidedAt];
        [self loseLife];
        [self runAction:self.explodeSFX];
    }
    //character collides with collectable
    else if(firstBody.categoryBitMask == TKCollisionCategoryCharacter && secondBody.categoryBitMask == TKCollisionCategoryCollectable)
    {
        TKCollectablesNode *collectable = (TKCollectablesNode *)secondBody.node;
        [collectable removeFromParent];
        [self performAnimationPoints:collidedAt];
        self.numberOfCollectablesCollected+=TKPoints;
        [self addPoints:TKPoints];
        
        //shows complement message on the screen depending on how many rescues have been made
        [self showComplement:collidedAt];
        
        //play sound effect
        [self runAction:self.collectSFX];
    }
}
#pragma mark - accelerometer

//starts obtaining accelerometer data if applicable
- (void)startMonitoringAcceleration
{
    //checks if accelerometer is available on the device
    if (self.motionManager.accelerometerAvailable) {
        
        //if available, start getting data
        [self.motionManager startAccelerometerUpdates];
    }
}
//called in the update method when game is over to stop collection of data
- (void)stopMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
    }
}

//moves the character based on accelerometer data
- (void)updateMainCharacterPositionFromMotionManager
{
    //data stored
    CMAccelerometerData* data = self.motionManager.accelerometerData;
    
    //turning left
    if ((data.acceleration.x) < -0.2) {
        //action to move the character to the left
        [self.mainCharacter runAction:self.moveCharLeft];
        if(!self.turnedLeft)
        {
            self.mainCharacter.size = dogLeft_size;
            self.mainCharacter.texture = _dogLeft;
            self.turnedLeft = YES;
            self.turnedRight = NO;
            self.noTurn = NO;
        }
    }
    //turning right
    else if((data.acceleration.x) > 0.2)
    {
        //action to move the character to the right
        [self.mainCharacter runAction:self.moveCharRight];
        if(!self.turnedRight)
        {
            self.mainCharacter.size = dogRight_size;
            self.mainCharacter.texture = _dogRight;
            self.turnedRight = YES;
            self.turnedLeft = NO;
            self.noTurn = NO;
        }
    }
    //no turn is made
    else
    {
        if(!self.noTurn)
        {
            self.mainCharacter.size = dogNormal_size;
            self.mainCharacter.texture = _dogNormal;
            self.noTurn = YES;
            self.turnedRight = NO;
            self.turnedLeft = NO;
        }
    }
}
#pragma mark - update
-(void)update:(NSTimeInterval)currentTime
{
    //background scolls only when game is 'NOT' over
    if(!self.gameOver)
    {
        //background parallax scrolling
        [self.background update:currentTime];
    }
    //execute game mechanics when character setup is completed and game is 'NOT' over
    if(self.doneCharacterSetup && !self.gameOver)
    {
        if(self.lastUpdateTimeInterval)
        {
            self.timeSinceLastMeteorite += currentTime - self.lastUpdateTimeInterval;
            self.timeSinceLastCollectable += currentTime - self.lastUpdateTimeInterval;
            
            //keeps track of the total game time.
            //used to make the game progressively harder
            _totalGameTime = _totalGameTime + currentTime - self.lastUpdateTimeInterval;
        }
        
        //spawns sprites according to a set of conditions
        [self spawnSprites];
        //GAME AI setup called every 10 seconds
        if(currentTime - self.lastUpdateAI >=7) {
            self.lastUpdateAI = currentTime;
            [self setupGameAI];
        }
        
        //records the time the update took place
        self.lastUpdateTimeInterval = currentTime;
        
        //accelerometer check
        [self updateMainCharacterPositionFromMotionManager];
        
        //prevents the main character from going off screen
        [self keepMainCharacterOnScreen];
        
        //smoke follows the character
        [self followCharacter];
    }
    //if game is over
    else if(self.gameOver)
    {
        
        //stops acquisition of accelerometer data upon game over
        [self stopMonitoringAcceleration];
        
        //updates the bestScore if the current score is higher
        self.gameData.bestScore = MAX(self.gameData.bestScore, self.hud.score);
        //saves all the data in the GameData class
        [self.gameData save];
        
        //GAME CENTER SCORE REPORTING
        //if the user is logged in and game is over, then send the best score to game center
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
                    [self reportScoreToGameCenter:self.hud.score andLeaderboardIdentifier:leaderboardIdentifier];
                }
            }];
        }
    }
    //calls gameOver only when game over is 'NOT' displayed and no lives are left.
    if(self.gameOver && !self.gameOverDisplay)
    {
        [self performGameOver];
    }
}
#pragma mark - helper methods
//prevents the character from going off screen
-(void)keepMainCharacterOnScreen
{
    //if character goes beyond left wall
    if(self.mainCharacter.position.x <= -self.frame.size.width / 2.0 + self.mainCharacter.size.width / 2.0)
    {
        self.mainCharacter.position =  CGPointMake(-self.frame.size.width /2.0 + self.mainCharacter.size.width / 2.0, self.mainCharacter.position.y);
    }
    //if character goes beyond right wall
    else if(self.mainCharacter.position.x >= self.frame.size.width / 2.0 - self.mainCharacter.size.width / 2.0)
    {
        self.mainCharacter.position =  CGPointMake(self.frame.size.width /2.0- self.mainCharacter.size.width / 2.0, self.mainCharacter.position.y);
    }
    if(self.mainCharacter.fire.position.x <=-self.frame.size.width / 2.0 + self.mainCharacter.size.width / 2.0)
    {
        self.mainCharacter.fire.position =CGPointMake(-self.frame.size.width /2.0 + self.mainCharacter.size.width / 2.0, self.mainCharacter.position.y);
    }
    else if(self.mainCharacter.fire.position.x >= self.frame.size.width / 2.0 - self.mainCharacter.size.width / 2.0)
    {
        self.mainCharacter.fire.position =  CGPointMake(self.frame.size.width /2.0- self.mainCharacter.size.width / 2.0, self.mainCharacter.position.y);
    }
}
//moves the main Character to the middle of the screen at the beginning of the game
-(void)moveToMiddleOfScreen
{
    [self runAction:self.takeOffSFX];
    SKAction *moveToMiddle = [SKAction moveTo:CGPointMake(0, 0) duration:1.0];
    [self.mainCharacter runAction:moveToMiddle completion:^{
        //allows the obstacles and collectables to begin scrolling
        self.doneCharacterSetup = YES;
    }];
}
#pragma mark - special effects
-(void)createExplosion:(CGPoint)position
{
    //specifies the 'sks' file path
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionFire" ofType:@"sks"];
    
    //unarchives the file specified by the path and gives it to explision(SKEmitterNode object)
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    
    //sets explosion's position to be = position of debris
    explosion.position = position;
    //display the explosion
    [self addChild:explosion];
    
    //removes the explosion after 2 seconds
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
}
-(void)createSmoke:(CGPoint)position
{
    //specifies the 'sks' file path
    NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"Smoke" ofType:@"sks"];
    
    //unarchives the file specified by the path and gives it to explision(SKEmitterNode object)
    self.smoke = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    
    //sets explosion's position to be = position of debris
    self.smoke.position = position;
    
    //display the explosion
    [self addChild:self.smoke];
    
    //removes the explosion after 2 seconds
    [self.smoke runAction:[SKAction waitForDuration:1.0] completion:^{
        SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.5];
        [self.smoke runAction:fadeOutAction completion:^{
            [self.smoke removeFromParent];
        }];
    }];
}
-(void)followCharacter
{
    SKAction *followCharacter = [SKAction moveTo:CGPointMake(self.mainCharacter.position.x, self.mainCharacter.position.y) duration:1.0];
    [self.smoke runAction:followCharacter];
    self.mainCharacter.fire.position = CGPointMake(self.mainCharacter.position.x, self.mainCharacter.position.y - self.mainCharacter.size.height / 2.0);
}
#pragma mark - points / GameOver
-(void)performGameOver
{
    [(TKViewController*)self.view.window.rootViewController  showAds];
    //main character exits the scene
    [self destroyMainCharacter];
    
    //game music stops
    [self.backgroundMusic stop];
   
    //game over music plays
    [self runAction:self.gameOverSFX];
    
    //sets restart property to 'YES' so the game can restart when player touches the screen
    self.restart = YES;
    
    //allows the game over display to appear
    self.gameOverDisplay = YES;
    [self addChild:self.gameOverNode];
    
    //pass in both the current score and best score to display upon game overs
    [self.gameOverNode performAnimation:self.hud.score andBestScore:self.gameData.bestScore];
}
-(void)restartGame
{
    if(self.restart)
    {
        [(TKViewController*)self.view.window.rootViewController  hideAds];
        //destroys the current scene and creates a new one
        for(SKNode *node in [self children])
        {
            if(![node.name  isEqual: @"background"])
            {
                [node removeFromParent];
            }
        }
        TKGameplayScene *newScene = [TKGameplayScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition fadeWithDuration:1.0];
        [self.view presentScene:newScene transition:transition];
    }
}
-(void)addPoints:(NSInteger)points
{
    [self.hud addPoints:points];
}
-(void)loseLife
{
    //subtracts a life bar
    [self.hud LoseLife];
    
     //returns true if number of lives = 0 and it's game over
    self.gameOver = [self.hud isGameOver];
}

#pragma mark - complements
-(void)showComplement:(CGPoint)position
{
    //change position since anchor point of label is different than character
    //position = CGPointMake(position.x-self.frame.size.width/2, position.y-self.frame.size.height/2);
    if(self.numberOfCollectablesCollected == 1)
    {
        [self performAnimationFirstSave:position];
    }
    if(self.numberOfCollectablesCollected == 3)
    {
        [self performAnimationNice:position];
    }
    if(self.numberOfCollectablesCollected == 7 | self.numberOfCollectablesCollected == 35)
    {
        [self performAnimationGreatJob:position];
    }
    if(self.numberOfCollectablesCollected == 12 | self.numberOfCollectablesCollected == 40)
    {
        [self performAnimationAwesome:position];
    }
    if(self.numberOfCollectablesCollected == 20 | self.numberOfCollectablesCollected == 50)
    {
        [self performAnimationAmazing:position];
    }
    if(self.numberOfCollectablesCollected == 30 | self.numberOfCollectablesCollected == 55)
    {
        [self performAnimationLegendary:position];
    }
    if(self.numberOfCollectablesCollected == 60)
    {
        [self performAnimationUltimateLegend:position];
    }
}
-(void)performAnimationFirstSave:(CGPoint)position
{
    self.complementLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.complementLabel.text = @"First Rescue!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor yellowColor];
    [self showComplement];
}
-(void)performAnimationNice:(CGPoint)position
{
    self.complementLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.complementLabel.text = @"Nice!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor yellowColor];
    [self showComplement];
}
-(void)performAnimationGreatJob:(CGPoint)position
{
    self.complementLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.complementLabel.text = @"Great Job!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor purpleColor];
    [self showComplement];
}
-(void)performAnimationAwesome:(CGPoint)position
{
    self.complementLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.complementLabel.text = @"AWESOME!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor redColor];
    [self showComplement];
}
-(void)performAnimationAmazing:(CGPoint)position
{
    self.complementLabel.text = @"AWESOME!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor redColor];
    [self showComplement];
}
-(void)performAnimationLegendary:(CGPoint)position
{
   // self.complementLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.complementLabel.text = @"Legendary!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor blueColor];
    [self showComplement];
}
-(void)performAnimationUltimateLegend:(CGPoint)position
{
   // self.complementLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.complementLabel.text = @"Ultimate Legend!";
    self.complementLabel.position = position;
    self.complementLabel.fontColor = [SKColor yellowColor];
    [self showComplement];
}
//shows points added when a collectable is collected
-(void)performAnimationPoints:(CGPoint)position
{
    self.pointLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    self.pointLabel.text = @"+1";
    self.pointLabel.fontColor = [UIColor yellowColor];
    self.pointLabel.position = position;
    [self showPoint];
}
-(void)showComplement
{
    SKAction *scaleUp = [SKAction scaleTo:1.4 duration:0.75];
    SKAction *fade = [SKAction fadeOutWithDuration:1.0];
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *sequence = [SKAction sequence:@[scaleUp, fade, wait]];
    [self addChild:self.complementLabel];
    
    [self.complementLabel runAction:sequence completion:^{
        [self.complementLabel removeFromParent];
    }];
}
-(void)showPoint
{
    SKAction *scaleUp = [SKAction scaleTo:1.4 duration:0.75];
    SKAction *fade = [SKAction fadeOutWithDuration:1.0];
    SKAction *moveLabel = [SKAction moveTo:CGPointMake(self.pointLabel.position.x, self.pointLabel.position.y + TKPointDistance) duration:0.5];
    [self addChild:self.pointLabel];
    [self.pointLabel runAction:moveLabel];
    [self.pointLabel runAction:scaleUp];
    [self.pointLabel runAction:fade completion:^{
        [self.pointLabel removeFromParent];
    }];
}
#pragma mark - sprite spawn mechanism
//called from the update method
-(void)spawnSprites
{
    if(self.timeSinceLastMeteorite > 0.8)
    {
        [self addMeteorites];
        self.timeSinceLastMeteorite = 0;
    }
    if(self.timeSinceLastCollectable > 1.0)
    {
        [self addCollectable];
        self.timeSinceLastCollectable = 0;
    }
}
#pragma mark - game AI setup
//makes the game progressively harder by increasing obstacle speed; called every 7 seconds
-(void)setupGameAI
{
    self.background.scrollingSpeed = self.background.scrollingSpeed + 1;
    self.meteoriteScrollingDuration = self.meteoriteScrollingDuration - 0.2;
}

#pragma mark - gameover main character destruction
-(void)destroyMainCharacter
{
    SKAction *destroyCharacter = [SKAction runBlock:^{
        [self.mainCharacter destroyMainCharacter];
    }];
    SKAction *wait = [SKAction waitForDuration:2.0];
    SKAction *sequence = [SKAction sequence:@[destroyCharacter, wait]];
    [self runAction:sequence completion:^{
        self.doneCharacterDestruction = YES;
    }];
    //set to nil to avoid contact with obstacles and collectables
    self.mainCharacter.physicsBody = nil;
}
#pragma mark - Game Center Score Reporting
-(void)reportScoreToGameCenter:(NSInteger)bestScore andLeaderboardIdentifier:(NSString *)leaderboardIdentifier
{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardIdentifier];
    score.value = bestScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
 
@end
