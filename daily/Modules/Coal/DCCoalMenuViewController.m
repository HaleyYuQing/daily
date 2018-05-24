//
//  DCCoalMenuViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalMenuViewController.h"

@interface DCCoalMenuViewController ()
@end

@implementation DCCoalMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"煤炭"];
    self.menuIndexArray = @[@(DCCoalMenu_Use), @(DCCoalMenu_Buy), @(DCCoalMenu_Store)];
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
        cell.textLabel.text =  @"使用";
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"购买";
    }
    else if(indexPath.section == 2)
    {
        cell.textLabel.text = @"库存";
    }
    return cell;
}

@end
