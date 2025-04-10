//
//  EMMAInstallAttributionSource.h
//  eMMa
//
//  Created by Adrián Carrera on 18/10/2018.
//  Copyright © 2018 EMMA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMMAInstallAttributionProvider;

@interface EMMAInstallAttributionSource : NSObject

@property int id;
@property NSString *name;
@property NSString *channel;
@property EMMAInstallAttributionProvider *provider;
@property NSDictionary *params;

@end
