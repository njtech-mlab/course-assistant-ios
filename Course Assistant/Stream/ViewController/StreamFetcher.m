//
//  StreamFetcher.m
//  课程助理
//
//  Created by Jason J on 10/2/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "StreamFetcher.h"

@implementation StreamFetcher

#define STREAM_EVALUATION_INFO_URL @"http://app.njut.org.cn/timetable/advicestream.action"
#define STREAM_SUMMARY_INFO_URL @"http://app.njut.org.cn/timetable/spitstream.action"

#define STREAM_LIKE_URL @"http://app.njut.org.cn/timetable/like.action"
#define STREAM_SUMMARY_COMMENT_URL @"http://app.njut.org.cn/timetable/comment.action"
#define STREAM_NEW_URL @"http://app.njut.org.cn/timetable/newnotification.action"

#define STREAM_INFO_DETAIL_URL @"http://app.njut.org.cn/timetable/infodetail.action"
#define STREAM_EVALUATION_INFO_DETAIL_URL @"http://app.njut.org.cn/timetable/adviceinfodetail.action"
#define STREAM_TEACHER_INFO_DETAIL_URL @"http://app.njut.org.cn/timetable/teacherinfodetail.action"
#define STREAM_TEACHER_EVALUATION_INFO_DETAIL_URL @"http://app.njut.org.cn/timetable/teacherinfodetailadvice.action"

#define TEACHER_STREAM_SPIT_URL @"http://app.njut.org.cn/timetable/fetchspit.action"
#define TEACHER_STREAM_ADVICE_URL @"http://app.njut.org.cn/timetable/fetchadvice.action"

+ (NSDictionary *)executeStreamFetch:(NSString *)query withToken:(NSInteger)token
{
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *wholeString = [NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *result = [[NSDictionary alloc] init];
    if (wholeString) {
        if (!([wholeString isEqualToString:@"{\"msg\":\"failed to check user\"}"] || [wholeString isEqualToString:@"{\"msg\":\"failed to check teacher\"}"])) {
            NSError *error = nil;
            if (token == 0) {
                NSString *lastUpdateString = [wholeString substringFromIndex:[wholeString rangeOfString:@":" options:NSBackwardsSearch].location + 1];
                NSString *jsonString = [[wholeString substringToIndex:[wholeString rangeOfString:@"lastupdate:"].location] substringFromIndex:[wholeString rangeOfString:@":"].location + 1];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
                result = @{ @"streamInfo" : json, @"edidOfLastUpdatedStream" : lastUpdateString };
            } else if (token == 1) {
                NSData *jsonData = [wholeString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
                result = @{ @"streamInfo" : json };
            }
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        } else {
            // Should log out
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"验证失败，请重新登录。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    return result;
}

+ (NSDictionary *)fetchInitialStreams
{
    NSString *request = [NSString stringWithFormat:@"%@", STREAM_SUMMARY_INFO_URL];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchInitialEvaluationStreams
{
    NSString *request = [NSString stringWithFormat:@"%@", STREAM_EVALUATION_INFO_URL];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchTeacherEvaluationStreamsByCtid:(NSString *)ctid
{
    NSString *request = [NSString stringWithFormat:@"%@?ctid=%@", TEACHER_STREAM_ADVICE_URL, ctid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchTeacherStreamsByCtid:(NSString *)ctid
{
    NSString *request = [NSString stringWithFormat:@"%@?ctid=%@", TEACHER_STREAM_SPIT_URL, ctid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchStreamDetailByEdid:(NSString *)edid
{
    NSString *request = [NSString stringWithFormat:@"%@?edid=%@", STREAM_INFO_DETAIL_URL, edid];
    return [self executeStreamFetch:request withToken:1];
}

+ (NSDictionary *)fetchStreamEvaluationDetailByEdid:(NSString *)edid
{
    NSString *request = [NSString stringWithFormat:@"%@?edid=%@", STREAM_EVALUATION_INFO_DETAIL_URL, edid];
    return [self executeStreamFetch:request withToken:1];
}

+ (NSDictionary *)fetchTeacherStreamDetailByEdid:(NSString *)edid
{
    NSString *request = [NSString stringWithFormat:@"%@?edid=%@", STREAM_TEACHER_INFO_DETAIL_URL, edid];
    return [self executeStreamFetch:request withToken:1];
}

+ (NSDictionary *)fetchTeacherStreamEvaluationDetailByEdid:(NSString *)edid
{
    NSString *request = [NSString stringWithFormat:@"%@?edid=%@", STREAM_TEACHER_EVALUATION_INFO_DETAIL_URL, edid];
    return [self executeStreamFetch:request withToken:1];
}

+ (NSDictionary *)fetchLatestStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid
{
    NSString *request = [NSString stringWithFormat:@"%@?lastupdate=%@", STREAM_SUMMARY_INFO_URL, lastUpdatedEdid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchLatestEvaluationStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid
{
    NSString *request = [NSString stringWithFormat:@"%@?lastupdate=%@", STREAM_EVALUATION_INFO_URL, lastUpdatedEdid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchTeacherLatestStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid andCtid:(NSString *)ctid
{
    NSString *request = [NSString stringWithFormat:@"%@?ctid=%@&lastupdate=%@", TEACHER_STREAM_SPIT_URL, ctid, lastUpdatedEdid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchTeacherLatestEvaluationStreamsByUsingNumberOfLastUpdatedStream:(NSString *)lastUpdatedEdid andCtid:(NSString *)ctid
{
    NSString *request = [NSString stringWithFormat:@"%@?ctid=%@&lastupdate=%@", TEACHER_STREAM_ADVICE_URL, ctid, lastUpdatedEdid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchLatestStreamsByUsingCtid:(NSString *)ctid andEdidOfLastUpdatedStream:(NSString *)lastUpdatedEdid
{
    NSString *request = [NSString stringWithFormat:@"%@?ctid=%@&lastupdate=%@", STREAM_SUMMARY_INFO_URL, ctid, lastUpdatedEdid];
    return [self executeStreamFetch:request withToken:0];
}

+ (NSDictionary *)fetchLikeResponseWithEdid:(NSString *)edid from:(NSString *)from to:(NSString *)to tag:(NSString *)tag
{
    NSString *request = [NSString stringWithFormat:@"%@?edid=%@&from=%@&to=%@&tag=%@", STREAM_LIKE_URL, edid, from, to, tag];
    NSString *query = [[NSString alloc] initWithString:request];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    NSLog(@"%@", results);
    return results;
}

@end
