//
//  CustomView.h
//  SYVerticalScrollViewDemo
//
//  Created by shiyong on 16/5/25.
//  Copyright © 2016年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

@property (strong, nonatomic) IBOutlet UILabel *lblA;
@property (strong, nonatomic) IBOutlet UILabel *lblB;
@property (strong, nonatomic) IBOutlet UIButton *BtnA;
@property (strong, nonatomic) IBOutlet UIButton *BtnB;

+(instancetype) customView;
@end
