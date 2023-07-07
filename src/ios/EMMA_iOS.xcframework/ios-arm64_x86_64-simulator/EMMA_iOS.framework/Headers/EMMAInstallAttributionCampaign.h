//
//  EMMAInstallAttributionCampaign.h
//  eMMa
//
//  Created by Adrián Carrera on 18/10/2018.
//  Copyright © 2018 EMMA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMMAInstallAttributionSource;

@interface EMMAInstallAttributionCampaign : NSObject

@property int id;
@property NSString *name;
@property EMMAInstallAttributionSource *source;
@property NSDictionary *clickParams;

@end
