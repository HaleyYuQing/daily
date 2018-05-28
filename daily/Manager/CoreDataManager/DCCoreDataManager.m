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
#import "CustomerEntityModel.h"
#import "OperatorEntityModel.h"
#import "PreorderLimeEntityModel.h"

#import "NSManagedObject+DC.h"

@interface DCCoreDataManager()
@property (nonatomic, strong) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundObjectContext;

@property (nonatomic, strong) NSMutableArray *stoneCustomersArray;
@property (nonatomic, strong) NSMutableArray *limeCustomersArray;
@property (nonatomic, strong) NSMutableArray *coalCustomersArray;
@property (nonatomic, strong) NSMutableArray *operatorsArray;
@property (nonatomic, strong) NSString *latestOperatorName;
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

- (NSMutableArray *)stoneCustomersArray
{
    if (!_stoneCustomersArray) {
        _stoneCustomersArray = [[NSMutableArray alloc] init];
    }
    return _stoneCustomersArray;
}

- (NSMutableArray *)coalCustomersArray
{
    if (!_coalCustomersArray) {
        _coalCustomersArray = [[NSMutableArray alloc] init];
    }
    return _coalCustomersArray;
}

- (NSMutableArray *)limeCustomersArray
{
    if (!_limeCustomersArray) {
        _limeCustomersArray = [[NSMutableArray alloc] init];
    }
    return _limeCustomersArray;
}

- (NSMutableArray *)operatorsArray
{
    if (!_operatorsArray) {
        _operatorsArray = [[NSMutableArray alloc] init];
    }
    return _operatorsArray;
}

- (NSArray *)getStoneCustomer
{
    return self.stoneCustomersArray;
}

- (NSArray *)getLimeCustomer
{
    return self.limeCustomersArray;
}

- (NSArray *)getCoalCustomer
{
    return self.coalCustomersArray;
}

- (NSArray *)getOperators
{
    return self.operatorsArray;
}

