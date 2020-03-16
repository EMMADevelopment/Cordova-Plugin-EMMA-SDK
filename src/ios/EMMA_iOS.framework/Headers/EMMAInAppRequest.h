//
//  EMMAInAppRequest.h
//  eMMa
//
//  Created by Adrian Carrera on 3/7/17.
//  Copyright © 2017 moddity. All rights reserved.
//

#import "EMMADefines.h"

@class EMMARequestDelegate;

@interface EMMAInAppRequest : NSObject

@property (nonatomic, strong) NSString *customId;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *inAppMessageId;
@property (nonatomic, strong) id<EMMARequestDelegate> requestDelegate;

-(instancetype)initWithType:(InAppType) type;
-(InAppType) type;

@end
