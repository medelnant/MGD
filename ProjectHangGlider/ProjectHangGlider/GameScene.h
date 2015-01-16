//
//  GameScene.h
//  ProjectHangGlider
//
//  Michael Edelnant
//  Mobile Game Design Term 1501
//  Week 2 - Game Alpha
//
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate> {

    //Define time interval for handling delta time
    NSTimeInterval _dt;
    
    //Define time interval for us to set within the update method to capture last updated
    NSTimeInterval _lastFrameUpdateTimeInt;
    
}


//Define player spriteNode
@property (strong, nonatomic) SKSpriteNode *player;

//Define clouds BG element
@property (strong, nonatomic) SKSpriteNode *clouds;

//Define Sound Actions
@property (strong, nonatomic) SKAction *edgeBoing;
@property (strong, nonatomic) SKAction *buildingTick;
@property (strong, nonatomic) SKAction *groundSplat;
@property (strong, nonatomic) SKAction *buildingPunch;
@property (strong, nonatomic) SKAction *playerTouch;
@property (strong, nonatomic) SKAction *playerFlight;
@property (strong, nonatomic) SKAction *gamePauseTouch;

//AVAudioPlayer for background music
@property (strong, nonatomic) AVAudioPlayer *soundTrackPlayer;

//Define Label for welcome/instruction text
@property (strong, nonatomic) SKLabelNode *instructionLabel;
@property (strong, nonatomic) SKLabelNode *descriptionLabel;


@end