- (NSString *)latestOperatorName
{
    return _latestOperatorName;
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

- (NSManagedObjectContext *)mainObjectContext
{
    if(!_mainObjectContext)
    {
        _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        
        NSString *applicationDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbName = [NSString stringWithFormat:@"test11.sqlite"];
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

- (NSString *)getBaseBuyItemEntityModel:(ItemEntity_Type)type
{
    NSString *model = nil;
    switch (type) {
        case ItemEntity_Type_Coal:
            model = @"BuyCoalEntityModel";
            break;
        case ItemEntity_Type_Stone:
            model = @"BuyStoneEntityModel";
            break;
        case ItemEntity_Type_Lime:
            model = @"SellLimeEntityModel";
            break;
        default:
            break;
    }
    return model;
}

//Buy Item
- (void)loadBuyItemData:(ItemEntity_Type)type complete:(void(^)(NSArray *itemArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSString *entityName = [self getBaseBuyItemEntityModel:type];
        if (!entityName) {
            return ;
        }
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:entityName];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *buyItemArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadBuyItemData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:buyItemArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (id model in buyItemArray) {
            BaseItemEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((BaseItemEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
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

- (void)addBuyItemData:(BaseItemEntity *)buyItem complete:(void(^)(NSString *error))completeBlock
{
    if (!buyItem) {
        completeBlock(nil);
        return ;
    }
    
    id entityModel = [self createModelFromEntity:buyItem];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
    
    [self addNewCustomerWithBuyItem:buyItem];
}

- (void)deleteBuyItemData:(BaseItemEntity *)buyItem complete:(void(^)(NSString *error))completeBlock
{
    if (!buyItem) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSString *entityName = [self getBaseBuyItemEntityModel:[buyItem.itemType integerValue]];
        if (!entityName) {
            return ;
        }
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",buyItem.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (id model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateBuyItemData:(BaseItemEntity *)buyItem complete:(void(^)(NSString *error))completeBlock;
{
    if (!buyItem) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSString *entityName = [self getBaseBuyItemEntityModel:[buyItem.itemType integerValue]];
        if (!entityName) {
            return ;
        }
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",buyItem.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (id model in resutls) {
            [self updateModel:model withBuyItemEntity:buyItem];
        }
        
        [self saveContext:completeBlock];
        
        [self addNewCustomerWithBuyItem:buyItem];
    }];
}

- (void)updateModel:(id)model withBuyItemEntity:(BaseItemEntity *)buyItem
{
    if ([model isKindOfClass:[BuyStoneEntityModel class]]) {
        BuyStoneEntityModel *entityModel = (BuyStoneEntityModel *)model;
        entityModel.itemType = buyItem.itemType;
        entityModel.createDate = buyItem.createDate;
        entityModel.name = buyItem.name;
        entityModel.itemPricePerKG = buyItem.itemPricePerKG;
        entityModel.itemWeight = buyItem.itemWeight;
        entityModel.itemTotalPrice = buyItem.itemTotalPrice;
        entityModel.carNumber = buyItem.carNumber;
        entityModel.buyerName = buyItem.buyerName;
        entityModel.carWeight = buyItem.carWeight;
        entityModel.carAndItemWeight = buyItem.carAndItemWeight;
    }
    if ([model isKindOfClass:[SellLimeEntityModel class]]) {
        SellLimeEntityModel *entityModel = (SellLimeEntityModel *)model;
        entityModel.itemType = buyItem.itemType;
        entityModel.createDate = buyItem.createDate;
        entityModel.name = buyItem.name;
        entityModel.itemPricePerKG = buyItem.itemPricePerKG;
        entityModel.itemWeight = buyItem.itemWeight;
        entityModel.itemTotalPrice = buyItem.itemTotalPrice;
        entityModel.carNumber = buyItem.carNumber;
        entityModel.buyerName = buyItem.buyerName;
        entityModel.carWeight = buyItem.carWeight;
        entityModel.carAndItemWeight = buyItem.carAndItemWeight;
    }
    if ([model isKindOfClass:[BuyCoalEntityModel class]]) {
        BuyCoalEntityModel *entityModel = (BuyCoalEntityModel *)model;
        entityModel.itemType = buyItem.itemType;
        entityModel.createDate = buyItem.createDate;
        entityModel.name = buyItem.name;
        entityModel.itemPricePerKG = buyItem.itemPricePerKG;
        entityModel.itemWeight = buyItem.itemWeight;
        entityModel.itemTotalPrice = buyItem.itemTotalPrice;
        entityModel.carNumber = buyItem.carNumber;
        entityModel.buyerName = buyItem.buyerName;
        entityModel.carWeight = buyItem.carWeight;
        entityModel.carAndItemWeight = buyItem.carAndItemWeight;
    }
}

- (void)updateBuyItemEntity:(BaseItemEntity *)entity withBuyStoneEntityModel:(BuyStoneEntityModel *)entityModel
{
    entity.itemType = entityModel.itemType;
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.itemPricePerKG = entityModel.itemPricePerKG;
    entity.itemWeight = entityModel.itemWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndItemWeight = entityModel.carAndItemWeight;
    entity.itemTotalPrice = entityModel.itemTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.buyerName = entityModel.buyerName;
}

- (void)updateBuyItemEntity:(BaseItemEntity *)entity withBuyCoalEntityModel:(BuyCoalEntityModel *)entityModel
{
    entity.itemType = entityModel.itemType;
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.itemPricePerKG = entityModel.itemPricePerKG;
    entity.itemWeight = entityModel.itemWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndItemWeight = entityModel.carAndItemWeight;
    entity.itemTotalPrice = entityModel.itemTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.buyerName = entityModel.buyerName;
}

- (void)updateBuyItemEntity:(BaseItemEntity *)entity withSellLimeEntityModel:(SellLimeEntityModel *)entityModel
{
    entity.itemType = entityModel.itemType;
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.itemPricePerKG = entityModel.itemPricePerKG;
    entity.itemWeight = entityModel.itemWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndItemWeight = entityModel.carAndItemWeight;
    entity.itemTotalPrice = entityModel.itemTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.buyerName = entityModel.buyerName;
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
        if (![useCoal.operatorName isEqualToString:self.latestOperatorName]) {
            OperatorEntity *operator = [[OperatorEntity alloc] init];
            operator.name = useCoal.operatorName;
            operator.createDate = useCoal.createDate;
            [self addNewOperatorWithEntity:operator];
        }
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

//Store coal
- (void)loadStoreCoalData:(void(^)(NSArray *storeArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"BuyCoalEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *buyCoalModelArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadBuyCoalData, %@",error);
            return;
        }
        
        fetch = [[NSFetchRequest alloc] initWithEntityName:@"UseCoalEntityModel"];
        sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        error = nil;
        NSArray *useCoalModelArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadUseCoalData, %@",error);
            return;
        }
        
        NSMutableArray *buyCoalResults = [[NSMutableArray alloc] initWithCapacity:buyCoalModelArray.count];
        for (BuyCoalEntityModel *model in buyCoalModelArray) {
            BuyCoalEntityModel *entity = [self createEntityFromModel:model];
            [buyCoalResults addObject:entity];
        }
        
        NSMutableArray *useCoalResults = [[NSMutableArray alloc] initWithCapacity:useCoalModelArray.count];
        for (UseCoalEntityModel *model in useCoalModelArray) {
            UseCoalEntity *entity = [self createEntityFromModel:model];
            [useCoalResults addObject:entity];
        }
        
        NSMutableArray *subArray1 = [NSMutableArray arrayWithArray:buyCoalResults];
        [subArray1 addObjectsFromArray:useCoalResults];
        NSArray *allEntityArray = [subArray1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDate *date1 = ((BaseItemEntity *)obj1).createDate;
            NSDate *date2 = ((BaseItemEntity *)obj2).createDate;
            return [date2 compare:date1];
        }];
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (BaseItemEntity *entity in allEntityArray) {
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((BaseItemEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        
        NSMutableArray *storeResults = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSArray *array in results) {
            StoreCoalEntity *store = [[StoreCoalEntity alloc] init];
            store.createDate = ((BaseItemEntity *)[array firstObject]).createDate;
            [storeResults addObject:store];
            int totalWeight = 0;
            for (id subEntity in array) {
                if ([subEntity isKindOfClass:[BaseItemEntity class]]) {
                    totalWeight += [((BaseItemEntity *)subEntity).itemWeight intValue];
                }
                
                if ([subEntity isKindOfClass:[UseCoalEntity class]]) {
                    totalWeight -= [((UseCoalEntity *)subEntity).coalWeight intValue];
                }
            }
            store.totalWeight = @(totalWeight);
        }
        
        [self.mainObjectContext performBlock:^{
            completeBlock(storeResults);
        }];
    }];
}

//Preorder lime
- (void)loadPreorderLimeData:(void(^)(NSArray *limeArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"PreorderLimeEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *preorderLimeArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadPreorderLimeData, %@",error);
            return;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:preorderLimeArray.count];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (PreorderLimeEntityModel *model in preorderLimeArray) {
            PreorderLimeEntity *entity = [self createEntityFromModel:model];
            
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((PreorderLimeEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
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

- (void)addPreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *error))completeBlock
{
    if (!preorderLime) {
        completeBlock(nil);
        return ;
    }
    
    PreorderLimeEntityModel *entityModel = [self createModelFromEntity:preorderLime];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
    
    [self addNewCustomerWithPreorderLime:preorderLime];
}

- (void)deletePreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *error))completeBlock
{
    if (!preorderLime) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PreorderLimeEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",preorderLime.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (PreorderLimeEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updatePreorderLimeData:(PreorderLimeEntity *)preorderLime complete:(void(^)(NSString *error))completeBlock;
{
    if (!preorderLime) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PreorderLimeEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",preorderLime.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (PreorderLimeEntityModel *model in resutls) {
            [self updatePreorderLimeEntityModel:model withPreorderLimeEntity:preorderLime];
        }
        
        [self saveContext:completeBlock];
    }];
    
    [self addNewCustomerWithPreorderLime:preorderLime];
}

