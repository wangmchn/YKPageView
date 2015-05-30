//
//  WKPageCell.h
//  CosChat
//
//  Created by Mark on 15/4/27.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKPageCell : UIView
@property (nonatomic, copy) NSString *identifier;
- (id)initWithIdentifier:(NSString *)identifier;
@end
