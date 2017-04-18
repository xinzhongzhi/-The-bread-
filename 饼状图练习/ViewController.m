//
//  ViewController.m
//  饼状图练习
//
//  Created by 辛忠志 on 2017/4/18.
//  Copyright © 2017年 辛忠志. All rights reserved.
//
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#import "ViewController.h"
#import "AnimationView.h"
@interface ViewController ()
@property(strong,nonatomic)AnimationView * Aview;/*动画实现的view*/
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    /*设置Aview的位置 距离左侧平宽减去 200 *1/2的位置   dataItems 记录的是饼状图的比例分配 顺时针指向  colorItems 分配的是颜色 也会顺时针分配  titleItems 分配文字展示 也是顺时针分配*/
    self.Aview = [[AnimationView alloc]initWithFrame:CGRectMake((kScreenWidth-400) * 0.5f, 200, 400, 400) dataItems:@[@2,@2,@2,@4] colorItems:@[[UIColor redColor], [UIColor greenColor], [UIColor blueColor],[UIColor blackColor]] titleItems:@[@"化学",@"物理",@"语文",@"数学"]];
    [self.view addSubview:self.Aview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*点击viewController 触发动画效果*/
    [self.Aview animation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
