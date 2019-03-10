//
//  DCMultipChoiceCell.h
//  DCMultipleSelectionPickerView
//
//  Created by 戴川 on 2018/11/15.
//  Copyright © 2018 Landz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCMultipChoiceCell : UITableViewCell
@property(nonatomic,assign)BOOL isSelected;
-(void)setTitle:(NSString *)text;
-(void)setSelectedTextColor:(UIColor *)selectedTextColor textColor:(UIColor *)textColor;
@end

NS_ASSUME_NONNULL_END
