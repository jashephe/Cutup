//
//  CTPasteboardItemViewController.m
//  Cutup
//
//  Created by James Shepherdson on 5/23/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardItemViewController.h"
#import "CTOverlayPopUpButtonCell.h"
#import "CTPasteboardItemDataRepresentationView.h"

@interface CTPasteboardItemViewController ()
@property NSTrackingArea *trackingArea;
@property NSPopUpButton *pasteboardTypeButton;
@property NSString *activePasteboardType;
@end

@implementation CTPasteboardItemViewController

@synthesize pasteboardItemDataStore;
@synthesize trackingArea, pasteboardTypeButton, activePasteboardType;

- (id)init {
	self = [super init];
	if (self) {
		trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:(NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect | NSTrackingActiveAlways) owner:self userInfo:nil];
		self.view = [[CTPasteboardItemDataRepresentationView alloc] init];
		[self.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[self.view addTrackingArea:trackingArea];
		pasteboardTypeButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 160, 25) pullsDown:NO];
		[pasteboardTypeButton setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
		[pasteboardTypeButton setCell:[[CTOverlayPopUpButtonCell alloc] init]];
		[pasteboardTypeButton selectItemWithTitle:activePasteboardType];
		[pasteboardTypeButton setTarget:self];
		[pasteboardTypeButton setAction:@selector(selectNewType:)];
	}
	return self;
}

- (CTPasteboardItemDataStore *)pasteboardItemDataStore {
	return pasteboardItemDataStore;
}

- (void)setPasteboardItemDataStore:(CTPasteboardItemDataStore *)newPasteboardItemDataStore {
	pasteboardItemDataStore = newPasteboardItemDataStore;
	activePasteboardType = [pasteboardItemDataStore availableTypeFromArray:[NSArray arrayWithObjects:NSPasteboardTypePNG, NSPasteboardTypeTIFF, NSPasteboardTypeRTF, NSPasteboardTypeString, nil]];
	[self updateRepresentationViewWithType:activePasteboardType];
	
	[pasteboardTypeButton setFrameOrigin:NSMakePoint((self.view.bounds.size.width - pasteboardTypeButton.bounds.size.width)/2, (self.view.bounds.size.height - pasteboardTypeButton.bounds.size.height)/2)];
	[pasteboardTypeButton setMenu:[self preparePasteboardTypesMenuFromItemDataStore:pasteboardItemDataStore]];
}

- (void)updateRepresentationViewWithType:(NSString *)type {
	if ([type isEqualToString:NSPasteboardTypePNG] || [type isEqualToString:NSPasteboardTypeTIFF] || [type isEqualToString:@"com.apple.icns"]) {
		[(CTPasteboardItemDataRepresentationView *)self.view setType:CTPasteboardItemRepresentationImage];
		[(CTPasteboardItemDataRepresentationView *)self.view setObject:[[NSImage alloc] initWithData:[pasteboardItemDataStore dataForType:type]]];
	}
	else if ([type isEqualToString:NSPasteboardTypeRTF]) {
		[(CTPasteboardItemDataRepresentationView *)self.view setType:CTPasteboardItemRepresentationAttributedString];
		[(CTPasteboardItemDataRepresentationView *)self.view setObject:[[NSAttributedString alloc] initWithData:[pasteboardItemDataStore dataForType:type] options:nil documentAttributes:nil error:nil]];
	}
	else if ([type isEqualToString:NSPasteboardTypeString]) {
		[(CTPasteboardItemDataRepresentationView *)self.view setType:CTPasteboardItemRepresentationString];
		[(CTPasteboardItemDataRepresentationView *)self.view setObject:[[NSString alloc] initWithData:[pasteboardItemDataStore dataForType:type] encoding:NSUTF8StringEncoding]];
	}
	else {
		[(CTPasteboardItemDataRepresentationView *)self.view setType:@""];
		[(CTPasteboardItemDataRepresentationView *)self.view setObject:nil];
//		[(CTPasteboardItemDataRepresentationView *)self.view setType:CTPasteboardItemRepresentationString];
//		[(CTPasteboardItemDataRepresentationView *)self.view setObject:[[NSString alloc] initWithData:[pasteboardItemDataStore dataForType:type] encoding:NSUTF8StringEncoding]];
	}
	
	NSLog(@"Updating display to type %@", type);
	NSLog(@"Item Date:  %@", [[pasteboardItemDataStore metadata] objectForKey:CTPasteboardDate]);
	[self.view setNeedsDisplay:YES];
}

#pragma mark Overlay Button

- (void)mouseEntered:(NSEvent *)theEvent {
	[self.view addSubview:pasteboardTypeButton];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[pasteboardTypeButton removeFromSuperview];
	[self.view setNeedsDisplay:YES];
}

- (void)selectNewType:(NSPopUpButton *)sender {
	[self updateRepresentationViewWithType:[[sender selectedItem] title]];
}

- (NSMenu *)preparePasteboardTypesMenuFromItemDataStore:(CTPasteboardItemDataStore *)thePasteboardItemDataStore {
	NSMenu *menu = [[NSMenu alloc] init];
	for (NSString *type in [thePasteboardItemDataStore types])
		[menu addItem:[[NSMenuItem alloc] initWithTitle:type action:nil keyEquivalent:@""]];
	return menu;
}

#pragma mark Pasteboard Management

- (void)overwritePasteboardWithPasteboardItem {
	[[NSPasteboard generalPasteboard] clearContents];
	[[NSPasteboard generalPasteboard] writeObjects:[NSArray arrayWithObject:[pasteboardItemDataStore fabricatePasteboardItem/*WithTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, nil]*/]]];
}

@end
