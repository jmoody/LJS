README

FILES

* appledoc - appledoc 2.0 executable 
* xcode-build-phase-doc-script.sh - a script to generate appledocs
* templates - the default appledoc templates

INSTALLING (OPTIONAL)

To install appledocs on your system:

* download the sources from git hub
  https://github.com/tomaz/appledoc
  and follow the instructions found there
  
  
INCLUDING APPLEDOC DOCUMENTATION IN YOUR XCODE PROJECT

1. Add the Documentation directory to your Project
  * right click on your project in the Xcode 4 Project Navigation
    pane and select 'Add Files'
  
  * IMPORTANT Select copy item into destination group's folder
  
  * IMPORTANT Deselect all targets (i.e. don't add to any target)

2. Create a Run Script Build Phase
  * In the Project Navigator (cmd + 1) select the project to
    open the Build Settings editor

  * select the Target that you want to build documentation for

  * select the Build Phases tab

  * in the lower right corner, use the button to add a Run Script
    build phase

  * copy and paste the contents of the 
    xcode-build-phase-doc-script.sh
    to the script area

  * read the comments in the script to configure it for your project





  

