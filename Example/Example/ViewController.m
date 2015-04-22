#import "SOContextViewController.h"
#import "ViewController.h"
#import "UIViewController+SOContext.h"

#import "SOInjectMeta.h"

@interface ViewController () <SOContextViewController>

@property(assign, nonatomic) ViewController *Inject(typedViewController);
@property(assign, nonatomic) UIViewController *Inject(nonTypedViewController);

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  JSObjectionInjector *injector = self.so_injector;
  NSLog(@"%@", self.so_injector);
  assert(self == self.typedViewController);
  assert(self == self.nonTypedViewController);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
