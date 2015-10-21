//
//  GoodsCell.h
//  ShoppingCart
//
//  Created by coder on 15/10/20.
//  Copyright © 2015年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCell;
@protocol GoodsCellDelegate <NSObject>

- (void)didSelectAddButtonForCell:(GoodsCell *)goodsCell;

@end

@interface GoodsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) id<GoodsCellDelegate> delegate;
@end
