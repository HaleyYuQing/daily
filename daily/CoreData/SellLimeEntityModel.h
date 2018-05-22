//
//  SellLimeEntityModel.h
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SellLimeEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber * limePricePerKG;
@property (nonatomic, strong) NSNumber * limeWeight; //kg
@property (nonatomic, strong) NSNumber * limeTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic ,strong) NSString *buyerName;
@property (nonatomic, strong) NSNumber * carWeight;
@property (nonatomic, strong) NSNumber * carAndLimeWeight;

@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, strong) NSNumber * payedPrice;
@property (nonatomic, strong) NSNumber * notPayedPrice;
@property (nonatomic, strong) NSNumber * discountPrice;
@end
