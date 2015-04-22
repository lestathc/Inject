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
  [self bind:_viewController toClass:[UIViewController class]];
  if ([_viewController class] != [UIViewController class]) {
    [self bind:_viewController toClass:[_viewController class]];
  }
}

@end
