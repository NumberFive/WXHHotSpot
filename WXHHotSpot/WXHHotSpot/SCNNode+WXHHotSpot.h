//
//  SCNNode+WXHHotSpot.h
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/18.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "WXHHotSpot.h"
#import "WXHHotSpotNode.h"

@interface SCNNode (WXHHotSpot)
@property (nonatomic, strong) NSMutableArray *hotSpotArray;

//如果是2D的热点需要在render的update里更新这个函数
- (void)updateHotSpotPosition:(SCNView *)scnView;

- (void)addHotSpot:(id)hot;
- (void)showHotSpot;
- (void)hiddenHotSpot;
@end
