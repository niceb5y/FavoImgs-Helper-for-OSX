//
//  AppDelegate.m
//  FavoImgs Helper
//
//  Created by 김승호 on 2015. 6. 27..
//  Copyright (c) 2015년 Seungho Kim. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

-(id)init {
    self = [super init];
    if (self) {
        _urlPath = @"";
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *curPath = fileManager.currentDirectoryPath;
    if (![fileManager fileExistsAtPath:[curPath stringByAppendingString:@"/favoimgs.exe"]]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:NSLocalizedString(@"FavoImgs-Helper", @"FavoImgs Helper")];
        [alert setInformativeText:NSLocalizedString(@"FavoImgs-Not-Exist", @"FavoImgs Not Exist")];
        [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
        [alert runModal];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://azyu.tumblr.com/post/89925086759/favoimgs"]];
        [NSApp terminate:self];
    }
    [_target selectItemAtIndex:0];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application
{
    return YES;
}

- (IBAction)getPath:(id)sender {
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        _urlPath = [[panel URL] relativePath];
        [_path setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Path", @"Path   %@"), _urlPath]];
    }
}

- (IBAction)getImgs:(id)sender {
    NSString *args = @"";
    NSString *target = [_target objectValueOfSelectedItem];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"--source=%@ ", target]];
    if ([_targetname isEditable]) {
        if ([[_targetname stringValue] isEqualToString:@""]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:NSLocalizedString(@"FavoImgs-Helper", @"FavoImgs Helper")];
            [alert setInformativeText:[NSString stringWithFormat:NSLocalizedString(@"Enter-Name", @"Please enter name."), target]];
            [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
            [alert runModal];
            return;
        } else {
            if ([target isEqualToString:@"list"]) {
                args = [args stringByAppendingString:[NSString stringWithFormat:@"--slug=\"%@\" ", [_targetname stringValue]]];
            } else {
                args = [args stringByAppendingString:[NSString stringWithFormat:@"--hashtag=\"#%@\" ", [_targetname stringValue]]];
            }
        }
    }
    if ([_group state] == 1) {
        args = [args stringByAppendingString:@"--group=screen_name "];
    } else {
        args = [args stringByAppendingString:@"--group=none "];
    }
    if (![_urlPath isEqualToString:@""]) {
        args = [args stringByAppendingString:[NSString stringWithFormat:@"--path=\"%@\" ", _urlPath]];
    }
    if ([_someone state] == 1) {
        if ([[_screenName stringValue] isEqualToString:@""]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:NSLocalizedString(@"FavoImgs-Helper", @"FavoImgs Helper")];
            [alert setInformativeText:[NSString stringWithFormat:NSLocalizedString(@"Enter-Account-Name", @"Please enter account name.")]];
            [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
            [alert runModal];
            return;
        } else {
            args = [args stringByAppendingString:[NSString stringWithFormat:@"--screen_name=%@ ", [_screenName stringValue]]];
        }
    }
    if ([_excludeRetweet state] == 1) {
        args = [args stringByAppendingString:@"--exclude_rts"];
    }
    [self runFavoImgswithArgs:args];
}

- (IBAction)showHelp:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://niceb5y.net/blog/favoimgs-helper"]];
}

- (IBAction)showInfo:(id)sender {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:NSLocalizedString(@"FavoImgs-Helper-Info", @"FavoImgs Helper - FavoImgs GUI Frontend")];
    [alert setInformativeText:[NSString stringWithFormat:NSLocalizedString(@"FavoImgs-Helper-Credit", "FavoImgs Helper by @niceb5y"), version]];
    [alert setIcon:[NSImage imageNamed:NSImageNameInfo]];
    [alert runModal];
}

- (IBAction)resetPath:(id)sender {
    [self runFavoImgswithArgs:@"--reset_path"];
}

- (IBAction)checkSomeone:(id)sender {
    if ([_someone state] == 0) {
        [_screenName setEditable:NO];
        [_screenName setEnabled:NO];
    } else {
        [_screenName setEditable:YES];
        [_screenName setEnabled:YES];
    }
}

- (IBAction)selectTarget:(id)sender {
    if ([_target indexOfSelectedItem] % 2 == 0) {
        [_targetname setEditable:NO];
        [_targetname setEnabled:NO];
    } else {
        [_targetname setEditable:YES];
        [_targetname setEnabled:YES];
    }
}

- (void)runFavoImgswithArgs:(NSString *)args {
    NSString *cmd = [[NSString stringWithFormat:@"mono FavoImgs.exe "] stringByAppendingString:args];
    [_spinner startAnimation:self];
    system([cmd UTF8String]);
    [_spinner stopAnimation:self];
}

@end
