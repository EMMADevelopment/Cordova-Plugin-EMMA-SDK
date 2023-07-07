//
//  EMMAEventRequest.h
//  eMMa
//
//  Created by Adrián Carrera on 26/11/2018.
//  Copyright © 2018 EMMA. All rights reserved.
//

#import "EMMADefines.h"

@class EMMARequestDelegate;

@interface EMMAEventRequest : NSObject


@property (nonatomic, strong, nullable) NSDictionary*  attributes;
@property (nonatomic, weak, nullable) id<EMMARequestDelegate> requestDelegate;
@property (nonatomic, strong, nullable) NSString *customId;

NS_ASSUME_NONNULL_BEGIN
-(id)init NS_UNAVAILABLE;
-(id)initWithToken:(NSString*) token NS_DESIGNATED_INITIALIZER;
-(NSString*) token;
NS_ASSUME_NONNULL_END

@end
