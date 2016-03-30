//
//  SCAlertView.h
//  Higo
//
//  Created by sichenwang on 16/3/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCAlertActionStyle) {
    SCAlertActionStyleConfirm = 0,
    SCAlertActionStyleCancel,
};

NS_ASSUME_NONNULL_BEGIN

@interface SCAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(SCAlertActionStyle)style handler:(void (^ __nullable)(SCAlertAction *action))handler;

@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, assign, readonly) SCAlertActionStyle style;

@end

@interface SCAlertView : UIView

+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)alertViewWithAttributedTitle:(nullable NSAttributedString *)title message:(nullable NSString *)message;
+ (instancetype)alertViewWithTitle:(nullable NSString *)title attributedMessage:(nullable NSAttributedString *)message;
+ (instancetype)alertViewWithAttributedTitle:(nullable NSAttributedString *)title attributedMessage:(nullable NSAttributedString *)message;

/**
 *  只支持0-2个action，超过两个action将只显示前两个
 */
- (void)addAction:(SCAlertAction *)action;

@property (nonatomic, strong, readonly) NSArray<SCAlertAction *> *actions;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSAttributedString *attrTitle;
@property (nonatomic, copy, nullable) NSString *message;
@property (nonatomic, copy, nullable) NSAttributedString *attrMessage;

- (void)show;

@end

NS_ASSUME_NONNULL_END