- (void)updatePreorderLimeEntityModel:(PreorderLimeEntityModel *)entityModel withPreorderLimeEntity:(PreorderLimeEntity *)preorderLime
{
    entityModel.createDate = preorderLime.createDate;
    entityModel.name = preorderLime.name;
    entityModel.limeWeight = preorderLime.limeWeight;
    entityModel.carNumber = preorderLime.carNumber;
    entityModel.buyerName = preorderLime.buyerName;
    entityModel.orderTime = preorderLime.orderTime;
}

- (void)updatePreorderLimeEntity:(PreorderLimeEntity *)entity withPreorderLimeEntityModel:(PreorderLimeEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.limeWeight = entityModel.limeWeight;
    entity.carNumber = entityModel.carNumber;
    entity.buyerName = entityModel.buyerName;
    entity.orderTime = entityModel.orderTime;
}

//Use Stone
- (void)loadUseStoneData:(void(^)(NSArray *stoneArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *useStoneArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
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
        [self.mainObjectContext performBlock:^{
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
        [self saveContext:completeBlock];
        
        if (![useStone.operatorName isEqualToString:self.latestOperatorName]) {
            OperatorEntity *operator = [[OperatorEntity alloc] init];
            operator.name = useStone.operatorName;
            operator.createDate = useStone.createDate;
            [self addNewOperatorWithEntity:operator];
        }
    }
}

- (void)deleteUseStoneData:(UseStoneEntity *)useStone complete:(void(^)(NSString *error))completeBlock
{
    if (!useStone) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",useStone.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (UseStoneEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateUseStoneData:(UseStoneEntity *)useStone complete:(void(^)(NSString *error))completeBlock;
{
    if (!useStone) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate = %@",useStone.createDate];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (UseStoneEntityModel *model in resutls) {
            [self updateUseStoneEntityModel:model withUseStoneEntity:useStone];
        }
        
        [self saveContext:completeBlock];
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

//Store stone
- (void)loadStoreStoneData:(void(^)(NSArray *storeArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"BuyStoneEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *buyStoneModelArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadBuyStoneData, %@",error);
            return;
        }
        
        fetch = [[NSFetchRequest alloc] initWithEntityName:@"UseStoneEntityModel"];
        sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        error = nil;
        NSArray *useStoneModelArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadUseStoneData, %@",error);
            return;
        }
        
        NSMutableArray *buyStoneResults = [[NSMutableArray alloc] initWithCapacity:buyStoneModelArray.count];
        for (BuyStoneEntityModel *model in buyStoneModelArray) {
            BaseItemEntity *entity = [self createEntityFromModel:model];
            [buyStoneResults addObject:entity];
        }
        
        NSMutableArray *useStoneResults = [[NSMutableArray alloc] initWithCapacity:useStoneModelArray.count];
        for (UseStoneEntityModel *model in useStoneModelArray) {
            UseStoneEntity *entity = [self createEntityFromModel:model];
            [useStoneResults addObject:entity];
        }
        
        NSMutableArray *subArray1 = [NSMutableArray arrayWithArray:buyStoneResults];
        [subArray1 addObjectsFromArray:useStoneResults];
        NSArray *allEntityArray = [subArray1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDate *date1 = ((BaseItemEntity *)obj1).createDate;
            NSDate *date2 = ((BaseItemEntity *)obj2).createDate;
            return [date2 compare:date1];
        }];
        
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (BaseItemEntity *entity in allEntityArray) {
            if ([subArray lastObject] == nil) {
                [subArray addObject:entity];
                [results addObject:subArray];
            }else if ([DCConstant compareIsSameDay:((BaseItemEntity *)[subArray lastObject]).createDate nextDate:entity.createDate])
            {
                [subArray addObject:entity];
            }
            else{
                subArray = [[NSMutableArray alloc] initWithCapacity:1];
                [subArray addObject:entity];
                [results addObject:subArray];
            }
        }
        
        NSMutableArray *storeResults = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSArray *array in results) {
            StoreStoneEntity *store = [[StoreStoneEntity alloc] init];
            store.createDate = ((BaseItemEntity *)[array firstObject]).createDate;
            [storeResults addObject:store];
            
            int totalWeight = 0;
            for (id subEntity in array) {
                if ([subEntity isKindOfClass:[BaseItemEntity class]]) {
                    totalWeight += [((BaseItemEntity *)subEntity).itemWeight intValue];
                }
                
                if ([subEntity isKindOfClass:[UseStoneEntity class]]) {
                    totalWeight -= [((UseStoneEntity *)subEntity).stoneWeight intValue];
                }
            }
            store.totalWeight = @(totalWeight);
        }
        
        [self.mainObjectContext performBlock:^{
            completeBlock(storeResults);
        }];
    }];
}

