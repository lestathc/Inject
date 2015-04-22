#import "UIViewController+SOContext.h"

#import "JRSwizzle.h"
#import "Objection.h"
#import "SOContextViewController.h"
#import "SOInjectorModule.h"
#import "SOViewControllerModule.h"

@interface UIViewController (SOContex)

@property(assign, nonatomic) JSObjectionInjector *so_injector;

@end

@implementation UIViewController (SOContext)

objection_requires_sel(@selector(so_injector))

+ (void)load {
  NSError *error;
  [self jr_swizzleMethod:@selector(init)
              withMethod:@selector(so_swizzle_init)
                   error:&error];
  [self jr_swizzleMethod:@selector(initWithCoder:)
              withMethod:@selector(so_swizzle_initWithCoder:)
                   error:&error];
  [self jr_swizzleMethod:@selector(initWithNibName:bundle:)
              withMethod:@selector(so_swizzle_initWithNibName:bundle:)
                   error:&error];
}

- (instancetype)initWithInheritedInjector:(JSObjectionInjector *)injector {
  self = [self so_swizzle_init];
  if (self) {
    [self mayInejctSelfInheritsInjector:injector];
  }
  return self;
}

- (instancetype)so_swizzle_init {
  id result = [self so_swizzle_init];
  [self mayInejctSelfInheritsInjector:[JSObjection defaultInjector]];
  return result;
}

- (id)so_swizzle_initWithCoder:(NSCoder *)aDecoder {
  id result = [self so_swizzle_initWithCoder:aDecoder];
  [self mayInejctSelfInheritsInjector:[JSObjection defaultInjector]];
  return result;
}

- (instancetype)so_swizzle_initWithNibName:(NSString *)nibNameOrNil
                                 bundle:(NSBundle *)nibBundleOrNil {
  id result = [self so_swizzle_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  [self mayInejctSelfInheritsInjector:[JSObjection defaultInjector]];
  return result;
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
