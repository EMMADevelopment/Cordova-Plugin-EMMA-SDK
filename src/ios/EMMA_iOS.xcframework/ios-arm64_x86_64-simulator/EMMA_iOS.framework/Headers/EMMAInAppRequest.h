//
//  EMMAInAppRequest.h
//  eMMa
//
//  Created by Adrian Carrera on 3/7/17.
//  Copyright © 2017 EMMA. All rights reserved.
//

#import "EMMADefines.h"

@class EMMARequestDelegate;

@interface EMMAInAppRequest : NSObject

@property (nonatomic, strong, nullable) NSString *customId;
@property (nonatomic, strong, nullable) NSString *label;
@property (nonatomic, strong, nullable) NSString *inAppMessageId;
@property (nonatomic, strong, nullable) id<EMMARequestDelegate> requestDelegate;

NS_ASSUME_NONNULL_BEGIN

-(id)initWithType:(InAppType) type;
-(InAppType) type;

NS_ASSUME_NONNULL_END

@end
