//
//  DCMultipleChoicePickerView.m
//  DCMultipleSelectionPickerView
//
//  Created by 戴川 on 2018/11/15.
//  Copyright © 2018 Landz. All rights reserved.
//

#import "DCMultipleChoicePickerView.h"

#import "DCMultipChoiceCell.h"


#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//默认选中的颜色
#define kSelectedColor RGBA(190, 162, 108, 1)
//判断iPhoneX iphoneXS
#define iPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)
//判断iPhoneXR
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXSMax
#define iPhoneXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneX所有系列
#define iPhoneXAll (iPhoneX || iPhoneXR || iPhoneXS_MAX)
//导航栏高度
#define kNavigationBarHeight (iPhoneXAll ? 88 : 64)
//底部安全区域
#define kHomeIndicator (iPhoneXAll ? 34 : 0)
//屏幕高度和宽度
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight ([[UIScreen mainScreen] bounds].size.height)


@interface DCMultipleChoicePickerView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *image;


@property (nonatomic, strong) NSMutableArray *selectedDataArr;
/** 选中s数据的缓存 */
@property (nonatomic, strong) NSMutableArray *CacheSelectedDataArr;
@end

static NSString *const cellKey = @"cellKey";
@implementation DCMultipleChoicePickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        NSLog(@"该方法不是初始化方法");
    }
    return self;
}

-(instancetype)initWithType:(DCPickerViewType)type
{
    CGRect frame;
    if(type == DCPickerViewTypeNoNavgationBar)
    {
        frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }else
    {
        frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationBarHeight);
    }
    if(self = [super initWithFrame:frame])
    {
        _selectedTextColor = kSelectedColor;
        _textColor = [UIColor darkGrayColor];
        _image = [UIImage imageNamed:@"icon_screen_retangle"];
        _selectedImage = [UIImage imageNamed:@"icon_screen_retangleSelect"];
        [self p_DCSetMainView];
        self.hidden = YES;
    }
    return self;
}
#pragma mark - 公共方法
-(void)showAnimation
{
    self.hidden = NO;
    //改变cell的状态
    for(NSInteger i=0, count=self.dataArr.count ;i<count;i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DCMultipChoiceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if([self.CacheSelectedDataArr containsObject:indexPath])
        {
            cell.isSelected = YES;
        }else
        {
            cell.isSelected = NO;
        }
    }
    for (NSIndexPath *indexPath in self.CacheSelectedDataArr) {
        DCMultipChoiceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat height = self.bottomView.frame.size.height;
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}
-(void)setCancelTextColor:(UIColor *)color
{
    [self.cancleButton setTitleColor:color forState:UIControlStateNormal];
}
-(void)setConfirmTextColor:(UIColor *)color
{
    [self.confirmButton setTitleColor:color forState:UIControlStateNormal];
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor textColor:(UIColor *)textColor
{
    _selectedTextColor = selectedTextColor;
    _textColor = textColor;
    [self.tableView reloadData];
}
-(void)setSelectedImage:(UIImage *)selectedImage image:(UIImage *)image
{
    
}
#pragma mark - 私有方法
-(void)p_DCSetMainView
{
    self.backgroundColor = RGBA(51, 51, 51, 0.3);
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.confirmButton];
    [self.bottomView addSubview:self.cancleButton];
    [self.bottomView addSubview:self.tableView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bottomView addSubview:lineView];
}
-(void)p_DCHidenAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)setDataArr:(NSArray<NSString *> *)dataArr
{
    _dataArr = dataArr;
    
    if(dataArr.count < 4)
    {
        //重新布局
        self.bottomView.frame = CGRectMake(0,self.frame.size.height, KScreenWidth,  55*(dataArr.count+1) + kHomeIndicator);
        self.tableView.frame = CGRectMake(0, 55, KScreenWidth, 55 * dataArr.count);
    }
    [self.tableView reloadData];
}
#pragma mark - target
-(void)cancleButtonClick:(UIButton *)button
{
    //如果取消，把上次确定的时候缓存的数据赋值过来
    self.selectedDataArr = [NSMutableArray arrayWithArray:self.CacheSelectedDataArr];
    [self p_DCHidenAnimation];
}
-(void)confrimButtonClick:(UIButton *)button
{
    self.CacheSelectedDataArr = [self.selectedDataArr mutableCopy];
    
    NSMutableArray *selectedStringArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selectedDataArr) {
        NSString *string = self.dataArr[indexPath.row];
        [selectedStringArr addObject:string];
    }
    
    if(self.finishBlock)
    {
        self.finishBlock(selectedStringArr);
    }
    [self p_DCHidenAnimation];
}
#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCMultipChoiceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    if(cell.isSelected)
    {
        [self.selectedDataArr addObject:indexPath];
    }else
    {
        [self.selectedDataArr removeObject:indexPath];
    }
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCMultipChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    [cell setTitle:self.dataArr[indexPath.row]];
    [cell setSelectedTextColor:_selectedTextColor textColor:_textColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - setter//getter
-(UIView *)bottomView
{
    if(_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, KScreenWidth, 275 + kHomeIndicator)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
-(UIButton *)cancleButton
{
    if(_cancleButton == nil)
    {
        _cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 55)];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
-(UIButton *)confirmButton
{
    if(_confirmButton == nil)
    {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 64, 0, 64, 55)];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kSelectedColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confrimButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
-(UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, KScreenWidth, 220)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerClass:[DCMultipChoiceCell class] forCellReuseIdentifier:cellKey];
    }
    return _tableView;
}
-(NSMutableArray *)selectedDataArr
{
    if(_selectedDataArr == nil)
    {
        _selectedDataArr = [NSMutableArray array];
    }
    return _selectedDataArr;
}
-(NSMutableArray *)CacheSelectedDataArr
{
    if(_CacheSelectedDataArr == nil)
    {
        _CacheSelectedDataArr = [NSMutableArray array];
    }
    return _CacheSelectedDataArr;
}

@end
