//
//  NSWindow+Center.m
//  Cutup
//
//  Created by James Shepherdson on 6/14/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "NSWindow+Center.h"

@implementation NSWindow (Center)

- (void)reallyCenter {
	[self setFrameOrigin:NSMakePoint([[NSScreen mainScreen] frame].size.width/2.0f - [self frame].size.width/2.0f, [[NSScreen mainScreen] frame].size.height/2.0f - [self frame].size.height/2.0f)];
}

@end
