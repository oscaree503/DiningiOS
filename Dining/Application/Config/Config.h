//
//  Config.m

// API REQUEST
//#define SERVER_URL @"http://172.16.1.24/train/back-end"
#define SERVER_URL @"http://thetrainapp.com"

#define API_KEY @"f1e3c46751ecd6e4cff77ffd948794cc"

#define API_URL (SERVER_URL @"/api")

#define API_URL_USER_SIGNUP (SERVER_URL @"/api/user_signup")
#define API_URL_USER_PROFILE_UPDATE (SERVER_URL @"/api/user_profile_update")
#define API_URL_USER_LOGOUT (SERVER_URL @"/api/user_logout")

#define API_URL_USER_LOGIN (SERVER_URL @"/api/user_login")
#define API_URL_USER_RETRIEVE_PASSWORD (SERVER_URL @"/api/user_retrieve_password")
#define API_URL_USER_CHANGE_PASSWORD (SERVER_URL @"/api/user_change_password")



#define API_URL_HOME (SERVER_URL @"/api/home")
#define API_URL_DISCOVER (SERVER_URL @"/api/discover")
#define API_URL_POST (SERVER_URL @"/api/post")
#define API_URL_REFERENCE_USER_DETAIL (SERVER_URL @"/api/reference_user_detail")
#define API_URL_ACTIVITIES (SERVER_URL @"/api/activities")
#define API_URL_ACTIVITY_DONE (SERVER_URL @"/api/activity_done")
#define API_URL_FOLLOW_USER (SERVER_URL @"/api/follow_user")
#define API_URL_LIKE_POST (SERVER_URL @"/api/like_post")
#define API_URL_COMMENT_POST (SERVER_URL @"/api/comment_post")
#define API_URL_SEARCH (SERVER_URL @"/api/search")
#define API_URL_REPORT (SERVER_URL @"/api/report")


//MapView

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

//Parse
#define parse_application_id @"sfS9ahQ7r52p1ysSDpgVY8bL7jBf3oHOf02P2GfD"
#define parse_client_key @"QFGFg68jzU7OrMIi1qj5pzPTspAv5qYSNWAH1qJr"


// MEDIA CONFIG
#define MEDIA_USER_SELF_DOMAIN_PREFIX @"tr_media_user_"
#define MEDIA_POST_SELF_DOMAIN_PREFIX @"tr_media_post_"
#define MEDIA_POST_THUMB_SELF_DOMAIN_PREFIX @"tr_media_post_thumb_"

#define MEDIA_URL (SERVER_URL @"/assets/media/")
#define MEDIA_URL_USERS (SERVER_URL @"/assets/media/users/")
#define MEDIA_URL_POSTS (SERVER_URL @"/assets/media/posts/")
#define MEDIA_URL_POST_THUMBS (SERVER_URL @"/assets/media/post_thumbs/")


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288

#define FONT_ALLER(s) [UIFont fontWithName:@"Aller" size:s]

// Default Config
#define TABLEVIEW_SCROLL_MARGIN_HEIGHT 60.0f
#define REPORT_MAX_LENGTH 255