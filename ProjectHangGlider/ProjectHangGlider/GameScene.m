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
    [self addChild:ground];
    
    //Add Building 1
    SKSpriteNode *building1 = [SKSpriteNode spriteNodeWithImageNamed:@"building1"];
    building1.position = CGPointMake(100,(building1.size.height/2)+ground.size.height);
    [self addChild:building1];
    
    //Add Building 2
    SKSpriteNode *building2 = [SKSpriteNode spriteNodeWithImageNamed:@"building2"];
    building2.position = CGPointMake(185,(building2.size.height/2)+ground.size.height);
    [self addChild:building2];
    
    //Add Building 3
    SKSpriteNode *building3 = [SKSpriteNode spriteNodeWithImageNamed:@"building3"];
    building3.position = CGPointMake(310,(building3.size.height/2)+ground.size.height);
    [self addChild:building3];
    
    //Add Player
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    player.position = CGPointMake(50, 250);
    [self addChild:player];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
