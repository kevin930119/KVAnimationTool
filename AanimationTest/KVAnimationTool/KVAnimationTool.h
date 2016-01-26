//
//  KVAnimationTool.h
//  AanimationTest
//
//  Created by 知子花 on 16/1/26.
//  Copyright © 2016年 知子花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    RotationX,//绕X轴旋转
    RotationY,//绕Y轴旋转
    RotationZ//绕Z轴旋转(实际就是在屏幕表面旋转)
}RotationAxis;

@protocol KVAnimationToolDelegate <NSObject>

@optional
//动画开始
- (void)animationDidStart;
//动画结束
- (void)animationDidStop;

@end

@interface KVAnimationTool : NSObject
//动画代理
@property (nonatomic, weak) id <KVAnimationToolDelegate> delegate;
//正在展示动画的视图
@property (nonatomic, strong) UIView * showingView;

+ (instancetype)sharedAnimationTool;

- (void)stopAnimation;

#pragma mark - 简单动画方法
/*
 移动动画(动画结束视图停留)
 */
- (void)animationPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration;
/*
 移动动画(动画结束，视图按原路返回)
 */
- (void)animationBackPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration;
/*
 在一条路径上不断重复移动
 */
- (void)animationRepeatPositionWithView:(UIView*)view fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration;


/*
 拉伸动画(动画结束,视图不拉伸)
 */
- (void)animationScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;
/*
 拉伸动画(动画结束,视图不拉伸,渐变返回)
 */
- (void)animationBackScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;
/*
 重复拉伸动画
 */
- (void)animationRepeatScaleWithView:(UIView*)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;


/*
 旋转动画,绕什么轴旋转由axis的值决定
 */
- (void)animationRotationWithAxis:(RotationAxis)axis view:(UIView*)view repeatCount:(NSInteger)count;


/*
 淡入
 */
- (void)fadeinWithView:(UIView*)view;
/*
 淡出
 */
- (void)fadeoutWithView:(UIView*)view;
#pragma mark - 复杂动画(多组动画组合)
/*
 群组动画，不重复，视图停留在动画结束的位置
 */
- (void)groupAnimationWithAnimations:(NSArray*)animations view:(UIView*)view duration:(CGFloat)duration;
/*
 群组动画,不重复，视图返回原先的位置
 */
- (void)groupAnimationBackWithAnimations:(NSArray*)animations view:(UIView*)view duration:(CGFloat)duration;
/*
 群组动画,不断重复
 */
- (void)groupAnimationRepeatWithAnimations:(NSArray*)animations view:(UIView*)view duration:(CGFloat)duration;

#pragma mark - 简单抛物线
/*
 视图停留在动画结束的位置
 */
- (void)forwardThrowView:(UIView *)view from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration;
/*
 动画结束，动画不对视图做任何改变，视图还在原来的位置
 */
- (void)throwView:(UIView *)view from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration;

#pragma mark - 视图过渡动画
/*
    一共四种过渡方法，四个方向
 过渡方法(type):
    kCATransitionFade    淡入淡出
    kCATransitionMoveIn  新视图移动到旧视图上
    kCATransitionPush    新视图推出旧视图
    kCATransitionReveal  移开旧视图显示新视图
 
    私有API（慎用，使用了上不了线，尽管效果挺好看，需要直接传入字符串）
    pageCurl            向上翻一页
    pageUnCurl          向下翻一页
    rippleEffect        滴水效果
    suckEffect          收缩效果，如一块布被抽走
    cube                立方体效果
    oglFlip             上下翻转效果
 四个方向(subType):
    kCATransitionFromRight  从右
    kCATransitionFromLeft   从左
    kCATransitionFromTop    从上
    kCATransitionFromBottom 从下
 */
- (void)viewTransitionWithView:(UIView*)view type:(NSString*)type subType:(NSString*)subType duration:(CGFloat)duration;
@end
