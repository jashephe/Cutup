//
//  CTPasteboardItemDataStore.m
//  Cutup
//
//  Created by James Shepherdson on 5/31/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardItemDataStore.h"

#pragma mark Constants
NSString *const CTPasteboardDate = @"pasteboardItemDate";

@interface CTPasteboardItemDataStore ()
@property NSMutableDictionary *dataStore;
@end

@implementation CTPasteboardItemDataStore

@synthesize dataStore, metadata;

- (id)initWithPasteboardItem:(NSPasteboardItem *)thePasteboardItem {
	self = [super init];
	if (self) {
		dataStore = [[NSMutableDictionary alloc] initWithCapacity:0];
		[self storeDataFromPasteboardItem:thePasteboardItem];
	}
	return self;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		dataStore = [aDecoder decodeObjectForKey:CTPasteboardItemDataKey];
		metadata = [aDecoder decodeObjectForKey:CTPasteboardItemMetadataKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:dataStore forKey:CTPasteboardItemDataKey];
	[aCoder encodeObject:metadata forKey:CTPasteboardItemMetadataKey];
}

#pragma mark Pasteboard Storage
- (void)storeDataFromPasteboardItem:(NSPasteboardItem *)thePasteboardItem {
	for (NSString *type in [thePasteboardItem types]) {
		if ([[type substringToIndex:3] isEqualToString:@"dyn"])
			continue;
		NSData *data = [thePasteboardItem dataForType:type];
		if (data)
			[dataStore setValue:data forKey:type];
	}	
}

- (NSPasteboardItem *)fabricatePasteboardItem {
	NSPasteboardItem *newPasteboardItem = [[NSPasteboardItem alloc] init];
	for (NSString *type in [dataStore allKeys])
		[newPasteboardItem setData:[dataStore objectForKey:type] forType:type];
	return newPasteboardItem;
}

- (NSPasteboardItem *)fabricatePasteboardItemWithTypes:(NSArray *)types {
	NSPasteboardItem *newPasteboardItem = [[NSPasteboardItem alloc] init];
	for (NSString *type in types)
		[newPasteboardItem setData:[dataStore objectForKey:type] forType:type];
	return newPasteboardItem;
}

- (NSArray *)types {
	return dataStore.allKeys;
}

- (NSData *)dataForType:(NSString *)theKey {
	return [dataStore objectForKey:theKey];
}

- (NSString *)availableTypeFromArray:(NSArray *)availableTypes {
	for (NSString *type in availableTypes)
		if ([dataStore.allKeys containsObject:type])
			return type;
	return nil;
}

@end
