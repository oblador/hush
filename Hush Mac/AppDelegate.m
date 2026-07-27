//
//  AppDelegate.m
//  Hush Mac
//
//  Created by Karsten Kusche on 26.01.21.
//

#import "AppDelegate.h"
#import <SafariServices/SafariServices.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSButton* stateCheckbox;
@end

@implementation AppDelegate

- (NSString*)contentBlockerIdentifier
{
	return [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".ContentBlocker"];
}

- (void)awakeFromNib
{
	_stateCheckbox.state = NSControlStateValueMixed;
	_stateCheckbox.enabled = NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[SFContentBlockerManager reloadContentBlockerWithIdentifier: self.contentBlockerIdentifier completionHandler:^(NSError * _Nullable error) {
		if (error != nil)
		{
			NSLog(@"Failed to reload content blocker: %@",error);
		}
	}];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)refreshEnabledState
{
	[SFContentBlockerManager getStateOfContentBlockerWithIdentifier:self.contentBlockerIdentifier completionHandler:^(SFContentBlockerState * _Nullable state, NSError * _Nullable error) {
		NSControlStateValue newState = NSControlStateValueMixed;
		if (error != nil)
		{
				NSLog(@"Failed to get content blocker state: %@",error);
		}
		else if (state != nil)
		{
			newState = state.enabled ? NSControlStateValueOn : NSControlStateValueOff;
		}
		[self performSelectorOnMainThread:@selector(updateState:) withObject:@(newState) waitUntilDone:NO];
	}];
}

- (void)updateState:(NSNumber*)number
{
	_stateCheckbox.state = number.intValue;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}
@end
