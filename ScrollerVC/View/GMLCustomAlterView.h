//
//  GMLCustomAlterView.h
//  ScrollerVC
//
//  Created by hi on 15/8/7.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  确认按钮Block
 *
 *  @param isConfirmBtnClick 是否被点击
 */
typedef void (^AlterViewConfirmBtnClickBlock)(BOOL isConfirmBtnClick);
/**
 * 取消按钮Block
 *
 *  @param isCancelBtnClick 是否被点击
 */
typedef void (^AlterViewCancelBtnClickBlock)(BOOL isCancelBtnClick);


typedef NS_ENUM(NSInteger, GMLCustomAlterViewStyle) {
    GMLCustomAlterViewStylePlain,
    GMLCustomAlterViewStyleGlobal
};

@interface GMLCustomAlterView : UIView
{
    CGFloat _contentViewWidth;
    CGFloat _contentViewHeight;
    CGFloat _viewGap;
    
}
-(instancetype)initWithFrame:(CGRect)frame style:(GMLCustomAlterViewStyle)style;
- (void)showView;
- (void)hideView;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *confirmButton;

@end
