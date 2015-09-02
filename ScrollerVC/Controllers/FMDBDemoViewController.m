//
//  FMDBDemoViewController.m
//  ScrollerVC
//
//  Created by hi on 15/9/1.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "FMDBDemoViewController.h"
#import "FMDB.h"
#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"GML.sqlite"

@interface FMDBDemoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    FMDatabase *_db;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *descripField;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *genderLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;


@end

@implementation FMDBDemoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
 
   
}

+(NSString *)databaseFilePath
{
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
    return dbFilePath;
    
}

- (IBAction)creatTable:(id)sender
{
    FMDatabase *db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog (@"Could not open db");
        return;
    }
    if ([db open]) {
        NSString *sql = @"CREATE TABLE 'gml' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'description' VARCHAR(100),'age' VARCHAR(10), 'gender' VARCHAR(10))";
        if (![db tableExists:@"gml"]) {
            if ([db executeUpdate:sql]) {
                NSLog(@"create table success");
            }else{
                NSLog(@"fail to create table");
            }
        }else {
            NSLog(@"table is already exist");
        }
    }else{
        NSLog(@"fail to open");
    }

    
}

- (IBAction)insertData:(id)sender
{
    
    if ([_ageField.text isEqualToString:@""] || [_nameField.text isEqualToString:@""]|| [_nameField.text isEqualToString:@""] ) {
        NSLog(@"请输入信息");
        return;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dataBasePath];
    if ([db open]) {
        NSString * sql = @"insert into gml (name, description, age,gender) values(?, ?,?,?) ";
        BOOL res = [db executeUpdate:sql, _nameField.text, _descripField.text,_ageField.text,_genderField.text];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }

    
}

- (IBAction)showData:(id)sender
{
    static int idx = 1;
   
    FMDatabase *db = [FMDatabase databaseWithPath:dataBasePath];
    if ([db open]) {
        NSString *sql = @"SELECT *FROM gml";
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *age = [resultSet stringForColumn:@"age"];
            NSString *gender = [resultSet stringForColumn:@"gender"];
            NSString *des = [resultSet stringForColumn:@"description"];
            NSData *imgeData = [resultSet dataForColumn:@"photo"];
            if (idx==1) {
                _nameLab.text = name;
                _ageLab.text = age;
                _genderLab.text = gender;
                _desLab.text = des;
                _myImageView.image = [UIImage imageWithData:imgeData];
                idx = 0;
            }else{
                _nameLab.text = @"点击展示";
                _genderLab.text = @"点击展示";
                _ageLab.text = @"点击展示";
                _desLab.text = @"点击展示";
                _myImageView.image = [UIImage imageNamed:@"ico_jiahao"];

                idx = 1;
            }
        }
    }
    
}


- (IBAction)deleteData:(id)sender
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:dataBasePath];
    if ([db open]) {
        NSString *sql = @"DELETE FROM gml";
        if ([db executeUpdate:sql]) {
            NSLog(@"delete succ");
        }else{
            NSLog(@"delete faild ");
        }
    }
}

- (IBAction)chooseImage:(id)sender
{
    NSLog(@"chooseImage");
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
    pickCtrl.sourceType =   UIImagePickerControllerSourceTypePhotoLibrary;
    pickCtrl.allowsEditing = YES;
    pickCtrl.delegate = self;
    [self presentViewController:pickCtrl animated:YES completion:nil];
    
}

-(void)insertImage:(UIImage *)image
{
    FMDatabase *db = [FMDatabase databaseWithPath:dataBasePath];
    NSData *imageData = UIImagePNGRepresentation(image);
    if ([db open]) {
        //判断字段是否存在
        if ([db columnExists:dataBasePath inTableWithName:@"gml"]) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE gml  WHERE photo = '%@'",imageData];
            [db executeUpdate:sql];
        }else{
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE gml ADD photo blob"];
            [db executeUpdate:sql];
            NSString *update = [NSString stringWithFormat:@"UPDATE  gml SET photo = ? WHERE id = 8"];
            [db executeUpdate:update,imageData];
        }
    }

   
    
}
#pragma mark --UIImagePickerControllerDelegate ---
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info == %@",info);
    
    _myImageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self insertImage:_myImageView.image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
