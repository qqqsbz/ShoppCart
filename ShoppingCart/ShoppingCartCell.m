//
//  ShoppingCartCell.m
//  ShoppingCart
//
//  Created by coder on 15/10/19.
//  Copyright © 2015年 coder. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "UIColor+Util.h"
#import "UIImage+RTTint.h"
@implementation ShoppingCartCell

- (void)awakeFromNib {
    self.panicBuyLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"#EAEAEA"].CGColor;
    self.logicView.layer.borderColor = [UIColor colorWithHexString:@"#EAEAEA"].CGColor;
    self.numberLabel.layer.borderColor = [UIColor colorWithHexString:@"#EAEAEA"].CGColor;
    self.checkButton.imageView.image = [[UIImage imageNamed:@"check-selected"] rt_tintedImageWithColor:[UIColor redColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)cellCheckButtonSelected:(BOOL)selected
{
    UIImage *image;
    if (selected) {
        image = [UIImage imageNamed:@"check-selected"];
    } else {
        image = [UIImage imageNamed:@"check"];
    }
    [self.checkButton setImage:image forState:UIControlStateNormal];
}

- (IBAction)reduceAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectReduceInShoppingCartCell:)]) {
        [self.delegate didSelectReduceInShoppingCartCell:self];
    }
}

- (IBAction)addAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectAddInShoppingCartCell:)]) {
        [self.delegate didSelectAddInShoppingCartCell:self];
    }
}
- (IBAction)checkAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectCheckInShoppingCartCell:)]) {
        [self.delegate didSelectCheckInShoppingCartCell:self];
    }
}

@end
