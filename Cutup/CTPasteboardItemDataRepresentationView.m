//
//  CTPasteboardItemDataRepresentationView.m
//  Cutup
//
//  Created by James Shepherdson on 6/24/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardItemDataRepresentationView.h"
#import "NSImage+ProportionalScaling.h"

#define OVERLAY_BORDER_RADIUS 3.0f

NSString *CTPasteboardItemRepresentationString = @"stringRepresentation";
NSString *CTPasteboardItemRepresentationAttributedString = @"attributedStringRepresentation";
NSString *CTPasteboardItemRepresentationImage = @"imageRepresentation";

@implementation CTPasteboardItemDataRepresentationView

@synthesize type, object, comment;

- (id)initWithFrame:(NSRect)frame type:(NSString *)theType object:(id)theObject comment:(NSString *)theComment {
	self = [super initWithFrame:frame];
	if (self) {
		type = theType;
		object = theObject;
		comment = theComment;
	}
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect drawingRect = [self bounds];
	if (type == CTPasteboardItemRepresentationString) {
		NSString *plainText = (NSString *)object;
		[plainText drawInRect:drawingRect withAttributes:nil];
	}
	else if (type == CTPasteboardItemRepresentationAttributedString) {
		NSAttributedString *richText = (NSAttributedString *)object;
		[richText drawInRect:drawingRect];
	}
	else if (type == CTPasteboardItemRepresentationImage) {
		NSImage *image = (NSImage *)object;
		[[image imageByScalingProportionallyToSize:[self bounds].size] drawInRect:drawingRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	}
	else {
		[@"No Representation" drawInRect:drawingRect withAttributes:nil];
	}
	
#define DATESTAMP_INSET 3
	NSAttributedString *attributedComment = [[NSAttributedString alloc] initWithString:comment attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithCalibratedWhite:0.9f alpha:1.0f], NSForegroundColorAttributeName, [NSFont systemFontOfSize:10.0f], NSFontAttributeName, nil]];
	
	NSRect textRect = NSMakeRect((self.bounds.size.width - attributedComment.size.width)/2, DATESTAMP_INSET, attributedComment.size.width, attributedComment.size.height);
	
	[[NSColor colorWithCalibratedWhite:0.0f alpha:0.3f] set];
	[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(textRect, -DATESTAMP_INSET, -DATESTAMP_INSET) xRadius:DATESTAMP_INSET*2 yRadius:DATESTAMP_INSET*2] fill];
	[attributedComment drawInRect:textRect];

}

@end
