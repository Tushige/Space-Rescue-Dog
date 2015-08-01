//
//  TKUtil.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/25/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKUtil.h"

@implementation TKUtil
+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max
{
    //max - min returns a number within that range
    //however, it might get below min, so we add min
    return arc4random() % (max - min) + min;
}
+(UIImage *) resizeWithImage:(UIImage *)img scale:(CGSize) newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
