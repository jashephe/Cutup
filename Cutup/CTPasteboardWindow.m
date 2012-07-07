//
//  CTPasteboardWindow.m 
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//
//  Inspired by parts of SNRHUDKit <https://github.com/indragiek/SNRHUDKit> (Simplified BSD License).  Thanks, indragiek!
//

#import "CTPasteboardWindow.h"

#define WINDOW_CORNER_RADIUS	10.0f

# pragma mark -
# pragma mark Headers

@interface CTPasteboardWindow ()
@property NSView *actualContentView;
@property NSUInteger actualStyleMask;
@end

# pragma mark -
# pragma mark Window

@implementation CTPasteboardWindow

@synthesize backgroundGradient, borderColor;
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

# pragma mark Style Mask Faking

- (NSUInteger)styleMask {
	return actualStyleMask;
}

- (void)setStyleMask:(NSUInteger)styleMask {
	[self setActualStyleMask:styleMask];
}

# pragma mark Content View Faking

- (void)setContentView:(NSView *)aView {
	if ([actualContentView isEqualTo:aView])
		return;
	NSRect bounds = [self frame];
	bounds.origin = NSZeroPoint;
	CTGradientWindowFrameView *frameView = (CTGradientWindowFrameView *)[super contentView];
	if (!frameView) {
		frameView = [[CTGradientWindowFrameView alloc] initWithFrame:bounds];
		[super setContentView:frameView];
	}
	if (actualContentView)
		[actualContentView removeFromSuperview];
	actualContentView = aView;
	[actualContentView setFrame:bounds];
	[actualContentView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[frameView addSubview:actualContentView];
}

- (NSView *)contentView {
	return actualContentView;
}

# pragma mark Borderless Window Fixes

- (BOOL)canBecomeKeyWindow {
	return YES;
}

@end

# pragma mark -
# pragma mark Window Frame

@implementation CTGradientWindowFrameView

- (void)drawRect:(NSRect)dirtyRect {
	NSRect drawingRect = NSInsetRect([self bounds], 0.5f, 0.5f);
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:drawingRect xRadius:WINDOW_CORNER_RADIUS yRadius:WINDOW_CORNER_RADIUS];
	[NSGraphicsContext saveGraphicsState];
	[path addClip];
	[((CTPasteboardWindow *)self.window).backgroundGradient drawInBezierPath:path angle:-90];
	[NSGraphicsContext restoreGraphicsState];
	[((CTPasteboardWindow *)self.window).borderColor set];
	[path stroke];
}

@end