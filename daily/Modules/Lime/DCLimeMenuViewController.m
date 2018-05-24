//
//  DCLimeMenuViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCLimeMenuViewController.h"

@interface DCLimeMenuViewController ()
@end

@implementation DCLimeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石灰"];
    
    self.menuIndexArray = @[@(DCLimeMenu_Sell), @(DCLimeMenu_Store)];
}

#pragma UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text =  @"出售";
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = @"预定";
    }
    return cell;
}

@end
