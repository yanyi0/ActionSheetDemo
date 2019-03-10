//
//  DCMultipChoiceCell.m
//  DCMultipleSelectionPickerView
//
//  Created by 戴川 on 2018/11/15.
//  Copyright © 2018 Landz. All rights reserved.
//

#import "DCMultipChoiceCell.h"
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight ([[UIScreen mainScreen] bounds].size.height)
//#pragma mark - 16进制色值转RGB
#define UIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface DCMultipChoiceCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *textColor;

@end

@implementation DCMultipChoiceCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self ld_setupUI];
    }
    return self;
}
-(void)setTitle:(NSString *)text
{
    self.titleLabel.text = text;
    self.titleLabel.textColor = [UIColor darkGrayColor];
}
-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if(isSelected)
    {
        self.titleLabel.textColor = _selectedTextColor;
    }else
    {
        self.titleLabel.textColor = _textColor;
    }
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor textColor:(UIColor *)textColor
{
    _selectedTextColor = selectedTextColor;
    _textColor = textColor;
    
    self.titleLabel.textColor = _textColor;
}
#pragma mark - private
-(void)ld_setupUI
{
    UIView *contentView = self.contentView;
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.lineView];
    self.titleLabel.frame = CGRectMake(0, 0, KScreenWidth, 54);
    self.lineView.frame = CGRectMake(0, 54, KScreenWidth, 1);
}
#pragma mark - settert//getter
-(UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGBHex(0x999999);
    }
    return _lineView;
}
@end
