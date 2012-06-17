//
//  CTShortcutRecorder.h
//  Cutup
//
//  Created by James Shepherdson on 6/8/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTShortcut.h"

@interface CTShortcutRecorder : NSControl

@property (readonly) BOOL isRecording;
@property CTShortcut *shortcut;

@end
