//
//  CTUtils.h
//  Cutup
//
//  Created by James Shepherdson on 6/19/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#pragma mark Defaults Keys
extern NSString *const CTPasteboardWindowWidthKey;
extern NSString *const CTPasteboardWindowHeightKey;
extern NSString *const CTPasteboardWindowGradientTopColorKey;
extern NSString *const CTPasteboardWindowGradientBottomColorKey;
extern NSString *const CTPasteboardWindowGradientBorderColorKey;
extern NSString *const CTLaunchAtLoginKey;
extern NSString *const CTPasteboardWindowShortcutKey;
extern NSString *const CTPasteboardItemsMemoryKey;

#pragma mark Other Keys
extern NSString *const CTPasteboardItemDataKey;
extern NSString *const CTShortcutCharactersKey;
extern NSString *const CTShortcutKeyCodesKey;
extern NSString *const CTShortcutModifierFlagsKey;

#pragma mark Names
extern NSString *const CTPasteboardItemsCacheFileName;

#pragma mark Functions
extern NSString* CTCacheDirectory();