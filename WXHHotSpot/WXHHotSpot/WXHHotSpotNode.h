//
//  WXHHotSpotNode.h
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/19.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "SCNVector3Extensions.h"

@interface WXHHotSpotNode : SCNNode
@property (nonatomic, assign) SCNVector3 normal;
- (void)setPosition:(SCNVector3)position normal:(SCNVector3)normal scnView:(SCNView *)scnView;
- (void)playAnimation;
- (void)stopAnimation;
@end
