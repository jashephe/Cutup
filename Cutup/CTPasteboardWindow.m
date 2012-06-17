//
//  CTPasteboardWindow.m 
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//
//  *Heavily* inspired by parts of SNRHUDKit <https://github.com/indragiek/SNRHUDKit> (Simplified BSD License).  Thanks, indragiek!
//

#import "CTPasteboardWindow.h"
#import "NSBezierPath+MCAdditions.h"

#define WINDOW_TITLEBAR_HEIGHT			22.0f
#define WINDOW_TOP_COLOR				[NSColor colorWithCalibratedWhite:0.98 alpha:0.96]
#define WINDOW_BOTTOM_COLOR				[NSColor colorWithCalibratedWhite:0.92 alpha:0.96]
#define WINDOW_HIGHLIGHT_COLOR			[NSColor colorWithCalibratedWhite:1.0 alpha:0.2]
#define WINDOW_CORNER_RADIUS			10.0f

#define WINDOW_TITLE_FONT				[NSFont systemFontOfSize:11.0f]
#define WINDOW_TITLE_COLOR				[NSColor colorWithCalibratedWhite:0.5 alpha:1.0]
#define WINDOW_TITLE_SHADOW_OFFSET		NSMakeSize(0.0f, 1.0f)
#define WINDOW_TITLE_SHADOW_BLUR_RADUIS	1.0f
#define WINDOW_TITLE_SHADOW_COLOR		[NSColor colorWithCalibratedWhite:0.8 alpha:1.0]

# pragma mark -
# pragma mark Headers

@interface CTPasteboardWindow ()
@property NSView *actualContentView;
@property NSUInteger actualStyleMask;
@end

# pragma mark -
# pragma mark Window

@implementation CTPasteboardWindow

@synthesize actualContentView, actualStyleMask;

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
	if (([super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:deferCreation])) {
		actualStyleMask = windowStyle;
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setHasShadow:YES];
	}
	return self;
}

- (NSRect)contentRectForFrameRect:(NSRect)windowFrame {
	windowFrame.origin = NSZeroPoint;
	if (actualStyleMask & NSTitledWindowMask)
		windowFrame.size.height -= WINDOW_TITLEBAR_HEIGHT;
	return windowFrame;
}

+ (NSRect)frameRectForContentRect:(NSRect)windowContentRect styleMask:(NSUInteger)windowStyle {
	if (windowStyle & NSTitledWindowMask)
		windowContentRect.size.height += WINDOW_TITLEBAR_HEIGHT;
	return windowContentRect;
}

- (NSRect)frameRectForContentRect:(NSRect)windowContent {
	if (actualStyleMask & NSTitledWindowMask)
		windowContent.size.height += WINDOW_TITLEBAR_HEIGHT;
	return windowContent;
}

# pragma mark Style Mask Faking

- (NSUInteger)styleMask {
	return actualStyleMask;
}

- (void)setStyleMask:(NSUInteger)styleMask {
	[self setActualStyleMask:styleMask];
}

# pragma mark Content View Faking

- (void)setContentView:(NSView *)aView {
	if ([actualContentView isEqualTo:aView]) {
		return;
	}
	NSRect bounds = [self frame];
	bounds.origin = NSZeroPoint;
	CTGradientWindowFrameView *frameView = [super contentView];
	if (!frameView) {
		frameView = [[CTGradientWindowFrameView alloc] initWithFrame:bounds];
		[super setContentView:frameView];
	}
	if (actualContentView) {
		[actualContentView removeFromSuperview];
	}
	actualContentView = aView;
	[actualContentView setFrame:[self contentRectForFrameRect:bounds]];
	[actualContentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[frameView addSubview:actualContentView];
}

- (NSView *)contentView {
	return actualContentView;
}

- (void)setTitle:(NSString *)aString {
	[super setTitle:aString];
	[[super contentView] setNeedsDisplay:YES];
}

# pragma mark Borderless Window Fixes

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)becomeFirstResponder {
	return YES;
}

- (BOOL)resignFirstResponder {
	return YES;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

@end

# pragma mark -
# pragma mark Window Frame

@implementation CTGradientWindowFrameView

- (void)drawRect:(NSRect)dirtyRect {
	NSRect drawingRect = NSInsetRect(self.bounds, 0.5f, 0.5f);
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:drawingRect xRadius:WINDOW_CORNER_RADIUS yRadius:WINDOW_CORNER_RADIUS];
	[NSGraphicsContext saveGraphicsState];
	[path addClip];
	
	if (((CTPasteboardWindow *)self.window).styleMask & NSTitledWindowMask) {
		// Fill in the title bar with a gradient background
		NSRect titleBarRect = NSMakeRect(0.f, NSMaxY(self.bounds) - WINDOW_TITLEBAR_HEIGHT, self.bounds.size.width, WINDOW_TITLEBAR_HEIGHT);
		NSGradient *titlebarGradient = [[NSGradient alloc] initWithStartingColor:WINDOW_BOTTOM_COLOR endingColor:WINDOW_TOP_COLOR];
		[titlebarGradient drawInRect:titleBarRect angle:90.f];
		
		// Draw the window title
		[self drawTitleInRect:titleBarRect];
	}
		
	// Rest of the window has a solid fill
	NSRect bottomRect;
	if (((CTPasteboardWindow *)self.window).styleMask & NSTitledWindowMask)
		bottomRect = NSMakeRect(0.f, 0.f, self.bounds.size.width, self.bounds.size.height - WINDOW_TITLEBAR_HEIGHT);
	else
		bottomRect = NSMakeRect(0.f, 0.f, self.bounds.size.width, self.bounds.size.height);
	[[self windowBackgroundColor] set];
	[NSBezierPath fillRect:bottomRect];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawTitleInRect:(NSRect)titleBarRect {
	NSString *title = [[self window] title];
	if (title) {
		NSShadow *shadow = [NSShadow new];
		[shadow setShadowColor:WINDOW_TITLE_SHADOW_COLOR];
		[shadow setShadowOffset:WINDOW_TITLE_SHADOW_OFFSET];
		[shadow setShadowBlurRadius:WINDOW_TITLE_SHADOW_BLUR_RADUIS];
		NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
		[style setAlignment:NSCenterTextAlignment];
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:WINDOW_TITLE_COLOR, NSForegroundColorAttributeName, WINDOW_TITLE_FONT, NSFontAttributeName, shadow, NSShadowAttributeName, style, NSParagraphStyleAttributeName, nil];
		NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
		NSSize titleSize = attrTitle.size;
		NSRect titleRect = NSMakeRect(0.f, NSMidY(titleBarRect) - (titleSize.height / 2.f), titleBarRect.size.width, titleSize.height);
		[attrTitle drawInRect:NSIntegralRect(titleRect)];
	}
}

# pragma mark Drawing Utilities

- (NSColor *)windowBackgroundColor {
	NSColor *color = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"pasteboardWindow.color"]];
	if (color)
		return color;
	return WINDOW_BOTTOM_COLOR;
}

@end