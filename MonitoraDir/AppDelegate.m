//
//  AppDelegate.m
//  MonitoraDir
//
//  Created by Danilo Altheman on 12/10/12.
//  Copyright (c) 2012 Danilo Altheman. All rights reserved.
//

#import "AppDelegate.h"
void file_events_callback(ConstFSEventStreamRef streamRef, void *userData, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]) {
    
    char **paths = eventPaths;
    
    for (int  i = 0; i < numEvents; i++) {
        FSEventStreamEventFlags flags = eventFlags[i];
        NSLog(@"Event: %llu, Flags: %02x, Path: %@", eventIds[i], flags, [NSString stringWithUTF8String:paths[i]]);
        if (flags & kFSEventStreamEventFlagItemCreated) {
            NSLog(@"Criou");
        }
        else if (flags & kFSEventStreamEventFlagItemRemoved) {
            NSLog(@"Removeu");
        }
        else if (flags & kFSEventStreamEventFlagItemModified) {
            NSLog(@"Alterou");
        }
        else if (flags & kFSEventStreamEventFlagItemRenamed) {
            NSLog(@"Renomeou");
        }
        else if (flags & kFSEventStreamEventFlagItemXattrMod) {
            // Teste
            NSLog(@"Alterou permissoes");
        }
    }
    
/*
     FSEventStreamEventFlags
     
     enum {
     kFSEventStreamEventFlagNone = 0x00000000,
     kFSEventStreamEventFlagMustScanSubDirs = 0x00000001,
     kFSEventStreamEventFlagUserDropped = 0x00000002,
     kFSEventStreamEventFlagKernelDropped = 0x00000004,
     kFSEventStreamEventFlagEventIdsWrapped = 0x00000008,
     kFSEventStreamEventFlagHistoryDone = 0x00000010,
     kFSEventStreamEventFlagRootChanged = 0x00000020,
     kFSEventStreamEventFlagMount = 0x00000040,
//     These flags are only set if you specified the FileEvents
     kFSEventStreamEventFlagUnmount = 0x00000080,
//flags when creating the stream
    kFSEventStreamEventFlagItemCreated = 0x00000100,
    kFSEventStreamEventFlagItemRemoved = 0x00000200,
    kFSEventStreamEventFlagItemInodeMetaMod = 0x00000400,
    kFSEventStreamEventFlagItemRenamed = 0x00000800,
    kFSEventStreamEventFlagItemModified = 0x00001000,
    kFSEventStreamEventFlagItemFinderInfoMod = 0x00002000,
    kFSEventStreamEventFlagItemChangeOwner = 0x00004000,
    kFSEventStreamEventFlagItemXattrMod = 0x00008000,
    kFSEventStreamEventFlagItemIsFile = 0x00010000,
    kFSEventStreamEventFlagItemIsDir = 0x00020000,
    kFSEventStreamEventFlagItemIsSymlink = 0x00040000
};
Constants
kFSEventStreamEventFlagNone
There was some change in the directory at the specific path supplied in this event.

kFSEventStreamEventFlagMustScanSubDirs
Your application must rescan not just the directory given in the event, but all its children, recursively. This can happen if there was a problem whereby events were coalesced hierarchically. For example, an event in /Users/jsmith/Music and an event in /Users/jsmith/Pictures might be coalesced into an event with this flag set and path=/Users/jsmith. If this flag is set you may be able to get an idea of whether the bottleneck happened in the kernel (less likely) or in your client (more likely) by checking for the presence of the informational flags kFSEventStreamEventFlagUserDropped or kFSEventStreamEventFlagKernelDropped.

kFSEventStreamEventFlagUserDropped
The kFSEventStreamEventFlagUserDropped or kFSEventStreamEventFlagKernelDropped flags may be set in addition to the kFSEventStreamEventFlagMustScanSubDirs flag to indicate that a problem occurred in buffering the events (the particular flag set indicates where the problem occurred) and that the client must do a full scan of any directories (and their subdirectories, recursively) being monitored by this stream. If you asked to monitor multiple paths with this stream then you will be notified about all of them. Your code need only check for the kFSEventStreamEventFlagMustScanSubDirs flag; these flags (if present) only provide information to help you diagnose the problem.

kFSEventStreamEventFlagKernelDropped
kFSEventStreamEventFlagEventIdsWrapped
If kFSEventStreamEventFlagEventIdsWrapped is set, it means the 64-bit event ID counter wrapped around. As a result, previously-issued event ID's are no longer valid arguments for the sinceWhen parameter of the FSEventStreamCreate...() functions.

kFSEventStreamEventFlagHistoryDone
Denotes a sentinel event sent to mark the end of the "historical" events sent as a result of specifying a sinceWhen value in the FSEventStreamCreate...() call that created this event stream. (It will not be sent if kFSEventStreamEventIdSinceNow was passed for sinceWhen.) After invoking the client's callback with all the "historical" events that occurred before now, the client's callback will be invoked with an event where the kFSEventStreamEventFlagHistoryDone flag is set. The client should ignore the path supplied in this callback.

kFSEventStreamEventFlagRootChanged
Denotes a special event sent when there is a change to one of the directories along the path to one of the directories you asked to watch. When this flag is set, the event ID is zero and the path corresponds to one of the paths you asked to watch (specifically, the one that changed). The path may no longer exist because it or one of its parents was deleted or renamed. Events with this flag set will only be sent if you passed the flag kFSEventStreamCreateFlagWatchRoot to FSEventStreamCreate...() when you created the stream.

kFSEventStreamEventFlagMount
Denotes a special event sent when a volume is mounted underneath one of the paths being monitored. The path in the event is the path to the newly-mounted volume. You will receive one of these notifications for every volume mount event inside the kernel (independent of DiskArbitration). Beware that a newly-mounted volume could contain an arbitrarily large directory hierarchy. Avoid pitfalls like triggering a recursive scan of a non-local filesystem, which you can detect by checking for the absence of the MNT_LOCAL flag in the f_flags returned by statfs(). Also be aware of the MNT_DONTBROWSE flag that is set for volumes which should not be displayed by user interface elements.

kFSEventStreamEventFlagUnmount
Denotes a special event sent when a volume is unmounted underneath one of the paths being monitored. The path in the event is the path to the directory from which the volume was unmounted. You will receive one of these notifications for every volume unmount event inside the kernel. This is not a substitute for the notifications provided by the DiskArbitration framework; you only get notified after the unmount has occurred. Beware that unmounting a volume could uncover an arbitrarily large directory hierarchy, although Mac OS X never does that.
     
     
     
    */
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Diretório a ser monitorado.
    CFStringRef path = CFSTR("/Users/danilo/Desktop/DroBoh");
    // Cria o array com a lista de diretórios.
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&path, 1, NULL);
    // Cria a estrutura para o context.
    streamContext = (FSEventStreamContext *)malloc(sizeof(FSEventStreamContext));
    streamContext->version = 0;
    streamContext->info = NULL;
    streamContext->retain = NULL;
    streamContext->release = NULL;
    streamContext->copyDescription = NULL;
    
    // Verifica por alterações à cada 1/2s
    CFTimeInterval latency = 0.5;
    // Cria a Stream, e define a função de callback.
    streamRef = FSEventStreamCreate(NULL, &file_events_callback, streamContext, pathsToWatch, kFSEventStreamEventIdSinceNow, latency, kFSEventStreamEventFlagNone);
    // Coloca no Runloop
    FSEventStreamScheduleWithRunLoop(streamRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    // Inicia o monitoramento.
    FSEventStreamStart(streamRef);
}

// Quando aplicativo for encerrado, iremos parar e invalidar o FSEvent
-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    FSEventStreamStop(streamRef);
    FSEventStreamInvalidate(streamRef);
    return NSTerminateNow;
}

- (void)dealloc {
    [super dealloc];
}

@end
