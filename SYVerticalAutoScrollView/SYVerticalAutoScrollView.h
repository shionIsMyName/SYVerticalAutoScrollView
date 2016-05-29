//
//  SYVerticalAutoScrollView.h
//  SYVerticalScrollView
//
//  Created by shiyong on 16/5/18.
//  Copyright © 2016年 sy. All rights reserved.
// The core idea of this view is auto switching two views to make them look like cycling all the time,so you have give the view two subviews!!!
//

#import <UIKit/UIKit.h>


/**
 *  block for updating your contentViews while the view is scrolling
 *  更新内容时blcok
 *
 *  @param sender view which you touched 需要更新的控件
 *  @param data   data which you passed through 数据
 *  @param index  current index of scrolling 对应索引
 */
typedef void(^UpdateContentHandler)(id sender,NSMutableArray* data,int index);


@interface SYVerticalAutoScrollView : UIView

/**current index of scrolling/当前数据索引(类似于横向轮播的页码)*/
@property(nonatomic,assign) int dataIndex;



/**
 *  convinience initilizer
 *  便捷初始化
 *
 *  @param frame              frame of SYVerticalAutoScrollView/视图的位置和尺寸
 *  @param customViews        contentViews of SYVerticalAutoScrollView/滚动视图中的子视图(自定义)
 *  @param interval           interval of animations/动画间隔
 *  @param duration           duration of animations/动画时长
 *  @param dataSource         dataSource for contentViews/滚动视图的数据源
 *  @param updateHandler      handler method for updating while the view is scrolling/自定义button的更新回调,sender为需要更新的控件,data为数据源,index为当前滚动的索引
 *
 *  @return 实例
 */
+(instancetype) viewWithFrame:(CGRect) frame
                   customVies:(NSArray *) customViews
            animationInterval:(float) interval
            animationDuration:(float) duration
                   dataSource:(NSMutableArray *) dataSource
                      updator:(UpdateContentHandler) updateHandler;

/**
 *  initilizer
 *  初始化
 *
 *  @param frame              frame of SYVerticalAutoScrollView/视图的位置和尺寸
 *  @param customViews        contentViews of SYVerticalAutoScrollView/滚动视图中的子视图(自定义)
 *  @param interval           interval of animations/动画间隔
 *  @param duration           duration of animations/动画时长
 *  @param dataSource         dataSource for contentViews/滚动视图的数据源
 *  @param updateHandler      handler method for updating while the view is scrolling/自定义button的更新回调,sender为需要更新的控件,data为数据源,index为当前滚动的索引
 *
 *  @return 实例
 */
-(instancetype) initWithFrame:(CGRect)frame
                  customViews:(NSArray *) customViews
            animationInterval:(float) interval
            animationDuration:(float) duration
                   dataSource:(NSMutableArray *) dataSource
                      updator:(UpdateContentHandler) updateHandler;

/**
 *  stop scrolling/停止滚动
 */
-(void) stop;

/**
 *  continue scrolling/开始滚动
 */
-(void) run;

/**
 *  update dataSource of the view/更新数据源
 */
-(void) updateDataSource:(NSArray *) dataSource;

@end
