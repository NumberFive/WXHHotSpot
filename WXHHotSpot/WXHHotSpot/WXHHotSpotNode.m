//
//  WXHHotSpotNode.m
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/19.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import "WXHHotSpotNode.h"
@interface WXHHotSpotNode ()
@property (nonatomic, strong) SCNNode *dotNode;
@property (nonatomic, strong) SCNNode *circleNode;
@end
@implementation WXHHotSpotNode
+ (instancetype)node
{
    WXHHotSpotNode *node = [[WXHHotSpotNode alloc] init];
    return node;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildNode:self.dotNode];
        [self addChildNode:self.circleNode];
        self.dotNode.position = SCNVector3Make(0, 0, 0.0001);
    }
    return self;
}
- (void)playAnimation
{
    CAKeyframeAnimation *dotAnimation = [CAKeyframeAnimation animation];
    dotAnimation.keyPath = @"scale";
    dotAnimation.values = @[[NSValue valueWithSCNVector3:SCNVector3Make(1.0, 1.0, 1.0)],
                            [NSValue valueWithSCNVector3:SCNVector3Make(1.1, 1.1, 1.1)],
                            [NSValue valueWithSCNVector3:SCNVector3Make(1.2, 1.2, 1.2)],
                            [NSValue valueWithSCNVector3:SCNVector3Make(1.2, 1.2, 1.2)],
                            [NSValue valueWithSCNVector3:SCNVector3Make(1.0, 1.0, 1.0)]];
    
    dotAnimation.duration = 1.0;
    dotAnimation.repeatCount = MAXFLOAT;
    [self.dotNode addAnimation:dotAnimation forKey:@"DotAnimation"];
    
    CAKeyframeAnimation *circleAnimation = [CAKeyframeAnimation animation];
    circleAnimation.keyPath = @"scale";
    
    circleAnimation.values = @[[NSValue valueWithSCNVector3:SCNVector3Make(1.0, 1.0, 1.0)],
                               [NSValue valueWithSCNVector3:SCNVector3Make(1.3, 1.3, 1.3)],
                               [NSValue valueWithSCNVector3:SCNVector3Make(1.5, 1.5, 1.5)],
                               [NSValue valueWithSCNVector3:SCNVector3Make(1.5, 1.5, 1.5)],
                               [NSValue valueWithSCNVector3:SCNVector3Make(1.6, 1.6, 1.6)],
                               [NSValue valueWithSCNVector3:SCNVector3Make(1.0, 1.0, 1.0)]];
    
    circleAnimation.duration = 1.0;
    circleAnimation.repeatCount = MAXFLOAT;
    [self.circleNode addAnimation:circleAnimation forKey:@"CircleAnimation"];
}

- (void)stopAnimation
{
    [self.dotNode removeAllAnimations];
    [self.circleNode removeAllAnimations];
}

- (void)setPosition:(SCNVector3)position normal:(SCNVector3)normal scnView:(SCNView *)scnView
{
    self.worldPosition = position;
    
    SCNVector3 objectNormal = normal;
    SCNVector3 hotspotNormal = SCNVector3Make(0, 0, 1);
    
    objectNormal = SCNVector3Normalize(objectNormal);
    hotspotNormal = SCNVector3Normalize(hotspotNormal);
    
    CGFloat radian = SCNVector3DotProduct(hotspotNormal, objectNormal);  //计算叉乘
    radian = acosf(radian);//计算弧度
    SCNVector3 crossProduct = SCNVector3CrossProduct(hotspotNormal, objectNormal);
    
    self.rotation = SCNVector4Make(crossProduct.x, crossProduct.y, crossProduct.z, radian);
    
    CGFloat space = 0.001;
    self.worldPosition = SCNVector3Add(self.worldPosition, SCNVector3MulNunber(objectNormal, space));
}


- (SCNNode *)dotNode
{
    if (!_dotNode) {
        _dotNode = [SCNNode node];
        _dotNode.geometry = [SCNPlane planeWithWidth:0.003 height:0.003];
        _dotNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
        _dotNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"hotSpot_1"];
    }
    return _dotNode;
}
- (SCNNode *)circleNode
{
    if (!_circleNode) {
        _circleNode = [SCNNode node];
        _circleNode.geometry = [SCNPlane planeWithWidth:0.005 height:0.005];
        _circleNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
        _circleNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"hotSpot_2"];
    }
    return _circleNode;
}
@end
