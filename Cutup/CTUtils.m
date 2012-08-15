//
//  CTUtils.m
//  Cutup
//
//  Created by James Shepherdson on 6/19/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTUtils.h"

#pragma mark Defaults Keys
NSString *const CTPasteboardWindowWidthKey = @"pasteboardWindow.width";
NSString *const CTPasteboardWindowHeightKey = @"pasteboardWindow.height";
NSString *const CTPasteboardWindowGradientTopColorKey = @"pasteboardWindow.topColor";
NSString *const CTPasteboardWindowGradientBottomColorKey = @"pasteboardWindow.bottomColor";
NSString *const CTPasteboardWindowGradientBorderColorKey = @"pasteboardWindow.borderColor";
NSString *const CTLaunchAtLoginKey = @"launchAtLogin";
NSString *const CTPasteboardWindowShortcutKey = @"pasteboardWindow.shortcut";
NSString *const CTPasteboardItemsMemoryKey = @"pasteboardItemMemory";

#pragma mark Other Keys
NSString *const CTPasteboardItemDataKey = @"pasteboardItem.data";
NSString *const CTPasteboardItemMetadataKey = @"pasteboardItem.metadata";

NSString *const CTShortcutCharactersKey = @"shortcut.characters";
NSString *const CTShortcutKeyCodesKey = @"shortcut.keycodes";
NSString *const CTShortcutModifierFlagsKey = @"shortcut.modifiers";

#pragma mark Names
NSString *const CTPasteboardItemsCacheFileName = @"pbitems";

#pragma mark Functions

NSString* CTCacheDirectory() {
	NSString *path = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([paths count]) {
		NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
		path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
	}
	
	// We want to create the directory if it doesn't exist (otherwise NSKeyedArchiver will fail silently)
	BOOL isDirectory;
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
	if (!isDirectory) {
		NSLog(@"No cache directory.  Creating...");
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	return path;
}
