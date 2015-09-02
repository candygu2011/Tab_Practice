//
//  UserInfoCell.h
//  ScrollerVC
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end
