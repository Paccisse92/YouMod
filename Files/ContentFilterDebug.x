#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didShow) {

        didShow = YES;

        NSMutableString *result = [NSMutableString string];

        int count = 0;

        for (id section in array) {

            if (![section respondsToSelector:@selector(contentsArray)])
                continue;

            NSArray *contents = [section valueForKey:@"contentsArray"];

            for (id item in contents) {

                if (![item respondsToSelector:@selector(elementRenderer)])
                    continue;

                id renderer = [item valueForKey:@"elementRenderer"];

                NSString *desc = [renderer description];

                if (desc.length > 120) {
                    desc = [desc substringToIndex:120];
                }

                [result appendFormat:
                 @"[%d]\n%@\n\n",
                 count,
                 desc];

                count++;

                if (count >= 20)
                    break;
            }

            if (count >= 20)
                break;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{

            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            UIViewController *vc = window.rootViewController;

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"20 RENDERERS"
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
