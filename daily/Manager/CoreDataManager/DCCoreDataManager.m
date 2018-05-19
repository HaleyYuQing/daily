//
//  DCCoreDataManager.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoreDataManager.h"
#import <CoreData/CoreData.h>
#import "BuyCoalEntityModel.h"
#import "UseCoalEntityModel.h"
#import "SellLimeEntityModel.h"
#import "BuyStoneEntityModel.h"
#import "UseStoneEntityModel.h"
#import "NSManagedObject+DC.h"

@interface DCCoreDataManager()
@property (nonatomic, strong) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundObjectContext;

@property (nonatomic, strong) NSManagedObjectContext *stoneModelMainObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *stoneModelBackgroundObjectContext;
@end

@implementation DCCoreDataManager
+ (DCCoreDataManager *)sharedInstance
{
    static DCCoreDataManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DCCoreDataManager alloc] init];
    });
    
    return _instance;
}

- (NSManagedObjectContext *)backgroundObjectContext
{
    if (!_backgroundObjectContext) {
        _backgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        _backgroundObjectContext.parentContext = self.mainObjectContext;
    }
    return _backgroundObjectContext;
}

- (NSManagedObjectContext *)stoneModelBackgroundObjectContext
{
    if (!_stoneModelBackgroundObjectContext) {
        _stoneModelBackgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _stoneModelBackgroundObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        _stoneModelBackgroundObjectContext.parentContext = self.stoneModelMainObjectContext;
    }
    return _stoneModelBackgroundObjectContext;
}

- (NSManagedObjectContext *)mainObjectContext
{
    if(!_mainObjectContext)
    {
        _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        
        NSString *applicationDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbName = [NSString stringWithFormat:@"test.sqlite"];
        NSString *dbPath = [applicationDirectoryPath stringByAppendingPathComponent:dbName];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError *error = nil;
        NSURL *persistenURL = [NSURL fileURLWithPath:dbPath];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenURL options:[self persistentStoreOptions] error:&error]) {
            NSString *fileName = [[dbPath lastPathComponent] stringByDeletingPathExtension];
            if (fileName) {
                NSString *path = [dbPath stringByDeletingLastPathComponent];
                NSArray *cachedFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
                BOOL delete = NO;
                for (NSString *file in cachedFiles) {
                    if ([file hasPrefix:fileName]) {
                        NSString *deletePath = [path stringByAppendingPathComponent:file];
                        if (deletePath && [[NSFileManager defaultManager] removeItemAtPath:deletePath error:&error]) {
                            delete = YES;
                        }
                    }
                }
                
                if (delete) {
                    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenURL options:[self persistentStoreOptions] error:&error]) {
                        NSLog(@"%@",error);
                    }
                }
            }
        }
        
        [_mainObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return _mainObjectContext;
}

- (NSManagedObjectContext *)stoneModelMainObjectContext
{
    if(!_stoneModelMainObjectContext)
    {
        _stoneModelMainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _stoneModelMainObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        
        NSString *applicationDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbName = [NSString stringWithFormat:@"stone.sqlite"];
        NSString *dbPath = [applicationDirectoryPath stringByAppendingPathComponent:dbName];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StoneModel" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError *error = nil;
        NSURL *persistenURL = [NSURL fileURLWithPath:dbPath];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenURL options:[self persistentStoreOptions] error:&error]) {
            NSString *fileName = [[dbPath lastPathComponent] stringByDeletingPathExtension];
            if (fileName) {
                NSString *path = [dbPath stringByDeletingLastPathComponent];
                NSArray *cachedFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
                BOOL delete = NO;
                for (NSString *file in cachedFiles) {
                    if ([file hasPrefix:fileName]) {
                        NSString *deletePath = [path stringByAppendingPathComponent:file];
                        if (deletePath && [[NSFileManager defaultManager] removeItemAtPath:deletePath error:&error]) {
                            delete = YES;
                        }
                    }
                }
                
                if (delete) {
                    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenURL options:[self persistentStoreOptions] error:&error]) {
                        NSLog(@"%@",error);
                    }
                }
            }
        }
        
        [_stoneModelMainObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return _stoneModelMainObjectContext;
}

- (NSDictionary *)persistentStoreOptions
{
    return @{NSInferMappingModelAutomaticallyOption:@YES , NSMigratePersistentStoresAutomaticallyOption:@YES, NSSQLitePragmasOption:@{@"synchronous":@"OFF"}};
}

