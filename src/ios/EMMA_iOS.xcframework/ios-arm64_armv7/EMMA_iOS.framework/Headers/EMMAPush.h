//
//  eMMaPush.h
//  eMMa
//
//  Created by Jaume Cornadó Panadés on 2/12/14.
//  Copyright (c) 2014 EMMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMMACampaign.h"

@interface EMMAPush : EMMACampaign

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *tag;

@property BOOL showAlert;

@end
