//
//  DCHistoryTextField.m
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCHistoryTextField.h"
#import "DCCoreDataManager.h"

@interface DCHistoryTextField()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *historyArray;
@end

@implementation DCHistoryTextField

- (instancetype)initWithDelegate:(id)delegate isNumber:(BOOL)isNumber
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.delegate = delegate;
        self.keyboardType = isNumber ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeyDone;
        self.font = [UIFont systemFontOfSize:18];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}

- (void)setupHistoryTableView:(CGRect)frame
{
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
}

- (void)reloadHitoryWithData:(NSArray *)array
{
    self.historyArray = [array copy];
    self.tableView.hidden = self.historyArray.count == 0;
    [self.tableView reloadData];
}

- (void)hideHistoryTableView
{
    self.tableView.hidden = YES;
    [self.tableView removeFromSuperview];
}

#pragma mark UITableViewDataSource &UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
    }
    
    cell.textLabel.text = [self getShowedString:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self resignFirstResponder];
    __block CustomerEntity *customer = (CustomerEntity *)self.historyArray[indexPath.row];
    if (self.selectHandle) {
        self.selectHandle(customer);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSString *)getShowedString:(NSInteger)index
{
    if (self.tag == UpdateEntity_Type_LimeUserName || self.tag == UpdateEntity_Type_CoalUserName || self.tag == UpdateEntity_Type_StoneUserName) {
        return ((CustomerEntity *)self.historyArray[index]).name;
    }
    else
    {
        return ((CustomerEntity *)self.historyArray[index]).carNumber;
    }
}
@end
