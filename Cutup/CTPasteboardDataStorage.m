//
//  CTPasteboardDataStorage.m
//  Cutup
//
//  Created by James Shepherdson on 5/31/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardDataStorage.h"

@implementation CTPasteboardDataStorage

@synthesize pasteboardItemData;

- (id)initWithPasteboardItem:(NSPasteboardItem *)thePasteboardItem {
	self = [super init];
	if (self) {
		pasteboardItemData = [[NSMutableDictionary alloc] initWithCapacity:0];
		[self storeDataFromPasteboardItem:thePasteboardItem];
	}
	return self;
}

- (void)storeDataFromPasteboardItem:(NSPasteboardItem *)thePasteboardItem {
	for (NSString *type in [thePasteboardItem types]) {
		NSData *data = [thePasteboardItem dataForType:type];
		if (data)
			[pasteboardItemData setValue:data forKey:type];
	}	
}

- (NSPasteboardItem *)fabricatePasteboardItem {
	NSPasteboardItem *newPasteboardItem = [[NSPasteboardItem alloc] init];
	for (NSString *type in [pasteboardItemData allKeys])
		[newPasteboardItem setData:[pasteboardItemData objectForKey:type] forType:type];
	return newPasteboardItem;
}

@end