//Customer
- (BOOL)isIncludeCustomerEntity:(CustomerEntity *)customer
{
    switch ([customer.customerType integerValue] ) {
        case CustomerType_Stone:
        {
            for (CustomerEntity *entity in self.stoneCustomersArray) {
                if ([entity.name isEqualToString:customer.name] && [entity.carNumber isEqualToString:customer.carNumber]) {
                    return YES;
                }
            }
            break;
        }
        case CustomerType_Lime:
        {
            for (CustomerEntity *entity in self.limeCustomersArray) {
                if ([entity.name isEqualToString:customer.name] && [entity.carNumber isEqualToString:customer.carNumber]) {
                    return YES;
                }
            }
            break;
        }
        case CustomerType_Coal:
        {
            for (CustomerEntity *entity in self.coalCustomersArray) {
                if ([entity.name isEqualToString:customer.name] && [entity.carNumber isEqualToString:customer.carNumber]) {
                    return YES;
                }
            }
            break;
        }
        default:
            break;
    }
    
    return NO;
}

- (void)loadCustomerDataType:(CustomerType)type complete:(void(^)(NSArray *stoneArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"CustomerEntityModel"];
        if (type != CustomerType_ALL) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerType = %@", @(type)];
            [fetch setPredicate:predicate];
        }
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *customerArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadCustomerData, %@",error);
            return;
        }
        [self.coalCustomersArray removeAllObjects];
        [self.limeCustomersArray removeAllObjects];
        [self.stoneCustomersArray removeAllObjects];
        
        for (CustomerEntityModel *model in customerArray) {
            CustomerEntity *entity = [self createEntityFromModel:model];
            if ([entity.customerType integerValue] == CustomerType_Coal) {
                [self.coalCustomersArray addObject:entity];
            }
            else if ([entity.customerType integerValue] == CustomerType_Lime) {
                [self.limeCustomersArray addObject:entity];
            }
            else if ([entity.customerType integerValue] == CustomerType_Stone) {
                [self.stoneCustomersArray addObject:entity];
            }
        }
    }];
}

