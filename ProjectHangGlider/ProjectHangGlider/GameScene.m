//
//  GameScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Mobile Game Design Term 1501
//  Week 2 - Game Alpha
//
//  Created by vAesthetic on 1/8/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@end


//Define animation speed constants
static const float CLOUDS_PPS = 10;
//static const float BUILDINGS_PPS = 30;


// Define my constants for category bitmasks.
// These allow for us to determine which physics bodies collide within the physics world.
static const uint32_t playerCategory    = 1;
static const uint32_t buildingCategory  = 2;
static const uint32_t groundCategory    = 4;
static const uint32_t edgeCategory      = 8;

//define bool bit/flag to track firstTouch used to trigger startGamePlay method

@implementation GameScene
{
@private
    //Flag to account for first touch to init sequence.
    BOOL firstTouch;
    
    //Global pause bit/flag within game scene
    BOOL gamePaused;
}

//Default method for handling contact between different physics bodies(SpriteNodes)
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    // create placeholder reference for the "non player" object
    // This helps us quickly exclude the player and deal directly with objects that the player is colliding into.
    SKPhysicsBody *collisionObject;
    
    //Compare bitmask category numbers (having the player be cat=1 helps with this approach)
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        collisionObject = contact.bodyB;
    } else {
        collisionObject = contact.bodyA;
    }
    
    if (collisionObject.categoryBitMask == buildingCategory) {
        //NSLog(@"Building was hit!");
        [self runAction:_buildingTick];
    }
    
    if (collisionObject.categoryBitMask == edgeCategory) {
        //NSLog(@"Scene edge was hit!");
        //[self runAction:_edgeBoing];
        
    }
    
    if (collisionObject.categoryBitMask == groundCategory) {
        //NSLog(@"Ground was hit!");
        [self runAction:_groundSplat];
        
    }
    
}


//Default method called when scene is fully loaded i believe. Utilizing this for pre-loading audio.
-(void)didMoveToView:(SKView *)view {
    
    //Define sound actions for preloading when scene/view is loaded
    //Bit of a bummer that you can't set audio levels for playSoundFileNamed within SKAction :/
    //Suggestions online say to use AVAudioPlayer which doesn't meet the requirements for this assignment since we need to use proprietary SpriteKit methods to play audio
    
    _edgeBoing      = [SKAction playSoundFileNamed:@"boing.mp3" waitForCompletion:NO];
    _buildingTick   = [SKAction playSoundFileNamed:@"bulbbreaking.mp3" waitForCompletion:NO];
    _groundSplat    = [SKAction playSoundFileNamed:@"splat.mp3" waitForCompletion:NO];
    _buildingPunch  = [SKAction playSoundFileNamed:@"punch.mp3" waitForCompletion:NO];
    _gamePauseTouch = [SKAction playSoundFileNamed:@"camerashutter.mp3" waitForCompletion:NO];
    _playerFlight   = [SKAction playSoundFileNamed:@"woosh.mp3" waitForCompletion:NO];
    
}

//Default method - main init trigger from view controller instatiating scene to load.
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Note: Targeting iphone 6 landscape 667x375/1334x750
        self.backgroundColor = [SKColor whiteColor];
    
        //Add physicsBody to the scene which will trigger collision/contact on edges of the screen
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        
        //Need to set contact delegate to self in order to register contacts
        self.physicsWorld.contactDelegate = self;
    
        //Call custom method to build scene
        [self setScene];
        
    }
    return self;
}

