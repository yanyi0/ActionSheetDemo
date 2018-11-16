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

@interface DCMultipChoiceCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *image;

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
    [self.selectedButton setSelected:NO];
    
    
}
-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    [self.selectedButton setSelected:isSelected];
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
-(void)setSelectedImage:(UIImage *)selectedImage image:(UIImage *)image
{
    [self.selectedButton setImage:selectedImage forState:UIControlStateNormal];
    [self.selectedButton setImage:image forState:UIControlStateSelected];
}
#pragma mark - private
-(void)ld_setupUI
{
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.selectedButton];
    
    self.titleLabel.frame = CGRectMake(0, 0, KScreenWidth, 55);
    self.selectedButton.frame = CGRectMake(KScreenWidth - 42, 21, 12, 12);
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
-(UIButton *)selectedButton
{
    if(_selectedButton == nil)
    {
        _selectedButton = [[UIButton alloc]init];
        [_selectedButton setImage:[UIImage imageNamed:@"icon_screen_retangle"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"icon_screen_retangleSelect"] forState:UIControlStateSelected];
    }
    return _selectedButton;
}

@end
