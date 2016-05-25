//
//  CustomView.m
//  SYVerticalScrollViewDemo
//
//  Created by shiyong on 16/5/25.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView




+(instancetype) customView{
    return [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil].firstObject;
}
-(void) awakeFromNib{
    _lblA.layer.cornerRadius=3;
    _lblA.layer.borderWidth=1;
    _lblA.layer.borderColor=[UIColor redColor].CGColor;
    
    _lblB.layer.cornerRadius=3;
    _lblB.layer.borderWidth=1;
    _lblB.layer.borderColor=[UIColor redColor].CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
