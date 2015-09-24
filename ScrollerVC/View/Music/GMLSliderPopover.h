//
//  GMLSliderPopover.h
//  ScrollerVC
//
//  Created by hi on 15/9/24.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMLPopover;
@interface GMLSliderPopover : UISlider

@property (nonatomic,strong) GMLPopover *popover;

- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;
- (void)hidePopoverAnimated:(BOOL)animated;

@end
