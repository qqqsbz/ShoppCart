//
//  ViewController.m
//  ShoppingCart
//
//  Created by coder on 15/10/19.
//  Copyright © 2015年 coder. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingCartCell.h"
#import "Goods.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,ShoppingCartCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editItem;
@property (strong, nonatomic) IBOutlet UILabel *freightLabel;
@property (strong, nonatomic) IBOutlet UIButton *balanceButton;
@property (strong, nonatomic) IBOutlet UILabel *selectAllLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIView *operationView;

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL edit;
@property (strong, nonatomic) NSMutableArray *basketList;
@property (strong, nonatomic) NSMutableArray *basketDatas;

@end

static NSString *reuseIdentifier = @"ShoppingCartCell";
static NSString *kGoodsCountNotifica = @"K_GOODS_COUNT";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.basketList  = [NSMutableArray array];
    self.basketDatas = [NSMutableArray array];
    [self initialization];
    
    CGRect frame = self.view.frame;
    frame.size.height -= CGRectGetHeight(self.operationView.frame);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShoppingCartCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    [self.view bringSubviewToFront:self.contentView];
}

- (void)initialization
{
    for (NSInteger i = 0; i < self.dataList.count ; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.basketList addObject:indexPath];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataList && self.dataList.count > 0) {
        self.operationView.hidden = NO;
        [self calculatePrice];
    } else {
        self.operationView.hidden = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row != 0) {
        cell.panicBuyLabel.hidden = YES;
        cell.limitLabel.hidden = YES;
    }

    if ([self.basketList containsObject:indexPath]) {
        [cell cellCheckButtonSelected:YES];
    } else {
        [cell cellCheckButtonSelected:NO];
    }
    
    Goods *goods = self.dataList[indexPath.row];
    //cell.imageView.image    = [UIImage imageNamed:goods.coverUrl];
    cell.nameLabel.text     = goods.name;
    cell.priceLabel.text    = [NSString stringWithFormat:@"%.2f",goods.price];
    cell.numberLabel.text   = [NSString stringWithFormat:@"%ld",(long)goods.count];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

#pragma mark -- ShoppingCartCell Delegate
- (void)didSelectAddInShoppingCartCell:(ShoppingCartCell *)shoppingCartCell
{
    NSInteger number = [shoppingCartCell.numberLabel.text integerValue];
    if (number >= 1) {
        number += 1;
        shoppingCartCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
        NSInteger row = [self.tableView indexPathForCell:shoppingCartCell].row;
        Goods *goods  = [self.dataList objectAtIndex:row];
        goods.count  += 1;
        [self.dataList replaceObjectAtIndex:row withObject:goods];
        [self calculatePrice];
    }
}

- (void)didSelectReduceInShoppingCartCell:(ShoppingCartCell *)shoppingCartCell
{
    NSInteger number = [shoppingCartCell.numberLabel.text integerValue];
    if (number > 1) {
        number -= 1;
        shoppingCartCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
        NSInteger row = [self.tableView indexPathForCell:shoppingCartCell].row;
        Goods *goods  = [self.dataList objectAtIndex:row];
        goods.count  -= 1;
        [self.dataList replaceObjectAtIndex:row withObject:goods];
        [self calculatePrice];
    }
}

- (void)didSelectCheckInShoppingCartCell:(ShoppingCartCell *)shoppingCartCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:shoppingCartCell];
    if ([self.basketList containsObject:indexPath]) {
        [self.basketList removeObject:indexPath];
        [self.basketDatas addObject:self.dataList[indexPath.row]];
        [shoppingCartCell cellCheckButtonSelected:NO];
    } else {
        [self.basketList addObject:indexPath];
        [shoppingCartCell cellCheckButtonSelected:YES];
        [self.basketDatas removeObject:self.dataList[indexPath.row]];
    }
    [self calculatePrice];
    
}

- (IBAction)editAction:(UIBarButtonItem *)sender {
    self.edit = !self.edit;
    if (self.edit) {
        sender.title = @"完成";
        self.selectAllLabel.hidden = NO;
        self.moneyLabel.hidden = YES;
        self.freightLabel.hidden = YES;
        [self.balanceButton setTitle:@"删除" forState:UIControlStateNormal];
    } else {
        sender.title = @"编辑";
        self.selectAllLabel.hidden = YES;
        self.moneyLabel.hidden = NO;
        self.freightLabel.hidden = NO;
    }
    [self calculatePrice];
    [self didSelectAllCell:!self.edit];
}

- (void)calculatePrice
{
    float prices = 0.0;
    NSInteger count = 0;
    for (Goods *goods in self.dataList) {
        if (![self.basketDatas containsObject:goods]) {
            prices += goods.price * goods.count;
            count += goods.count;
        }
    }
    NSString *string;
    if (!self.edit) {
        string = [NSString stringWithFormat:@"去结算(%ld)",(long)count];
    } else {
        string = @"删除";
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"商品总价： ¥%.2f",prices];
    [self.balanceButton setTitle:string forState:UIControlStateNormal];
    
    NSDictionary *dic = @{
                          @"count":[NSString stringWithFormat:@"%ld",(long)count],
                          @"datas":self.dataList
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoodsCountNotifica object:nil userInfo:dic];
}

- (void)didSelectAllCell:(BOOL)selected
{
    UIImage *image;
    if (selected) {
        image = [UIImage imageNamed:@"check-selected"];
    } else {
        image = [UIImage imageNamed:@"check"];
    }
    self.checkButton.imageView.image = image;
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    for (NSInteger row = 0; row < rows; row ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        ShoppingCartCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.checkButton.imageView.image = image;
        }
        if (selected) {
            if (![self.basketList containsObject:indexPath]) {
                [self.basketList addObject:indexPath];
            }
        } else {
            [self.basketList removeObject:indexPath];
        }
    }
    
}

//结算 or 删除
- (IBAction)balanceAction:(UIButton *)sender {
    if (self.edit) {//删除
        if (self.basketList && self.basketList.count > 0) {
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSIndexPath *indexPath in self.basketList) {
                Goods *goods = self.dataList[indexPath.row];
                [tempArray addObject:goods];
            }
            [self.dataList removeObjectsInArray:tempArray];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:self.basketList withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            [self.basketList removeAllObjects];
            [self.tableView reloadData];
            
            [self calculatePrice];
            if (self.dataList && self.dataList.count) {
                self.operationView.hidden = NO;
            } else {
                self.operationView.hidden = YES;
            }
        }
    } else { //结算
        //跳转到结算界面
    }
}

- (IBAction)checkAction:(UIButton *)sender {
    [self didSelectAllCell:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
