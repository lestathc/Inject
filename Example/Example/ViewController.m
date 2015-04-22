#import "Objection.h"
#import "SOContextViewController.h"
#import "SOInjectMeta.h"
#import "ViewController.h"
#import "UIViewController+SOContext.h"

@implementation InjectableClassA
objection_register_singleton(InjectableClassA)
@end

@implementation InjectableClassB
objection_register_singleton(InjectableClassB)
@end

@interface InjectableClassC ()
@property(strong, nonatomic) InjectableClassA *Inject(classA);
@property(strong, nonatomic) InjectableClassB *Inject(classB);
@end

@implementation InjectableClassC
@end

@implementation InjectableClassD
@end

@interface ViewController () <SOContextViewController>
/**
 *  Self injection
 */
@property(assign, nonatomic) ViewController *Inject(typedViewController);
/**
 *  Self injection
 */
@property(assign, nonatomic) UIViewController *Inject(nonTypedViewController);
/**
 *  View controller singlton
 */
@property(strong, nonatomic) InjectableClassA *Inject(classA);
/**
 *  View controller singlton
 */
@property(strong, nonatomic) InjectableClassB *Inject(classB);
/**
 *  Different instance with view controller singlton
 */
@property(strong, nonatomic) InjectableClassC *Inject(classC);
@property(strong, nonatomic) InjectableClassC *Inject(classCF);
/**
 *  Global singlton
 */
@property(strong, nonatomic) InjectableClassD *Inject(classD);

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = [NSString stringWithFormat:@"%@", self];
  self.label1.text = [NSString stringWithFormat:@"typedViewController: %@", self.typedViewController];
  self.label2.text = [NSString stringWithFormat:@"nonTypedViewController: %@", self.nonTypedViewController];
  self.label3.text = [NSString stringWithFormat:@"classA: %@", self.classA];
  self.label4.text = [NSString stringWithFormat:@"classB: %@", self.classB];
  self.label5.text = [NSString stringWithFormat:@"classC: %@, %@, %@\nclassCF: %@, %@, %@", self.classC, self.classC.classA, self.classC.classB, self.classCF, self.classCF.classA, self.classCF.classB];
  self.label6.text = [NSString stringWithFormat:@"classD: %@", self.classD];
}

- (IBAction)push {
  
}

@end
