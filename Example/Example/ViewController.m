#import "Objection.h"
#import "SOContextViewController.h"
#import "SOInjectMeta.h"
#import "ViewController.h"
#import "UIViewController+SOContext.h"

@implementation InjectableClassA
objection_register_singleton(InjectableClassA)
- (void)dealloc {
  NSLog(@"%@ is deallocated", [NSString stringWithFormat:@"%@", self]);
}
@end

@implementation InjectableClassB
objection_register_singleton(InjectableClassB)
- (void)dealloc {
  NSLog(@"%@ is deallocated", [NSString stringWithFormat:@"%@", self]);
}
@end

@interface InjectableClassC ()
@InjectSingltonProperty InjectableClassA *classA;
@InjectSingltonProperty InjectableClassB *classB;
@end

@implementation InjectableClassC
- (void)dealloc {
  NSLog(@"%@ is deallocated", [NSString stringWithFormat:@"%@", self]);
}
@end

@implementation InjectableClassD
- (void)dealloc {
  NSLog(@"%@ is deallocated", [NSString stringWithFormat:@"%@", self]);
}
@end

@interface ViewController () <SOContextViewController>
/**
 *  Self injection
 */
@InjectSingltonProperty ViewController *typedViewController;
/**
 *  Self injection
 */
@InjectSingltonProperty id<SOContextViewController> nonTypedViewController;
/**
 *  View controller singlton
 */
@InjectSingltonProperty InjectableClassA *classA;
/**
 *  View controller singlton
 */
@InjectSingltonProperty InjectableClassB *classB;
/**
 *  Different instance with view controller singlton
 */
@InjectProperty InjectableClassC *classC;
@InjectProperty InjectableClassC *classCF;
/**
 *  Global singlton
 */
@InjectSingltonProperty InjectableClassD *classD;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[NSOperationQueue currentQueue] addOperationWithBlock:^{
    // If there is life cycle problem, some text will be 'null'
    self.title = [NSString stringWithFormat:@"%@", self];
    self.label1.text = [NSString stringWithFormat:@"typedViewController: %@", self.typedViewController];
    self.label2.text = [NSString stringWithFormat:@"nonTypedViewController: %@", self.nonTypedViewController];
    self.label3.text = [NSString stringWithFormat:@"classA: %@", self.classA];
    self.label4.text = [NSString stringWithFormat:@"classB: %@", self.classB];
    self.label5.text = [NSString stringWithFormat:@"classC: %@, %@, %@\nclassCF: %@, %@, %@", self.classC, self.classC.classA, self.classC.classB, self.classCF, self.classCF.classA, self.classCF.classB];
    self.label6.text = [NSString stringWithFormat:@"classD: %@", self.classD];
  }];
}

- (void)dealloc {
  NSLog(@"%@ is deallocated", [NSString stringWithFormat:@"%@", self]);
}

@end
