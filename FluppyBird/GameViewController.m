//
//  GameViewController.m
//  FluppyBird
//
//  Created by Adriano on 4/2/16.
//  Copyright (c) 2016 Adriano. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

#pragma mark - Setup methods
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setupEverything];
}

-(void)setupEverything {

    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    skView.ignoresSiblingOrder = YES; // Some optimizations!
    
    GameScene *scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

#pragma mark - iOS config stuff
- (BOOL)shouldAutorotate
{
    return YES;
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



@end
