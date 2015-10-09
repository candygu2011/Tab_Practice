//
//  HairGlassViewController.m
//  ScrollerVC
//
//  Created by hi on 15/9/25.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "HairGlassViewController.h"
#import <Accelerate/Accelerate.h>

@interface HairGlassViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@end

@implementation HairGlassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self hairGlassEffect];
}

- (void)hairGlassEffect
{
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:self.imageView.bounds];
//    toolBar.alpha = 0.8 ;
//    [self.imageView addSubview:toolBar];
    
    
    
    
}

//-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage
//{
//    
//    UIImage *image = self.imageView.image;
//    if (image.size.width < 1 || image.size.height < 1) {
//        return nil;
//    }
//    
//    if (!image.CGImage) {
//        
//        return nil;
//    }
//    
//    if (maskImage && !maskImage.CGImage) {
//        return nil;
//    }
//    
//    CGRect imageRect = {CGPointZero,image.size};
//    UIImage *effectImage = image;
//    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
//    BOOL hasStaturationChange = fabs(saturationDeltaFactor - 1.)>__FLT_EPSILON__;
//    if (hasBlur || hasStaturationChange) {
//        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
//        
//    }
//    
//    
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.leftConstraint.constant == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.leftConstraint.constant = -250;
            [self.imageView layoutIfNeeded];
        }];
        
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.leftConstraint.constant = 0;
            [self.imageView layoutIfNeeded];
        }];
    }
    
    
}

@end
