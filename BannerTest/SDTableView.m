//
//  SDTableView.m
//  BannerTest
//
//  Created by sundan on 17/3/16.
//  Copyright © 2017年 lzt. All rights reserved.
//

#import "SDTableView.h"

@implementation SDTableView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.block(touches,event,YES);
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.block(touches,event,NO);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    self.block(touches,event,NO);
}


@end