- (void)saveContext:(void(^)(NSString *error))complete
{
    if ([self.backgroundObjectContext hasChanges]) {
        [self.backgroundObjectContext performBlock:^{
            NSError *error = nil;
            if (![self.backgroundObjectContext save:&error]) {
                NSLog(@"DCCoreDataManager, saveContext error:%@", error);
            }
            
            if ([self.mainObjectContext hasChanges]) {
                [self.mainObjectContext performBlock:^{
                    NSError *er = nil;
                    if (![self.mainObjectContext save:&er]) {
                        complete(error.localizedDescription);
                        NSLog(@"DCCoreDataManager, saveContext error:%@", er);
                    }
                    else{
                        complete(nil);
                    }
                }];
            }
            else
            {
                complete(nil);
            }
        }];
    }
    else
    {
        if (complete) {
            complete(nil);
        }
    }
}

- (void)saveStoneContext:(void(^)(NSString *error))complete
{
    if ([self.stoneModelBackgroundObjectContext hasChanges]) {
        [self.stoneModelBackgroundObjectContext performBlock:^{
            NSError *error = nil;
            if (![self.stoneModelBackgroundObjectContext save:&error]) {
                NSLog(@"DCCoreDataManager, saveContext error:%@", error);
            }
            
            if ([self.stoneModelMainObjectContext hasChanges]) {
                [self.stoneModelMainObjectContext performBlock:^{
                    NSError *er = nil;
                    if (![self.stoneModelMainObjectContext save:&er]) {
                        complete(error.localizedDescription);
                        NSLog(@"DCCoreDataManager, saveContext error:%@", er);
                    }
                    else{
                        complete(nil);
                    }
                }];
            }
            else
            {
                complete(nil);
            }
        }];
    }
    else
    {
        if (complete) {
            complete(nil);
        }
    }
}

