//
//  AnimationView.m
//  饼状图练习
//
//  Created by 辛忠志 on 2017/4/18.
//  Copyright © 2017年 辛忠志. All rights reserved.
//

#define kAnimationDuration 1.0f
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kPieBackgroundColor [UIColor grayColor]
#define kPieFillColor [UIColor clearColor].CGColor
#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]
#define kLabelLoctionRatio (0.5*bgRadius)
#define ktitleLabelLoctionRatio (1.5*bgRadius)
#import "AnimationView.h"
@interface AnimationView()
@property(strong,nonatomic)CAShapeLayer * CAlayer;/*系统画圆的工具*/
@property (nonatomic) CGFloat total;
@end
@implementation AnimationView
- (id)initWithFrame:(CGRect)frame dataItems:(NSArray *)dataItems colorItems:(NSArray *)colorItems titleItems:(NSArray *)titleItems
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        self.backgroundColor = kPieBackgroundColor;
        
        //1.pieView中心点 *0.5f就是代表 中间位置坐标  view里面的初始化方法会在vc调用viewDidload之后才屌用，所以输出的中间位置 会随着你设置的 frame而改变
        CGFloat centerWidth = self.frame.size.width * 0.5f;
        CGFloat centerHeight = self.frame.size.height * 0.5f;
        CGFloat centerX = centerWidth;
        CGFloat centerY = centerHeight;
        /*设置中点坐标*/
        CGPoint centerPoint = CGPointMake(centerX, centerY);
        /*这个时候计算圆角坐标 如果你设置这个view的高度和宽度不是等同的时候按照其中一个算(等比例)*/
        CGFloat radiusBasic = centerWidth > centerHeight ? centerHeight : centerWidth;
        NSLog(@"%f",centerWidth);
        NSLog(@"%f",centerHeight);
        NSLog(@"%f",radiusBasic);
        //计算红绿蓝部分总和  这个和计算之后 总数都是10 但是也可以大于10 大于10的情况 也是按照比例进行计算的
        _total = 0.0f;
        for (int i = 0; i < dataItems.count; i++) {
            _total += [dataItems[i] floatValue];
            NSLog(@"%f",_total);
        }
        NSLog(@"%f",_total);
        //线的半径为扇形半径的一半，线宽是扇形半径，这样就能画出圆形了
        //2.背景路径
        CGFloat bgRadius = radiusBasic * 0.5;
        NSLog(@"%f",bgRadius);
        /*要想画圆你需要有 中点坐标  外弧度的路径  开始画圆的位置  开始-结束的时间*/
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                              radius:bgRadius
                                                          startAngle:-M_PI_2
                                                            endAngle:M_PI_2 * 3
                                                           clockwise:YES];
        /*fillColor 代表填充色  strokeStart 起始值是0.0f  strokeEnd 默认值是1.0f 这两个值代表绘制的起止位置  
         strokeColor 代表边缘线的颜色
         zPosition 是配置遮挡属性，比如layer1和layer2在同一个父layer上，layer1的zPosition=1，layer2的zPosition=0，layer1就会挡住layer2 
         lineWidth 代表展示外侧线条的宽度 会影响整个饼图的样式
         lineCap 代表是边缘线的类型
         */
        self.CAlayer = [CAShapeLayer layer];
        self.CAlayer.fillColor   = [UIColor clearColor].CGColor;
        self.CAlayer.strokeColor = [UIColor lightGrayColor].CGColor;
        self.CAlayer.strokeStart = 0.0f;
        self.CAlayer.strokeEnd   = 1.0f;
        self.CAlayer.zPosition   = 1;
        self.CAlayer.lineWidth   = bgRadius * 1.9f;
        self.CAlayer.lineCap       = kCALineCapRound;
        self.CAlayer.path        = bgPath.CGPath;/*从贝塞尔曲线获取到形状*/
        
        
        //3.子扇区路径  “-”之后的部分就是弧度线 宽度部分  这个路径需要 1 中心的坐标 2 路径的长度 也就是你给圆的一半的长度 上面记载了 3  还有开始的位置 4 停止的时间
        CGFloat otherRadius = radiusBasic * 0.5 - 0.0;
        UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                 radius:otherRadius
                                                             startAngle:-M_PI_2
                                                               endAngle:M_PI_2 * 3
                                                              clockwise:YES];
        
        CGFloat start = 0.0f;
        CGFloat end = 0.0f;
        for (int i = 0; i < dataItems.count; i++) {
            //4.计算当前end位置 = 上一个结束位置 + 当前部分百分比
            end = [dataItems[i] floatValue] / _total + start;
            NSLog(@"%f",end);
            //图层
            CAShapeLayer *pie = [CAShapeLayer layer];
            [self.layer addSublayer:pie];
            /*填充颜色*/
            pie.fillColor   = kPieFillColor;
            if (i > colorItems.count - 1 || !colorItems  || colorItems.count == 0) {//如果传过来的颜色数组少于item个数则随机填充颜色
                pie.strokeColor = kPieRandColor.CGColor;
            } else {
                pie.strokeColor = ((UIColor *)colorItems[i]).CGColor;
            }
            pie.strokeStart = start;
            pie.strokeEnd   = end;
            pie.lineWidth   = otherRadius * 2.0f;
            pie.zPosition   = 2;
            pie.path        = otherPath.CGPath;
            
            NSLog(@"%f",start + end);
            //计算百分比label的位置
            CGFloat centerAngle = M_PI * (start + end);
            /*kLabelLoctionRatio 代表距离中心点的系数 系数越大距离越远*/
            CGFloat labelCenterX = kLabelLoctionRatio * sinf(centerAngle) + centerX;
            CGFloat labelCenterY = -kLabelLoctionRatio * cosf(centerAngle) + centerY;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, radiusBasic * 0.7f, radiusBasic * 0.7f)];
            label.center = CGPointMake(labelCenterX, labelCenterY);
            label.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)((end - start + 0.005) * 100)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.layer.zPosition = 3;
            [self addSubview:label];
            
            /*设置文字展示部分*/
            /*ktitleLabelLoctionRatio 代表距离中心点的系数 系数越大距离越远*/
            CGFloat titlelabelCenterX = ktitleLabelLoctionRatio * sinf(centerAngle) + centerX;
            CGFloat titlelabelCenterY = -ktitleLabelLoctionRatio * cosf(centerAngle) + centerY;
            UILabel * titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, radiusBasic * 0.7f, radiusBasic * 0.7f)];
            titleLabel.center = CGPointMake(titlelabelCenterX, titlelabelCenterY);
            titleLabel.text = ((NSString *)titleItems[i]);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.layer.zPosition = 3;
            [self addSubview:titleLabel];
            
            //计算下一个start位置 = 当前end位置
            start = end;
        }
        self.layer.mask = self.CAlayer;
    }
    return self;
}
/*实现转圈的动画效果 这个动画实现是要在点击ViewController的时候实现的*/
-(void)animation{
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = 1.0f;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [self.CAlayer addAnimation:animation forKey:@"circleAnimation"];
}
- (void)dealloc
{
    [self.layer removeAllAnimations];
}
@end
