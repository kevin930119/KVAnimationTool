//
//  ViewController.m
//  AanimationTest
//
//  Created by 知子花 on 16/1/25.
//  Copyright © 2016年 知子花. All rights reserved.
//

#import "ViewController.h"

#import "KVAnimationTool.h"

@interface ViewController () <KVAnimationToolDelegate>

@end

@implementation ViewController
{
    UIImageView * _imageView;
    
    UIImageView * _roundImage;
    
    UILabel * _colorLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initUI];
    //要想监听到动画的开始与停止，必须先设置代理
    [KVAnimationTool sharedAnimationTool].delegate = self;
    //拉伸动画
//    [self animationScale];
    //位移动画
//    [self animationPosition];
    //旋转动画
//    [self animationRotation];
    //淡入淡出动画
//    [self fade];
    //抛物线
//    [self throwLine];
    //多组动画组合
//    [self groupAnimation];
    
    //颜色动画
    [self colorUI];
//    [self colorAnimation];
}

- (void)initUI {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _imageView.image = [UIImage imageNamed:@"bg_home"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView.layer setCornerRadius:10];
    _imageView.layer.masksToBounds = YES;
    [self.view addSubview:_imageView];
    
    _roundImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    _roundImage.image = [UIImage imageNamed:@"chengzhang_02"];
    [_imageView addSubview:_roundImage];
}

#pragma mark - 淡入淡出动画
- (void)fade {
    [[KVAnimationTool sharedAnimationTool] fadeoutWithView:_roundImage];
}

#pragma mark - 拉伸动画
- (void)animationScale {
    [[KVAnimationTool sharedAnimationTool] animationRepeatScaleWithView:_roundImage fromValue:1.0f toValue:2.0f duration:2.0f];
}

#pragma mark - 旋转动画
- (void)animationRotation {
    [[KVAnimationTool sharedAnimationTool] animationRotationWithAxis:RotationX view:_roundImage repeatCount:1000000000];
}

#pragma mark - 移动动画
- (void)animationPosition {
    [[KVAnimationTool sharedAnimationTool] animationBackPositionWithView:_roundImage fromValue:_roundImage.layer.position toValue:CGPointMake(200, 300) duration:1.0f];
}

#pragma mark - 抛物线动画
- (void)throwLine {
    [[KVAnimationTool sharedAnimationTool] forwardThrowView:_roundImage from:_roundImage.frame.origin to:CGPointMake(100, 300) height:100 duration:2.0f];
}

#pragma mark - 复杂动画
- (void)groupAnimation {
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:_roundImage.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 400)];
    
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    
    [[KVAnimationTool sharedAnimationTool] groupAnimationRepeatWithAnimations:@[positionAnimation, scaleAnimation] view:_roundImage duration:2.0f];
}

- (void)animationDidStart {
    NSLog(@"动画开始");
}

- (void)animationDidStop {
    NSLog(@"动画结束");
}

#pragma mark - 视图过渡动画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self transition];
}

bool flag = NO;
- (void)transition {
    if (flag) {
        _imageView.image = [UIImage imageNamed:@"bg_home"];
        flag = !flag;
    }else {
        _imageView.image = [UIImage imageNamed:@"bgImage4"];
        flag = !flag;
    }
    [self.view insertSubview:_imageView atIndex:0];
    //添加过渡效果
    [[KVAnimationTool sharedAnimationTool] viewTransitionWithView:self.view type:@"suckEffect" subType:kCATransitionFromLeft duration:1.0f];
}

#pragma mark - 颜色渐变动画

- (void)colorUI {
    NSString * str = @"我是魏佳林，我叫魏佳林";
    NSMutableAttributedString * mstr = [[NSMutableAttributedString alloc] initWithString:str];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(2, 3)];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(8, 3)];
    
    _colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 300, 50)];
    _colorLabel.attributedText = mstr;
    [self.view addSubview:_colorLabel];
    [self colorAnimation];
}

- (void)colorAnimation {
    CABasicAnimation * colorAnimation = [CABasicAnimation animation];
    colorAnimation.fromValue = (id)[UIColor yellowColor].CGColor;
    colorAnimation.toValue = (id)[UIColor blueColor].CGColor;
    colorAnimation.duration = 10.0f;
    colorAnimation.repeatCount = 1;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.autoreverses = NO;
    colorAnimation.fillMode = kCAFillModeForwards;
    [_colorLabel.layer addAnimation:colorAnimation forKey:@"backgroundColor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
