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

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    //Note: Targeting iphone 6 landscape 667x375/1334x750
    self.backgroundColor = [SKColor whiteColor];
    
    //Add physicsBody to the scene which will trigger collision/contact on edges of the screen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    //Change gravity settings of the physics world
    self.physicsWorld.gravity = CGVectorMake(0, -.05);
    
    //Call custom method to build scene
    [self setScene];

    
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
    [self addChild:ground];
    
    //Add Building 1
    SKSpriteNode *building1 = [SKSpriteNode spriteNodeWithImageNamed:@"building1"];
    building1.position = CGPointMake(200,(building1.size.height/2)+ground.size.height);
    building1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:building1.frame.size];
    building1.physicsBody.dynamic = NO;
    building1.name = @"building1";
    [self addChild:building1];
    
    //Add Building 2
    SKSpriteNode *building2 = [SKSpriteNode spriteNodeWithImageNamed:@"building2"];
    building2.position = CGPointMake(285,(building2.size.height/2)+ground.size.height);
    building2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:building2.frame.size];
    building2.physicsBody.dynamic = NO;
    building2.name = @"building2";
    [self addChild:building2];
    
    //Add Building 3
    SKSpriteNode *building3 = [SKSpriteNode spriteNodeWithImageNamed:@"building3"];
    building3.position = CGPointMake(410,(building3.size.height/2)+ground.size.height);
    building3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:building3.frame.size];
    building3.physicsBody.dynamic = NO;
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
    [self addChild:player];
    
    
    // create the vector
    CGVector myVector = CGVectorMake(20, 20);
    // apply the vector
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
