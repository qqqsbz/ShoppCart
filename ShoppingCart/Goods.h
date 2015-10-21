//
//  Goods.h
//  ShoppingCart
//
//  Created by coder on 15/10/20.
//  Copyright © 2015年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface Goods : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *coverUrl;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) float     price;
@property (assign, nonatomic) NSInteger count;

@end
