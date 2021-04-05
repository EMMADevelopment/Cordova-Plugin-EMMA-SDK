//
//  EMMANativeAd.h
//  eMMa
//
//  Created by Ivan Aguila Garrofe on 4/7/17.
//  Copyright © 2017 EMMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMMACampaign.h"

@interface EMMANativeAd : EMMACampaign


@property BOOL openInSafari;
@property (nonatomic, strong) NSString * nativeAdTemplateId;
@property (nonatomic, strong) NSDictionary * nativeAdContent;
@property (nonatomic, strong)  NSString * tag;

-(BOOL) parseResponseInfo: (NSDictionary*) responseDict;

-(NSString*) getField: (NSString *) fieldKey __attribute__((deprecated("This method was deprecated due to container templates. Use nativeAdContent and parse data according to needs")));

@end
