#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didShow) {

        NSMutableString *result = [NSMutableString string];

        for (id section in array) {

            if (![section respondsToSelector:@selector(contentsArray)])
                continue;

            NSArray *contents = [section valueForKey:@"contentsArray"];

            [result appendFormat:
                @"Section contents: %lu\n",
                (unsigned long)contents.count];

            for (NSUInteger i = 0; i < MIN(contents.count, 5); i++) {

                id item = contents[i];

                [result appendFormat:
                    @"  -> %@\n",
                    NSStringFromClass([item class])];
            }

            if (result.length > 500)
                break;
        }

        didShow = YES;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{

            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            UIViewController *vc = window.rootViewController;

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"CONTENTS DEBUG"
                                                message:result
                                         preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];

            [vc presentViewController:alert
                             animated:YES
                           completion:nil];
        });
    }

    %orig;
}

%end