//Custom method for building the entire scene
-(void)setScene {
    
    //Instruction Text
    _instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    _instructionLabel.text = @"Click anywhere to start";
    _instructionLabel.fontColor = [SKColor blackColor];
    _instructionLabel.fontSize = 25;
    _instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 250);
    [self addChild:_instructionLabel];
    
    //Description Text
    _descriptionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Light"];
    _descriptionLabel.text = @"Make sure to touch buildings and player(Joe Hanglider) for required sound effects.";
    _descriptionLabel.fontColor = [SKColor blackColor];
    _descriptionLabel.fontSize = 10;
    _descriptionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 235);
    [self addChild:_descriptionLabel];
    
    
    //Add Background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //Add Clouds
    _clouds = [SKSpriteNode spriteNodeWithImageNamed:@"clouds"];
    _clouds.position = CGPointMake(CGRectGetMidX(self.frame),(self.frame.size.height-_clouds.size.height)-20);
    _clouds.alpha = .5;
    _clouds.name = @"clouds";
    [self addChild:_clouds];
    
    //Add Ground
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.position = CGPointMake(CGRectGetMidX(self.frame),ground.size.height/2);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.frame.size];
    ground.physicsBody.dynamic = NO;
    ground.physicsBody.categoryBitMask = groundCategory;
    [self addChild:ground];
    
    //Add Building 1
    SKSpriteNode *building1 = [SKSpriteNode spriteNodeWithImageNamed:@"building1"];
    building1.position = CGPointMake(200,(building1.size.height/2)+ground.size.height);
    building1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:building1.frame.size];
    building1.physicsBody.dynamic = NO;
    building1.physicsBody.categoryBitMask = buildingCategory;
    building1.name = @"building1";
    [self addChild:building1];
    
    //Add Building 2
    SKSpriteNode *building2 = [SKSpriteNode spriteNodeWithImageNamed:@"building2"];
    building2.position = CGPointMake(285,(building2.size.height/2)+ground.size.height);
    building2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:building2.frame.size];
    building2.physicsBody.dynamic = NO;
    building2.physicsBody.categoryBitMask = buildingCategory;
    building2.name = @"building2";
    [self addChild:building2];
    
    //Add Building 3
    SKSpriteNode *building3 = [SKSpriteNode spriteNodeWithImageNamed:@"building3"];
    building3.position = CGPointMake(410,(building3.size.height/2)+ground.size.height);
    building3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:building3.frame.size];
    building3.physicsBody.dynamic = NO;
    building3.physicsBody.categoryBitMask = buildingCategory;
    building3.name = @"building3";
    [self addChild:building3];
    
    //Add Player
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    _player.position = CGPointMake(CGRectGetMidX(self.frame), 300);
    _player.name = @"player";
    _player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_player.frame.size.width/2];
    _player.physicsBody.friction = 0;
    _player.physicsBody.linearDamping = 0;
    _player.physicsBody.restitution = 1.0f;
    _player.physicsBody.categoryBitMask = playerCategory;
    _player.physicsBody.contactTestBitMask = edgeCategory | buildingCategory | groundCategory;
    [self addChild:_player];
    
    //Add Pause Button
    SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
    pauseButton.position = CGPointMake((self.frame.size.width -25),ground.size.height + 20);
    pauseButton.name = @"pauseButton";
    [self addChild:pauseButton];
    
    
}

//Default method to account for touches within the scene
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*
    Looping through all nodes at the touch point. My understanding is that this becomes troublesome
    with parent & child node relationships but works for this assignment.
    Same applies for overlapping nodes.
        -- Will fire touch event for all nodes at that given touch point
    */
    
    if(firstTouch == NO) {
        NSLog(@"firstTouch! - call startGamePlay method");
        [self startGamePlay];
        firstTouch = YES;
    }
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        NSArray *spriteNodes = [self nodesAtPoint:touchPoint];
        
        if ([spriteNodes count])
        {
            for (SKNode *spriteNode in spriteNodes)
            {
                if ([spriteNode.name isEqualToString:@"building1"])
                {
                    //Building 1
                    //NSLog(@"Building1 Clicked!");
                    [self runAction:_buildingPunch];
                }
                else if ([spriteNode.name isEqualToString:@"building2"])
                {
                    //Building2
                    //NSLog(@"Building2 Clicked!");
                    [self runAction:_buildingPunch];
                }
                else if ([spriteNode.name isEqualToString:@"building3"])
                {
                    //Building3
                    //NSLog(@"Building3 Clicked!");
                    [self runAction:_buildingPunch];
                }
                else if ([spriteNode.name isEqualToString:@"player"])
                {
                    //Player
                    //NSLog(@"Player Clicked!");
                    [self runAction:_playerTouch];
                }
                else if ([spriteNode.name isEqualToString:@"pauseButton"])
                {
                    [self runAction:_gamePauseTouch];
                    [self togglePauseGame];
                    
                    
                }
                else {
                    // create the vector to apply to player
                    CGVector myVector = CGVectorMake(0, 15);
                    // apply the vector as an impulse to launch player to bouncy land.
                    [_player.physicsBody applyImpulse:myVector];
                    [self runAction:_playerFlight];
                }
            }
        }
    }
    
    
}

