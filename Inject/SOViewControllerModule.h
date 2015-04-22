#import <UIKit/UIKit.h>

#import "JSObjectionModule.h"

@interface SOViewControllerModule : JSObjectionModule

@property(strong, nonatomic, readonly) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@end
