//
//  TKScrollingNode.h
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TKScrollingNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;
@property(nonatomic)SKSpriteNode * child;
+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerHeight:(float) height;
- (void) update:(NSTimeInterval)currentTime;

@end
