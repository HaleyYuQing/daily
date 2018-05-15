//
//  NSManagedObject+DC.h
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject(DC)
+ (instancetype)createManagedObjectInContext:(NSManagedObjectContext *)context;
@end
