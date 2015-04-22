#import "AppDelegate.h"

#import "Objection.h"
#import "SOInjectMeta.h"
#import "ViewController.h"

@interface AppModule : JSObjectionModule
@end

@implementation AppModule

- (void)configure {
  [self bindBlock:^id(JSObjectionInjector *context) {
    static InjectableClassD *classD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      classD = [[InjectableClassD alloc] init];
    });
    return classD;
  }
          toClass:[InjectableClassD class]];
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [JSObjection setDefaultInjector:
      [JSObjection createInjectorWithModules:[[AppModule alloc] init], nil]];
  [[JSObjection defaultInjector] injectDependencies:self];

  return YES;
}

@end
