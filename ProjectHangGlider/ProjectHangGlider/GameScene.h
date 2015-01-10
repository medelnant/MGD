//
//  GameScene.h
//  ProjectHangGlider
//
//  Michael Edelnant
//  Mobile Game Design Term 1501
//  Week 1 - Proof
//
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate> 

//Define player spriteNode
@property (strong, nonatomic) SKSpriteNode *player;

//Define Sound Actions
@property (strong, nonatomic) SKAction *edgeBoing;
@property (strong, nonatomic) SKAction *buildingTick;
@property (strong, nonatomic) SKAction *groundSplat;
@property (strong, nonatomic) SKAction *buildingPunch;
@property (strong, nonatomic) SKAction *playerTouch;

//AVAudioPlayer for background music
@property (strong, nonatomic) AVAudioPlayer *soundTrackPlayer;

//Define Label for welcome/instruction text
@property (strong, nonatomic) SKLabelNode *instructionLabel;
@property (strong, nonatomic) SKLabelNode *descriptionLabel;


@end
