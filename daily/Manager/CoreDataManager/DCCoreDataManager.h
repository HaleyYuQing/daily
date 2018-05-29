//
//  DCCoreDataManager.h
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItemEntity.h"
#import "UseCoalEntity.h"
#import "UseStoneEntity.h"
#import "CustomerEntity.h"
#import "OperatorEntity.h"
#import "StoreCoalEntity.h"
#import "StoreStoneEntity.h"
#import "PreorderLimeEntity.h"

@interface DCCoreDataManager : NSObject
+ (DCCoreDataManager *)sharedInstance;

//BaseBuy
- (void)loadBuyItemData:(ItemEntity_Type)type complete:(void(^)(NSArray *itemArray))completeBlock;
- (void)addBuyItemData:(BaseItemEntity *)buyItem complete:(void(^)(NSString *error))completeBlock;
- (void)deleteBuyItemData:(BaseItemEntity *)buyItem complete:(void(^)(NSString *error))completeBlock;
- (void)updateBuyItemData:(BaseItemEntity *)buyItem complete:(void(^)(NSString *error))completeBlock;

//UseCoal
- (void)loadUseCoalData:(void(^)(NSArray *coalArray))completeBlock;
- (void)addUseCoalData:(UseCoalEntity *)buyCoal complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteUseCoalData:(UseCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;
- (void)updateUseCoalData:(UseCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;

//StoreCoal
- (void)loadStoreCoalData:(void(^)(NSArray *coalArray))completeBlock;

//PreorderLime
- (void)loadPreorderLimeData:(void(^)(NSArray *lineArray))completeBlock;
- (void)addPreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *errorString))completeBlock;
- (void)deletePreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *error))completeBlock;
- (void)updatePreorderLimeData:(PreorderLimeEntity *)oldPreorderLime newPreorderLime:(PreorderLimeEntity *)newPreorderLime complete:(void(^)(NSString *error))completeBlock;

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
