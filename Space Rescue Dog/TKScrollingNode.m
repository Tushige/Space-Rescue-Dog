//
//  TKScrollingNode.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKScrollingNode.h"
#import "TKUtil.h"
#import "TKMeteoritesNode.h"

@interface TKScrollingNode ()

@end
@implementation TKScrollingNode
/*
+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerHeight:(float) height
{
    //UIImage * image = [UIImage imageNamed:name];
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:name];
    
    TKScrollingNode * realNode = [TKScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(image.size.width, height)];
    realNode.scrollingSpeed = 100;
    realNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:realNode.frame];
    float total = 0;
    
    while(total<(height + image.size.height)){
        realNode.child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [realNode.child setAnchorPoint:CGPointMake(0.5, 0.5)];
        [realNode.child setPosition:CGPointMake(0, total)];
        [realNode addChild:realNode.child];
        total+=realNode.child.size.height;
    }
    
    return realNode;
}*/

+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerHeight:(float) height
{
    //UIImage * image = [UIImage imageNamed:name];
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:name];
    
    TKScrollingNode * realNode = [TKScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(image.size.width, height)];
    
    realNode.scrollingSpeed = 100;
    realNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:realNode.frame];
    float total = 0;
    
    while(total<(height + image.size.height)){
        realNode.child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [realNode.child setAnchorPoint:CGPointMake(0.5, 0.5)];
        [realNode.child setPosition:CGPointMake(0, total)];
        [realNode addChild:realNode.child];
        total+=realNode.child.size.height;
    }
    
    return realNode;
}
-(void)update:(NSTimeInterval)currentTime
{
    //SCROLLS THE BACKGROUND
    [self.children enumerateObjectsUsingBlock:^(SKSpriteNode * child, NSUInteger idx, BOOL *stop) {
     child.position = CGPointMake(child.position.x, child.position.y-self.scrollingSpeed);
     
     //if child is off screen
     //only half the image may show on the screen if the child is off screen
     if (child.position.y <= -child.size.height)
     {
         float delta = child.position.y+child.size.height;
         child.position = CGPointMake(child.position.x, child.size.height*(self.children.count-1)+delta);
     }
     }];
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
