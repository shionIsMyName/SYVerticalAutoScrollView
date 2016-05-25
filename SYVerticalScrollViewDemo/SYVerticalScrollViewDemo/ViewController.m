//
//  ViewController.m
//  SYVerticalScrollViewDemo
//
//  Created by shiyong on 16/5/25.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "ViewController.h"
#import "SYVerticalAutoScrollView.h"
#import "CustomView.h"

#define RDMCLR  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ViewController ()

@property (nonatomic,retain) SYVerticalAutoScrollView *simpleView;

@property (nonatomic,retain) SYVerticalAutoScrollView *customView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加控制按钮
    //load event control btns
    [self loadEventControlBtns];
    
    //简单的初始化
    //simpleView demo
    [self loadSimpleViewDemo];
    
    //自定义内容视图初始化
    //customView demo
    [self loadCustomViewDemo];
}

//load event control btns
-(void) loadEventControlBtns{
    for (int i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:RDMCLR];
        if (i==0) {
            [btn setTitle:@"update" forState:UIControlStateNormal];
        }else if(i==1){
            [btn setTitle:@"stop" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"run" forState:UIControlStateNormal];
        }
        [btn setTag:i];
        btn.frame = CGRectMake(100*i, self.view.center.y-50, 100, 50);
        [btn addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}
//简单的初始化
//simpleView demo
-(void) loadSimpleViewDemo{
    //prepare params
    UIButton *btnA = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btnB = [UIButton buttonWithType:UIButtonTypeCustom];
    //if you want listen events when they were tapped,
    [btnA addTarget:self  action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnB addTarget:self  action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    //core idea of this view is auto switching two views to make them look like cycling all the time,so you have give the view two views!!!
    NSArray *btns = [[NSArray alloc] initWithObjects:btnA,btnB,nil];
    CGRect defaultRect = CGRectMake(0, self.view.center.y, self.view.frame.size.width, 50);
    float animationInterval = 2;
    float animationDuration = 1;
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:@"data0",@"data1",@"data2",@"data3",@"data4",@"data5",nil];
    
    //init it
    _simpleView = [[SYVerticalAutoScrollView alloc] init:defaultRect
                                             customViews:btns
                                       animationInterval:animationInterval
                                       animationDuration:animationDuration
                                              dataSource:dataSource
                                                 updator:^(UIButton *sender,
                                                           NSMutableArray *data,
                                                           int index) {
                                                     //do your update with params
                                                     [sender setTitle:data[index] forState:UIControlStateNormal];
                                                 }];
    _simpleView.backgroundColor=RDMCLR;
    [self.view addSubview:_simpleView];
}

-(void) loadCustomViewDemo{
    //prepare params
    CustomView *custViewOne = [CustomView customView];
    CustomView *custViewTwo = [CustomView customView];
    [custViewOne.BtnA addTarget:self  action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [custViewOne.BtnB addTarget:self  action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [custViewTwo.BtnA addTarget:self  action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [custViewTwo.BtnB addTarget:self  action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *custArr = [[NSMutableArray alloc] initWithObjects:custViewOne,custViewTwo, nil];
    
    CGRect custRect = CGRectMake(0, self.view.center.y+100, self.view.frame.size.width, 50);
    float animationInterval = 2;
    float animationDuration = 1;
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:@"data0",@"data1",@"data2",@"data3",@"data4",@"data5",nil];
    
    //init it
    _customView = [[SYVerticalAutoScrollView alloc] init:custRect
                                             customViews:custArr
                                       animationInterval:animationInterval
                                       animationDuration:animationDuration
                                              dataSource:dataSource
                                                 updator:^(CustomView *sender,
                                                           NSMutableArray *data,
                                                           int index) {
                                                     //do your update with params
                                                     [sender.BtnA setTitle:data[index] forState:UIControlStateNormal];
                                                     [sender.BtnB setTitle:data[index] forState:UIControlStateNormal];
                                                     [sender.lblA setText:@"HOT"];
                                                     [sender.lblB setText:@"HOT"];
                                                 }];
    _customView.backgroundColor=RDMCLR;
    [self.view addSubview:_customView];
}

-(void) controlAction:(UIButton *) sender{
    NSInteger tag = sender.tag;
    if (tag==0) {
        //update
         NSMutableArray *newDataSource = [[NSMutableArray alloc] initWithObjects:@"newData0",@"newData1",@"newdata2",@"newData3",@"newData4",@"newData5",nil];
        [_simpleView updateDataSource:newDataSource];
        [_customView updateDataSource:newDataSource];
    }else if(tag==1){
        //stop
        [_simpleView stop];
        [_customView stop];
    }else{
        //run
        [_simpleView run];
        [_customView run];
    }
}


-(void) clickAction:(UIButton *) sender{
    NSLog(@"you tapped the --->%d element of the dataSource",_simpleView.dataIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
