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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIView *backgroundView;

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
        [self p_DCSetMainView];
        self.hidden = YES;
    }
    return self;
}
#pragma mark - 公共方法
-(void)showAnimation
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    //防止cell上面点击事件失效
    pan.cancelsTouchesInView = NO;
    [self addGestureRecognizer:pan];
    
    self.hidden = NO;
    self.titleLabel.text = self.relation;
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
#pragma mark - 私有方法
-(void)p_DCSetMainView
{
//    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//    self.backgroundView.backgroundColor = RGBA(51, 51, 51, 0.3);
//    [self addSubview:self.backgroundView];
    
    self.backgroundColor = RGBA(51, 51, 51, 0.3);
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.confirmButton];
    [self.bottomView addSubview:self.cancleButton];
    [self.bottomView addSubview:self.tableView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bottomView addSubview:lineView];
}

-(void)dismissContactView:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self.bottomView pointInside:[self.bottomView convertPoint:location fromView:self] withEvent:nil]){
            [self removeGestureRecognizer:sender];
            [self p_DCHidenAnimation];
        }
    }
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
    [self p_DCHidenAnimation];
}
-(void)confrimButtonClick:(UIButton *)button
{
    if(self.finishBlock)
    {
        self.finishBlock(self.selectedItem);
    }
    [self p_DCHidenAnimation];
}
#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCMultipChoiceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    self.selectedItem = self.dataArr[indexPath.row];
    if(self.finishBlock)
    {
        self.finishBlock(self.selectedItem);
        cell.isSelected = !cell.isSelected;
    }
    [self p_DCHidenAnimation];
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
-(UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, KScreenWidth - 64 - 64, 55)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:19];
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
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
@end
