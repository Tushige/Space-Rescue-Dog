//
//  TKViewController.h
//  Space Rescue Dog
//

//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface TKViewController : UIViewController<GKGameCenterControllerDelegate, ADBannerViewDelegate>

-(void)showLeaderboard;
- (void)bannerViewDidLoadAd:(ADBannerView *)banner;
-(void)hideAds;
-(void)showAds;

@end
