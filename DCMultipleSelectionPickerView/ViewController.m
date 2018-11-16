//
//  ViewController.m
//  DCMultipleSelectionPickerView
//
//  Created by 戴川 on 2018/11/15.
//  Copyright © 2018 Landz. All rights reserved.
//

#import "ViewController.h"
#import "DCMultipleChoicePickerView.h"

@interface ViewController ()
@property (nonatomic, strong) DCMultipleChoicePickerView  *pickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    button.center = self.view.center;
    [button setTitle:@"点击弹框" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    DCMultipleChoicePickerView *pickerView = [[DCMultipleChoicePickerView alloc]initWithType:DCPickerViewTypeNoNavgationBar];
    pickerView.dataArr = @[@"南",@"北",@"东",@"西",@"中",@"上",@"下",@"左",@"右"];
    pickerView.finishBlock = ^(NSArray * _Nonnull selectedArr) {
        NSLog(@"%@",[selectedArr componentsJoinedByString:@","]);
    };
    [self.view addSubview:pickerView];
    _pickerView = pickerView;
}

-(void)buttonDidClick
{
    NSLog(@"buttonDidClick");
    [_pickerView showAnimation];
}

@end
