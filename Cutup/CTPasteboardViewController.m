//
//  CTPasteboardViewController.m
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardViewController.h"
#import "CTPasteboardDataStorage.h"
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

- (void)awakeFromNib {
	__block NSView *pasteboardContentViewRef = pasteboardContentView;
	[pasteboardItemViewController addObservationKeyPath:@"view" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
		NSView *newView = (NSView *)[notification newValue];
		[newView setFrame:pasteboardContentViewRef.bounds];
		if ([pasteboardContentViewRef subviews].count > 0)
			[pasteboardContentViewRef replaceSubview:[[pasteboardContentViewRef subviews] objectAtIndex:0] with:newView];
		else
			[pasteboardContentViewRef addSubview:newView];
	}];
}

- (IBAction)performControlBarAction:(NSSegmentedControl *)sender {
	if ([sender selectedSegment] == 0) {
		if (currentIndex < pasteboardItemsData.count - 1)
			currentIndex += 1;
	}
	else if ([sender selectedSegment] == 1) {
		[[NSPasteboard generalPasteboard] clearContents];
		[[NSPasteboard generalPasteboard] writeObjects:[NSArray arrayWithObject:[[pasteboardItemsData objectAtIndex:currentIndex] fabricatePasteboardItem]]];
		[pasteboardItemsData removeObjectAtIndex:currentIndex];
		[self.view.window orderOut:self];
		currentIndex = 0;
	}
	else if ([sender selectedSegment] == 2) {
		if (currentIndex > 0)
			currentIndex -= 1;
	}
	[self updatePasteboardItemDisplay];
}

- (void)updatePasteboardItemDisplay {
	if (currentIndex > -1 && currentIndex < pasteboardItemsData.count)
		[pasteboardItemViewController setPasteboardItem:[[pasteboardItemsData objectAtIndex:currentIndex] fabricatePasteboardItem]];
	[controlBar setLabel:[NSString stringWithFormat:@"%i of %lu", currentIndex+1, pasteboardItemsData.count] forSegment:1];
}

#pragma mark Pasteboard Monitoring

- (void)checkPasteboard {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	if ([pasteboard changeCount] > lastPasteboardChangeCount && [pasteboard pasteboardItems].count > 0) {
		NSPasteboardItem *currentItem = [[pasteboard pasteboardItems] objectAtIndex:0];
		CTPasteboardDataStorage *pasteboardItemDataStore = [[CTPasteboardDataStorage alloc] initWithPasteboardItem:currentItem];
		[pasteboardItemsData insertObject:pasteboardItemDataStore atIndex:0];
		[self updatePasteboardItemDisplay];
		lastPasteboardChangeCount = [pasteboard changeCount];
	}
}

@end
