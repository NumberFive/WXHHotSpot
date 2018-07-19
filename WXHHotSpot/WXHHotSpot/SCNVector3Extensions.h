//
//  SCNVector3Extensions.h
//  ARRuler
//
//  Created by 伍小华 on 2018/3/21.
//  Copyright © 2018年 伍小华. All rights reserved.
//

#ifndef SCNVector3Extensions_h
#define SCNVector3Extensions_h
#import <SceneKit/SceneKit.h>

static void drawLines(SCNVector3 p1,SCNVector3 p2,SCNNode *linesNode);
static SCNVector4 SCNVector4RotationVector(SCNVector3 from,SCNVector3 to);
//轴心和旋转弧度，生成四元数
static SCNVector4 SCNVector4RotationRadian(SCNVector3 axis, float radian);
static SCNVector3 SCNVector3Sub(SCNVector3 v1, SCNVector3 v2);
static SCNVector3 SCNVector3Add(SCNVector3 v1, SCNVector3 v2);
static SCNVector3 SCNVector3Middle(SCNVector3 v1, SCNVector3 v2);
static float SCNVector3DotProduct(SCNVector3 v1,SCNVector3 v2);
static SCNVector3 SCNVector3CrossProduct(SCNVector3 v1,SCNVector3 v2);

static SCNVector3 SCNVector3AddNumber(SCNVector3 v1, float x);
static SCNVector3 SCNVector3SubNumber(SCNVector3 v1, float x);
static SCNVector3 SCNVector3MulNunber(SCNVector3 v1, float x);
static SCNVector3 SCNVector3DivNumber(SCNVector3 v1, float x);

static SCNVector3 SCNVector3Normalize(SCNVector3 v);
static float SCNVector3Length(SCNVector3 v);
static float SCNVector3Distance(SCNVector3 v1,SCNVector3 v2);
static float AngleToRadian(float angle);
static float RadianToAngle(float radian);

static void LinesUpdate(SCNVector3 p1,SCNVector3 p2,SCNNode *linesNode)
{
    double length = SCNVector3Distance(p1,p2);
    SCNVector3 p = p1;
    p.y = p.y + length;
    
    SCNVector3 v1 = SCNVector3Sub(p1,p);
    SCNVector3 v2 = SCNVector3Sub(p1,p2);
    
    SCNVector4 rotation = SCNVector4RotationVector(v1,v2);
    
    SCNVector3 scale = linesNode.scale;
    scale.y = length;
    linesNode.scale = scale;
    
    linesNode.position = p1;
    linesNode.rotation = rotation;
    linesNode.position = SCNVector3Middle(p1,p2);
}

//获取一个向量旋转到另一个向量的rotation
static SCNVector4 SCNVector4RotationVector(SCNVector3 from, SCNVector3 to)
{
    SCNVector3 crossProduct = SCNVector3CrossProduct(from,to);
    
    double dotProduct = SCNVector3DotProduct(from,to);
    double cosRadian = dotProduct / (SCNVector3Length(from) * SCNVector3Length(to));
    double radian = acos(cosRadian);
    return SCNVector4Make(crossProduct.x, crossProduct.y, crossProduct.z, radian);
}

//轴心和旋转弧度，生成四元数
static SCNVector4 SCNVector4RotationRadian(SCNVector3 axis, float radian)
{
    double halfRadian = radian / 2.0;
    float s = sin(halfRadian);
    
    float w = cos(halfRadian);
    float x = axis.x * s;
    float y = axis.y * s;
    float z = axis.z * s;
    
    return SCNVector4Make(x, y, z, w);
}

static float AngleToRadian(float angle)
{
    return M_PI * (angle) / 180.0;
}
static float RadianToAngle(float radian)
{
    return radian * 180.0 / M_PI;
}

