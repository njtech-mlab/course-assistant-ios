//
//  StreamFetcher.h
//  课程助理
//
//  Created by Jason J on 10/2/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STREAM_JSON @"json"
#define STREAM_LAST_UPDATE_NUMBER @"count"

#define STREAM_COMMENT @"commentlist"
#define STREAM_INFO @"spit"
#define STREAM_EVALUATION_INFO @"courseAdvice"
#define STREAM_LIKE_NUMBER @"likenum"

#define STREAM_COMMENT_LIST @"list"
#define STREAM_COURSE_NAME @"coursename"
#define STREAM_EVER_LIKE @"everlike"
#define STREAM_SUMMARY_INFO_CONTENT @"content"
#define STREAM_EVALUATION_INFO_ATTENDANCE @"attendance"
#define STREAM_EVALUATION_INFO_EFFECT @"learningEffect"
#define STREAM_EVALUATION_INFO_SPEED @"speed"
#define STREAM_EVALUATION_INFO_ARRANGEMENT @"arrangement"
#define STREAM_EVALUATION_INFO_CAID @"caid"
#define STREAM_INFO_DATE @"date"
#define STREAM_INFO_CTID @"ctid"
#define STREAM_INFO_EDID @"spitid"
#define STREAM_INFO_SCHOOLNUMBER @"schoolnumber"
#define STREAM_SUMMARY_INFO_TIME @"timestamp"

#define STREAM_COMMENT_FROM @"fromuser"
#define STREAM_COMMENT_TO @"touser"
#define STREAM_COMMENT_INFOID @"infoid"
#define STREAM_COMMENT_ID @"commentid"

#define STREAM_TEACHER_REPLY_TOKEN @"teacherreplied"

@interface StreamFetcher : NSObject

+ (NSDictionary *)fetchInitialStreams;
+ (NSDictionary *)fetchInitialEvaluationStreams;

+ (NSDictionary *)fetchLatestStreamsByUsingCtid:(NSString *)ctid andEdidOfLastUpdatedStream:(NSString *)lastUpdatedEdid;

+ (NSDictionary *)fetchLatestStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid;
+ (NSDictionary *)fetchLatestEvaluationStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid;

+ (NSDictionary *)fetchLikeResponseWithEdid:(NSString *)edid from:(NSString *)from to:(NSString *)to tag:(NSString *)tag;

+ (NSDictionary *)fetchTeacherStreamsByCtid:(NSString *)ctid;
+ (NSDictionary *)fetchTeacherEvaluationStreamsByCtid:(NSString *)ctid;

+ (NSDictionary *)fetchStreamDetailByEdid:(NSString *)edid;
+ (NSDictionary *)fetchStreamEvaluationDetailByEdid:(NSString *)edid;

+ (NSDictionary *)fetchTeacherStreamDetailByEdid:(NSString *)edid;
+ (NSDictionary *)fetchTeacherStreamEvaluationDetailByEdid:(NSString *)edid;

+ (NSDictionary *)fetchTeacherLatestStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid andCtid:(NSString *)ctid;
+ (NSDictionary *)fetchTeacherLatestEvaluationStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid andCtid:(NSString *)ctid;

@end
