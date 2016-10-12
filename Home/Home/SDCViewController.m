//
//  SDCViewController.m
//  MoKuai
//
//  Created by zhongpu on 16/10/11.
//  Copyright © 2016年 zhongpu. All rights reserved.
//

#import "SDCViewController.h"
#import "SDCycleScrollView.h"
#import "UIView+EXT.h"
#import "UIColor+RGBA.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT (IS_IOS7 ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.height - 20)
#define WIDTH_FIT 320.0 * SCREEN_WIDTH
#define HEIGHT_FIT 568.0 * SCREEN_HEIGHT

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

@interface SDCViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) SDCycleScrollView * sdcyclesView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) UIView * topView;

@end

@implementation SDCViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    
    
    _sdcyclesView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220) delegate:self placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    _sdcyclesView.localizationImageNamesGroup = @[[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"]];
    _sdcyclesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _sdcyclesView.showPageControl = YES;
    _sdcyclesView.titleLabelHeight = 0;
    _sdcyclesView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _sdcyclesView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    [headerView addSubview:_sdcyclesView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH - 50, 40)];
    [_topView addSubview:textField];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 2;
    textField.layer.masksToBounds = YES;
    textField.placeholder = @"   耶耶耶！！！";
    [self.view addSubview:_topView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
   if (point.y < 0) {
        _sdcyclesView.height = - point.y + 220;
        _sdcyclesView.top = point.y;
      
   }else if (point.y > 0){
       
       CGFloat p = fmod(MIN(self.tableView.height, scrollView.contentOffset.y) , SCREEN_HEIGHT) /SCREEN_HEIGHT * 8.0; // 8.0 倍数 变换速度
       
       if (SCREEN_HEIGHT <= point.y || p > 1) //因为取得余数 只算  1倍以内， 超过1 都为显示 p = 1
       {
           p = 1;
       }
       if (point.y == 0){
           p = 0;
       }
       NSLog(@"%f",fabs(p));
       [self sssssWithP: fabs(p)];

   }
    
}

#pragma mark - 渐变色
-(void)sssssWithP:(CGFloat)p{
    RGBA rgba = RGBAFromUIColor([UIColor whiteColor]);
    CGFloat red1 = rgba.r;
    CGFloat green1 = rgba.g;
    CGFloat blue1 = rgba.b;
    CGFloat aph1 = 0;
    
    
    RGBA rgbNew = RGBAFromUIColor([UIColor redColor]);
    CGFloat red2 = rgbNew.r;
    CGFloat green2 = rgbNew.g;
    CGFloat blue2 = rgbNew.b;
    CGFloat aph2 = 0.9;
    
    //向前变
//    CGFloat redTemp1 = ((red2 - red1) * (1-p)) + red1;
//    CGFloat greenTemp1 = ((green2 - green1) * (1 - p)) + green1;
//    CGFloat blueTemp1 = ((blue2 - blue1) * (1 - p)) + blue1;
//
    //向后变
    CGFloat redTemp2 = ((red2 - red1) * p) + red1;
    CGFloat greenTemp2 = ((green2 - green1) * p) + green1;
    CGFloat blueTemp2 = ((blue2 - blue1) * p) + blue1;
    CGFloat aphTemp2 = (aph2 - aph1) * p + aph1;
    if (p == 0) {
        aphTemp2 = 0;
    }
    self.topView.backgroundColor = [UIColor colorWithRed:redTemp2 green:greenTemp2 blue:blueTemp2 alpha:aphTemp2];
    NSLog(@"%f",aphTemp2);

    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = @"sss";
    return cell;
}


@end
