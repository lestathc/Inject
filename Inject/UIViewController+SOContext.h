#import <UIKit/UIKit.h>

@class JSObjectionInjector;

@interface UIViewController (SOContext)

@property(assign, nonatomic, readonly) JSObjectionInjector *so_injector;

- (instancetype)initWithInheritedInjector:(JSObjectionInjector *)injector;
- (NSArray *)so_modules;

@end
