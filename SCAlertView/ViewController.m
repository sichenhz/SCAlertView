//
//  ViewController.m
//  SCAlertView
//
//  Created by sichenwang on 16/3/8.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "ViewController.h"
#import "SCAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)]];
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressView:)]];
}

- (void)tapView:(id)sender {
    [self showAlertView];
}

- (void)pressView:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"同意退款￥12" message:@"退款金额将返回买家银行卡" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertView {
    NSString *title = @"同意退款￥12";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]|￥)+" options:0 error:NULL];
    NSArray *matches = [regular matchesInString:title options:0 range:NSMakeRange(0, title.length)];
    for (NSTextCheckingResult *result in matches) {
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
    }

    SCAlertView *alertView = [SCAlertView alertViewWithAttributedTitle:attrString message:@"退款金额将返回买家银行卡"];
    SCAlertAction *action = [SCAlertAction actionWithTitle:@"确定" style:SCAlertActionStyleConfirm handler:^(SCAlertAction *action) {
        NSLog(@"点击确定");
    }];
    [alertView addAction:[SCAlertAction actionWithTitle:@"取消" style:SCAlertActionStyleCancel handler:nil]];
    [alertView addAction:action];
    [alertView show];
}

@end
