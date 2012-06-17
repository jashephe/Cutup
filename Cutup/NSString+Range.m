//
//  NSString+Range.m
//  Cutup
//
//  Created by James Shepherdson on 6/5/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "NSString+Range.h"

@implementation NSString (Range)

- (NSInteger)indexOfString:(NSString *)text {
	NSRange range = [self rangeOfString:text];
	if (range.location != NSNotFound)
		return range.location;
	return -1;
}

- (NSInteger)indexOfChar:(char)character {
	NSRange range = [self rangeOfString:[NSString stringWithFormat:@"%c", character]];
	if (range.location != NSNotFound)
		return range.location;
	return -1;
}

@end
