//
//  KVAnimationTool.m
//  AanimationTest
//
//  Created by 知子花 on 16/1/26.
//  Copyright © 2016年 知子花. All rights reserved.
//

#import "KVAnimationTool.h"
#import <QuartzCore/QuartzCore.h>
//设置成大数，模拟无限循环
#define MaxRepeatCount 1000000000000

@implementation KVAnimationTool

+ (instancetype)sharedAnimationTool {
    static KVAnimationTool * tool = nil;
    static dispatch_once_t toolToken;
    dispatch_once(&toolToken, ^{
        tool = [[KVAnimationTool alloc] init];
    });
    return tool;
}

- (void)stopAnimation {
    if (self.showingView) {
        [self.showingView.layer removeAllAnimations];
    }
}

#pragma mark - 简单移动动画
/*
  移动动画(动画结束视图停留)
*/
- (void)animationPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration {
    //不重复
    [self animationPositionWithView:view fromValue:fromValue toValue:toValue duration:duration autoreverses:NO removeOnCompletion:NO fillMode:kCAFillModeForwards repeatCount:1];
}
/*
    移动动画(动画结束，视图按原路返回)
 */
- (void)animationBackPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration {
    //不重复
    [self animationPositionWithView:view fromValue:fromValue toValue:toValue duration:duration autoreverses:YES removeOnCompletion:YES fillMode:kCAFillModeRemoved repeatCount:1];
}
/*
    在一条路径上不断重复移动
 */
- (void)animationRepeatPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration {
    [self animationPositionWithView:view fromValue:fromValue toValue:toValue duration:duration autoreverses:YES removeOnCompletion:NO fillMode:kCAFillModeRemoved repeatCount:MaxRepeatCount];
}

- (void)animationPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration autoreverses:(BOOL)autoFlag removeOnCompletion:(BOOL)removeFlag fillMode:(NSString*)fillMode repeatCount:(NSInteger)count {
    self.showingView = view;
    //如果是X,Y轴单方向移动的话，那么把FromValue和ToValue做一个修改
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:fromValue];
    positionAnimation.toValue = [NSValue valueWithCGPoint:toValue];
    //这个属性是为了设定自动动画返回的
    positionAnimation.autoreverses = autoFlag;
    positionAnimation.removedOnCompletion = removeFlag;//必须加上这个才能确保下面的属性生效
    positionAnimation.fillMode = fillMode;//动画结束让视图停留
    positionAnimation.duration = duration;
    positionAnimation.repeatCount = count;
    positionAnimation.delegate = self;
    [view.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
}

#pragma mark - 简单拉伸动画
/*
    拉伸动画(动画结束,视图不拉伸)
 */
- (void)animationScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration {
    [self animationScaleWithView:view fromValue:fromValue toValue:toValue duration:duration autoreverses:NO removeOnCompletion:NO fillMode:kCAFillModeForwards repeatCount:1];
}
/*
    拉伸动画(动画结束,视图不拉伸，渐变返回)
 */
- (void)animationBackScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration {
    [self animationScaleWithView:view fromValue:fromValue toValue:toValue duration:duration autoreverses:YES removeOnCompletion:YES fillMode:kCAFillModeRemoved repeatCount:1];
}
/*
 重复拉伸动画
 */
