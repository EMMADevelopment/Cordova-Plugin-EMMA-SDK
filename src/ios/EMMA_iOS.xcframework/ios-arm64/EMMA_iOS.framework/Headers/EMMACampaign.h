//
//  EMMACampaign.h
//  eMMa
//
//  Created by Jaume Cornadó Panadés on 16/12/14.
//  Copyright (c) 2014 EMMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMADefines.h"

@class EMMABannerCampaign; 
@class EMMAStripCampaign;
@class EMMATabBarCampaign;
@class EMMAAdBallCampaign;
@class EMMAStartViewCampaign;

@interface EMMACampaign : NSObject


-(id) initWithType: (EMMACampaignType) type;

@property EMMACampaignType type;

@property (nonatomic, strong) id filterInfo;

@property  long idPromo;

@property (nonatomic, strong) NSURL *promoURL;

@property (nonatomic, strong) NSURL *imageURL;

@property BOOL canClose;

@property NSInteger times;

@property (nonatomic, strong) NSDictionary * params;

+(EMMACampaignType) typeFromString: (NSString*) type;

-(EMMABannerCampaign*) toBanner;

-(EMMAStripCampaign*) toStrip;

-(EMMATabBarCampaign*) toTabBar;

-(void) parseCampaignInfo:(NSDictionary*) response;

-(EMMAAdBallCampaign*) toAdBall;

-(EMMAStartViewCampaign*) toStartView;

-(BOOL) checkTimesShown;

-(void) updateTimesShown;

@end
