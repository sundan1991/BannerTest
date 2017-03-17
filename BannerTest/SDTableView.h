//
//  SDTableView.h
//  BannerTest
//
//  Created by sundan on 17/3/16.
//  Copyright © 2017年 lzt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SDTableViewTouchBlock) (NSSet<UITouch *> *touches,UIEvent *touchEvent, BOOL isTouch);

@interface SDTableView : UITableView

@property (nonatomic ,copy  )   SDTableViewTouchBlock  block;

@end
