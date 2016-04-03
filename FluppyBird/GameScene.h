//
//  GameScene.h
//  FluppyBird
//

//  Copyright (c) 2016 Adriano. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GameSceneProtocol <NSObject>
-(void)onGameOverEvent;
@end

@interface GameScene : SKScene

@property (nonatomic) id<GameSceneProtocol> gameOverDelegate;
-(void)goToIdle;

@end