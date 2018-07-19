//
//  SCNNode+WXHHotSpot.m
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/18.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import "SCNNode+WXHHotSpot.h"
#import <objc/runtime.h>
#import "SCNVector3Extensions.h"

static char const * const KWXHHotSpotArray = "KWXHHotSpotArray";

@implementation SCNNode (WXHHotSpot)
- (void)updateHotSpotPosition:(SCNView *)scnView
{
    if ([self.hotSpotArray count]) {
        
        for (id hot in self.hotSpotArray) {
            if ([hot isKindOfClass:[WXHHotSpot class]]) {
                WXHHotSpot *hotSpot = (WXHHotSpot *)hot;
                
                SCNVector3 hotSpotPosition = [scnView.scene.rootNode convertVector:hotSpot.position fromNode:self];
                SCNVector3 screenPosition = [scnView projectPoint:hotSpotPosition];
                hotSpot.imageView.center = CGPointMake(screenPosition.x, screenPosition.y);
                
                //添加透明度和alpha的映射
//                SCNVector3 cameraPosition = scnView.pointOfView.worldPosition;
//                SCNVector3 objectPosition = self.worldPosition;
//
//                SCNVector3 v1 = SCNVector3Normalize(SCNVector3Sub(objectPosition, hotSpotPosition));
//                SCNVector3 v2 = SCNVector3Normalize(SCNVector3Sub(objectPosition, cameraPosition));
//
//                CGFloat radian = SCNVector3DotProduct(v1, v2);  //计算叉乘
//                radian = acosf(radian);//计算弧度
//                radian = 1 - radian / M_PI; //把弧度0~2π映射到1~0
//
//                CGFloat alpha = radian + 0.05;
//                CGFloat scale = radian + 0.3;
//
//                hotSpot.imageView.alpha = alpha;
//                hotSpot.imageView.transform = CGAffineTransformMakeScale(scale, scale);
            }
        }
    }
}
- (void)addHotSpot:(id)hot
{
    [self.hotSpotArray addObject:hot];
    
    if ([hot isKindOfClass:[WXHHotSpot class]]) {
//        WXHHotSpot *hotSpot = (WXHHotSpot *)hot;
    } else if ([hot isKindOfClass:[WXHHotSpotNode class]]){
        WXHHotSpotNode *node = (WXHHotSpotNode *)hot;
        [self addChildNode:node];
    }
}
- (void)showHotSpot
{
    if ([self.hotSpotArray count]) {
        for (id hot in self.hotSpotArray) {
            if ([hot isKindOfClass:[WXHHotSpot class]]) {
                WXHHotSpot *hotSpot = (WXHHotSpot *)hot;
                hotSpot.imageView.hidden = NO;
                [hotSpot.imageView startAnimating];
            } else if ([hot isKindOfClass:[WXHHotSpotNode class]]){
                WXHHotSpotNode *node = (WXHHotSpotNode *)hot;
                node.hidden = NO;
                [node playAnimation];
            }
        }
    }
}
- (void)hiddenHotSpot
{
    if ([self.hotSpotArray count]) {
        for (id hot in self.hotSpotArray) {
            if ([hot isKindOfClass:[WXHHotSpot class]]) {
                WXHHotSpot *hotSpot = (WXHHotSpot *)hot;
                hotSpot.imageView.hidden = YES;
                [hotSpot.imageView stopAnimating];
            } else if ([hot isKindOfClass:[WXHHotSpotNode class]]){
                WXHHotSpotNode *node = (WXHHotSpotNode *)hot;
                node.hidden = YES;
                [node stopAnimation];
            }
        }
    }
}

#pragma mark - Setter / Getter
- (void)setHotSpotArray:(NSMutableArray *)hotSpotArray
{
    objc_setAssociatedObject(self, KWXHHotSpotArray, hotSpotArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)hotSpotArray
{
    NSMutableArray *array = objc_getAssociatedObject(self, KWXHHotSpotArray);
    if (!array) {
        array = [NSMutableArray array];
        [self setHotSpotArray:array];
    }
    return array;
}

@end
