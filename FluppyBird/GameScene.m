//
//  GameScene.m
//  FluppyBird
//
//  Created by Adriano on 4/2/16.
//  Copyright (c) 2016 Adriano. All rights reserved.
//

#import "GameScene.h"

typedef enum {
    GameStatusIdle,
    GameStatusOver,
    GameStatusPlaying
} GameStatus;

@interface Bird : SKNode
//-(void)jump;
@end

@implementation Bird

-(id)init {
    if((self = (Bird *)[SKSpriteNode spriteNodeWithImageNamed:@"b1"])) {
        SKAction *flap = [SKAction
          animateWithTextures:
            @[
            [SKTexture textureWithImageNamed:@"b1"],
            [SKTexture textureWithImageNamed:@"b2"],
            [SKTexture textureWithImageNamed:@"b3"],
            [SKTexture textureWithImageNamed:@"b2"]
            ]
          timePerFrame:0.25];
        [self runAction:[SKAction repeatActionForever:flap]];
        [self setXScale:0.6];
        [self setYScale:0.6];
        [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(26, 18)]];
        self.physicsBody.mass = 0.1;
        self.physicsBody.contactTestBitMask = 0x1 << 1;
    }
    return self;
}

@end

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) Bird * player;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) GameStatus status;
@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor blueColor];
        self.status = GameStatusIdle;
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}

-(void)initGame {
    [self setupFloor:320];
    [self setupBird];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.status == GameStatusPlaying) {
        [self.player.physicsBody setVelocity:CGVectorMake(0, 0)];
        [self.player.physicsBody applyImpulse:CGVectorMake(0, 40)];
    } else {
        [self removeBird];
        [self setStatus:GameStatusPlaying];
        [self initGame];
    }
}

-(void)update:(NSTimeInterval)currentTime {
    self.player.zRotation = M_PI * self.player.physicsBody.velocity.dy * 0.0005;
}



-(void)setupBird {
    self.player = [Bird new];
    self.player.position = CGPointMake(self.size.width/2, 300);
    [self addChild:self.player];
}

-(void)setupFloor:(int)screenWidth {
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor"];
    floor.xScale = 2;
    [floor setAnchorPoint:CGPointZero];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    [floor.physicsBody setCategoryBitMask:0x1 << 1];
    [self addChild:floor];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    [self gameOver];
}

-(void)removeBird {
    if(self.player && self.player != nil) {
        [self removeChildrenInArray:@[self.player]];
        self.player = nil;
    }
}

-(void)gameOver {
    [self setStatus:GameStatusOver];
}

@end
