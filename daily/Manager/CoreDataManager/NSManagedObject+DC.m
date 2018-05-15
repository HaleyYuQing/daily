//
//  NSManagedObject+DC.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "NSManagedObject+DC.h"

@implementation NSManagedObject(DC)
+ (instancetype)createManagedObjectInContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    return [[[self class] alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}
@end
