#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didShow && array.count > 0) {

        didShow = YES;

        NSString *desc = [[array firstObject] description];

        if (desc.length > 800) {
            desc = [desc substringToIndex:800];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];

            UIViewController *vc = window.rootViewController;

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"FILTER DEBUG"
                                                message:desc
                                         preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:
                [UIAlertAction actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                       handler:nil]
            ];

            [vc presentViewController:alert animated:YES completion:nil];
        });
    }

    %orig;
}

%end
