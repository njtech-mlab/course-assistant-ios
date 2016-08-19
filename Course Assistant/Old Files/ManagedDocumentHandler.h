//
//  ManagedDocumentHandler.h
//  南工课立方
//
//  Created by Jason J on 13-5-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface ManagedDocumentHandler : NSObject

@property (strong, nonatomic) UIManagedDocument *document;

+ (ManagedDocumentHandler *)sharedDocumentHandler;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end
