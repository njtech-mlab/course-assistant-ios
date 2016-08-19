//
//  GradeTVC.m
//  课程助理
//
//  Created by Jason J on 13-5-28.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "GradeTVC.h"
#import "GradeTableViewCell.h"

@interface GradeTVC () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, GradeTableViewCellDelegate>
@property (strong, nonatomic) NSArray *sortedOriginalScoreArray;
@property (strong, nonatomic) NSArray *sortedScoreArray;
@property (strong, nonatomic) NSMutableArray *currentSortedScoreArray;
@property (strong, nonatomic) NSMutableArray *removedCellIndexArray;
@end

@implementation GradeTVC

- (NSMutableArray *)removedCellIndexArray
{
    if (!_removedCellIndexArray) {
        _removedCellIndexArray = [[NSMutableArray alloc] init];
    }
    return _removedCellIndexArray;
}

- (void)setScoreArray:(NSArray *)scoreArray
{
    _scoreArray = scoreArray;
    
    self.sortedOriginalScoreArray = [[_scoreArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"conversionScore" ascending:NO]]] copy];
    
    NSMutableArray *scoreMutableArray = [[_scoreArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"conversionScore" ascending:NO]]] mutableCopy];
    for (NSDictionary *dic in scoreMutableArray) {
        NSString *scoreString = [dic objectForKey:@"score"];
        if ([scoreString isEqualToString:@"优秀"]) {
            scoreString = @"95";
        } else if ([scoreString isEqualToString:@"良好"]) {
            scoreString = @"85";
        } else if ([scoreString isEqualToString:@"中等"]) {
            scoreString = @"75";
        } else if ([scoreString isEqualToString:@"及格"]) {
            scoreString = @"65";
        } else if ([scoreString isEqualToString:@"不及格"]) {
            scoreString = @"55";
        }
        [dic setValue:scoreString forKey:@"score"];
    }
    
    self.sortedScoreArray = [scoreMutableArray copy];
    self.currentSortedScoreArray = [scoreMutableArray mutableCopy];
    
    [self.removedCellIndexArray removeAllObjects];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GPAGeniusSwitch"]) {
        NSString *retakeTempCourseName;
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        NSInteger index = 0;
        NSInteger retakeTempScore = 0;
        for (NSDictionary *dic in self.sortedScoreArray) {
            if ([[[dic objectForKey:@"retakeTag"] description] integerValue] && ![[[dic objectForKey:@"coursename"] description] isEqualToString:retakeTempCourseName]) {
                retakeTempCourseName = [[dic objectForKey:@"coursename"] description];
                retakeTempScore = [[[dic objectForKey:@"score"] description] integerValue];
                NSInteger index2 = 0;
                for (NSDictionary *dic2 in self.sortedScoreArray) {
                    if ([[[dic2 objectForKey:@"coursename"] description] isEqualToString:retakeTempCourseName] && ![[[dic2 objectForKey:@"retakeTag"] description] integerValue]) {
                        if ([[[dic2 objectForKey:@"score"] description] integerValue] > retakeTempScore) {
                            [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index]];
                        } else if ([[[dic2 objectForKey:@"score"] description] integerValue] < retakeTempScore) {
                            [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index2]];
                        } else {
                            [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index2]];
                        }
                        break;
                    }
                    index2 = index2 + 1;
                }
                [indexArray addObject:[NSNumber numberWithInteger:index]];
            } else if ([[[dic objectForKey:@"retakeTag"] description] integerValue] && [[[dic objectForKey:@"coursename"] description] isEqualToString:retakeTempCourseName]) {
                if ([[[dic objectForKey:@"score"] description] integerValue] > retakeTempScore) {
                    [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:[[indexArray lastObject] integerValue]]];
                } else if ([[[dic objectForKey:@"score"] description] integerValue] < retakeTempScore) {
                    [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index]];
                } else {
                    [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index]];
                }
            }
            if (![[[dic objectForKey:@"score"] description] intValue]) {
                [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index]];
            }
            if (self.publicCourseFilterOn) {
                if ([[[dic valueForKey:@"courseNature"] description] isEqualToString:@"公共选修课"]) {
                    [self.removedCellIndexArray addObject:[NSNumber numberWithInteger:index]];
                }
            }
            index = index + 1;
        }
        
        for (NSNumber *number in self.removedCellIndexArray) {
            NSInteger replaceIndex = [number integerValue];
            NSDictionary *dic = [[NSDictionary alloc] init];
            [self.currentSortedScoreArray replaceObjectAtIndex:replaceIndex withObject:dic];
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refresh
{
    [self.delegate gradeTVCDidRefresh:self];
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.scoreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GradeDetailCell";
    GradeTableViewCell *cell = (GradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.userInteractionEnabled = YES;
    cell.alpha = 1;
    cell.contentView.alpha = 1;
    for (UIView *view in [cell.contentView subviews]) {
        if (view.frame.size.height == 1 && view.tag != 1) {
            [view removeFromSuperview];
        }
    }
    cell.isRemoved = NO;
    for (NSNumber *number in self.removedCellIndexArray) {
        NSInteger index = [number integerValue];
        if (index == indexPath.item) {
            cell.contentView.alpha = 0.5;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 300, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:line];
            cell.isRemoved = YES;
        }
    }
    cell.delegate = self;
    cell.index = indexPath.item;
    
    NSArray *sortedScoreArray = self.sortedOriginalScoreArray;
    NSDictionary *scoreDictionary = [sortedScoreArray objectAtIndex:indexPath.item];
    cell.sep.hidden = NO;
    cell.courseNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.makeupLabel.font = [UIFont systemFontOfSize:14.0];
    cell.courseNameLabel.text = [[scoreDictionary valueForKey:@"coursename"] description];
    cell.scoreLabel.text = [[scoreDictionary valueForKey:@"score"] description];
    cell.creditLabel.text = [NSString stringWithFormat:@"%@ 学分", [[scoreDictionary valueForKey:@"credit"] description]];
    cell.coursePropertyLabel.text = [[scoreDictionary valueForKey:@"courseNature"] description];
    if ([[[scoreDictionary valueForKey:@"makeupScore"] description] integerValue]) {
        cell.makeupLabel.hidden = NO;
        cell.makeupLabel.text = [NSString stringWithFormat:@"补考：%@", [[scoreDictionary valueForKey:@"makeupScore"] description]];
    } else {
        cell.makeupLabel.hidden = YES;
    }
    if ([[[scoreDictionary valueForKey:@"retakeTag"] description] integerValue]) {
        cell.retakeLabel.hidden = NO;
    } else {
        cell.retakeLabel.hidden = YES;
    }
    if ([[[scoreDictionary valueForKey:@"makeupScore"] description] integerValue] && [[[scoreDictionary valueForKey:@"retakeTag"] description] integerValue]) {
        cell.makeupLabel.hidden = NO;
        cell.retakeLabel.hidden = YES;
        cell.makeupLabel.text = [NSString stringWithFormat:@"重修补考：%@", [[scoreDictionary valueForKey:@"makeupScore"] description]];
    }
    
    NSInteger score = [[scoreDictionary valueForKey:@"conversionScore"] integerValue];
    [self paintCell:cell usingScore:score];
    return cell;
}

- (void)gradeTableViewCell:(GradeTableViewCell *)sender didRemoveCellOfIndex:(NSInteger)index
{
    NSNumber *indexObject = [NSNumber numberWithInteger:index];
    NSDictionary *dic = [[NSDictionary alloc] init];
    [self.removedCellIndexArray addObject:indexObject];
    [self.currentSortedScoreArray replaceObjectAtIndex:index withObject:dic];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)gradeTableViewCell:(GradeTableViewCell *)sender didAddBackCellOfIndex:(NSInteger)index
{
    NSNumber *indexObject = [NSNumber numberWithInteger:index];
    [self.removedCellIndexArray removeObject:indexObject];
    [self.currentSortedScoreArray replaceObjectAtIndex:index withObject:[self.sortedScoreArray objectAtIndex:index]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#define FOUNDATION_COLOR_RED 200
#define FOUNDATION_COLOR_GREEN 20
#define FOUNDATION_COLOR_BLUE 30
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ULTIMATE_GREEN_HUE 100
#define ULTIMATE_RED_HUE 20
#define FOUNDATION_SATURATION 1.0
#define FOUNDATION_BRIGHTNESS 0.8
#define ALPHA 1
#define HSBA(h, s, b, a) [UIColor colorWithHue:h/360.0 saturation:s brightness:b alpha:a]

- (void)paintCell:(GradeTableViewCell *)cell usingScore:(NSInteger)score
{
    //CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    //CGRect gradientFrame = CGRectMake(0, 0, 320, 56);
    if (score - 60 < 0) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            cell.contentView.backgroundColor = HSBA(ULTIMATE_RED_HUE, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, ALPHA);
        } else {
            cell.backgroundColor = HSBA(ULTIMATE_RED_HUE, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, ALPHA);
        }
        /*
        gradient.frame = gradientFrame;
        gradient.colors = [NSArray arrayWithObjects:(id)HSBA(ULTIMATE_RED_HUE, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, 0.85).CGColor, (id)HSBA(ULTIMATE_RED_HUE, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, ALPHA).CGColor, nil];
        if ([[cell layer].sublayers count] == 1) {
            [[cell layer] insertSublayer:gradient atIndex:0];
        } else {
            [[cell layer] replaceSublayer:[[cell layer].sublayers objectAtIndex:0] with:gradient];
        }
        */
        //cell.contentView.backgroundColor = HSBA(ULTIMATE_RED_HUE, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, 1);
    } else {
        NSInteger margin = score - 60;
        CGFloat hue = ULTIMATE_RED_HUE + (margin * 2);
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            cell.contentView.backgroundColor = HSBA(hue, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, ALPHA);
        } else {
            cell.backgroundColor = HSBA(hue, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, ALPHA);
        }
        /*
        gradient.frame = gradientFrame;
        gradient.colors = [NSArray arrayWithObjects:(id)HSBA(hue, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, 0.85).CGColor, (id)HSBA(hue, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, ALPHA).CGColor, nil];
        if ([[cell layer].sublayers count] == 1) {
            [[cell layer] insertSublayer:gradient atIndex:0];
        } else {
            [[cell layer] replaceSublayer:[[cell layer].sublayers objectAtIndex:0] with:gradient];
        }
        */
        //cell.contentView.backgroundColor = HSBA(hue, FOUNDATION_SATURATION, FOUNDATION_BRIGHTNESS, 1);
    }
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *thinLine = [[UIView alloc] initWithFrame:CGRectMake(0, 31, 320, 1)];
    thinLine.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    UILabel *wholeGPALabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 21)];
    UILabel *degreeGPALabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 140, 21)];
    wholeGPALabel.textColor = [UIColor darkGrayColor];
    wholeGPALabel.font = [UIFont boldSystemFontOfSize:14.0];
    wholeGPALabel.backgroundColor = [UIColor clearColor];
    degreeGPALabel.textColor = [UIColor darkGrayColor];
    degreeGPALabel.font = [UIFont boldSystemFontOfSize:14.0];
    degreeGPALabel.backgroundColor = [UIColor clearColor];
    degreeGPALabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:wholeGPALabel];
    [view addSubview:degreeGPALabel];
    [view addSubview:thinLine];
    
    // 算出全程GPA（包括选修课等）
    float wholeCredit = 0.0;
    float wholePoint = 0.0;
    for (NSDictionary *scoreDic in self.currentSortedScoreArray) {
        if (![[scoreDic valueForKey:@"cancelled"] integerValue]) {
            float floatScore = [[scoreDic valueForKey:@"score"] floatValue];
            float credit = [[scoreDic valueForKey:@"credit"] floatValue];
            float point = 0.0;
            if (floatScore < 60.0) {
                if ([[scoreDic valueForKey:@"makeupScore"] floatValue]) {
                    if ([[scoreDic valueForKey:@"makeupScore"] floatValue] >= 70.0) {
                        point = 2.0;
                    } else if ([[scoreDic valueForKey:@"makeupScore"] floatValue] >= 60.0 && [[scoreDic valueForKey:@"makeupScore"] floatValue] < 70.0) {
                        point = (([[scoreDic valueForKey:@"makeupScore"] floatValue] - 60.0) / 10) + 1.0;
                    } else {
                        point = 0;
                    }
                } else {
                    point = 0;
                }
            } else {
                point = ((floatScore - 60.0) / 10) + 1.0;
            }
            wholeCredit = wholeCredit + credit;
            wholePoint = wholePoint + (point * credit);
        }
    }
    if (wholeCredit == 0) {
        wholeGPALabel.text = @"全程GPA：0";
    } else {
        wholeGPALabel.text = [NSString stringWithFormat:@"全程GPA：%.2f", round(100.0 * (wholePoint / wholeCredit)) / 100.0];
    }
    
    // 算出学位GPA
    // 从11级开始的学位GPA算法
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"grade"] integerValue] > 2010) {
        float degreeWholeCredit = 0.0;
        float degreeWholePoint = 0.0;
        for (NSDictionary *scoreDic in self.currentSortedScoreArray) {
            if ([[[scoreDic valueForKey:@"courseNature"] description] isEqualToString:@"必修课"] || [[[scoreDic valueForKey:@"courseNature"] description] isEqualToString:@"限选课"]) {
                if (![[scoreDic valueForKey:@"cancelled"] integerValue]) {
                    float floatScore = [[scoreDic valueForKey:@"conversionScore"] floatValue];
                    float credit = [[scoreDic valueForKey:@"credit"] floatValue];
                    float point = 0.0;
                    if (floatScore < 60.0) {
                        if ([[scoreDic valueForKey:@"makeupScore"] floatValue]) {
                            if ([[scoreDic valueForKey:@"makeupScore"] floatValue] >= 70.0) {
                                point = 2.0;
                            } else if ([[scoreDic valueForKey:@"makeupScore"] floatValue] >= 60.0 && [[scoreDic valueForKey:@"makeupScore"] floatValue] < 70.0) {
                                point = (([[scoreDic valueForKey:@"makeupScore"] floatValue] - 60.0) / 10) + 1.0;
                            } else {
                                point = 0;
                            }
                        } else {
                            point = 0;
                        }
                    } else {
                        point = ((floatScore - 60.0) / 10) + 1.0;
                    }
                    degreeWholeCredit = degreeWholeCredit + credit;
                    degreeWholePoint = degreeWholePoint + (point * credit);
                }
            }
        }
        if (degreeWholeCredit == 0) {
            degreeGPALabel.text = @"学位GPA：0";
        } else {
            degreeGPALabel.text = [NSString stringWithFormat:@"学位GPA：%.2f", round(100.0 * (degreeWholePoint / degreeWholeCredit)) / 100.0];
        }
    // 10级以前的学位GPA算法
    } else {
        float degreeWholeCredit = 0.0;
        float degreeWholePoint = 0.0;
        for (NSDictionary *scoreDic in self.currentSortedScoreArray) {
            if ([[[scoreDic valueForKey:@"examMethod"] description] isEqualToString:@"学位课"]) {
                if (![[scoreDic valueForKey:@"cancelled"] integerValue]) {
                    float floatScore = [[scoreDic valueForKey:@"conversionScore"] floatValue];
                    float credit = [[scoreDic valueForKey:@"credit"] floatValue];
                    float point = 0.0;
                    if (floatScore < 60.0) {
                        if ([[scoreDic valueForKey:@"makeupScore"] floatValue]) {
                            if ([[scoreDic valueForKey:@"makeupScore"] floatValue] >= 70.0) {
                                point = 2.0;
                            } else  if ([[scoreDic valueForKey:@"makeupScore"] floatValue] >= 60.0 && [[scoreDic valueForKey:@"makeupScore"] floatValue] < 70.0) {
                                point = (([[scoreDic valueForKey:@"makeupScore"] floatValue] - 60.0) / 10) + 1.0;
                            } else {
                                point = 0;
                            }
                        } else {
                            point = 0;
                        }
                    } else {
                        point = ((floatScore - 60.0) / 10) + 1.0;
                    }
                    degreeWholeCredit = degreeWholeCredit + credit;
                    degreeWholePoint = degreeWholePoint + (point * credit);
                }
            }
        }
        if (!degreeWholeCredit) {
            degreeGPALabel.text = @"此学年学期无学位课";
        } else {
            degreeGPALabel.text = [NSString stringWithFormat:@"学位GPA：%.2f", round(100.0 * (degreeWholePoint / degreeWholeCredit)) / 100.0];
        }
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

@end
