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
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandler:)];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler:)];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.view addGestureRecognizer:singleTapGesture];
    [self.view addGestureRecognizer:doubleTapGesture];
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)singleTapHandler:(id)sender {
    [self showAlertViewStyle:SCAlertViewStyleAlert];
}

- (void)doubleTapHandler:(id)sender {
    [self showAlertViewStyle:SCAlertViewStyleActionSheet];
}

- (void)longPressHandler:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"同意退款￥12" message:@"退款金额将返回买家银行卡" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertViewStyle:(SCAlertViewStyle)style {
    NSString *title = @"同意退款￥12";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]|￥)+" options:0 error:NULL];
    NSArray *matches = [regular matchesInString:title options:0 range:NSMakeRange(0, title.length)];
    for (NSTextCheckingResult *result in matches) {
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
    }

    SCAlertView *alertView = [SCAlertView alertViewWithAttributedTitle:attrString message:@"退款金额将返回买家银行卡" style:style];
    SCAlertAction *action = [SCAlertAction actionWithTitle:@"确定" style:SCAlertActionStyleConfirm handler:^(SCAlertAction *action) {
        NSLog(@"点击确定");
    }];
    [alertView addAction:[SCAlertAction actionWithTitle:@"test" style:SCAlertActionStyleDefault handler:nil]];
    [alertView addAction:[SCAlertAction actionWithTitle:@"取消" style:SCAlertActionStyleCancel handler:nil]];
    [alertView addAction:action];
    [alertView show];
}

@end