- (void)animationRepeatScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration {
    [self animationScaleWithView:view fromValue:fromValue toValue:toValue duration:duration autoreverses:YES removeOnCompletion:NO fillMode:kCAFillModeRemoved repeatCount:MaxRepeatCount];
}
- (void)animationScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration autoreverses:(BOOL)autoFlag removeOnCompletion:(BOOL)removeFlag fillMode:(NSString*)fillMode repeatCount:(NSInteger)count {
    self.showingView = view;
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:toValue];
    scaleAnimation.autoreverses = autoFlag;
    scaleAnimation.fillMode = fillMode;
    scaleAnimation.repeatCount = count;
    scaleAnimation.duration = duration;
    scaleAnimation.delegate = self;
    [view.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
#pragma mark - 简单旋转动画
- (void)animationRotationWithAxis:(RotationAxis)axis view:(UIView*)view repeatCount:(NSInteger)count {
    self.showingView = view;
    NSString * axisStr = @"";
    switch (axis) {
        case RotationX:
            axisStr = @"x";
            break;
        case RotationY:
            axisStr = @"y";
            break;
        case RotationZ:
            axisStr = @"z";
            break;
        default:
            break;
    }
    CABasicAnimation * rotationAnimation = [self createAnimationRotationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@", axisStr]];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI_2];
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = count;
    rotationAnimation.duration = 0.5f;
    rotationAnimation.delegate = self;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma mark - 淡入淡出动画
/*
 淡入
 */
- (void)fadeinWithView:(UIView*)view {
    self.showingView = view;
    CABasicAnimation * animation = [self createAnimationRotationWithKeyPath:@"opacity"];
    animation.duration = 1.0f;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [view.layer addAnimation:animation forKey:@"fadeinAnimation"];
}
/*
 淡出
 */
- (void)fadeoutWithView:(UIView*)view {
    self.showingView = view;
    CABasicAnimation * animation = [self createAnimationRotationWithKeyPath:@"opacity"];
    animation.duration = 1.0f;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [view.layer addAnimation:animation forKey:@"fadeoutAnimation"];
}

#pragma mark - 复杂动画(多组动画组合)
/*
    群组动画，不重复，视图停留在动画结束的位置
 */
- (void)groupAnimationWithAnimations:(NSArray*)animations view:(UIView*)view duration:(CGFloat)duration{
    [self groupAnimationWithAnimations:animations view:view repeatCount:1 duration:duration removeOnCompletion:NO fillMode:kCAFillModeForwards autoreverses:NO];
}
/*
    群组动画,不重复，视图返回原先的位置
 */
- (void)groupAnimationBackWithAnimations:(NSArray*)animations view:(UIView*)view duration:(CGFloat)duration {
    [self groupAnimationWithAnimations:animations view:view repeatCount:1 duration:duration removeOnCompletion:NO fillMode:kCAFillModeRemoved autoreverses:YES];
}
/*
 群组动画,不断重复
 */
- (void)groupAnimationRepeatWithAnimations:(NSArray*)animations view:(UIView*)view duration:(CGFloat)duration {
    [self groupAnimationWithAnimations:animations view:view repeatCount:MaxRepeatCount duration:duration removeOnCompletion:NO fillMode:kCAFillModeForwards autoreverses:YES];
}
- (void)groupAnimationWithAnimations:(NSArray*)animations view:(UIView *)view repeatCount:(NSInteger)count duration:(CGFloat)duration removeOnCompletion:(BOOL)removeFlag fillMode:(NSString*)fillMode autoreverses:(BOOL)autoFlag{
    self.showingView = view;
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = self;
    groupAnimation.repeatCount = count;
    groupAnimation.duration = duration;
    groupAnimation.autoreverses = autoFlag;
    groupAnimation.removedOnCompletion = removeFlag;
    groupAnimation.fillMode = fillMode;
    groupAnimation.animations = animations;
    [view.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

#pragma mark - 简单抛物线
/*
    视图停留在动画结束的位置
 */
- (void)forwardThrowView:(UIView *)view from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration
{
    //不重复，并且动画结束，视图停留在动画结束的位置
    [self throwView:view from:start to:end height:height duration:duration repeatCount:1 removeOnCompletion:NO fillMode:kCAFillModeForwards autoreverses:NO];
}
/*
    动画结束，动画不对视图做任何改变，视图还在原来的位置
 */
- (void)throwView:(UIView *)view from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration {
    [self throwView:view from:start to:end height:height duration:duration repeatCount:1 removeOnCompletion:YES fillMode:kCAFillModeRemoved autoreverses:YES];
}


- (void)throwView:(UIView *)view from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration repeatCount:(NSInteger)count removeOnCompletion:(BOOL)removeFlag fillMode:(NSString*)fillMode autoreverses:(BOOL)autoFlag{
    self.showingView = view;
    //初始化抛物线path
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cpx = (start.x + end.x) / 2;
    CGFloat cpy = - height;
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, end.x, end.y);
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CFRelease(path);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = autoFlag;
    scaleAnimation.toValue = [NSNumber numberWithFloat:(CGFloat)((arc4random() % 4) + 4) / 10.0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = self;
    groupAnimation.repeatCount = count;
    groupAnimation.duration = duration;
    groupAnimation.removedOnCompletion = removeFlag;
    groupAnimation.fillMode = fillMode;
    groupAnimation.animations = @[scaleAnimation, animation];
    [view.layer addAnimation:groupAnimation forKey:@"position scale"];
}

#pragma mark - 视图过渡动画
- (void)viewTransitionWithView:(UIView*)view type:(NSString*)type subType:(NSString*)subType duration:(CGFloat)duration {
    CATransition * transition = [[CATransition alloc] init];
    transition.type = type;
    transition.subtype = subType;
    transition.duration = duration;
    [view.layer addAnimation:transition forKey:@"transition"];
}

#pragma mark - 动画代理方法
- (void)animationDidStart:(CAAnimation *)anim {
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStart)]) {
        [self.delegate animationDidStart];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop)]) {
        [self.delegate animationDidStop];
    }
    [self.showingView.layer removeAllAnimations];
    self.showingView = nil;
}

- (CABasicAnimation*)createAnimationRotationWithKeyPath:(NSString*)keyPath {
    return [CABasicAnimation animationWithKeyPath:keyPath];
}

@end