- (void)addCustomerData:(CustomerEntity *)customer complete:(void(^)(NSString *error))completeBlock
{
    if (!customer) {
        completeBlock(nil);
        return ;
    }
    
    CustomerEntityModel *entityModel = [self createModelFromEntity:customer];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
}

- (void)deleteCustomerData:(CustomerEntity *)customer complete:(void(^)(NSString *error))completeBlock
{
    if (!customer) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CustomerEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ && carNumber = ",customer.name, customer.carNumber];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (CustomerEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateCustomerData:(CustomerEntity *)customer complete:(void(^)(NSString *error))completeBlock;
{
    if (!customer) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CustomerEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ && carNumber = %@",customer.name, customer.carNumber];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (CustomerEntityModel *model in resutls) {
            [self updateCustomerEntityModel:model withCustomerEntity:customer];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateCustomerEntityModel:(CustomerEntityModel *)entityModel withCustomerEntity:(CustomerEntity *)customer
{
    entityModel.createDate = customer.createDate;
    entityModel.name = customer.name;
    entityModel.carNumber = customer.carNumber;
    entityModel.customerType = customer.customerType;
    if (customer.itemPricePerKG > 0) {
        entityModel.itemPricePerKG = customer.itemPricePerKG;
    }
    if (customer.carWeight > 0) {
        entityModel.carWeight = customer.carWeight;
    }
}

- (void)updateCustomerEntity:(CustomerEntity *)entity withCustomerEntityModel:(CustomerEntityModel *)entityModel
{
    entity.createDate = entityModel.createDate;
    entity.name = entityModel.name;
    entity.customerType = entityModel.customerType;
    entity.itemPricePerKG = entityModel.itemPricePerKG;
    entity.carNumber = entityModel.carNumber;
    entity.carWeight = entityModel.carWeight;
}

- (void)addNewCustomerWithBuyItem:(BaseItemEntity *)entity
{
    CustomerEntity *customer = [[CustomerEntity alloc] init];
    customer.name = entity.buyerName;
    customer.carNumber = entity.carNumber;
    customer.carWeight = entity.carWeight;
    customer.customerType = @([entity getCustomerType]);
    customer.itemPricePerKG = entity.itemPricePerKG;
    customer.createDate = entity.createDate;
    
    [self updateCustomer:customer];
}

- (void)addNewCustomerWithPreorderLime:(PreorderLimeEntity *)entity
{
    CustomerEntity *customer = [[CustomerEntity alloc] init];
    customer.name = entity.buyerName;
    customer.carNumber = entity.carNumber;
    customer.customerType = @(ItemEntity_Type_Lime);
    customer.createDate = entity.createDate;
    
    [self updateCustomer:customer];
}

- (void)updateCustomer:(CustomerEntity *)customer
{
    __weak typeof(self) weakSelf = self;
    if ([self isIncludeCustomerEntity:customer]) {
        [self updateCustomerData:customer complete:^(NSString *error) {
            [weakSelf loadCustomerDataType:[customer.customerType integerValue] complete:nil];
        }];
    }
    else
    {
        [self addCustomerData:customer complete:^(NSString *error) {
            [weakSelf loadCustomerDataType:[customer.customerType integerValue] complete:nil];
        }];
    }
}

//Operator
- (void)loadOperatorDataComplete:(void(^)(NSArray *stoneArray))completeBlock
{
    [self.backgroundObjectContext performBlock:^{
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"OperatorEntityModel"];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO selector:@selector(compare:)];
        [fetch setSortDescriptors:@[sort]];
        NSError *error = nil;
        NSArray *customerArray = [self.backgroundObjectContext executeFetchRequest:fetch error:&error];
        if (error) {
            completeBlock(nil);
            NSLog(@"loadOperatorData, %@",error);
            return;
        }
        
        [self.operatorsArray removeAllObjects];
        
        for (OperatorEntityModel *model in customerArray) {
            OperatorEntity *entity = [self createEntityFromModel:model];
            [self.operatorsArray addObject:entity];
        }
        
        self.latestOperatorName = ((OperatorEntityModel*)[self.operatorsArray firstObject]).name;
    }];
}

