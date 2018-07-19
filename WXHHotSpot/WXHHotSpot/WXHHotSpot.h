//
//  WXHHotSpot.h
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/18.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@class WXHHotSpot;

@protocol WXHHotSpotDelegate <NSObject>
- (void)hotSpotDidSelected:(WXHHotSpot *)hotSpot;
@end

@interface WXHHotSpot : NSObject
@property (nonatomic, assign, readonly) SCNVector3 position;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, weak) id<WXHHotSpotDelegate> delgate;

- (void)setPosition:(SCNVector3)position scnView:(SCNView *)scnView;
@end


