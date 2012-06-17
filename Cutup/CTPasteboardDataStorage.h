//
//  CTPasteboardDataStorage.h
//  Cutup
//
//  Created by James Shepherdson on 5/31/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPasteboardDataStorage : NSObject <NSCoding>

@property (strong) NSMutableDictionary *pasteboardItemData;

- (id)initWithPasteboardItem:(NSPasteboardItem *)thePasteboardItem;
- (NSPasteboardItem *)fabricatePasteboardItem;

@end
