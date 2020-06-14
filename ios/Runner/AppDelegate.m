#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "DYPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
  
    
    
    [DYPlugin registerWithRegistrar:[self registrarForPlugin:@"DYPlugin"]];
    

    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    // dosomething
    return YES;
}


	
@end
