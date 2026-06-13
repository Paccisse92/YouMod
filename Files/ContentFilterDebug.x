#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didShow) {

        didShow = YES;

        NSMutableString *result = [NSMutableString string];

        NSInteger limit = MIN((NSInteger)array.count, 20);

        for (NSInteger i = 0; i < limit; i++) {

            id obj = array[i];

            [result appendFormat:
                @"ITEM %ld\n%@\n\n",
                (long)i,
                NSStringFromClass([obj class])];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            UIViewController *vc = window.rootViewController;

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"CLASS DEBUG"
                                                message:result
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
