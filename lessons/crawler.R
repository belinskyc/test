rm(list=ls());                         # clear Environment tab
options(show.error.locations = TRUE);  # show line numbers on error

fileList = list.files("lessons", pattern="*.qmd");
fileText = c();
fileMatches = c();

# read in each file
for(i in 1:length(fileList))
{
  # this automatically changes spaces to %20
  fileText[i] = read.delim(paste("lessons/", fileList[i], sep=""), header = FALSE);
  temp = regmatches(fileText[[i]], gregexpr("/.*\\.(png|jpg|PNG|JPG)", fileText[[i]]))
  fileMatches = append(fileMatches, unlist(temp));
}

# get all files in images folder (but not directory names)
#   this will maintain spaces and %20
imageList = list.files("lessons/images", pattern = "\\.");

# add \ to name to match (awkward -- will change later)
imageList = paste("/", imageList, sep="");

# replace space with %20
# imageList = gsub(" ", "%20", imageList);

# make all lowercase
imageList = tolower(imageList);
fileMatches = tolower(fileMatches);

imagesUnused = c();

for(i in 1:length(imageList))
{ 
  # cover both spaces and %20
  spaceInName = gsub(" ", "%20", imageList[i]);
  
  if(!(imageList[i] %in% fileMatches |
       spaceInName %in% fileMatches))
  {
    imagesUnused[length(imagesUnused)+1] = imageList[i];
  }
}

# remove / from name (yep, awkward...)
imagesUnused = gsub("/", "", imagesUnused);

print(imagesUnused)


if(dir.exists("lessons/images/unused") == FALSE)
  dir.create("lessons/images/unused");

if(length(imagesUnused) > 0)
  for(i in 1:length(imagesUnused))
  {
    file.rename(from= paste(getwd(), "/lessons/images/", imagesUnused[i], sep=""),
                to = paste(getwd(), "/lessons/images/unused/", imagesUnused[i], sep=""))
  }

## still does not handle spaces/%20 well