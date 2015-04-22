#import "SOInjectorModule.h"

#import "Objection.h"

@implementation SOInjectorModule

- (void)configure {
  [self bindBlock:^id(JSObjectionInjector *context) {
    return context;
  }
          toClass:[JSObjectionInjector class]];
}

@end
