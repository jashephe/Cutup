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

# pragma mark Headers
@interface CTFlippedView : NSView

@end

@interface CTPasteboardItemViewController ()
@property NSTrackingArea *trackingArea;
@property NSPopUpButton *previewTypeSelect;
@property NSButton *availableTypesSelect;
@property NSString *activePasteboardType;
@property NSPopover *activeTypesPopup;
@end

# pragma mark -
# pragma mark Pasteboard Item View Controller

@implementation CTPasteboardItemViewController

@synthesize pasteboardItemDataStore;
@synthesize trackingArea, previewTypeSelect, availableTypesSelect, activePasteboardType, activeTypesPopup;

- (id)init {
	self = [super init];
	if (self) {
		trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:(NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect | NSTrackingActiveAlways) owner:self userInfo:nil];
		self.view = [[CTPasteboardItemDataRepresentationView alloc] init];
		[self.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[self.view addTrackingArea:trackingArea];
		
		previewTypeSelect = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 160, 25) pullsDown:NO];
		[previewTypeSelect setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
		[previewTypeSelect setCell:[[CTOverlayPopUpButtonCell alloc] init]];
		[previewTypeSelect setTarget:self];
		[previewTypeSelect setAction:@selector(changePreviewType:)];
		
	}
	return self;
}
- (CTPasteboardItemDataStore *)pasteboardItemDataStore {
	return pasteboardItemDataStore;
}

- (void)setPasteboardItemDataStore:(CTPasteboardItemDataStore *)newPasteboardItemDataStore {
//	if (!availableTypesSelect) {
//		availableTypesSelect = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 19, 16)];
//		[availableTypesSelect setImage:[NSImage imageNamed:@"pasteboard_dropdown"]];
//		[availableTypesSelect setAutoresizingMask:NSViewMinXMargin | NSViewMinYMargin];
//		[availableTypesSelect setImagePosition:NSImageOnly];
//		[availableTypesSelect setBordered:NO];
//		[availableTypesSelect setTarget:self];
//		[availableTypesSelect setAction:@selector(changeActiveTypes:)];
//		[self.view addSubview:availableTypesSelect];
//	}
//	
//	if (!activeTypesPopup) {
//		activeTypesPopup = [[NSPopover alloc] init];
//		[activeTypesPopup setAnimates:NO];
////		[activeTypesPopup setBehavior:NSPopoverBehaviorSemitransient];
//	}
//	if (activeTypesPopup.isShown)
//		[activeTypesPopup performClose:self];
	
	pasteboardItemDataStore = newPasteboardItemDataStore;
	activePasteboardType = [pasteboardItemDataStore availableTypeFromArray:[NSArray arrayWithObjects:@"com.apple.icns", NSPasteboardTypePNG, NSPasteboardTypeTIFF, NSPasteboardTypeRTF, NSPasteboardTypeString, nil]];
	[self updateRepresentationViewWithType:activePasteboardType];
	
	// Update preview menu and selected item
	[previewTypeSelect setMenu:[self generateAvailableTypesMenu]];
	[previewTypeSelect selectItemWithTitle:activePasteboardType];
	
	[activeTypesPopup setContentViewController:[self fabricateAvailableTypesListViewController]];
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
	
	[(CTPasteboardItemDataRepresentationView *)self.view setComment:[NSDateFormatter localizedStringFromDate:[[pasteboardItemDataStore metadata] objectForKey:CTPasteboardDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
	[self.view setNeedsDisplay:YES];
}

# pragma mark Preview Type Button

- (void)mouseEntered:(NSEvent *)theEvent {	
	[previewTypeSelect setFrameOrigin:NSMakePoint((self.view.bounds.size.width - previewTypeSelect.bounds.size.width)/2, (self.view.bounds.size.height - previewTypeSelect.bounds.size.height)/2)];
	[self.view addSubview:previewTypeSelect];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[previewTypeSelect removeFromSuperview];
	[self.view setNeedsDisplay:YES];
}

- (void)changePreviewType:(NSPopUpButton *)sender {
	[self updateRepresentationViewWithType:[[sender selectedItem] title]];
}

- (NSMenu *)generateAvailableTypesMenu {
	NSMenu *menu = [[NSMenu alloc] init];
	for (NSString *type in [pasteboardItemDataStore types])
		[menu addItem:[[NSMenuItem alloc] initWithTitle:type action:nil keyEquivalent:@""]];
	return menu;
}

# pragma mark Type Select Button

- (void)changeActiveTypes:(NSButton *)sender {	
//	[activeTypesPopup showRelativeToRect:NSMakeRect(15, 0, 19, sender.frame.size.height) ofView:sender preferredEdge:NSMaxYEdge];
	[activeTypesPopup showRelativeToRect:self.view.superview.superview.frame ofView:self.view.superview.superview preferredEdge:NSMinYEdge];
}

- (NSArray *)generateActiveTypesList {
	NSMutableArray *activeTypes = [[NSMutableArray alloc] initWithCapacity:1];
	for (NSButton *checkbox in activeTypesPopup.contentViewController.view.subviews)
		if ([checkbox state] == NSOnState)
			[activeTypes addObject:[checkbox title]];
	return activeTypes;
}

- (NSViewController *)fabricateAvailableTypesListViewController {
	NSView *container = [[CTFlippedView alloc] init];
	
	CGFloat aggregateHeight = 0;
	CGFloat maxWidth = 0;
	for (NSString *type in [pasteboardItemDataStore types]) {
		NSButton *checkbox = [[NSButton alloc] initWithFrame:NSMakeRect(0, aggregateHeight, 1, 1)];
		[checkbox setButtonType:NSSwitchButton];
		[checkbox setBezelStyle:0];
		[checkbox setTitle:type];
		[checkbox.cell setControlSize:NSSmallControlSize];
		[checkbox setState:NSOnState];
		[checkbox sizeToFit];
		[container addSubview:checkbox];
		
		maxWidth = MAX(maxWidth, checkbox.frame.size.width);
		aggregateHeight += checkbox.frame.size.height;
	}
	
	[container setFrame:NSMakeRect(0, 0, maxWidth, aggregateHeight)];
	
	NSViewController *viewController = [[NSViewController alloc] initWithNibName:nil bundle:nil];
	[viewController setView:container];
	return viewController;
}

# pragma mark Pasteboard Management

- (void)overwritePasteboardWithPasteboardItem {
	[[NSPasteboard generalPasteboard] clearContents];
	[[NSPasteboard generalPasteboard] writeObjects:[NSArray arrayWithObject:[pasteboardItemDataStore fabricatePasteboardItem/*WithTypes:[self generateActiveTypesList]*/]]];
}

@end

# pragma mark -
# pragma mark CTFlippedView
// This is used to make the output of fabricateAvailableTypesListViewController match generateAvailableTypesMenu.

@implementation CTFlippedView

- (BOOL)isFlipped {
	return YES;
}

@end
