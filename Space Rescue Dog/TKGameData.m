//
//  TKGameData.m
//  Space Rescue Dog
//
//  Created by Tushig Ochirhkuyag on 7/30/14.
//  Copyright (c) 2014 Tuke Entertainment. All rights reserved.
//

#import "TKGameData.h"
#import "TKUtil.h"

@implementation TKGameData

//boilerplate Objective-C implementation for the singleton pattern
+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}
#pragma mark - data persistency
//helper method to construct file path to store game data
+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}
-(instancetype)initWithCoder:(NSCoder *)decoder
{
    self=[self init];
    if(self)
    {
        self.bestScore = [decoder decodeIntegerForKey:TKBestScore];
        self.playerName = [decoder decodeObjectForKey:TKPlayerName];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.bestScore forKey: TKBestScore];
    [encoder encodeObject:self.playerName forKey:TKPlayerName];
}
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [TKGameData filePath]];
    if (decodedData) {
        TKGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[TKGameData alloc] init];
}
//need to call this after any changes are made to bestScore to persist data between launches
-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[TKGameData filePath] atomically:YES];
}

@end
