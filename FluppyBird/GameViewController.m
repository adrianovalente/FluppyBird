//
//  GameViewController.m
//  FluppyBird
//
//  Created by Adriano on 4/2/16.
//  Copyright (c) 2016 Adriano. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController() <GameSceneProtocol>
@property (weak, nonatomic) IBOutlet UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UIImageView *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *moreGamesButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) GameScene *gameScene;

@end

@implementation GameViewController

#pragma mark - Setup methods
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setupEverything];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupGameOverButtons];
}

-(void)setupEverything {
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    self.gameOverView.hidden = YES;
    skView.ignoresSiblingOrder = YES; // Some optimization
    
    self.gameScene = [GameScene sceneWithSize:skView.bounds.size];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    self.gameScene.gameOverDelegate = self;
    [skView presentScene:self.gameScene];
    [self.gameScene goToIdle];
}

-(void)setupGameOverButtons {
    [self.playButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayButtonTapped)]];
}

-(void)onPlayButtonTapped {
    [self.gameScene goToIdle];
    [self.gameOverView setHidden:YES];
}

#pragma mark - iOS config stuff
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Game Over Protocol
- (void)onGameOverEvent {
    [self.gameOverView setHidden:NO];
}



@end
