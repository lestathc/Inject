#import "UIViewController+SOContext.h"

#import "JRSwizzle.h"
#import "Objection.h"
#import "SOContextViewController.h"
#import "SOInjectorModule.h"
#import "SOViewControllerModule.h"

@interface UIViewController (SOContex)

@property(strong, nonatomic) JSObjectionInjector *so_inheritedInjector;
@property(assign, nonatomic) JSObjectionInjector *so_injector;

@end

@implementation UIViewController (SOContext)

objection_requires_sel(@selector(so_injector))

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
  objc_setAssociatedObject(self, @selector(so_injector), so_injector, OBJC_ASSOCIATION_ASSIGN);
}

- (JSObjectionInjector *)so_injector {
  return objc_getAssociatedObject(self, @selector(so_injector));
}

- (void)mayInejctSelfInheritsInjector:(JSObjectionInjector *)injector {
  if ([self conformsToProtocol:@protocol(SOContextViewController)]
      && self.so_injector == nil) {
    JSObjectionInjector *newInjector =
        [[injector withModule:[[SOInjectorModule alloc] init]]
            withModuleCollection:[self so_modules]];
    [newInjector injectDependencies:self];
  }
}

- (NSArray *)so_modules {
  return @[ [[SOViewControllerModule alloc] initWithViewController:self], ];
}

@end
