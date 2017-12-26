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
        [self updateDeleteItemTitle];
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
- (IBAction)addItemHandle:(UIBarButtonItem *)sender {
    [self.tableView beginUpdates];
    
    // 1. 数据上添加一个
    [self.dataArray addObject:@"New Item"];
    // 2. UI 更新
    NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPathOfNewItem] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPathOfNewItem atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self updateButtonsToMatchTableState];
}

- (IBAction)editItemHandle:(UIBarButtonItem *)sender {
    [self.tableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)deleteItemHandle:(UIBarButtonItem *)sender {
    NSString *actionTitle;
    if ([self.tableView indexPathsForSelectedRows].count == 1) {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"UIActionSheet 标题");
    } else {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"UIActionSheet 标题");
    }
    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"取消按钮");
    NSString *okTitle = NSLocalizedString(@"OK", @"确定按钮");
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"" message:actionTitle preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        if (selectedRows.count > 0) {
            // 通过集合来删除数据的方法应该学习
            // 创建一个集合 查找出需要删除的数据
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndexPath in selectedRows) {
                [indicesOfItemsToDelete addIndex:selectionIndexPath.row];
            }
            // 移除
            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            // UI
            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            // 移除数据
            [self.dataArray removeAllObjects];
            // 刷新 某个段的UI
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.tableView setEditing:NO animated:YES];
        [self updateButtonsToMatchTableState];
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (IBAction)cancelItemHandle:(UIBarButtonItem *)sender {
    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

@end
