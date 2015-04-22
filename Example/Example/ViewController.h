#import <UIKit/UIKit.h>

@interface InjectableClassA : NSObject
@end

@interface InjectableClassB : NSObject
@end

@interface InjectableClassC : NSObject
@end

@interface InjectableClassD : NSObject
@end

@interface ViewController : UIViewController

@property(assign, nonatomic) IBOutlet UILabel *label1;
@property(assign, nonatomic) IBOutlet UILabel *label2;
@property(assign, nonatomic) IBOutlet UILabel *label3;
@property(assign, nonatomic) IBOutlet UILabel *label4;
@property(assign, nonatomic) IBOutlet UILabel *label5;
@property(assign, nonatomic) IBOutlet UILabel *label6;

@end
