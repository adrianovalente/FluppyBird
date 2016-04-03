//
//  GameScene.m
//  FluppyBird
//
//  Created by Adriano on 4/2/16.
//  Copyright (c) 2016 Adriano. All rights reserved.
//

#import "GameScene.h"
#define PIPES_VELOCITY 4
#define PIPES_COUNT 3
#define FIRST_PIPE_POSITION 600
#define DISTANCE_BETWEEN_PIPES 200

typedef enum {
    GameStatusIdle,
    GameStatusOver,
    GameStatusPlaying
} GameStatus;

@interface Bird : SKNode
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
    }
    return self;
}

@end

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) Bird * player;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) GameStatus status;
@property (nonatomic, strong) NSMutableArray *pipes;
@property (nonatomic, strong) NSMutableArray *topPipes;
@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor blueColor];
        self.status = GameStatusIdle;
        [self setupFloor:320];
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}

-(void)goToIdle {
    [self removeBird];
    [self setupBird];
    [self removeAllPipes];
    [self setStatus:GameStatusIdle];
}

-(void)initGame {
    [self setStatus:GameStatusPlaying];
    [self.player setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(26, 18)]];
    [self.player.physicsBody setMass: 0.1];
    [self.player.physicsBody setContactTestBitMask:0x1 << 1];
    [self.player.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.player.physicsBody applyImpulse:CGVectorMake(0, 40)];
    [self resetAllPipes];
}

-(void)resetAllPipes {
    [self removeAllPipes];
    [self initPipes];
}

-(void)initPipes {
    for(int i=0; i<PIPES_COUNT; i++) {
        
        int yPosition = [self getRandomYOffest];
        int xPosition = FIRST_PIPE_POSITION + i * DISTANCE_BETWEEN_PIPES;
        
        SKSpriteNode *pipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_bottom"];
        [pipe setAnchorPoint:CGPointZero];
        [pipe setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:pipe.frame]];
        [pipe.physicsBody setCategoryBitMask:0x1 << 1];
        pipe.position = CGPointMake(xPosition, yPosition);
        self.pipes[i] = pipe;
        [self addChild:pipe];
        
        SKSpriteNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_top"];
        [topPipe setAnchorPoint:CGPointZero];
        [topPipe setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:topPipe.frame]];
        [topPipe.physicsBody setCategoryBitMask:0x1 << 1];
        topPipe.position = CGPointMake(xPosition, 700 + yPosition);
        self.topPipes[i] = topPipe;
        [self addChild:topPipe];

    }
}

-(void)updatePipes {
    if(self.status == GameStatusPlaying) {
        for(int i=0; i<PIPES_COUNT; i++) {
            SKSpriteNode *pipe = (SKSpriteNode *)self.pipes[i];
            SKSpriteNode *topPipe = (SKSpriteNode *)self.topPipes[i];
            [self updateScoreIfNecessary:pipe.position.x];
            BOOL pipeIsGone = pipe.position.x < -70;
            int xPosition = pipeIsGone ? FIRST_PIPE_POSITION : pipe.position.x - PIPES_VELOCITY;
            int yPosition = pipeIsGone ? [self getRandomYOffest] : pipe.position.y;
            pipe.position = CGPointMake(xPosition, yPosition);
            
            topPipe.position = CGPointMake(xPosition, yPosition + 700);
            
        }
    }
}

-(void)updateScoreIfNecessary:(int)position {
    if(position < 155 && position > 150) [self.gameOverDelegate onPassBetweenPipes];
}

-(int)getRandomYOffest {
    return [self getRandomNumberBetween:-400 to:-200];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

-(void)removeAllPipes {
    [self removeChildrenInArray:self.pipes];
    [self removeChildrenInArray:self.topPipes];
    self.pipes = [NSMutableArray arrayWithArray:@[]];
    self.topPipes = [NSMutableArray arrayWithArray:@[]];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.status == GameStatusPlaying) {
        [self.player.physicsBody setVelocity:CGVectorMake(0, 0)];
        [self.player.physicsBody applyImpulse:CGVectorMake(0, 40)];
    } else if(self.status == GameStatusIdle){
        [self initGame];
    }
}

-(void)update:(NSTimeInterval)currentTime {
    self.player.zRotation = M_PI * self.player.physicsBody.velocity.dy * 0.0005;
    [self updatePipes];
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
    floor.zPosition = 2;
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
    if(self.status != GameStatusOver) [self.gameOverDelegate onGameOverEvent];
    [self setStatus:GameStatusOver];
}

@end
