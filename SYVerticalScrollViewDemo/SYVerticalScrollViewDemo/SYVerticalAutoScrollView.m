//
//  SYVerticalAutoScrollView.m
//  SYVerticalScrollView
//
//  Created by shiyong on 16/5/18.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "SYVerticalAutoScrollView.h"

//height of the view 本视图高度
#define HIT self.frame.size.height
//widht of the view 本视图宽度
#define WIT self.frame.size.width

@interface SYVerticalAutoScrollView ()
/**block for updating/更新block*/
@property (nonatomic,copy) UpdateContentHandler updator;
/**dataSource of contentViews/滚动数据源*/
@property (nonatomic,strong) NSMutableArray *dataSource;
/**current index of scrolling/当前滚动索引*/
@property(nonatomic,assign,readonly) int index;
/**subViewOne/子视图1*/
@property (nonatomic,copy) UIView  *dsubViewOne;
/**subViewTwo/子视图2*/
@property (nonatomic,copy) UIView *dsubViewTwo;
/**whether start cycling/无限循环*/
@property(nonatomic,assign) BOOL cycleScroll;
/**interval of animations/动画间隔*/
@property(nonatomic,assign) float animationInterval;
/**duration of animations/动画时长*/
@property(nonatomic,assign) float animationDuration;
/**count of scrolling/滚动计数(滚动到第二次时开启两个子视图的无限循环)*/
@property(nonatomic,assign) int scrollCount;
//timer for scrolling/计时器
@property (nonatomic,retain) NSTimer *timer;
@end
@implementation SYVerticalAutoScrollView

//initilizer
-(instancetype) init:(CGRect)frame
         customViews:(NSArray *) customViews
   animationInterval:(float) interval
   animationDuration:(float) duration
          dataSource:(NSMutableArray *)dataSource
             updator:(UpdateContentHandler)updateHandler{
    self = [super initWithFrame:frame];
    //更新
    _dataSource = [NSMutableArray arrayWithArray:dataSource];
    _updator = updateHandler;
    _animationInterval = interval;
    _animationDuration = duration;
    
    
    //初始化子视图
    _dsubViewOne = customViews[0];
    _dsubViewTwo = customViews[1];
    _dsubViewOne.frame =CGRectMake(0, HIT, WIT, HIT);
    _dsubViewTwo.frame =CGRectMake(0, HIT*2, WIT, HIT);
    [self addSubview:_dsubViewOne];
    [self addSubview:_dsubViewTwo];
    [self setSubviews];
    
    //默认设置
    self.backgroundColor=[UIColor clearColor];
    _index=-1;
    _scrollCount=0;
    self.clipsToBounds=YES;
    
    //加载计时器
    _timer = self.timer;
    
    return self;
}
//set subviews
-(void) setSubviews{
    //初始化数据
    NSMutableArray *dataArr = _dataSource;
    if (dataArr.count>1) {
        self.updator(_dsubViewOne,dataArr,0);
        self.updator(_dsubViewTwo,dataArr,1);
        [_dsubViewOne setTag:0];
        [_dsubViewTwo setTag:1];
    }else{
        self.updator(_dsubViewOne,dataArr,0);
        self.updator(_dsubViewTwo,dataArr,0);
        [_dsubViewOne setTag:0];
        [_dsubViewTwo setTag:0];
    }
}

-(NSTimer *) timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval target:self selector:@selector(changeAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

//change action
-(void) changeAction:(id) userInfo{
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:_dataSource];
    //矫正参数
    [self justifyParams:dataArr];
    [UIView animateWithDuration:_animationDuration animations:^{
        _dsubViewOne.frame = CGRectMake(0,_dsubViewOne.frame.origin.y-HIT, _dsubViewOne.frame.size.width, _dsubViewOne.frame.size.height);
        _dsubViewTwo.frame = CGRectMake(0, _dsubViewTwo.frame.origin.y-HIT,_dsubViewTwo.frame.size.width, _dsubViewTwo.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            //一旦进入循环 就会不断切换两个子控件的位置
            if (_cycleScroll) {
                if (CGRectGetMaxY(_dsubViewOne.frame)==(CGRectGetMinY(_dsubViewTwo.frame))){
                    //更新数据
                    _dsubViewOne.frame =CGRectMake(0, CGRectGetMaxY(_dsubViewTwo.frame), WIT, HIT);
                    self.updator(_dsubViewOne,dataArr,_index);
                    [_dsubViewOne setTag:_index];
                }else{
                    //更新数据
                    _dsubViewTwo.frame =CGRectMake(0, CGRectGetMaxY(_dsubViewOne.frame), WIT, HIT);
                    self.updator(_dsubViewTwo,dataArr,_index);
                    [_dsubViewTwo setTag:_index];
                }
                
                //更新当前数据索引
                _dataIndex++;
                _dataIndex = (_dataIndex%dataArr.count);
            }
            //更新滚动索引
            _index++;
            _index = (_index%dataArr.count);
        }
    }];
}






-(void) justifyParams:(NSArray *) dataArr{
    if (_scrollCount<2) {
        //滚动到第二个子视图时 开启循环
        if (_scrollCount==1) {
            //修正滚动索引
            if (dataArr.count<3) {
                _index=0;
            }else{
                _index=2;
            }
            //修改滚动相关参数
            _cycleScroll=YES;
            _scrollCount=3;
        }else{
            _scrollCount++;
            
        }
    }
}


-(void) stop{
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}


-(void) run{
    if (_timer) {
        [_timer setFireDate:[NSDate date]];
    }
}


-(void) updateDataSource:(NSMutableArray *) dataSource{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
        
        self.updator(_dsubViewOne,dataSource,0);
        if (dataSource.count>1) {
            self.updator(_dsubViewTwo,dataSource,1);
        }
        _dsubViewOne.frame =CGRectMake(0, HIT, WIT, HIT);
        _dsubViewTwo.frame =CGRectMake(0, HIT*2, WIT, HIT);
        
        
        [_dataSource removeAllObjects];
        _dataSource=[NSMutableArray arrayWithArray:dataSource];
        _index=-1;
        _dataIndex=0;
        _scrollCount=0;
        _cycleScroll=NO;
        _timer=self.timer;
    }
}


-(void) removeFromSuperview{
    if (_timer) {
        [_timer invalidate];
    }
    [super removeFromSuperview];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
