Little Joy Software 
--------------------

Useful source code for MacOS and iOS projects.  This code requires
ARC.

Tested:

Xcode 4.3 4D1002
Lion 10.7.2
iOS 4.2 - 5.1

Regarding the MacOS libraries and ARC read this from apple:

**Can I develop applications for Mac OS X with ARC using Snow
  Leopard?**

*No. The Snow Leopard version of Xcode 4.2 doesn’t support ARC at all
on Mac OS X, because it doesn’t include the 10.7 SDK. Xcode 4.2 for
Snow Leopard does support ARC for iOS though, and Xcode 4.2 for Lion
supports both Mac OS X and iOS. This means you need a Lion system to
build an ARC application that runs on Snow Leopard.*

This means that you cannot use this code to develop MacOS applications
using Snow Leopard.

TO CLONE
--------------------
This repository contains submodules. 
To clone:

1. % git clone --recursive git@github.com:jmoody/LJS.git
2. % cd LJS
3. % git submodule update --recursive --init
4. % git submodule foreach git checkout master

License
--------------------

This software is under the 3-clause BSD License (AKA the new BSD
License or modified BSD License).

This license allows the software to be used in commercial and
noncommercial projects.

Although the license does not prohibit the use of this code in
miliarty or intelligence domains (CIA, FBI, all they tell us is lies),
I would appreciate it if you would not.

I worked for about 10 years under DARPA contracts and indirectly for
various intelligence agencies.  If you find youself in a similar
situation, know this: you can do better.


Documentation
--------------------

The most current documentation can be build by running the
Documentation target in the Test-MacOS and Test-iOS projects.

Branches of Interest
--------------------

**pre-arc-maintenance:**  pre-arc branch - no longer supported


Attributions
--------------------

This software relies or uses the following software (the associated
licenses can be found in the attributes file)

* SFHFKeychainUtils
* Appledoc
* Reporter
* CocoaLumberjack 
* OCMock
* GHUnit
* Apple Reachability
* json-framework
* UKKQueue
* CocoaHTTPServer

JSON-RPC
--------------------

* http://groups.google.com/group/json-rpc/web/json-rpc-2-0
* http://json-rpc.org/wiki/specification 

Other Links
--------------------

* [Join.me - a free browser-based screen sharing application](http://join.me "join.me")
* [Daring Fireball Markdown editor](http://daringfireball.net/projects/markdown/dingus "daringfireball")

Contact Information
--------------------

    Joshua Moody
    http://littlejoysoftware.com
    joshuajmoody@gmail.com
    UK 44 20 3286 1473
    US 802-659-0087
    Skype:    morethan50eggs
    iChat:    morethan50eggs@me.com
    FaceTime: joshuajmoody@gmail.com
