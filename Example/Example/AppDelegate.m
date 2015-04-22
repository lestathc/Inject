#import "AppDelegate.h"

#import "Objection.h"
#import "SOInjectMeta.h"
#import "ViewController.h"

@interface ClassA: NSObject

@end

@interface ClassAProvider: NSObject

@end

@implementation ClassA
@end

@interface AppDelegate ()

@property (copy, nonatomic) NSString *Inject(abc);
@property (strong, nonatomic) ClassA *Inject(classA);

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [JSObjection setDefaultInjector:[JSObjection createInjector]];
  [[JSObjection defaultInjector] injectDependencies:self];
  
  NSLog(@"%@", self.classA);
  self.window = [[UIWindow alloc] init];
  ViewController *viewController = [[ViewController alloc] init];
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
