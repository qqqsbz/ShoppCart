//
//  GoodsCell.m
//  ShoppingCart
//
//  Created by coder on 15/10/20.
//  Copyright © 2015年 coder. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectAddButtonForCell:)]) {
        [self.delegate didSelectAddButtonForCell:self];
    }
}

@end