//Custom method to init gameplay sequence. Otherwise it would be more annoying than it already is.
-(void)startGamePlay {
    
    //Remove SKLabelNodes from scene
    [_instructionLabel removeFromParent];
    [_descriptionLabel removeFromParent];
    
    //Trigger Background music to start playing
    [self playBackgroundAudioTrack];
    
    //Set world gravity
    //Change gravity settings of the physics world
    self.physicsWorld.gravity = CGVectorMake(0, -1.5);
}

//Custom method to play background audio track
-(void)playBackgroundAudioTrack {
    
    //Play Soundtrack/Background Music utilizing AVFoundation AVAudioPlayer
    
    //Specify url of file location
    NSURL * soundTrackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"soundtrack" ofType:@"mp3"]];
    
    //Alloc init and set track for player to play
    _soundTrackPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundTrackURL error:nil];
    
    //Specify num of loops (negative number means infinite loops)
    _soundTrackPlayer.numberOfLoops = -1;
    
    //Set Volumne to be substantially lower
    _soundTrackPlayer.volume = .25;
    
    //Play background audio track
    [_soundTrackPlayer play];
    
}

//Custom Helper Method for Animating Clouds right to left
-(void) scrollClouds {
    
    //For each instance or child node with the name of clouds...do something
    //Similar to a loop construct but simply enumerating through all instances of provided name.
    [self enumerateChildNodesWithName:@"clouds" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Placeholder node that will be set to the node being enumerated.
        SKSpriteNode *clouds = (SKSpriteNode*) node;
        
        //Setting the speed/velocity of the node. Only affecting the x for the horizontal scrolling effect
        CGPoint bgVelocity = CGPointMake((-1) * CLOUDS_PPS, 0);
        
        //Calculated point
        CGPoint distanceToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        clouds.position = CGPointAdd(clouds.position, distanceToMove);
        
        
        //Check if position is past left edge of scene
        //Buggy.. needs to be readdressed
        if(clouds.position.x <= -self.size.width) {
            //NSLog(@"We are moving past that certain point!");
        }
        
        
    }];
    
}

//Custom Helper Methods
//found via Ray Wenderlich forums/articles
static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b) {
    return CGPointMake(a.x * b,a.y *b);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

//Custom method for pausing the game
-(void) togglePauseGame {
    
    if(gamePaused) {
        gamePaused = NO;
        NSLog(@"Game already paused. Unpausing!");
        self.scene.physicsWorld.speed = 1.0;
        self.scene.view.paused = NO;
        
        //Play Game Background Music
        if(![_soundTrackPlayer isPlaying]) {
            [_soundTrackPlayer play];
        }
        
    } else {
        NSLog(@"Pausing Game!");
        gamePaused = YES;
        self.scene.physicsWorld.speed = 0.0;
        self.scene.view.paused = YES;
        
        //Pause Game Background Music
        if([_soundTrackPlayer isPlaying]) {
            [_soundTrackPlayer pause];
        }
    }
}


//Default Method called at each frame interval
-(void)update:(CFTimeInterval)currentTime {
    
    //Conditional to set the deltaTime
    if(_lastFrameUpdateTimeInt) {
        _dt = currentTime - _lastFrameUpdateTimeInt;
    } else {
        _dt = 0;
    }
    
    //Capture the time for use on next user for lastFrameUpdateTimeInt
    _lastFrameUpdateTimeInt = currentTime;
    
    //Call Methods I want to update
    [self scrollClouds];
    
}

@end
