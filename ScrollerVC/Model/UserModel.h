//
//  UserModel.h
//  ScrollerVC
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,strong) UIImage *photo;

@end
