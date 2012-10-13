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
    streamRef = FSEventStreamCreate(NULL, &file_events_callback, streamContext, pathsToWatch, kFSEventStreamEventIdSinceNow, (CFTimeInterval)latency, kFSEventStreamEventFlagNone);
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
