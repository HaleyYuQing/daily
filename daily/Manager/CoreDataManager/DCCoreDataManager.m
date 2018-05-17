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
#import "NSManagedObject+DC.h"

@interface DCCoreDataManager()
@property (nonatomic, strong) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundObjectContext;
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
    
    return nil;
}

- (void)updateBuyCoalEntityModel:(BuyCoalEntityModel *)entityModel withBuyCoalEntity:(BuyCoalEntity *)buyCoal
{
    entityModel.createDate = buyCoal.createDate;
    entityModel.name = buyCoal.entityName;
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
    entity.entityName = entityModel.name;
    entity.coalPricePerKG = entityModel.coalPricePerKG;
    entity.coalWeight = entityModel.coalWeight;
    entity.carWeight = entityModel.carWeight;
    entity.carAndCoalWeight = entityModel.carAndCoalWeight;
    entity.coalTotalPrice = entityModel.coalTotalPrice;
    entity.carNumber = entityModel.carNumber;
    entity.carOwnerName = entityModel.carOwnerName;
}
@end