//向量相减
static SCNVector3 SCNVector3Sub(SCNVector3 v1, SCNVector3 v2)
{
    return SCNVector3Make(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
}
//向量相加
static SCNVector3 SCNVector3Add(SCNVector3 v1, SCNVector3 v2)
{
    return SCNVector3Make(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
}
//两点中点
static SCNVector3 SCNVector3Middle(SCNVector3 v1, SCNVector3 v2)
{
    SCNVector3 v = SCNVector3Add(v1,v2);
    v.x /= 2.0;
    v.y /= 2.0;
    v.z /= 2.0;
    return v;
}
//向量单位化
static SCNVector3 SCNVector3Normalize(SCNVector3 v)
{
    double length = SCNVector3Length(v);
    v.x /= length;
    v.y /= length;
    v.z /= length;
    return v;
}
//一个向量的长度
static float SCNVector3Length(SCNVector3 v)
{
    return sqrtf(v.x*v.x+v.y*v.y+v.z*v.z);
}
//两点的距离
static float SCNVector3Distance(SCNVector3 v1,SCNVector3 v2)
{
    return SCNVector3Length(SCNVector3Sub(v1, v2));
}
//叉乘
static SCNVector3 SCNVector3CrossProduct(SCNVector3 v1,SCNVector3 v2)
{
    return SCNVector3Make(v1.y*v2.z-v1.z*v2.y,
                          v1.z*v2.x-v1.x*v2.z,
                          v1.x*v2.y-v1.y*v2.x);
}
//点乘
static float SCNVector3DotProduct(SCNVector3 v1,SCNVector3 v2)
{
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
}
// 两个向量是否平行
static bool SCNVector3Parallel(SCNVector3 v1,SCNVector3 v2)
{
    v1 = SCNVector3Normalize(v1);
    v2 = SCNVector3Normalize(v2);
    
    if (fabsf(v1.x) != fabsf(v2.x)) {
        return NO;
    } else if (fabsf(v1.y) != fabsf(v2.y)) {
        return NO;
    } else if (fabsf(v1.z) != fabsf(v2.z)) {
        return NO;
    } else {
        return YES;
    }
}
//获取平面的中心
static SCNVector3 centerOfPlane(NSArray<NSValue *> *pointArray)
{
    SCNVector3 position = SCNVector3Zero;
    
    for (NSValue *value in pointArray) {
        SCNVector3 vector = value.SCNVector3Value;
        position = SCNVector3Add(position, vector);
    }
    float count = (float)[pointArray count];
    return SCNVector3Make(position.x/count, position.y/count, position.z/count);
}

//获取平面的法线
static SCNVector3 normalOfPlane(NSArray<NSValue *> *pointArray)
{
    if ([pointArray count] < 3) {
        return SCNVector3Zero;
    } else {
        SCNVector3 center = centerOfPlane(pointArray);
        
        NSInteger count = [pointArray count];
        
        NSValue *point0 = pointArray[0];
        NSValue *point1 = pointArray[1];
        
        SCNVector3 vector1 = SCNVector3Sub(point0.SCNVector3Value, center);
        SCNVector3 vector2 = SCNVector3Sub(point1.SCNVector3Value, center);
        
        for (NSInteger i = 1; i < count; ++i) {
            if (SCNVector3EqualToVector3(vector1, SCNVector3Zero)) {
                point0 = pointArray[i];
                vector1 = SCNVector3Sub(point0.SCNVector3Value, center);
            } else {
                point1 = pointArray[i];
                vector2 = SCNVector3Sub(point1.SCNVector3Value, center);
                
                
                if (!SCNVector3EqualToVector3(vector2, SCNVector3Zero)) {
                    break;
                }
            }
        }
        
        SCNVector3 normal = SCNVector3CrossProduct(vector1, vector2);
        normal = SCNVector3Normalize(normal);
        return normal;
    }
}

//判断平面的法线是否指向一个点
static bool isNormalFaceToPoint(SCNVector3 normal, SCNVector3 point, SCNVector3 planePoint)
{
    SCNVector3 vector = SCNVector3Sub(point,planePoint);
    float radian = SCNVector3DotProduct(vector, normal);
    
    if (radian <= 0) {
        return NO;
    } else {
        return YES;
    }
}

//判断一个平面的正面是否对着一个点
static bool isPlaneFaceToPoint(NSArray<NSValue *> *pointArray, SCNVector3 point)
{
    SCNVector3 normal = normalOfPlane(pointArray);
    NSValue *value = pointArray[0];
    return isNormalFaceToPoint(normal, point, value.SCNVector3Value);
}

static SCNVector3 SCNVector3AddNumber(SCNVector3 v1, float x)
{
    return SCNVector3Make(v1.x + x, v1.y + x, v1.z + x);
}
static SCNVector3 SCNVector3SubNumber(SCNVector3 v1, float x)
{
    return SCNVector3Make(v1.x - x, v1.y - x, v1.z - x);
}
static SCNVector3 SCNVector3MulNunber(SCNVector3 v1, float x)
{
    return SCNVector3Make(v1.x * x, v1.y * x, v1.z * x);
}
static SCNVector3 SCNVector3DivNumber(SCNVector3 v1, float x)
{
    return SCNVector3Make(v1.x / x, v1.y / x, v1.z / x);
}

#endif /* SCNVector3Extensions_h */
