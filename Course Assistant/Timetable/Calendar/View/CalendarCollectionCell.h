//
//  CalendarCollectionCell.h
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dayView.h"

@interface CalendarCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet dayView *dayView;
@property (strong, nonatomic) NSString *dayString;

@end
