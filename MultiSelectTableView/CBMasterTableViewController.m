//
//  CBMasterTableViewController.m
//  MultiSelectTableView
//
//  Created by 陈冰 on 2017/12/25.
//  Copyright © 2017年 ChenBing. All rights reserved.
//

#import "CBMasterTableViewController.h"

static NSString *TitleCellIdentifier = @"TitleCellIdentifier";

@interface CBMasterTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *eidtItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CBMasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 允许多选并且编辑
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    // 数据
    self.dataArray = [NSMutableArray new];
    NSString *itemFormatStringTitle = NSLocalizedString(@"Item ", @"Item Format String Title");
    for (NSUInteger i = 0; i < 12; i++) {
        NSString *itemTitle = [itemFormatStringTitle stringByAppendingString:@(i).stringValue];
        [self.dataArray addObject:itemTitle];
    }
    
    // 更新按钮以匹配表格状态
    [self updateButtonsToMatchTableState];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateButtonsToMatchTableState];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateDeleteItemTitle];
}

#pragma mark - Menu UI
- (void)updateButtonsToMatchTableState {
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem = self.cancelItem;
        [self updateButtonsToMatchTableState];
        self.navigationItem.leftBarButtonItem = self.deleteItem;
    } else {
        self.navigationItem.rightBarButtonItem = self.eidtItem;
        if (self.dataArray.count > 0) {
            self.eidtItem.enabled = YES;
        } else {
            self.eidtItem.enabled = NO;
        }
        self.navigationItem.leftBarButtonItem = self.addItem;
    }
}

- (void)updateDeleteItemTitle {
    NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
    BOOL allItemAreSelected = selectRows.count == self.dataArray.count;
    BOOL noItemAreSelected = selectRows.count == 0;
    
    // 变化按钮的名称
    if (allItemAreSelected || noItemAreSelected) {
        self.deleteItem.title = NSLocalizedString(@"Delete All", @"按钮名称");
    } else {
        NSString *title = NSLocalizedString(@"Delete", @"按钮名称");
        NSString *titleFormatString = [title stringByAppendingFormat:@"(%@)", @(selectRows.count)];
        self.deleteItem.title = titleFormatString;
    }
}

#pragma mark - Menu Action
- (IBAction)addItemHandle:(UIBarButtonItem *)sender {}
- (IBAction)editItemHandle:(UIBarButtonItem *)sender {}
- (IBAction)deleteItemHandle:(UIBarButtonItem *)sender {}
- (IBAction)cancelItemHandle:(UIBarButtonItem *)sender {}

@end
