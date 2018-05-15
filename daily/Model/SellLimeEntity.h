//
//  SellLimeEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellLimeEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;

@property (nonatomic ,strong) NSString *buyerName;
@property (nonatomic, assign) float limePricePerKG;
@property (nonatomic, assign) float limeWeight; //kg

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) float carWeight;
@property (nonatomic, assign) float carAndLimeWeight;

@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, assign) float payedPrice;
@property (nonatomic, assign) float notPayedPrice;
@property (nonatomic, assign) float discountPrice;
@end
