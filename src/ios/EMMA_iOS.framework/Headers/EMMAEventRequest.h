//
//  EMMAEventRequest.h
//  eMMa
//
//  Created by Adrián Carrera on 26/11/2018.
//  Copyright © 2018 moddity. All rights reserved.
//

#import "EMMADefines.h"

@class EMMARequestDelegate;

@interface EMMAEventRequest : NSObject

@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSString *customId;
@property (nonatomic, weak) id<EMMARequestDelegate> requestDelegate;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype) initWithToken:(NSString*) token NS_DESIGNATED_INITIALIZER;
-(NSString*) token;

@end
