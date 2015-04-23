#import "SOViewControllerModule.h"

@implementation SOViewControllerModule

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
  }
  return self;
}

- (void)configure {
  __weak SOViewControllerModule *weakSelf = self;
  [self bindBlock:^id(JSObjectionInjector *context) {
    return weakSelf.viewController;
  }
          toClass:[UIViewController class]];
  if ([_viewController class] != [UIViewController class]) {
    [self bindBlock:^id(JSObjectionInjector *context) {
      return weakSelf.viewController;
    }
            toClass:[_viewController class]];
  }
}

@end
