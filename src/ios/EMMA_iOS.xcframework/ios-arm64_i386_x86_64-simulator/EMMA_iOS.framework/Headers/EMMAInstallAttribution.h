//
//  EMMAAttribution.h
//  eMMa
//
//  Created by Adrián Carrera on 18/10/2018.
//  Copyright © 2018 EMMA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMMAInstallAttributionCampaign;

@interface EMMAInstallAttribution : NSObject

@property NSString *status;
@property EMMAInstallAttributionCampaign *campaign;

@end
