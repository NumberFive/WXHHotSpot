//
//  ViewController.m
//  WXHHotSpot
//
//  Created by 伍小华 on 2018/7/18.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import "SCNNode+WXHHotSpot.h"

@interface ViewController ()<SCNSceneRendererDelegate,WXHHotSpotDelegate>
@property (nonatomic, strong) SCNView *scnView;
@property (nonatomic, strong) SCNNode *rootNode;
@property (nonatomic, strong) SCNNode *objectNode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scnView];
    self.scnView.frame = self.view.bounds;
    
    self.objectNode = [SCNNode node];
    self.objectNode.geometry = [SCNBox boxWithWidth:0.1 height:0.1 length:0.1 chamferRadius:0];
    self.objectNode.geometry.firstMaterial.diffuse.contents = [UIColor brownColor];
    [self.rootNode addChildNode:self.objectNode];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.scnView addGestureRecognizer:tapGesture];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height - 40 - 20, 80, 40);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"show" forState:UIControlStateNormal];
    [button setTitle:@"hidden" forState:UIControlStateSelected];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.objectNode showHotSpot];
    } else {
        [self.objectNode hiddenHotSpot];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.scnView];
    
    NSArray *hitTestReaults = [self.scnView hitTest:point options:nil];
    if ([hitTestReaults count]) {
        SCNHitTestResult *hitTestResult = hitTestReaults.firstObject;
        
        SCNVector3 worldNormal = hitTestResult.worldNormal;
        SCNVector3 position = hitTestResult.worldCoordinates;
        
        //添加3D的热点
//        WXHHotSpotNode *hotSpotNode = [WXHHotSpotNode node];
//        [self.objectNode addHotSpot:hotSpotNode];
//        [hotSpotNode setPosition:position normal:worldNormal scnView:self.sceneView];
        
        //添加2D的热点
        WXHHotSpot *hotSpot = [[WXHHotSpot alloc] init];
        [self.objectNode addHotSpot:hotSpot];
        [hotSpot setPosition:position scnView:self.scnView];
    }
}

#pragma mark - SCNSceneRendererDelegate
- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.objectNode updateHotSpotPosition:self.scnView];
    }];
}
#pragma mark - WXHHotSpotDelegate
- (void)hotSpotDidSelected:(WXHHotSpot *)hotSpot
{
    SCNVector3 position = hotSpot.position;
}
#pragma mark - Setter / Getter
- (SCNView *)scnView
{
    if (!_scnView) {
        _scnView = [[SCNView alloc] init];
        _scnView.scene = [SCNScene scene];
        _scnView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
        _scnView.scene.lightingEnvironment.contents = @"tropical_beach.hdr";
        _scnView.scene.background.contents = @"tropical_beach.hdr";
        _scnView.allowsCameraControl = YES;
        _scnView.showsStatistics = YES;
        _scnView.delegate = self;
        
        self.rootNode = _scnView.scene.rootNode;
    }
    return _scnView;
}

@end