- (void)addOperatorData:(OperatorEntity *)customer complete:(void(^)(NSString *error))completeBlock
{
    if (!customer) {
        completeBlock(nil);
        return ;
    }
    
    OperatorEntityModel *entityModel = [self createModelFromEntity:customer];
    if (entityModel) {
        [self saveContext:completeBlock];
    }
}

- (void)deleteOperatorData:(OperatorEntity *)customer complete:(void(^)(NSString *error))completeBlock
{
    if (!customer) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OperatorEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ ",customer.name];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (OperatorEntityModel *model in resutls) {
            [[self backgroundObjectContext] deleteObject:model];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateOperatorData:(OperatorEntity *)customer complete:(void(^)(NSString *error))completeBlock;
{
    if (!customer) {
        completeBlock(nil);
        return;
    }
    
    [[self backgroundObjectContext] performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OperatorEntityModel"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",customer.name];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resutls =  [[self backgroundObjectContext] executeFetchRequest:request error:&error];
        if (error) {
            completeBlock(error.localizedDescription);
            NSLog(@"%@", error);
            return;
        }
        
        for (OperatorEntityModel *model in resutls) {
            [self updateOperatorEntityModel:model withOperatorEntity:customer];
        }
        
        [self saveContext:completeBlock];
    }];
}

- (void)updateOperatorEntityModel:(OperatorEntityModel *)entityModel withOperatorEntity:(OperatorEntity *)customer
{
    entityModel.name = customer.name;
    entityModel.createDate = customer.createDate;
}

- (void)updateOperatorEntity:(OperatorEntity *)entity withOperatorEntityModel:(OperatorEntityModel *)entityModel
{
    entity.name = entityModel.name;
    entity.createDate = entityModel.createDate;
}

- (void)addNewOperatorWithEntity:(OperatorEntity *)entity
{
    [self updateOperator:entity];
}

- (void)updateOperator:(OperatorEntity *)customer
{
    __weak typeof(self) weakSelf = self;
    if ([self isIncludeOperatorEntity:customer]) {
        [self updateOperatorData:customer complete:^(NSString *error) {
            [weakSelf loadOperatorDataComplete:nil];
        }];
    }
    else{
        [self addOperatorData:customer complete:^(NSString *error) {
            [weakSelf loadOperatorDataComplete:nil];
        }];
    }
}

- (BOOL)isIncludeOperatorEntity:(OperatorEntity *)operator
{
    for (OperatorEntity *entity in self.operatorsArray) {
        if ([entity.name isEqualToString:operator.name]) {
            return YES;
        }
    }
    
    return NO;
}

