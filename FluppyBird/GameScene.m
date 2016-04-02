//
//  GameScene.m
//  FluppyBird
//
//  Created by Adriano on 4/2/16.
//  Copyright (c) 2016 Adriano. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property (nonatomic) SKSpriteNode * player;
@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
    
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"bird"];
        self.player.position = CGPointMake(100, 100);
        [self addChild:self.player];
        
    }
    return self;
}

@end
