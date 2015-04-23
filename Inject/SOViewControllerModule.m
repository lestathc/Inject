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
  [self bindBlock:^id(JSObjectionInjector *context) {
    return self.viewController;
  }
          toClass:[UIViewController class]];
  if ([_viewController class] != [UIViewController class]) {
    [self bindBlock:^id(JSObjectionInjector *context) {
      return self.viewController;
    }
            toClass:[_viewController class]];
  }
}

@end