//Create
- (id)createEntityFromModel:(id)model
{
    if (!model) {
        return nil;
    }
    
    if ([model isKindOfClass:[BuyCoalEntityModel class]]) {
        BuyCoalEntityModel *entityModel = (BuyCoalEntityModel *)model;
        BaseItemEntity *entity = [[BaseItemEntity alloc] init];
        [self updateBuyItemEntity:entity withBuyCoalEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[BuyStoneEntityModel class]]) {
        BuyStoneEntityModel *entityModel = (BuyStoneEntityModel *)model;
        BaseItemEntity *entity = [[BaseItemEntity alloc] init];
        [self updateBuyItemEntity:entity withBuyStoneEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[SellLimeEntityModel class]]) {
        SellLimeEntityModel *entityModel = (SellLimeEntityModel *)model;
        BaseItemEntity *entity = [[BaseItemEntity alloc] init];
        [self updateBuyItemEntity:entity withSellLimeEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[UseCoalEntityModel class]]) {
        UseCoalEntityModel *entityModel = (UseCoalEntityModel *)model;
        UseCoalEntity *entity = [[UseCoalEntity alloc] init];
        [self updateUseCoalEntity:entity withUseCoalEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[UseStoneEntityModel class]]) {
        UseStoneEntityModel *entityModel = (UseStoneEntityModel *)model;
        UseStoneEntity *entity = [[UseStoneEntity alloc] init];
        [self updateUseStoneEntity:entity withUseStoneEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[CustomerEntityModel class]]) {
        CustomerEntityModel *entityModel = (CustomerEntityModel *)model;
        CustomerEntity *entity = [[CustomerEntity alloc] init];
        [self updateCustomerEntity:entity withCustomerEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[OperatorEntityModel class]]) {
        OperatorEntityModel *entityModel = (OperatorEntityModel *)model;
        OperatorEntity *entity = [[OperatorEntity alloc] init];
        [self updateOperatorEntity:entity withOperatorEntityModel:entityModel];
        
        return entity;
    }
    
    if ([model isKindOfClass:[PreorderLimeEntityModel class]]) {
        PreorderLimeEntityModel *entityModel = (PreorderLimeEntityModel *)model;
        PreorderLimeEntity *entity = [[PreorderLimeEntity alloc] init];
        [self updatePreorderLimeEntity:entity withPreorderLimeEntityModel:entityModel];
        
        return entity;
    }
    
    return nil;
}

- (id)createModelFromEntity:(id)entity
{
    if (!entity) {
        return nil;
    }
    
    if ([entity isKindOfClass:[BaseItemEntity class]]) {
        BaseItemEntity *itemEntity = (BaseItemEntity *)entity;
        NSManagedObject *entityModel = nil;
        if ([itemEntity.itemType integerValue] == ItemEntity_Type_Stone) {
            entityModel = [BuyStoneEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        }
        else if ([itemEntity.itemType integerValue] == ItemEntity_Type_Coal)
        {
            entityModel = [BuyCoalEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        }
        else if ([itemEntity.itemType integerValue] == ItemEntity_Type_Lime)
        {
            entityModel = [SellLimeEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        }
        
        if (entityModel) {
            [self updateModel:entityModel withBuyItemEntity:itemEntity];
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
    
    if ([entity isKindOfClass:[UseStoneEntity class]]) {
        UseStoneEntity *useStone = (UseStoneEntity *)entity;
        UseStoneEntityModel *entityModel = [UseStoneEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updateUseStoneEntityModel:entityModel withUseStoneEntity:useStone];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[CustomerEntity class]]) {
        CustomerEntity *useStone = (CustomerEntity *)entity;
        CustomerEntityModel *entityModel = [CustomerEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updateCustomerEntityModel:entityModel withCustomerEntity:useStone];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[OperatorEntity class]]) {
        OperatorEntity *useStone = (OperatorEntity *)entity;
        OperatorEntityModel *entityModel = [OperatorEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updateOperatorEntityModel:entityModel withOperatorEntity:useStone];
            return entityModel;
        }
    }
    
    if ([entity isKindOfClass:[PreorderLimeEntity class]]) {
        PreorderLimeEntity *useStone = (PreorderLimeEntity *)entity;
        PreorderLimeEntityModel *entityModel = [PreorderLimeEntityModel createManagedObjectInContext:[self backgroundObjectContext]];
        if (entityModel) {
            [self updatePreorderLimeEntityModel:entityModel withPreorderLimeEntity:useStone];
            return entityModel;
        }
    }
    
    return nil;
}
@end
