//
//  CTOverlayPopupButtonCell.m
//  Cutup
//
//  Created by James Shepherdson on 5/27/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTOverlayPopUpButtonCell.h"

@implementation CTOverlayPopUpButtonCell

// Constants
#define BORDER_RADUIS			4.0f
#define ARROW_SECTION_WIDTH		20.0f
#define X_PADDING				5.0f
#define ARROW_WIDTH				6.0f
#define ARROW_HEIGHT			4.0f
// ---------

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView {
	if([self isHighlighted]) {
		NSBezierPath *background = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:BORDER_RADUIS yRadius:BORDER_RADUIS];
		[[NSColor colorWithCalibratedWhite:0.1 alpha:0.6] set];
		[background fill];
	}
	else {
		NSBezierPath *background = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:BORDER_RADUIS yRadius:BORDER_RADUIS];
		[[NSColor colorWithCalibratedWhite:0.0 alpha:0.6] set];
		[background fill];
	}
	
	float arrStartX = self.controlView.frame.size.width - (ARROW_SECTION_WIDTH + ARROW_WIDTH)/2.0f;
	float arrMidY = self.controlView.frame.size.height/2.0f;
	
	NSBezierPath *arrow = [NSBezierPath bezierPath];
	[arrow moveToPoint:NSMakePoint(arrStartX, arrMidY + 1)];
	[arrow lineToPoint:NSMakePoint(arrStartX + ARROW_WIDTH, arrMidY + 1)];
	[arrow lineToPoint:NSMakePoint(arrStartX + ARROW_WIDTH/2, arrMidY + 1 + ARROW_HEIGHT)];
	[arrow closePath];
	[arrow moveToPoint:NSMakePoint(arrStartX, arrMidY - 1)];
	[arrow lineToPoint:NSMakePoint(arrStartX + ARROW_WIDTH, arrMidY - 1)];
	[arrow lineToPoint:NSMakePoint(arrStartX + ARROW_WIDTH/2, arrMidY - 1 - ARROW_HEIGHT)];
	[arrow closePath];
	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.8f] set];
	[arrow fill];
}

- (void)drawTitleWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:self.title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont controlContentFontOfSize:13], NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, [NSColor colorWithCalibratedWhite:1.0f alpha:0.8f], NSShadowAttributeName, nil]];
	[attributedTitle drawInRect:NSInsetRect(NSMakeRect(0, 0, cellFrame.size.width - ARROW_SECTION_WIDTH, cellFrame.size.height), X_PADDING, (cellFrame.size.height - attributedTitle.size.height)/2.0f)];
}

@end
