#import "AppIconOptionsController.h"
#import <YouTubeHeader/YTAssetLoader.h>

@interface AppIconOptionsController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *appIcons;
@property (assign, nonatomic) NSInteger selectedIconIndex;

@end

@implementation AppIconOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Change App Icon";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"YTSans-Bold" size:22], NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.selectedIconIndex = -1;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSBundle *backIcon = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"]];
    UIImage *backImage = [UIImage imageNamed:@"Back.png" inBundle:backIcon compatibleWithTraitCollection:nil];
    backImage = [self resizeImage:backImage newSize:CGSizeMake(24, 24)];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backButton setImage:backImage forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setFrame:CGRectMake(0, 0, 24, 24)];
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = customBackButton;

    UIColor *buttonColor = [UIColor colorWithRed:203.0/255.0 green:22.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIImage *resetImage = [UIImage systemImageNamed:@"arrow.clockwise.circle.fill"];
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithImage:resetImage style:UIBarButtonItemStylePlain target:self action:@selector(resetIcon)];
    resetButton.tintColor = buttonColor;
    
    UIImage *saveImage = [UIImage systemImageNamed:@"square.and.arrow.up.fill"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithImage:saveImage style:UIBarButtonItemStylePlain target:self action:@selector(saveIcon)];
    saveButton.tintColor = buttonColor;

    self.navigationItem.rightBarButtonItems = @[saveButton, resetButton];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self.appIcons = [bundle pathsForResourcesOfType:@"png" inDirectory:@"AppIcons"];
    
    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appIcons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *iconPath = self.appIcons[indexPath.row];
    cell.textLabel.text = [iconPath.lastPathComponent stringByDeletingPathExtension];
    
    UIImage *iconImage = [UIImage imageWithContentsOfFile:iconPath];
    cell.imageView.image = iconImage;
    cell.imageView.layer.cornerRadius = 10.0;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.frame = CGRectMake(10, 10, 40, 40);
    cell.textLabel.frame = CGRectMake(60, 10, self.view.frame.size.width - 70, 40);
    
    if (indexPath.row == self.selectedIconIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIconIndex = indexPath.row;
    [self.tableView reloadData];
}

- (void)resetIcon {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [infoDict removeObjectForKey:@"ALTAppIcon"];
    [infoDict writeToFile:plistPath atomically:YES];

    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error resetting icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to reset icon"];
        } else {
            NSLog(@"Icon reset successfully");
            [self showAlertWithTitle:@"Success" message:@"Icon reset successfully"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)saveIcon {
    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *selectedIcon = self.selectedIconIndex >= 0 ? self.appIcons[self.selectedIconIndex] : nil;
        if (selectedIcon) {
            NSString *iconName = [selectedIcon.lastPathComponent stringByDeletingPathExtension];
           
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            [infoDict setObject:iconName forKey:@"ALTAppIcon"];
            [infoDict writeToFile:plistPath atomically:YES];
            
            [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error setting alternate icon: %@", error.localizedDescription);
                    [self showAlertWithTitle:@"Error" message:@"Failed to set alternate icon"];
                } else {
                    NSLog(@"Alternate icon set successfully");
                    [self showAlertWithTitle:@"Success" message:@"Alternate icon set successfully"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }];
        } else {
            NSLog(@"Selected icon path is nil");
        }
    });
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
