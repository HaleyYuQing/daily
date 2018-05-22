//
//  DCCoreDataManager.h
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuyCoalEntity.h"
#import "UseCoalEntity.h"
#import "SellLimeEntity.h"
#import "BuyStoneEntity.h"
#import "UseStoneEntity.h"
#import "CustomerEntity.h"
#import "OperatorEntity.h"
#import "StoreCoalEntity.h"
#import "StoreStoneEntity.h"
#import "PreorderLimeEntity.h"

@interface DCCoreDataManager : NSObject
+ (DCCoreDataManager *)sharedInstance;

//BuyCoal
- (void)loadBuyCoalData:(void(^)(NSArray *coalArray))completeBlock;
- (void)addBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;
- (void)updateBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;

//UseCoal
- (void)loadUseCoalData:(void(^)(NSArray *coalArray))completeBlock;
- (void)addUseCoalData:(UseCoalEntity *)buyCoal complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteUseCoalData:(UseCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;
- (void)updateUseCoalData:(UseCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;

//StoreCoal
- (void)loadStoreCoalData:(void(^)(NSArray *coalArray))completeBlock;

//SellLime
- (void)loadSellLimeData:(void(^)(NSArray *lineArray))completeBlock;
- (void)addSellLimeData:(SellLimeEntity *)sellLime complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteSellLimeData:(SellLimeEntity *)sellLime complete:(void(^)(NSString *error))completeBlock;
- (void)updateSellLimeData:(SellLimeEntity *)sellLime complete:(void(^)(NSString *error))completeBlock;

//PreorderLime
- (void)loadPreorderLimeData:(void(^)(NSArray *lineArray))completeBlock;
- (void)addPreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *errorString))completeBlock;
- (void)deletePreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *error))completeBlock;
- (void)updatePreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *error))completeBlock;

//BuyStone
- (void)loadBuyStoneData:(void(^)(NSArray *stoneArray))completeBlock;
- (void)addBuyStoneData:(BuyStoneEntity *)buyStone complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteBuyStoneData:(BuyStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock;
- (void)updateBuyStoneData:(BuyStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock;

//UseStone
- (void)loadUseStoneData:(void(^)(NSArray *stoneArray))completeBlock;
- (void)addUseStoneData:(UseStoneEntity *)buyStone complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteUseStoneData:(UseStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock;
- (void)updateUseStoneData:(UseStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock;

//StoreStone
- (void)loadStoreStoneData:(void(^)(NSArray *stoneArray))completeBlock;

//Customer
- (void)loadCustomerDataType:(CustomerType)type complete:(void(^)(NSArray *stoneArray))completeBlock;

//Operator
- (void)loadOperatorDataComplete:(void(^)(NSArray *stoneArray))completeBlock;

- (NSArray *)getStoneCustomer;
- (NSArray *)getLimeCustomer;
- (NSArray *)getCoalCustomer;
- (NSArray *)getOperators;
- (NSString *)latestOperatorName;
@end
