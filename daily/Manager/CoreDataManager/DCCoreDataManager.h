//
//  DCCoreDataManager.h
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuyCoalEntity.h"

@interface DCCoreDataManager : NSObject
+ (DCCoreDataManager *)sharedInstance;

- (void)loadBuyCoalData:(void(^)(NSArray *coalArray))completeBlock;
- (void)addBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *errorString))completeBlock;
- (void)deleteBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;;
- (void)updateBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;;
@end
