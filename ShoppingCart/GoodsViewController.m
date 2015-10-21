//
//  GoodsViewController.m
//  ShoppingCart
//
//  Created by coder on 15/10/20.
//  Copyright © 2015年 coder. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsCell.h"
#import "Goods.h"
#import "ViewController.h"
@interface GoodsViewController ()<GoodsCellDelegate>

@property (strong, nonatomic) NSArray        *dataList;
@property (strong, nonatomic) UIButton       *cartButton;
@property (strong, nonatomic) UILabel        *badgeLabel;
@property (strong, nonatomic) NSMutableArray *cartViews;
@property (strong, nonatomic) NSMutableArray *basketList;
@property (assign, nonatomic) CGFloat         previousY;

@end


static NSString *reuseIdentifier = @"GoodsCell";
static NSString *kGoodsCountNotifica = @"K_GOODS_COUNT";
@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cartViews = [NSMutableArray array];
    self.basketList = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self getData];
    [self buildCart];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:kGoodsCountNotifica object:nil];
}

- (void)getData
{
    NSArray *datas = @[
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 草莓味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 原味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 蓝莓味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 芦荟味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 橘子味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 牛奶味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 哈密瓜味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 西瓜味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 香草味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 巧克力味 330ml",@"price":@"4.90",@"count":@"1"},
                       @{@"coverUrl":@"rusuanjun.jpg",@"name":@"味全 活性乳酸菌 番茄味 330ml",@"price":@"4.90",@"count":@"1"},
                     ];
    NSError *error;
    NSArray *jsonDatas = [MTLJSONAdapter modelsOfClass:[Goods class] fromJSONArray:datas error:&error];
    self.dataList = jsonDatas;
}

- (void)buildCart
{
    self.cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cartButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 58 , CGRectGetHeight(self.view.frame) - 125, 45, 45);
    self.cartButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    self.cartButton.layer.masksToBounds = YES;
    self.cartButton.layer.cornerRadius  = 5.f;
    [self.cartButton setImage:[UIImage imageNamed:@"TabCartSelected"] forState:UIControlStateNormal];
    [self.cartButton addTarget:self action:@selector(pushToCartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cartButton];
    
    CGFloat wh = 22;
    self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cartButton.frame) - wh / 2, CGRectGetMinY(self.cartButton.frame) - wh / 3, wh, wh)];
    self.badgeLabel.text                = @"0";
    self.badgeLabel.font                = [UIFont systemFontOfSize:10.f];
    self.badgeLabel.textColor           = [UIColor whiteColor];
    self.badgeLabel.backgroundColor     = [UIColor redColor];
    self.badgeLabel.textAlignment       = NSTextAlignmentCenter;
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.layer.cornerRadius  = CGRectGetWidth(self.badgeLabel.frame) / 2;
    self.badgeLabel.layer.borderColor   = [UIColor whiteColor].CGColor;
    self.badgeLabel.layer.borderWidth   = 1.f;
    [self.view addSubview:self.badgeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    Goods *goods = self.dataList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:goods.coverUrl];
    cell.nameLabel.text = goods.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",goods.price];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

#pragma mark -- GoodsCell Delegate
- (void)didSelectAddButtonForCell:(GoodsCell *)goodsCell
{
    UIImageView *imageView = [UIImageView new];
    imageView.frame = goodsCell.imageView.frame;
    imageView.image = goodsCell.imageView.image;
    imageView.tag = goodsCell.tag;
    [self.view addSubview:imageView];
    [self.cartViews addObject:imageView];
    
    Goods *goods = self.dataList[goodsCell.tag];
    if ([self.basketList containsObject:goods]) {
        NSInteger index = [self.basketList indexOfObject:goods];
        Goods *resultGoods = [self.basketList objectAtIndex:index];
        resultGoods.count += 1;
        [self.basketList replaceObjectAtIndex:index withObject:resultGoods];
    } else {
        [self.basketList addObject:self.dataList[goodsCell.tag]];
    }
    
    CGPoint point = CGPointMake(goodsCell.frame.origin.x + imageView.center.x, goodsCell.frame.origin.y + imageView.center.y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addQuadCurveToPoint:self.cartButton.center controlPoint:CGPointMake(point.x + 200, point.y - 170)];
    
    
    CAKeyframeAnimation *positioAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positioAnimation.path     = path.CGPath;
    positioAnimation.fillMode = kCAFillModeRemoved;
    positioAnimation.removedOnCompletion = YES;
    positioAnimation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation.toValue   = [NSNumber numberWithFloat:0.1f];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation,positioAnimation];
    animationGroup.duration   = 1.f;
    animationGroup.fillMode   = kCAFillModeForwards;
    animationGroup.delegate   = self;
    animationGroup.removedOnCompletion = NO;
    [imageView.layer addAnimation:animationGroup forKey:@"group"];
    
}

#pragma mark -- UISrolleView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat space = fabsf(fabsf(y) - fabsf(self.previousY));
    if (self.previousY != 0 && y > self.previousY) {
        self.cartButton.center = CGPointMake(self.cartButton.center.x, self.cartButton.center.y + space);
        self.badgeLabel.center = CGPointMake(self.badgeLabel.center.x, self.badgeLabel.center.y + space);
    } else if (self.previousY != 0 && y < self.previousY) {
        self.cartButton.center = CGPointMake(self.cartButton.center.x, self.cartButton.center.y - space);
        self.badgeLabel.center = CGPointMake(self.badgeLabel.center.x, self.badgeLabel.center.y - space);
    }
    self.previousY = y;
}

#pragma mark -- Animation Delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    self.cartButton.enabled = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *removeView;
    for (UIView *subView in self.cartViews) {
        if (anim == [subView.layer animationForKey:@"group"]) {
            NSInteger count = [self.badgeLabel.text integerValue];
            count += 1;
            self.badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            removeView = subView;
            [subView removeFromSuperview];
        }
    }
    [self.cartViews removeObject:removeView];
    if (self.cartViews && self.cartViews.count > 0) {
        self.cartButton.enabled = NO;
    } else {
        self.cartButton.enabled = YES;
    }
}

- (void)pushToCartAction:(UIButton *)sender
{
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    viewController.dataList = self.basketList;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)notificationAction:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    self.badgeLabel.text = dic[@"count"];
    self.basketList = dic[@"datas"];
}

@end