//Buy Coal
- (void)loadBuyCoalData:(void(^)(NSArray *coalArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"BuyCoalEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *buyCoalArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadBuyCoalData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:buyCoalArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (BuyCoalEntityModel *model in buyCoalArray) {
            BuyCoalEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((BuyCoalEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        [self.mainObjectContext performBlock:^{
            completeBlock(results);
        }];
    }];
}

- (void)addBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock
{
    if (!buyCoal) {
        completeBlock(nil);
        return ;
    }
    
    BuyCoalEntityModel *entityModel = [self createModelFromEntity:buyCoal];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
}

- (void)deleteBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock
{
    if (!buyCoal) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BuyCoalEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",buyCoal.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (BuyCoalEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateBuyCoalData:(BuyCoalEntity *)buyCoal complete:(void(^)(NSString *error))completeBlock;
{
    if (!buyCoal) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BuyCoalEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",buyCoal.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (BuyCoalEntityModel *model in resutls) {
            [self updateBuyCoalEntityModel:model withBuyCoalEntity:buyCoal];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateBuyCoalEntityModel:(BuyCoalEntityModel *)entityModel withBuyCoalEntity:(BuyCoalEntity *)buyCoal
{
    entityModel.createDate = buyCoal.createDate;
    entityModel.name = buyCoal.name;
    entityModel.coalPricePerKG = buyCoal.coalPricePerKG;
    entityModel.coalWeight = buyCoal.coalWeight;
    entityModel.coalTotalPrice = buyCoal.coalTotalPrice;
    entityModel.carNumber = buyCoal.carNumber;
    entityModel.carOwnerName = buyCoal.carOwnerName;
    entityModel.carWeight = buyCoal.carWeight;
    entityModel.carAndCoalWeight = buyCoal.carAndCoalWeight;
}

- (void)updateBuyCoalEntity:(BuyCoalEntity *)entity withBuyCoalEntityModel:(BuyCoalEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.coalPricePerKG = entityModel.coalPricePerKG;
    entity.coalWeight = entityModel.coalWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndCoalWeight = entityModel.carAndCoalWeight;
    entity.coalTotalPrice = entityModel.coalTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.carOwnerName = entityModel.carOwnerName;
}

//Use Coal
- (void)loadUseCoalData:(void(^)(NSArray *coalArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"UseCoalEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *useCoalArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadUseCoalData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:useCoalArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (UseCoalEntityModel *model in useCoalArray) {
            UseCoalEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((UseCoalEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        [self.mainObjectContext performBlock:^{
            completeBlock(results);
        }];
    }];
}

- (void)addUseCoalData:(UseCoalEntity *)useCoal complete:(void(^)(NSString *error))completeBlock
{
    if (!useCoal) {
        completeBlock(nil);
        return ;
    }
    
    UseCoalEntityModel *entityModel = [self createModelFromEntity:useCoal];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
}

- (void)deleteUseCoalData:(UseCoalEntity *)useCoal complete:(void(^)(NSString *error))completeBlock
{
    if (!useCoal) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UseCoalEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",useCoal.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (UseCoalEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateUseCoalData:(UseCoalEntity *)useCoal complete:(void(^)(NSString *error))completeBlock;
{
    if (!useCoal) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UseCoalEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",useCoal.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (UseCoalEntityModel *model in resutls) {
            [self updateUseCoalEntityModel:model withUseCoalEntity:useCoal];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateUseCoalEntityModel:(UseCoalEntityModel *)entityModel withUseCoalEntity:(UseCoalEntity *)useCoal
{
    entityModel.createDate = useCoal.createDate;
    entityModel.name = useCoal.name;
    entityModel.coalWeight = useCoal.coalWeight;
    entityModel.operatorName = useCoal.operatorName;
}

- (void)updateUseCoalEntity:(UseCoalEntity *)entity withUseCoalEntityModel:(UseCoalEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.operatorName = entityModel.operatorName;
    entity.coalWeight = entityModel.coalWeight;
}

//Sell lime
- (void)loadSellLimeData:(void(^)(NSArray *limeArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"SellLimeEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *sellLimeArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadSellLimeData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:sellLimeArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (SellLimeEntityModel *model in sellLimeArray) {
            SellLimeEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((SellLimeEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        [self.mainObjectContext performBlock:^{
            completeBlock(results);
        }];
    }];
}

- (void)addSellLimeData:(SellLimeEntity *)sellLime complete:(void(^)(NSString *error))completeBlock
{
    if (!sellLime) {
        completeBlock(nil);
        return ;
    }
    
    SellLimeEntityModel *entityModel = [self createModelFromEntity:sellLime];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
}

- (void)deleteSellLimeData:(SellLimeEntity *)sellLime complete:(void(^)(NSString *error))completeBlock
{
    if (!sellLime) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SellLimeEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",sellLime.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (SellLimeEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateSellLimeData:(SellLimeEntity *)sellLime complete:(void(^)(NSString *error))completeBlock;
{
    if (!sellLime) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SellLimeEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",sellLime.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (SellLimeEntityModel *model in resutls) {
            [self updateSellLimeEntityModel:model withSellLimeEntity:sellLime];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateSellLimeEntityModel:(SellLimeEntityModel *)entityModel withSellLimeEntity:(SellLimeEntity *)sellLime
{
    entityModel.createDate = sellLime.createDate;
    entityModel.name = sellLime.name;
    entityModel.limePricePerKG = sellLime.limePricePerKG;
    entityModel.limeWeight = sellLime.limeWeight;
    entityModel.limeTotalPrice = sellLime.limeTotalPrice;
    entityModel.carNumber = sellLime.carNumber;
    entityModel.buyerName = sellLime.buyerName;
    entityModel.carWeight = sellLime.carWeight;
    entityModel.carAndLimeWeight = sellLime.carAndLimeWeight;
    entityModel.payedPrice = sellLime.payedPrice;
    entityModel.notPayedPrice = sellLime.notPayedPrice;
}

- (void)updateSellLimeEntity:(SellLimeEntity *)entity withSellLimeEntityModel:(SellLimeEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.limePricePerKG = entityModel.limePricePerKG;
    entity.limeWeight = entityModel.limeWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndLimeWeight = entityModel.carAndLimeWeight;
    entity.limeTotalPrice = entityModel.limeTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.buyerName = entityModel.buyerName;
    entity.payedPrice = entityModel.payedPrice;
    entity.notPayedPrice = entityModel.notPayedPrice;
}

//Buy Stone
- (void)loadBuyStoneData:(void(^)(NSArray *stoneArray))completeBlock
{
    [self.stoneModelMainObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"BuyStoneEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *buyStoneArray = [self.stoneModelMainObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadBuyStoneData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:buyStoneArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (BuyStoneEntityModel *model in buyStoneArray) {
            BuyStoneEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((BuyStoneEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        [self.stoneModelMainObjectContext performBlock:^{
            completeBlock(results);
        }];
    }];
}

- (void)addBuyStoneData:(BuyStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock
{
    if (!buyStone) {
        completeBlock(nil);
        return ;
    }
    
    BuyStoneEntityModel *entityModel = [self createModelFromEntity:buyStone];
    if (entityModel) {
        [self saveStoneContext:completeBlock];
    }
}

- (void)deleteBuyStoneData:(BuyStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock
{
    if (!buyStone) {
        completeBlock(nil);
        return;
    }
    
    [[self stoneModelBackgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BuyStoneEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",buyStone.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self stoneModelBackgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (BuyStoneEntityModel *model in resutls) {
            [[self stoneModelBackgroundObjectContext] deleteObject:model];
        }
        
        [self saveStoneContext:completeBlock];
    }];
}

- (void)updateBuyStoneData:(BuyStoneEntity *)buyStone complete:(void(^)(NSString *error))completeBlock;
{
    if (!buyStone) {
        completeBlock(nil);
        return;
    }
    
    [[self stoneModelBackgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BuyStoneEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",buyStone.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self stoneModelBackgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (BuyStoneEntityModel *model in resutls) {
            [self updateBuyStoneEntityModel:model withBuyStoneEntity:buyStone];
        }
        
        [self saveStoneContext:completeBlock];
    }];
}

- (void)updateBuyStoneEntityModel:(BuyStoneEntityModel *)entityModel withBuyStoneEntity:(BuyStoneEntity *)buyStone
{
    entityModel.createDate = buyStone.createDate;
    entityModel.name = buyStone.name;
    entityModel.stonePricePerKG = buyStone.stonePricePerKG;
    entityModel.stoneWeight = buyStone.stoneWeight;
    entityModel.stoneTotalPrice = buyStone.stoneTotalPrice;
    entityModel.carNumber = buyStone.carNumber;
    entityModel.carOwnerName = buyStone.carOwnerName;
    entityModel.carWeight = buyStone.carWeight;
    entityModel.carAndStoneWeight = buyStone.carAndStoneWeight;
}

- (void)updateBuyStoneEntity:(BuyStoneEntity *)entity withBuyStoneEntityModel:(BuyStoneEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.stonePricePerKG = entityModel.stonePricePerKG;
    entity.stoneWeight = entityModel.stoneWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndStoneWeight = entityModel.carAndStoneWeight;
    entity.stoneTotalPrice = entityModel.stoneTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.carOwnerName = entityModel.carOwnerName;
}

//Use Stone
- (void)loadUseStoneData:(void(^)(NSArray *stoneArray))completeBlock
{
    [self.stoneModelBackgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *useStoneArray = [self.stoneModelBackgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadUseStoneData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:useStoneArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (UseStoneEntityModel *model in useStoneArray) {
            UseStoneEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((UseStoneEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        [self.stoneModelMainObjectContext performBlock:^{
            completeBlock(results);
        }];
    }];
}

- (void)addUseStoneData:(UseStoneEntity *)useStone complete:(void(^)(NSString *error))completeBlock
{
    if (!useStone) {
        completeBlock(nil);
        return ;
    }
    
    UseStoneEntityModel *entityModel = [self createModelFromEntity:useStone];
    if (entityModel) {
        [self saveStoneContext:completeBlock];
    }
}

- (void)deleteUseStoneData:(UseStoneEntity *)useStone complete:(void(^)(NSString *error))completeBlock
{
    if (!useStone) {
        completeBlock(nil);
        return;
    }
    
    [[self stoneModelBackgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",useStone.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self stoneModelBackgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (UseStoneEntityModel *model in resutls) {
            [[self stoneModelBackgroundObjectContext] deleteObject:model];
        }
        
        [self saveStoneContext:completeBlock];
    }];
}

- (void)updateUseStoneData:(UseStoneEntity *)useStone complete:(void(^)(NSString *error))completeBlock;
{
    if (!useStone) {
        completeBlock(nil);
        return;
    }
    
    [[self stoneModelBackgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",useStone.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self stoneModelBackgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (UseStoneEntityModel *model in resutls) {
            [self updateUseStoneEntityModel:model withUseStoneEntity:useStone];
        }
        
        [self saveStoneContext:completeBlock];
    }];
}

- (void)updateUseStoneEntityModel:(UseStoneEntityModel *)entityModel withUseStoneEntity:(UseStoneEntity *)useStone
{
    entityModel.createDate = useStone.createDate;
    entityModel.name = useStone.name;
    entityModel.stoneWeight = useStone.stoneWeight;
    entityModel.operatorName = useStone.operatorName;
}

- (void)updateUseStoneEntity:(UseStoneEntity *)entity withUseStoneEntityModel:(UseStoneEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.operatorName = entityModel.operatorName;
    entity.stoneWeight = entityModel.stoneWeight;
}

//Create
- (id)createEntityFromModel:(id)model
{
    if (!model) {
        return nil;
    }
    
    if ([model isKindOfClass:[BuyCoalEntityModel class]]) {
        BuyCoalEntityModel *entityModel = (BuyCoalEntityModel *)model;
        BuyCoalEntity *entity = [[BuyCoalEntity alloc] init];
        [self updateBuyCoalEntity:entity withBuyCoalEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[UseCoalEntityModel class]]) {
        UseCoalEntityModel *entityModel = (UseCoalEntityModel *)model;
        UseCoalEntity *entity = [[UseCoalEntity alloc] init];
        [self updateUseCoalEntity:entity withUseCoalEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[SellLimeEntityModel class]]) {
        SellLimeEntityModel *entityModel = (SellLimeEntityModel *)model;
        SellLimeEntity *entity = [[SellLimeEntity alloc] init];
        [self updateSellLimeEntity:entity withSellLimeEntityModel:entityModel];
        return entity;
    }
    
    if ([model isKindOfClass:[BuyStoneEntityModel class]]) {
        BuyStoneEntityModel *entityModel = (BuyStoneEntityModel *)model;
        BuyStoneEntity *entity = [[BuyStoneEntity alloc] init];
        [self updateBuyStoneEntity:entity withBuyStoneEntityModel:entityModel];
        return entity;
    }
    
    if ([model isKindOfClass:[UseStoneEntityModel class]]) {
        UseStoneEntityModel *entityModel = (UseStoneEntityModel *)model;
        UseStoneEntity *entity = [[UseStoneEntity alloc] init];
        [self updateUseStoneEntity:entity withUseStoneEntityModel:entityModel];
        
        return entity;
    }
    
    return nil;
}

- (id)createModelFromEntity:(id)entity
{
    if (!entity) {
        return nil;
    }
    
    if ([entity isKindOfClass:[BuyCoalEntity class]]) {
        BuyCoalEntity *buyCoal = (BuyCoalEntity *)entity;
        BuyCoalEntityModel *entityModel = [BuyCoalEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updateBuyCoalEntityModel:entityModel withBuyCoalEntity:buyCoal];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[UseCoalEntity class]]) {
        UseCoalEntity *useCoal = (UseCoalEntity *)entity;
        UseCoalEntityModel *entityModel = [UseCoalEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updateUseCoalEntityModel:entityModel withUseCoalEntity:useCoal];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[SellLimeEntity class]]) {
        SellLimeEntity *sellLime = (SellLimeEntity *)entity;
        SellLimeEntityModel *entityModel = [SellLimeEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updateSellLimeEntityModel:entityModel withSellLimeEntity:sellLime];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[BuyStoneEntity class]]) {
        BuyStoneEntity *buyStone = (BuyStoneEntity *)entity;
        BuyStoneEntityModel *entityModel = [BuyStoneEntityModel createManagedObjectInContext:[self stoneModelBackgroundObjectContext]];
        if (entityModel) {
            [self updateBuyStoneEntityModel:entityModel withBuyStoneEntity:buyStone];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[UseStoneEntity class]]) {
        UseStoneEntity *useStone = (UseStoneEntity *)entity;
        UseStoneEntityModel *entityModel = [UseStoneEntityModel createManagedObjectInContext:[self stoneModelBackgroundObjectContext]];
        if (entityModel) {
            [self updateUseStoneEntityModel:entityModel withUseStoneEntity:useStone];
            return entityModel;
        }
    }
    
    return nil;
}
@end
