//
//  ViewController.m
//  BannerTest
//
//  Created by sundan on 17/3/16.
//  Copyright © 2017年 lzt. All rights reserved.
//

#import "ViewController.h"

#import "SDTableView.h"

#define KScreenWith [UIScreen mainScreen].bounds.size.width

#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define KTableViewHeaderHeight 200

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)   SDTableView *myTableView;

@property (nonatomic ,strong)   NSArray *imgArr;

@property (nonatomic ,assign)   NSInteger headerImgIndex;

@property (nonatomic ,strong)   CATransition *myTransition;

@property (nonatomic ,strong)   NSTimer *timer;

@property (nonatomic ,strong)   UIImageView *headerImageV;

@property (nonatomic ,assign)   BOOL swipLastPiece;

@property (nonatomic ,strong)   UIPageControl *myPageControl;

@end

@implementation ViewController

- (NSArray *)imgArr{
    if (_imgArr == nil) {
        _imgArr = @[@"1.jpg",@"2.png",@"3.jpg"];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    [self loadTimer];
}
- (void)viewDidAppear:(BOOL)animated{
    [self.timer setFireDate:[NSDate distantPast]];
}

#pragma mark - loadTimer
- (void)loadTimer{
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];

}
- (void)timerMethod:(NSTimer *)sender{
    if (self.swipLastPiece) {
        self.swipLastPiece = NO;
        return;
    }
    self.myTransition.subtype = kCATransitionFromRight;
    self.headerImgIndex++;
    [self changeImage];
}

#pragma mark - tableView
- (void)loadTableView{
    self.myTableView = [[SDTableView alloc] initWithFrame:CGRectMake(0, 20,KScreenWith,KScreenHeight-20) style:(UITableViewStylePlain)];
    self.myTableView.tableHeaderView = [self addTableViewHeaderView];
    [self addSwipMethodOnView:self.myTableView.tableHeaderView];
    [self addPageControlViewOnView:self.myTableView.tableHeaderView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.userInteractionEnabled = YES;
    __weak typeof(self)weakSelf = self;
    self.myTableView.block = ^(NSSet<UITouch *> *touches,UIEvent *touchEvent, BOOL isTouch){
        if (isTouch) {
            //点击切换图（应该是点击进详情页，管它呢。。。）
            [weakSelf.timer setFireDate:[NSDate distantFuture]];
        }
        else{
            //取消
            [weakSelf.timer setFireDate:[NSDate distantPast]];
        }
    };
    [self.view addSubview:self.myTableView];
}
- (void)addPageControlViewOnView:(UIView *)view{
    self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(KScreenWith-100, KTableViewHeaderHeight-60, 100, 40)];
    self.myPageControl.numberOfPages = self.imgArr.count;
    [view addSubview:self.myPageControl];
    
}
- (UIView *)addTableViewHeaderView{
    //imageView
    return [self returnHeaderViewWithImageView];
}
-(UIView *)returnHeaderViewWithImageView{
    CGRect rect = CGRectMake(0, 0, KScreenWith, KTableViewHeaderHeight);
    self.headerImageV = [[UIImageView alloc] initWithFrame:rect];
    NSString *imgPath = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"jpg"];
    self.headerImageV.image = [UIImage imageWithContentsOfFile:imgPath];
    self.headerImageV.userInteractionEnabled = YES;
    self.headerImageV.tag = 100;
    return self.headerImageV;
}
- (void)addSwipMethodOnView:(UIView *)view{
    //左滑手势
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewSwipeMethod:)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:leftSwip];
    //右滑手势
    UISwipeGestureRecognizer *rigSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewSwipeMethod:)];
    rigSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:rigSwip];
}
- (void)headerImageViewSwipeMethod:(UISwipeGestureRecognizer *)swip{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.swipLastPiece = YES;
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        //上一张
        self.myTransition.subtype = kCATransitionFromLeft;
        self.headerImgIndex --;
    }
    else if (swip.direction == UISwipeGestureRecognizerDirectionLeft){
        //下一张
        self.myTransition.subtype = kCATransitionFromRight;
        self.headerImgIndex ++;
    }
    [self changeImage];
    [self.timer setFireDate:[NSDate distantPast]];
}
- (void)changeImage{
    if (self.headerImgIndex <0) {
        self.headerImgIndex = self.imgArr.count-1;
    }
    else if (self.headerImgIndex == self.imgArr.count){
        self.headerImgIndex = 0;
    }
    NSArray *arr = [self.imgArr[self.headerImgIndex] componentsSeparatedByString:@"."];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:arr[0] ofType:arr[1]];
    [self.headerImageV setImage:[UIImage imageWithContentsOfFile:imgPath]];
    [self.headerImageV.layer addAnimation:self.myTransition forKey:@"push"];
    self.myPageControl.currentPage = self.headerImgIndex;
}
- (CATransition *)myTransition{
    if (_myTransition == nil) {
        _myTransition = [[CATransition alloc] init];
        _myTransition.type = @"push";
    }
    return _myTransition;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
    }
    return cell;
}

@end
