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


static NSString * const EightHonorsAndDisgraces = @"以热爱祖国为荣、以危害祖国为耻！,以服务人民为荣、以背离人民为耻！,以崇尚科学为荣、以愚昧无知为耻！,以辛勤劳动为荣、以好逸恶劳为耻！,以团结互助为荣、以损人利己为耻！,以诚实守信为荣、以见利忘义为耻！,以遵纪守法为荣、以违法乱纪为耻！,以艰苦奋斗为荣、以骄奢淫逸为耻！";

@interface SDCViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) SDCycleScrollView * sdcyclesView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) UIView * topView;

@property(nonatomic, strong) NSArray * dataArray;


@end

@implementation SDCViewController

#pragma mark - init

- (void)setTableView:(UITableView *)tableView{
    
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, 0);

}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self addTableViewHeader];
    [self addTopSearchView];
    _dataArray = [EightHonorsAndDisgraces componentsSeparatedByString:@","];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

//轮播器 tab-header
-(void)addTableViewHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    
    _sdcyclesView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220) delegate:self placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    _sdcyclesView.localizationImageNamesGroup = @[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"]];
    _sdcyclesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _sdcyclesView.showPageControl = YES;
    _sdcyclesView.titleLabelHeight = 0;
    _sdcyclesView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _sdcyclesView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    [headerView addSubview:_sdcyclesView];
    
    _tableView.tableHeaderView = headerView;

}

//搜索 悬浮
- (void)addTopSearchView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25, 25, SCREEN_WIDTH - 50, 40)];
    [_topView addSubview:textField];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 2;
    textField.layer.masksToBounds = YES;
    textField.placeholder = @"   耶耶耶！！！";
    [self.view addSubview:_topView];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y < 0) {
            _sdcyclesView.height = - offset.y + 220;
            _sdcyclesView.top = offset.y;
            [self gradientWithCoefficient:0];

        }else if (offset.y > 0){
            
            //渐变系数
            CGFloat gradientCoefficient = fmod(MIN(self.tableView.height, scrollView.contentOffset.y) , SCREEN_HEIGHT) /SCREEN_HEIGHT * 8.0; // 8.0 倍数 变换速度
            
            if (SCREEN_HEIGHT <= offset.y || gradientCoefficient > 1) //因为取得余数 只算  1倍以内， 超过1 都为显示 p = 1
            {
                gradientCoefficient = 1;
            }
            if (offset.y < 20)
            {
                gradientCoefficient = 0;
            }
            [self gradientWithCoefficient: fabs(gradientCoefficient)];
            
        }

    }
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    [self gradientWithCoefficient: 0];

}
#pragma mark - 渐变色
-(void)gradientWithCoefficient:(CGFloat)coefficient{
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
//    CGFloat redTemp1 = ((red2 - red1) * (1-coefficient)) + red1;
//    CGFloat greenTemp1 = ((green2 - green1) * (1 - coefficient)) + green1;
//    CGFloat blueTemp1 = ((blue2 - blue1) * (1 - coefficient)) + blue1;
//
    //向后变
    CGFloat redTemp2 = ((red2 - red1) * coefficient) + red1;
    CGFloat greenTemp2 = ((green2 - green1) * coefficient) + green1;
    CGFloat blueTemp2 = ((blue2 - blue1) * coefficient) + blue1;
    CGFloat aphTemp2 = (aph2 - aph1) * coefficient + aph1;
    if (coefficient == 0) {
        aphTemp2 = 0;
    }
    self.topView.backgroundColor = [UIColor colorWithRed:redTemp2 green:greenTemp2 blue:blueTemp2 alpha:aphTemp2];
//    NSLog(@"%f",aphTemp2);

    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}


@end
