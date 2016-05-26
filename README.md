#SYVerticalAutoScrollView
This is an auto cycled scroll view made by objective-c,you can put any subclasses of UIView in to make it work<br>(这是用objective-c封装的一个垂直轮播控件，可以实现淘宝客户端淘宝头条样的效果。)


#What this view can do?/这个视图可以干吗？
You can create a vertical auto cycled scroll view with a single initilizer. <br>
只要通过初始化方法，就可以实现淘宝头条轮播公告的效果。
![demopic](https://github.com/shionIsMyName/SYVerticalAutoScrollView/blob/branch_A/show2.png)


#How to use?/如何使用?
    //rect of the view/控件的尺寸位置
    CGRect rect = CGRectMake(0, self.view.frame.origin.y,self.view.frame.size.width, 50);
    
    //contentViews/内容视图数组
    //it has to be two exactly plain views,cause objective-c can not copy UIView,even if you could copy by using archiver/unarchiver,but when your views were made by ib ,subviews of copied views wound't be initlized!!!
    //必须要传递两个一样的视图，因为oc下无法复制uiview，就算用archiver/unarchiver可以复制，但是你的视图如果是ib绘制的话，子控件将无法被赋值！！！
    NSArray *contentViews = [[NSArray alloc] initWithObjects:[UIButton buttonWithType:UIButtonTypeCustom],[UIButton buttonWithType:UIButtonTypeCustom], nil];
    
    //interval of animations/动画间隔
    float intervalOfAnimation = 2;
    //duration of animations/动画持久
    float durationOfAnimation = 1;
    //datasource for updating contentViews per scrolling
    //每次滚动时，用来更新你传递的内容视图用的数据源
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:@"data1",@"data2",@"data3",@"data4",@"data5",@"data6", nil];
    
    //initilizer/初始化方法
    //you can put any subclasses of UIView in to make them work
    //只要是UIView的子类都可以用
     _sv = [[SYVerticalAutoScrollView alloc] init:rect
                                      customViews:contentViews
                                animationInterval:intervalOfAnimation
                                animationDuration:durationOfAnimation
                                       dataSource:dataSource
                                          updator:^(UIButton *sender,
                                                    NSMutableArray *data,
                                                    int index) {
        //do your personal setting or updating here!
        //你传递的内容视图的设置和更新写在这里
        [sender addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [sender setTitle:data[index] forState:UIControlStateNormal];
    }];
    
    //once you add into your superview,the view was started already.
    //添加到父视图后，动画就已经开始
    [self.view addSubview:_sv];
    
    
    -(void) changeAction:(UIButton *) sender{
    //dataIndex works like a pageNum,//can be used to confirm which element you clicked in dataSource.
    //数据索引类似横向轮播图控件的页码,
    //可以用来确定你点击的是数据源中的第几个元素。
    NSLog(@"index--->%d",_sv.dataIndex);
    }
   
  
#How to install?/如何安装?
1,drag into your project.<br>拖拽进工程 <br>
2,pod search SYVerticalAutoScrollView ,and vim the Podfile,pod install...... <br>终端搜索,编辑podfile,命令安装...


#how does it work?/原理
The core idea of this view actually is that two views switch each other all the time. <br>
原理其实就是两个内容视图不停的切换。

