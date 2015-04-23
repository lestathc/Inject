#import "UIViewController+SOContext.h"

#import "JRSwizzle.h"
#import "Objection.h"
#import "SOContextViewController.h"
#import "SOInjectorModule.h"
#import "SOViewControllerModule.h"

@interface SOContextViewControllerModule : JSObjectionModule
@property(weak, nonatomic, readonly) UIViewController *viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController;
@end

@implementation SOContextViewControllerModule

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
  }
  return self;
}

- (void)configure {
  if ([_viewController class] != [UIViewController class]) {
    [self bindClass:[_viewController class] toProtocol:@protocol(SOContextViewController)];
  } else {
    [self bindClass:[UIViewController class] toProtocol:@protocol(SOContextViewController)];
  }
}

@end

@interface UIViewController (SOContex)

@property(weak, nonatomic) JSObjectionInjector *so_inheritedInjector;
@property(strong, nonatomic) JSObjectionInjector *so_injector;

@end

@implementation UIViewController (SOContext)

+ (void)load {
  NSError *error;
  [self jr_swizzleMethod:@selector(viewDidLoad)
              withMethod:@selector(so_swizzle_viewDidLoad)
                   error:&error];
}

- (instancetype)initWithInheritedInjector:(JSObjectionInjector *)injector {
  self = [self init];
  if (self) {
    self.so_inheritedInjector = injector;
  }
  return self;
}

- (void)so_swizzle_viewDidLoad {
  [self so_swizzle_viewDidLoad];
  JSObjectionInjector *inheritedInjector = self.so_inheritedInjector;
  if (inheritedInjector == nil ) {
    inheritedInjector = [JSObjection defaultInjector];
  }
  [self mayInejctSelfInheritsInjector:inheritedInjector];
}

- (void)setSo_inheritedInjector:(JSObjectionInjector *)so_inheritedInjector {
  objc_setAssociatedObject(self, @selector(so_inheritedInjector), so_inheritedInjector, OBJC_ASSOCIATION_ASSIGN);
}

- (JSObjectionInjector *)so_inheritedInjector {
  return objc_getAssociatedObject(self, @selector(so_inheritedInjector));
}

- (void)setSo_injector:(JSObjectionInjector *)so_injector {
  objc_setAssociatedObject(self, @selector(so_injector), so_injector,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JSObjectionInjector *)so_injector {
  return objc_getAssociatedObject(self, @selector(so_injector));
}

- (void)mayInejctSelfInheritsInjector:(JSObjectionInjector *)injector {
  if ([self conformsToProtocol:@protocol(SOContextViewController)]
      && self.so_injector == nil) {
    NSMutableArray *modules = [self so_modulesInternal].mutableCopy;
    NSArray *customModules = [self so_modules];
    if (customModules.count) {
      [modules addObjectsFromArray:customModules];
    }
    JSObjectionInjector *newInjector =
        [[injector withModule:[[SOInjectorModule alloc] init]]
            withModuleCollection:modules];
    self.so_injector = newInjector;
    [newInjector injectDependencies:self];
  }
}

- (NSArray *)so_modules {
  return nil;
}

- (NSArray *)so_modulesInternal {
  return @[ [[SOViewControllerModule alloc] initWithViewController:self],
            [[SOContextViewControllerModule alloc] initWithViewController:self], ];
}

@end
