//
//  WXHHotSpot.m
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/18.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import "WXHHotSpot.h"
@interface WXHHotSpot ()
{
    UIImageView *_imageView;
}
@end
@implementation WXHHotSpot
@synthesize imageView = _imageView;

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _imageView.image = [UIImage imageNamed:@"热点-1"];
        _imageView.animationImages = @[[UIImage imageNamed:@"热点-1"],
                                       [UIImage imageNamed:@"热点-2"],
                                       [UIImage imageNamed:@"热点-3"],
                                       [UIImage imageNamed:@"热点-4"],
                                       [UIImage imageNamed:@"热点-5"],
                                       [UIImage imageNamed:@"热点-6"]];
        _imageView.animationDuration = 1.0;
        _imageView.animationRepeatCount = MAXFLOAT;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}
- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.delgate && [self.delgate respondsToSelector:@selector(hotSpotDidSelected:)]) {
        [self.delgate hotSpotDidSelected:self];
    }
}
- (void)setPosition:(SCNVector3)position scnView:(SCNView *)scnView
{
    _position = position;
    
    SCNVector3 screenPosition = [scnView projectPoint:position];
    self.imageView.center = CGPointMake(screenPosition.x, screenPosition.y);
    
    if (!self.imageView.superview) {
        [scnView addSubview:self.imageView];
    }
}
@end
