#import <objc/runtime.h>
#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (didShow) {
        %orig;
        return;
    }

    didShow = YES;

    NSMutableString *result = [NSMutableString string];

    unsigned int count = 0;

    objc_property_t *properties =
    class_copyPropertyList(%c(YTIElementRenderer), &count);

    [result appendFormat:@"Properties: %u\n\n", count];

    for (unsigned int i = 0; i < count; i++) {

        const char *name =
        property_getName(properties[i]);

        [result appendFormat:@"%s\n", name];
    }

    free(properties);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        UIWindow *window =
        [[[UIApplication sharedApplication] windows] firstObject];

        UIViewController *vc =
        window.rootViewController;

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"ELEMENT PROPERTIES"
                                            message:result
                                     preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
         [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                handler:nil]];

        [vc presentViewController:alert
                         animated:YES
                       completion:nil];
    });

    %orig;
}

%end
