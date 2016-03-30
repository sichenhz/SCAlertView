//
//  SCAlertView.m
//  Higo
//
//  Created by sichenwang on 16/3/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "SCAlertView.h"

@interface SCAlertAction()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) SCAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(SCAlertAction *action);

@end

@implementation SCAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(SCAlertActionStyle)style handler:(void (^)(SCAlertAction *action))handler {
    SCAlertAction *alertAction = [[SCAlertAction alloc] init];
    alertAction.title = title;
    alertAction.style = style;
    alertAction.handler = handler;
    return alertAction;
}

@end

@interface SCAlertView()

@property (nonatomic, readwrite) NSArray<SCAlertAction *> *actions;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UIView *lineTop;
@property (nonatomic, weak) UIView *lineMid;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, weak) UIView *backgroundView;

@end

@implementation SCAlertView

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    SCAlertView *alertView = [self alertView];
    alertView.title = title;
    alertView.message = message;
    return alertView;
}

+ (instancetype)alertViewWithAttributedTitle:(NSAttributedString *)title message:(NSString *)message {
    SCAlertView *alertView = [self alertView];
    alertView.attrTitle = title;
    alertView.message = message;
    return alertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title attributedMessage:(NSAttributedString *)message {
    SCAlertView *alertView = [self alertView];
    alertView.title = title;
    alertView.attrMessage = message;
    return alertView;
}

+ (instancetype)alertViewWithAttributedTitle:(NSAttributedString *)title attributedMessage:(NSAttributedString *)message {
    SCAlertView *alertView = [self alertView];
    alertView.attrTitle = title;
    alertView.attrMessage = message;
    return alertView;
}

+ (instancetype)alertView {
    CGFloat width = 270;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - 270) / 2.0;
    SCAlertView *alertView = [[SCAlertView alloc] initWithFrame:CGRectMake(x, 0, width, 0)];
    alertView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:237/255.0 alpha:1];
    alertView.layer.cornerRadius = 12;
    alertView.clipsToBounds = YES;
    [alertView layoutAlertView];
    return alertView;
}

- (void)addAction:(SCAlertAction *)action {
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.actions];
    [arrM addObject:action];
    self.actions = [arrM copy];
    [self layoutAlertView];
}

- (void)layoutAlertView {
    
    CGFloat height = 22;
    
    if (self.title || self.attrTitle) {
        CGRect frame = self.titleLabel.frame;
        frame.origin.y = height;
        frame.size.height = [self.titleLabel sizeThatFits:CGSizeMake(238, MAXFLOAT)].height;
        self.titleLabel.frame = frame;
        height += frame.size.height;
    }
    
    if (self.message || self.attrMessage) {
        if (self.title || self.attrTitle) {
            height += 5;
            CGRect frame = self.messageLabel.frame;
            frame.origin.y = height;
            frame.size.height = [self.messageLabel sizeThatFits:CGSizeMake(238, MAXFLOAT)].height;
            self.messageLabel.frame = frame;
            height += frame.size.height;
        } else {
            CGRect frame = self.messageLabel.frame;
            frame.origin.y = height;
            frame.size.height = [self.messageLabel sizeThatFits:CGSizeMake(238, MAXFLOAT)].height;
            self.messageLabel.frame = frame;
            height += frame.size.height;
        }
    }
    
    if ((self.title || self.attrTitle) || (self.message || self.attrMessage)) {
        height += 20;
    }
    
    if (self.actions.count) {
        CGRect frame = self.lineTop.frame;
        frame.origin.y = height;
        self.lineTop.frame = frame;
        height += 0.5;
        
        [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttons removeAllObjects];
        
        if (self.actions.count == 1) {
            UIButton *button = [self createButton:self.actions[0]];
            button.tag = 1000;
            button.frame = CGRectMake(0, height, 270, 44);
            [self.buttons addObject:button];
            height += 44;
        } else if (self.actions.count >= 2) {
            UIButton *button = [self createButton:self.actions[0]];
            button.tag = 1000;
            button.frame = CGRectMake(0, height, 135, 44);
            [self.buttons addObject:button];
            
            frame = self.lineMid.frame;
            frame.origin.x = 135;
            frame.origin.y = height;
            self.lineMid.frame = frame;
            
            button = [self createButton:self.actions[1]];
            button.tag = 1001;
            button.frame = CGRectMake(135, height, 135, 44);
            [self.buttons addObject:button];
            height += 44;
            
            [self bringSubviewToFront:self.lineMid];
        }
    } else {
        [_lineTop removeFromSuperview];
        [_lineMid removeFromSuperview];
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.origin.y = ([UIScreen mainScreen].bounds.size.height - height) / 2;
    self.frame = frame;
    
    NSAssert(height != 0, @"SCAlertView must have a title, a message or an action to display");
}

- (UIImage *)cornerRadiusBackgroundImage {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIButton *)createButton:(SCAlertAction *)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[self cornerRadiusBackgroundImage] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitle:action.title forState:UIControlStateNormal];
    if (action.style == SCAlertActionStyleCancel) {
        [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self.buttons addObject:button];
    return button;
}

- (void)buttonPressed:(UIButton *)sender {
    [self dismiss];
    SCAlertAction *action = self.actions[sender.tag - 1000];
    if (action.handler) {
        action.handler(action);
    }
}

- (void)show {
    if (self.isShowing) {
        return;
    }
    self.isShowing = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = window.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [window addSubview:backgroundView];
    _backgroundView = backgroundView;
    [window addSubview:self];
    self.center = window.center;
    
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(1.15, 1.15);
    [UIView animateWithDuration:0.2 animations:^{
        backgroundView.alpha = 0.4;
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)dismiss {
    if (!self.isShowing) {
        return;
    }
    self.isShowing = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
        
        [self layoutAlertView];
    }
}

- (void)setAttrTitle:(NSAttributedString *)attrTitle {
    if (_attrTitle != attrTitle) {
        _attrTitle = attrTitle;
        self.titleLabel.attributedText = attrTitle;
        
        [self layoutAlertView];
    }
}

- (void)setMessage:(NSString *)message {
    if (_message != message) {
        _message = message;
        self.messageLabel.text = message;
        
        [self layoutAlertView];
    }
}

- (void)setAttrMessage:(NSAttributedString *)attrMessage {
    if (_attrMessage != attrMessage) {
        _attrMessage = attrMessage;
        self.messageLabel.attributedText = attrMessage;
        
        [self layoutAlertView];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat width = 238;
        CGFloat x = (270 - 238) / 2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, 0)];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat width = 238;
        CGFloat x = (270 - 238) / 2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, 0)];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self addSubview:label];
        _messageLabel = label;
    }
    return _messageLabel;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIView *)lineTop {
    if (!_lineTop) {
        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 0.5)];
        lineTop.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.000];
        [self addSubview:lineTop];
        _lineTop = lineTop;
    }
    return _lineTop;
}

- (UIView *)lineMid {
    if (!_lineMid) {
        UIView *lineMid = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 44)];
        lineMid.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.000];
        [self addSubview:lineMid];
        _lineMid = lineMid;
    }
    return _lineMid;
}

@end
