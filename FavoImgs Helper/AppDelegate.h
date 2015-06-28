//
//  AppDelegate.h
//  FavoImgs Helper
//
//  Created by 김승호 on 2015. 6. 27..
//  Copyright (c) 2015년 Seungho Kim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSComboBox *target;
@property (weak) IBOutlet NSTextField *targetname;
@property (weak) IBOutlet NSTextField *path;
@property (weak) IBOutlet NSButton *someone;
@property (weak) IBOutlet NSTextField *screenName;
@property (weak) IBOutlet NSButton *group;
@property (weak) IBOutlet NSButton *excludeRetweet;
@property (weak) IBOutlet NSProgressIndicator *spinner;
@property (copy) NSString *urlPath;
- (IBAction)getPath:(id)sender;
- (IBAction)getImgs:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)checkSomeone:(id)sender;
- (IBAction)selectTarget:(id)sender;
- (void)runFavoImgswithArgs:(NSString *)args;

@end

