//
//  AlbumMenu.h
//  VocabularyTrip
//
//  Created by Ariel on 11/6/13.
//
//

#import <UIKit/UIKit.h>

@interface AlbumMenu : UIViewController {
	UIImageView *__unsafe_unretained backgroundView;
	UIButton *__unsafe_unretained backButton;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *backButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *backgroundView;

- (IBAction) done:(id)sender;
- (IBAction) album1ShowInfo:(id)sender;
- (IBAction) album2ShowInfo:(id)sender;
- (IBAction) album3ShowInfo:(id)sender;

@end






