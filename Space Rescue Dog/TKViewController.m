//
//  TKViewController.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKViewController.h"
#import "TKTitleScene.h"
#import "TKUtil.h"

@interface TKViewController()
{
    BOOL _bannerIsVisible;
    ADBannerView *_adBanner;
}

-(void)authenticateLocalPlayer;
@property(nonatomic)NSString *leaderboardIdentifier;

@end

@implementation TKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //SKNode *testNode = [SKNode node];
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    // Create and configure the scene.
    TKTitleScene * scene = [TKTitleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:scene];
    [self authenticateLocalPlayer];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //HANDLE iAD
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0 - bannerHeight, bannerWidth, bannerHeight)];
    _adBanner.delegate = self;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    //@param:viewController - log in view controller if user is not already logged in
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        
        //not nil if the user is not authenticated
        //NEED to pause the game
        if (viewController != nil)
        {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else if([GKLocalPlayer localPlayer].authenticated)
            //the user is already authenticated
            {
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
        };
}
-(void)showLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    [self presentViewController:gcViewController animated:YES completion:nil];
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - banner
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBanner.superview == nil)
        {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the top of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        //set to 'YES' to animates only once at the beginning
        _bannerIsVisible = YES;
    }
}
//WHEN ad retrievel fails
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //if retrievel fails, then we slide the banner off the screen.
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the top of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        //set to 'NO' so when retrievel is successful next time, the banner slides back into view
        _bannerIsVisible = NO;
    }
}
-(void)showAds
{
    _adBanner.hidden = NO;
}
-(void)hideAds
{
    _adBanner.hidden = YES;
}
@end
