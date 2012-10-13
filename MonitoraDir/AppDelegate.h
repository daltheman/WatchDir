//
//  AppDelegate.h
//  MonitoraDir
//
//  Created by Danilo Altheman on 12/10/12.
//  Copyright (c) 2012 Danilo Altheman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
@interface AppDelegate : NSObject <NSApplicationDelegate> {
    FSEventStreamRef streamRef;
    FSEventStreamContext *streamContext;
    NSNumber *lastEventID;
}

@property (assign) IBOutlet NSWindow *window;

@end
