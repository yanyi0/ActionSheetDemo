//
//  DCMultipleChoicePickerView.h
//  DCMultipleSelectionPickerView
//
//  Created by 戴川 on 2018/11/15.
//  Copyright © 2018 Landz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, DCPickerViewType)
{
    DCPickerViewTypeNoNavgationBar,
    DCPickerViewTypeNavgationBar,
};
typedef void(^selectedFinishBlock)(NSString *selectedItem);

@interface DCMultipleChoicePickerView : UIView
@property(nonatomic,copy)NSString *relation;
@property (nonatomic, strong) NSArray<NSString *> *dataArr;
@property(nonatomic,copy)selectedFinishBlock finishBlock;
@property(nonatomic,copy)NSString *selectedItem;
-(instancetype)initWithType:(DCPickerViewType)type;
/** 设置取消按钮的文字颜色 */
-(void)setCancelTextColor:(UIColor *)color;
/** 设置确认按钮的文字颜色 */
-(void)setConfirmTextColor:(UIColor *)color;
/** 设置选项的文字颜色和选中后的文字颜色 */
-(void)setSelectedTextColor:(UIColor *)selectedTextColor textColor:(UIColor *)textColor;
-(void)showAnimation;

@end

NS_ASSUME_NONNULL_END
