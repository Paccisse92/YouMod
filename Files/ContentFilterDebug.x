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

            for (id item in contents) {

                if (![item respondsToSelector:@selector(elementRenderer)])
                    continue;

                id renderer = [item valueForKey:@"elementRenderer"];

                [result appendFormat:
                    @"CLASS:\n%@\n\n",
                    NSStringFromClass([renderer class])];

                NSString *desc = [renderer description];

                if (desc.length > 400)
                    desc = [desc substringToIndex:400];

                [result appendFormat:
                    @"%@\n\n=================\n\n",
                    desc];

                didShow = YES;
                break;
            }

            if (didShow)
                break;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{

            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            UIViewController *vc = window.rootViewController;

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"ELEMENT DEBUG"
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
