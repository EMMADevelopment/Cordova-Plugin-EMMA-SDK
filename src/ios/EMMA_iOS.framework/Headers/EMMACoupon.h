//
//  eMMaCoupon.h
//  eMMa
//
//  Created by Gerard Mobile on 26/02/14.
//  Copyright (c) 2014 Gerard Llorente. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMMACoupon : NSObject

@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * couponDescription;
@property (nonatomic,retain) NSString * couponCode;
@property (nonatomic,retain) NSString * imageUrl;
@property (nonatomic,assign) int couponId;
@property (nonatomic,assign) int maxRedeem;
@property (nonatomic,assign) int currentRedeems;
@property (nonatomic,retain) NSDate * begin;
@property (nonatomic,retain) NSDate * end;
@property (nonatomic,retain) UIImage  * image;
@property (nonatomic,assign) int EMMAId;
@property (nonatomic,assign) BOOL isNew;

- (id)initWithDictionary:(NSDictionary*)info EMMAId:(int)emmaId;

@end
