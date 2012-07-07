//
//  CTPasteboardItemDataStore.h
//  Cutup
//
//  Created by James Shepherdson on 5/31/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Constants
extern NSString *const CTPasteboardDate;

@interface CTPasteboardItemDataStore : NSObject <NSCoding>

@property NSDictionary *metadata;

- (id)initWithPasteboardItem:(NSPasteboardItem *)thePasteboardItem;
- (NSPasteboardItem *)fabricatePasteboardItem;
- (NSPasteboardItem *)fabricatePasteboardItemWithTypes:(NSArray *)types;
- (NSArray *)types;
- (NSData *)dataForType:(NSString *)theKey;
- (NSString *)availableTypeFromArray:(NSArray *)availableTypes;

@end
