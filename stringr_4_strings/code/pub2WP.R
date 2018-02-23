# SET IT UP
library(RWordPress)
library(knitr)

# Set this first so that your credentials are logged with Wordpress (replace USERNAME and PASSWORD with actual values)
options(WordpressLogin = c(USERNAME = 'PASSWORD'), WordpressURL = "http://storybench.org/xmlrpc.php")

# PUBLISH A POST

# Upload featured image
postThumbnail <- RWordPress::uploadFile("images/your_featured_image_here.jpg", overwrite = TRUE)

# Post with featured image (replace filename and title)
knit2wp('Your_RMD_Here.Rmd', title = 'Your Title Here', publish = TRUE, upload = TRUE,
        wp_post_thumbnail = postThumbnail$id)


# UPDATE A POST

# Find post id in Dashboard (replace 1234 with actual post ID)
postID <- 1234

# Get the post
post <- getPost(postid = postID, login = getOption("WordpressLogin", stop("need a login and password")))

# Edit the post (keep category,tags and title as before)
knit2wp('Your_RMD_Here.Rmd',
        postid = postID,
        action = c("editPost"),
        title = post$title,
        categories = post$categories,
        mt_keywords = post$mt_keywords,
        wp_post_thumbnail = post$wp_post_thumbnail,
        publish = TRUE)
