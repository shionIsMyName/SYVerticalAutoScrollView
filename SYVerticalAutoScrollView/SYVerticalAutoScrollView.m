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
@property(nonatomic,assign,readonly) int scrollIndex;
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
//indicates timer is running or not
@property(nonatomic,assign) BOOL isRunning;

@end
@implementation SYVerticalAutoScrollView

//convinience method
+(instancetype) viewWithFrame:(CGRect)frame
                   customVies:(NSArray *)customViews
            animationInterval:(float)interval
            animationDuration:(float)duration
                   dataSource:(NSMutableArray *)dataSource
                      updator:(UpdateContentHandler)updateHandler{
    return [[SYVerticalAutoScrollView alloc] initWithFrame:frame
                                               customViews:customViews
                                         animationInterval:interval
                                         animationDuration:duration
                                                dataSource:dataSource
                                                   updator:updateHandler];
}

//initilizer
-(instancetype) initWithFrame:(CGRect)frame
                  customViews:(NSArray *) customViews
            animationInterval:(float) interval
            animationDuration:(float) duration
                   dataSource:(NSMutableArray *)dataSource
                      updator:(UpdateContentHandler)updateHandler{
    self = [super initWithFrame:frame];
    
    // updating members/更新
    _dataSource = [NSMutableArray arrayWithArray:dataSource];
    _updator = updateHandler;
    _animationInterval = interval;
    _animationDuration = duration;
    
    // initSubviews/初始化子视图
    _dsubViewOne = customViews[0];
    _dsubViewTwo = customViews[1];
    _dsubViewOne.frame =CGRectMake(0, HIT, WIT, HIT);
    _dsubViewTwo.frame =CGRectMake(0, HIT*2, WIT, HIT);
    [self addSubview:_dsubViewOne];
    [self addSubview:_dsubViewTwo];
    [self setSubviews];
    
    // default settings/默认设置
    self.backgroundColor=[UIColor clearColor];
    _scrollIndex=-1;
    _scrollCount=0;
    self.clipsToBounds=YES;
    
    // load timer/加载计时器
    _timer = self.timer;
    
    return self;
}

//set subviews
-(void) setSubviews{
    NSMutableArray *dataArr = _dataSource;
    if (dataArr.count>1) {
        self.updator(_dsubViewOne,dataArr,0);
        self.updator(_dsubViewTwo,dataArr,1);
    }else{
        self.updator(_dsubViewOne,dataArr,0);
        self.updator(_dsubViewTwo,dataArr,0);
    }
}

//change action
-(void) changeAction:(id) userInfo{
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:_dataSource];
    // modifying params/矫正参数
    [self modifyParams:dataArr];
    
    [UIView animateWithDuration:_animationDuration animations:^{
        //change frames of contentViews
        _dsubViewOne.frame = CGRectMake(0,_dsubViewOne.frame.origin.y-HIT, _dsubViewOne.frame.size.width, _dsubViewOne.frame.size.height);
        _dsubViewTwo.frame = CGRectMake(0, _dsubViewTwo.frame.origin.y-HIT,_dsubViewTwo.frame.size.width, _dsubViewTwo.frame.size.height);
    } completion:^(BOOL finished) {
        // once started cycling ,changing two subviews all the time/一旦进入循环 就会不断切换两个子控件的位置
        if (_cycleScroll) {
            if (CGRectGetMaxY(_dsubViewOne.frame)==(CGRectGetMinY(_dsubViewTwo.frame))){
                _dsubViewOne.frame =CGRectMake(0, HIT, WIT, HIT);
                self.updator(_dsubViewOne,dataArr,_scrollIndex);
            }else{
                _dsubViewTwo.frame =CGRectMake(0, HIT, WIT, HIT);
                self.updator(_dsubViewTwo,dataArr,_scrollIndex);
            }
            _dataIndex++;
            _dataIndex = (_dataIndex%dataArr.count);
        }
        _scrollIndex++;
        _scrollIndex = (_scrollIndex%dataArr.count);
    }];
}


-(void) modifyParams:(NSArray *) dataArr{
    if (_scrollCount<2) {
        // when scrollCount is 2 start cycling/滚动计数到第二时 开启循环
        if (_scrollCount==1) {
            if (dataArr.count<3) {
                _scrollIndex=0;
            }else{
                _scrollIndex=2;
            }
            _cycleScroll=YES;
            _scrollCount=3;
        }else{
            _scrollCount++;
            
        }
    }
}

// updating dataSource and properties of subviews/更新数据源及其子视图的属性
-(void) updateDataSource:(NSMutableArray *) dataSource{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
        
        //reset the view/还原默认设置
        self.updator(_dsubViewOne,dataSource,0);
        if (dataSource.count>1) {
            self.updator(_dsubViewTwo,dataSource,1);
        }
        
        _dsubViewOne.frame =CGRectMake(0, HIT, WIT, HIT);
        _dsubViewTwo.frame =CGRectMake(0, HIT*2, WIT, HIT);
        [_dataSource removeAllObjects];
        _dataSource=[NSMutableArray arrayWithArray:dataSource];
        
        _scrollIndex=-1;
        _dataIndex=0;
        _scrollCount=0;
        _cycleScroll=NO;
        
        _timer=self.timer;
    }
}



-(void) stop{
    if (_timer) {
        if (_isRunning) {
            _isRunning = NO;
            [_timer setFireDate:[NSDate distantFuture]];
        }
    }
}


-(void) run{
    if (_timer) {
        if (!_isRunning) {
            _isRunning = YES;
            [_timer setFireDate:[NSDate date]];
        }
    }
}

//lazy loading timer
-(NSTimer *) timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval target:self selector:@selector(changeAction:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        _isRunning = YES;
    }
    return _timer;
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
