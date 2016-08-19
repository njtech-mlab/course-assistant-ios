//
//  Stream.h
//  课程助理
//
//  Created by Jason J on 10/6/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stream : NSManagedObject

@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * edid;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSNumber * numberOfComments;
@property (nonatomic, retain) NSNumber * numberOfLikes;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * ctid;
@property (nonatomic, retain) NSString * evaluationAdvice;
@property (nonatomic, retain) NSNumber * evaluationAttendance;
@property (nonatomic, retain) NSNumber * evaluationSpeed;
@property (nonatomic, retain) NSNumber * evaluationDiscipline;
@property (nonatomic, retain) NSNumber * evaluationEffect;
@property (nonatomic, retain) NSSet *whoLikes;
@end

@interface Stream (CoreDataGeneratedAccessors)

- (void)addWhoLikesObject:(NSManagedObject *)value;
- (void)removeWhoLikesObject:(NSManagedObject *)value;
- (void)addWhoLikes:(NSSet *)values;
- (void)removeWhoLikes:(NSSet *)values;

@end
