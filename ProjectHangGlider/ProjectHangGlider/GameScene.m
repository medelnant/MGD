//
//  GameScene.m
//  ProjectHangGlider
//
//  Michael Edelnant
//  Mobile Game Design Term 1501
//  Week 1 - Proof
//
//  Created by vAesthetic on 1/8/15.
//  Copyright (c) 2015 medelnant. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@end

// Define my constants for category bitmasks.
// These allow for us to determine which physics bodies collide within the physics world.
static const uint32_t playerCategory    = 1;
static const uint32_t buildingCategory  = 2;
static const uint32_t groundCategory    = 4;
static const uint32_t edgeCategory      = 8;

@implementation GameScene


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
        NSLog(@"Building was hit!");
        //  SKAction *playSFX = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
        // [self runAction:playSFX];
    }
    
    if (collisionObject.categoryBitMask == edgeCategory) {
        NSLog(@"Scene edge was hit!");
        // SKAction *playSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        //  [self runAction:playSFX];
        
    }
    
    if (collisionObject.categoryBitMask == groundCategory) {
        NSLog(@"Ground was hit!");
        // SKAction *playSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        //  [self runAction:playSFX];
        
    }
    
}


//Not using didMoveToView. Instead refer to initWithSize method.
-(void)didMoveToView:(SKView *)view {

}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Note: Targeting iphone 6 landscape 667x375/1334x750
        self.backgroundColor = [SKColor whiteColor];
    
        //Add physicsBody to the scene which will trigger collision/contact on edges of the screen
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
    
        //Change gravity settings of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, -.05);
        
        //Need to set contact delegate to self in order to register contacts
        self.physicsWorld.contactDelegate = self;
    
        //Call custom method to build scene
        [self setScene];
    }
    return self;
}


-(void)setScene {
    
    //Add Background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //Add Clouds
    SKSpriteNode *clouds = [SKSpriteNode spriteNodeWithImageNamed:@"clouds"];
    clouds.position = CGPointMake(CGRectGetMidX(self.frame),(self.frame.size.height-clouds.size.height)-20);
    clouds.alpha = .5;
    [self addChild:clouds];
    
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
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    player.position = CGPointMake(50, 250);
    player.name = @"player";
    player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.frame.size.width/2];
    player.physicsBody.friction = 0;
    player.physicsBody.linearDamping = 0;
    player.physicsBody.restitution = 1.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.contactTestBitMask = edgeCategory | buildingCategory | groundCategory;
    
    
    
    [self addChild:player];
    
    
    
    // create the vector to apply to player
    CGVector myVector = CGVectorMake(20, 20);
    // apply the vector as an impulse to launch player to bouncy land.
    [player.physicsBody applyImpulse:myVector];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*
    Looping through all nodes at the touch point. My understanding is that this becomes troublesome
    with parent & child node relationships but works for this assignment.
    Same applies for overlapping nodes.
        -- Will fire touch event for all nodes at that given touch point
    */
    
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
                    NSLog(@"Building1 Clicked!");
                }
                else if ([spriteNode.name isEqualToString:@"building2"])
                {
                    //Building2
                    NSLog(@"Building2 Clicked!");
                }
                else if ([spriteNode.name isEqualToString:@"building3"])
                {
                    //Building3
                    NSLog(@"Building3 Clicked!");
                }
                else if ([spriteNode.name isEqualToString:@"player"])
                {
                    //Player
                    NSLog(@"Player Clicked!");
                }
                else {
                    //Do nothing
                }
            }
        }
    }
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
