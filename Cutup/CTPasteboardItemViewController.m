//
//  CTPasteboardItemViewController.m
//  Cutup
//
//  Created by James Shepherdson on 5/23/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardItemViewController.h"
#import "CTOverlayPopUpButtonCell.h"
#import "MAKVONotificationCenter.h"

@interface CTPasteboardItemViewController ()
@property NSTrackingArea *trackingArea;
@property NSPopUpButton *pasteboardTypeButton;
@end

@implementation CTPasteboardItemViewController

@synthesize pasteboardItem;
@synthesize trackingArea, pasteboardTypeButton;

- (id)init {
	self = [super init];
	if (self) {
		trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:(NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect | NSTrackingActiveAlways) owner:self userInfo:nil];
		
		__unsafe_unretained CTPasteboardItemViewController *pasteboardItemViewControllerRef = self;
		__unsafe_unretained NSTrackingArea *trackingAreaRef = trackingArea;
		[self addObservationKeyPath:@"pasteboardItem" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
			NSPasteboardItem *newPasteboardItem = (NSPasteboardItem *)[notification newValue];
			NSString *pasteboardType = [pasteboardItemViewControllerRef determineBestRepresentationFromTypes:[newPasteboardItem types]];
			NSView *theView = [pasteboardItemViewControllerRef prepareViewForPasteboardType:pasteboardType];
			pasteboardItemViewControllerRef.view = theView;
			[pasteboardItemViewControllerRef.view addTrackingArea:trackingAreaRef];
			
//			pasteboardTypeButton = [[NSPopUpButton alloc] init];
//			[pasteboardTypeButton setFrameSize:NSMakeSize(160, 25)];
//			[pasteboardTypeButton setFrameOrigin:NSMakePoint((self.view.bounds.size.width - pasteboardTypeButton.bounds.size.width)/2, (self.view.bounds.size.height - pasteboardTypeButton.bounds.size.height)/2)];
//			[pasteboardTypeButton setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
//			[pasteboardTypeButton setCell:[[CTOverlayPopUpButtonCell alloc] init]];
//			[pasteboardTypeButton setMenu:[pasteboardItemViewControllerRef preparePasteboardTypesMenuFromItem:newPasteboardItem]];
//			[pasteboardTypeButton selectItemWithTitle:pasteboardType];
		}];
	}
	return self;
}

- (NSString *)determineBestRepresentationFromTypes:(NSArray *)types {
	if ([types containsObject:@"public.tiff"])
		return @"public.tiff";
	else if ([types containsObject:@"com.apple.icns"])
		return @"com.apple.icns";
	else if ([types containsObject:@"public.rtf"])
		return @"public.rtf";
	else if ([types containsObject:@"public.utf8-plain-text"])
		return @"public.utf8-plain-text";
	else
		return @"";
}

#pragma mark Overlay Button

- (void)mouseEntered:(NSEvent *)theEvent {
	[self.view addSubview:pasteboardTypeButton];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[pasteboardTypeButton removeFromSuperview];
}

- (NSMenu *)preparePasteboardTypesMenuFromItem:(NSPasteboardItem *)thePasteboardItem {
	NSMenu *menu = [[NSMenu alloc] init];
	for (NSString *type in [thePasteboardItem types])
		[menu addItem:[[NSMenuItem alloc] initWithTitle:type action:nil keyEquivalent:@""]];
	return menu;
}

#pragma mark Subview Management

- (NSView*)prepareViewForPasteboardType:(NSString *)pasteboardType {
	if ([pasteboardType isEqualToString:@"public.utf8-plain-text"] || [pasteboardType isEqualToString:@"public.file-url"]) {
		NSTextView *textView = [[NSTextView alloc] init];
		[textView setDrawsBackground:NO];
		[textView setEditable:NO];
		[textView setString:[[NSString alloc] initWithData:[pasteboardItem dataForType:pasteboardType] encoding:NSUTF8StringEncoding]];
		[textView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		return textView;
	}
	else if ([pasteboardType isEqualToString:@"public.rtf"]) {
		NSTextView *textView = [[NSTextView alloc] init];
		[textView.textContainer setWidthTracksTextView:YES];
		[textView.textContainer setHeightTracksTextView:YES];
		[textView setDrawsBackground:NO];
		[textView setEditable:NO];
		[textView.textStorage setAttributedString:[[NSAttributedString alloc] initWithData:[pasteboardItem dataForType:pasteboardType] options:nil documentAttributes:nil error:nil]];
		[textView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		return textView;
	}
	else if ([pasteboardType isEqualToString:@"public.tiff"] || [pasteboardType isEqualToString:@"public.png"] || [pasteboardType isEqualToString:@"com.apple.icns"]) {
		NSImageView *imageView = [[NSImageView alloc] init];
		[imageView setEditable:NO];
		[imageView setImage:[[NSImage alloc] initWithData:[pasteboardItem dataForType:pasteboardType]]];
		[imageView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		return imageView;
	}
	else {
		NSTextField *label = [[NSTextField alloc] init];
		[label setEditable:NO];
		[label setSelectable:NO];
		[label setDrawsBackground:NO];
		[label setBordered:NO];
		[label setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[label.cell setTitle:@"No Preview Available"];
		return label;
	}
}

@end
