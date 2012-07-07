//
//  CTPasteboardViewController.m
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardViewController.h"
#import "CTPasteboardItemDataStore.h"
#import "MAKVONotificationCenter.h"

@interface CTPasteboardViewController ()
@property int lastPasteboardChangeCount;
@property int currentIndex;
@end

@implementation CTPasteboardViewController

@synthesize pasteboardContentView, controlBar, pasteboardItemViewController, pasteboardItemsData;
@synthesize lastPasteboardChangeCount, currentIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkPasteboard) userInfo:nil repeats:YES];
		pasteboardItemViewController = [[CTPasteboardItemViewController alloc] init];
		pasteboardItemsData = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return self;
}

#define PASTEBOARD_CACHE_FILE [CTCacheDirectory() stringByAppendingPathComponent:CTPasteboardItemsCacheFileName]

- (BOOL)archivePasteboardItemsData {
	return [NSKeyedArchiver archiveRootObject:pasteboardItemsData toFile:PASTEBOARD_CACHE_FILE];
}

- (BOOL)unarchivePasteboardItemsData {
	if ([[NSFileManager defaultManager] fileExistsAtPath:PASTEBOARD_CACHE_FILE]) {
		pasteboardItemsData = [NSKeyedUnarchiver unarchiveObjectWithFile:PASTEBOARD_CACHE_FILE];
		return YES;
	}
	return NO;
}

- (BOOL)deleteArchivedPasteboardItems {
	return [[NSFileManager defaultManager] removeItemAtPath:PASTEBOARD_CACHE_FILE error:nil];
}

- (void)awakeFromNib {
	[pasteboardItemViewController.view setFrame:pasteboardContentView.bounds];
	[pasteboardContentView addSubview:pasteboardItemViewController.view];
}

#pragma mark Navigation Actions Actions

- (IBAction)performControlBarAction:(NSSegmentedControl *)sender {
	if ([sender selectedSegment] == 0) {
		[self shiftPasteboardIndexLeft];
	}
	else if ([sender selectedSegment] == 1) {
		[self changePasteboard];
	}
	else if ([sender selectedSegment] == 2) {
		[self shiftPasteboardIndexRight];
	}
}

- (void)changePasteboard {
	[pasteboardItemViewController overwritePasteboardWithPasteboardItem];
	[self.view.window orderOut:self];
	[pasteboardItemsData removeObjectAtIndex:currentIndex];
	currentIndex = 0;
}

- (void)shiftPasteboardIndexLeft {
	if (currentIndex < pasteboardItemsData.count - 1) {
		currentIndex += 1;
		[self updatePasteboardItemDisplay];
	}
}

- (void)shiftPasteboardIndexRight {
	if (currentIndex > 0) {
		currentIndex -= 1;
		[self updatePasteboardItemDisplay];
	}
}

- (void)updatePasteboardItemDisplay {
	[pasteboardItemViewController setPasteboardItemDataStore:[pasteboardItemsData objectAtIndex:currentIndex]];
	[controlBar setLabel:[NSString stringWithFormat:@"%i / %lu", currentIndex + 1, pasteboardItemsData.count] forSegment:1];
}

#pragma mark Pasteboard Management

- (void)checkPasteboard {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	if ([pasteboard changeCount] > lastPasteboardChangeCount && [pasteboard pasteboardItems].count > 0) {
		NSPasteboardItem *currentItem = [[pasteboard pasteboardItems] objectAtIndex:0];
		CTPasteboardItemDataStore *pasteboardItemDataStore = [[CTPasteboardItemDataStore alloc] initWithPasteboardItem:currentItem];
		[pasteboardItemDataStore setMetadata:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], CTPasteboardDate, nil]];
		[pasteboardItemsData insertObject:pasteboardItemDataStore atIndex:0];
		[self updatePasteboardItemDisplay];
		lastPasteboardChangeCount = [pasteboard changeCount];
	}
}

#pragma mark Keyboard Actions

#define KEY_LEFT 123
#define KEY_RIGHT 124
#define KEY_RETURN 36
#define KEY_ENTER 76
#define KEY_ESCAPE 53
- (void)keyDown:(NSEvent *)theEvent {
	NSLog(@"%i", [theEvent keyCode]);
	switch ([theEvent keyCode]) {
		case KEY_LEFT:
			[self shiftPasteboardIndexLeft];
			break;
		case KEY_RIGHT:
			[self shiftPasteboardIndexRight];
			break;
		case KEY_RETURN:
		case KEY_ENTER:
			[self changePasteboard];
			break;
		case KEY_ESCAPE:
			[self.view.window orderOut:self];
			break;
		default:
			break;
	}
}

@end
