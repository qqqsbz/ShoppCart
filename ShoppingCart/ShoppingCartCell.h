//
//  ShoppingCartCell.h
//  ShoppingCart
//
//  Created by coder on 15/10/19.
//  Copyright © 2015年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingCartCell;
@protocol ShoppingCartCellDelegate <NSObject>

- (void)didSelectReduceInShoppingCartCell:(ShoppingCartCell *)shoppingCartCell;

- (void)didSelectAddInShoppingCartCell:(ShoppingCartCell *)shoppingCartCell;

- (void)didSelectCheckInShoppingCartCell:(ShoppingCartCell *)shoppingCartCell;

@end

@interface ShoppingCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *limitLabel;
@property (strong, nonatomic) IBOutlet UILabel *panicBuyLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIView *logicView;
@property (weak, nonatomic) id<ShoppingCartCellDelegate> delegate;

- (void)cellCheckButtonSelected:(BOOL)selected;

@end
