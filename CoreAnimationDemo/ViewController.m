//
//  ViewController.m
//  CoreAnimationDemo
//
//  Created by RookieHua on 2017/4/27.
//  Copyright © 2017年 RookieHua. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic,strong) UIView *aView;
#pragma mark - 碰撞
@property (nonatomic,strong) NSMutableArray *balls;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravity;
@property (nonatomic,strong) UICollisionBehavior *collision;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Core Animation Demo";
    
    [self createUI];
    [self test];
}

//CATransform3D Key Paths : (example)transform.rotation.z
//rotation 旋轉
//rotation.x
//rotation.y
//rotation.z

//scale 缩放
//scale.x
//scale.y
//scale.z

//translation 平移
//translation.x
//translation.y
//translation.z



//CGPoint Key Paths : (example)position.x
//x
//y
//CGRect Key Paths : (example)bounds.size.width
//origin.x
//origin.y
//origin
//size.width
//size.height
//size
//opacity
//backgroundColor
//cornerRadius
//borderWidth
//contents
//Shadow Key Path:
//shadowColor
//shadowOffset
//shadowOpacity
//shadowRadius

#pragma mark - good idea
- (void)test{
    //初始化球堆
    _balls = [NSMutableArray array];
    
    //初始化动态特性的执行者
    UIDynamicAnimator *animator     = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _animator                       = animator;
    
    //添加重力的动态特性，使其可执行
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]init];
    [self.animator addBehavior:gravity];
    _gravity = gravity;
    
    //添加碰撞的动态特性，使其可执行
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]init];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    _collision = collision;
    
    //添加两个球体，使用拥有重力特性和碰撞特性
    NSUInteger numOfBalls = 2;
    for (NSUInteger i = 0; i < numOfBalls; i ++) {
        
        UIImageView *ball = [UIImageView new];
        
        //球的随机颜色
        ball.backgroundColor = [UIColor colorWithRed:(arc4random()%100 + 100)/255.f green:(arc4random()%100 + 100)/255.f blue:(arc4random()%100 + 100)/255.f alpha:1.00f];
        
        //球的随机大小:40~60之间
        CGFloat width = arc4random()%20 + 40;
        
        //球的随机位置
        CGRect frame = CGRectMake(arc4random()%((int)(self.view.bounds.size.width - width)), 0, width, width);
        [ball setFrame:frame];
        
        //添加球体到父视图
        [self.view addSubview:ball];
        //球堆添加该球
        [self.balls addObject:ball];
        //给球添加重力特性
        [self.gravity addItem:ball];
        //给球添加碰接特性
        [self.collision addItem:ball];
}
    
}
#pragma mark - event
- (IBAction)stopAnimation:(UIButton *)sender {
    NSLog(@"--- 停止 ---");
    [self.aView.layer removeAllAnimations];
}

//平移
- (IBAction)translation:(UIButton *)sender {
    NSLog(@"--- 平移 ---");
    CABasicAnimation *translationAnimation =  [self createTranslationAnimation];
    [self.aView.layer addAnimation:translationAnimation forKey:@"TranslationAnimation"];
}
//旋转
- (IBAction)rotation:(UIButton *)sender {
    NSLog(@"--- 旋转 ---");
   CABasicAnimation *rotationAnimation = [self createRotationAnimation];
    [self.aView.layer addAnimation:rotationAnimation forKey:@"RotationAnimation"];
}
//轨迹
- (IBAction)trackLine:(UIButton *)sender {
    NSLog(@"--- 轨迹 ---");
    CABasicAnimation *translationAnimation =  [self createTranslationAnimation];
    CABasicAnimation *rotationAnimation = [self createRotationAnimation];
   
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2.0f;
    animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
    animationGroup.repeatCount = NSNotFound;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation, translationAnimation, nil]];
    
    //将上述两个动画编组
    [self.aView.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
}

#pragma mark - create Animation
- (CABasicAnimation *)createTranslationAnimation{
    //位置移动
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint: self.aView.layer.position];
    CGPoint toPoint = self.aView.layer.position;
    toPoint.x += 180;
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.duration = 2.0;
    return animation;
}

- (CABasicAnimation *)createRotationAnimation{
    //旋转动画
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI/6];
    rotationAnimation.duration = 2.0f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
    return rotationAnimation;
}
#pragma mark - UI
- (void)createUI{
    [self.view addSubview:self.aView];
}
#pragma mark - getter
- (UIView *)aView{
    if (!_aView) {
        _aView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 100, 50)];
        _aView.backgroundColor = [UIColor redColor];
    }
    return _aView;
}

@end
