//
//  EMMANativeAdParams.h
//  eMMa
//
//  Created by Adrian Carrera on 20/2/18.
//  Copyright © 2018 EMMA. All rights reserved.
//

#import "EMMAInAppRequest.h"

@interface EMMANativeAdRequest: EMMAInAppRequest

@property BOOL isBatch;
@property (nonatomic, strong) NSString *templateId;

-(instancetype)initWithType:(InAppType) type
__attribute__((unavailable("Use void init instead.")));

@end

