//
//  CTShortcut.m
//  Cutup
//
//  Created by James Shepherdson on 6/14/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTShortcut.h"

@implementation CTShortcut

@synthesize characters, keyCode, modifierFlags;

- (id)init {
	self = [super init];
	if (self) {
		characters = @"";
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		characters = [aDecoder decodeObjectForKey:CTShortcutCharactersKey];
		keyCode = [aDecoder decodeIntForKey:CTShortcutKeyCodesKey];
		modifierFlags = [aDecoder decodeIntForKey:CTShortcutModifierFlagsKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:characters forKey:CTShortcutCharactersKey];
	[aCoder encodeInt:keyCode forKey:CTShortcutKeyCodesKey];
	[aCoder encodeInt:(int)modifierFlags forKey:CTShortcutModifierFlagsKey];
}

@end
