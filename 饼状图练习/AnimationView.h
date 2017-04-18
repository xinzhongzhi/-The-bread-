//
//  AnimationView.h
//  饼状图练习
//
//  Created by 辛忠志 on 2017/4/18.
//  Copyright © 2017年 辛忠志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView
/**
 *  Pie
 *
 *  @param frame      frame
 *  @param dataItems  数据源
 *  @param colorItems 对应数据的pie的颜色，如果colorItems.count < dataItems 或
 *                      colorItems 为nil 会随机填充颜色 titleItems 是文字
 *
 */
- (id)initWithFrame:(CGRect)frame
          dataItems:(NSArray *)dataItems
         colorItems:(NSArray *)colorItems
         titleItems:(NSArray *)titleItems;
/*实现转圈的动画效果*/
-(void)animation;
@end
