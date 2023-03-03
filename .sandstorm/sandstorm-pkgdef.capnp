@0xaecd42915acc793f;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "aax9j672p6z8n7nyupzvj2nmumeqd4upa0f7mgu8gprwmy53x04h",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "WordPress"),

    appVersion = 19,  # Increment this for every release.

    appMarketingVersion = (defaultText = "v2023.03.02 (4.9.8)"),
    # Human-readable representation of appVersion. Should match the way you
    # identify versions of your app in documentation and marketing.

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New site"),
        nounPhrase = (defaultText = "site"),
        command = .startCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .continueCommand,
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.

    metadata = (
      icons = (
        appGrid = (svg = embed "app-graphics/wordpress-128.svg"),
        grain = (svg = embed "app-graphics/wordpress-24.svg"),
        market = (svg = embed "app-graphics/wordpress-150.svg"),
        #marketBig = (svg = embed "path/to/market-big-300x300.svg"),
      ),

      website = "https://wordpress.org/",

      codeUrl = "https://github.com/sandstormports/wordpress-sandstorm",

      license = (openSource = gpl2),

      categories = [webPublishing,],

      author = (

        contactEmail = "inbox@jacobweisz.com",

        pgpSignature = embed "pgp-signature",

        upstreamAuthor = "WordPress Project",
      ),

      pgpKeyring = embed "pgp-keyring",

      description = (defaultText = embed "description.md"),
      # The app's description in Github-flavored Markdown format, to be displayed e.g.
      # in an app store. Note that the Markdown is not permitted to contain HTML nor image tags (but
      # you can include a list of screenshots separately).

      shortDescription = (defaultText = "Content management"),
      # A very short (one-to-three words) description of what the app does. For example,
      # "Document editor", or "Notetaking", or "Email client". This will be displayed under the app
      # title in the grid view in the app market.

      screenshots = [
        # Screenshots to use for marketing purposes.  Examples below.
        # Sizes are given in device-independent pixels, so if you took these
        # screenshots on a Retina-style high DPI screen, divide each dimension by two.
        (width = 1166, height = 675, png = embed "app-graphics/wordpress_example_01.png"),
        (width = 1166, height = 675, png = embed "app-graphics/wordpress_example_02.png"),
        (width = 1166, height = 675, png = embed "app-graphics/wordpress_example_03.png"),
        (width = 1166, height = 675, png = embed "app-graphics/wordpress_example_04.png")
      ],
      changeLog = (defaultText = embed "changeLog.md"),
      # Documents the history of changes in Github-flavored markdown format (with the same restrictions
      # as govern `description`). We recommend formatting this with an H1 heading for each version
      # followed by a bullet list of changes.
    ),
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/opt/app" ),
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf" ]
        # You probably don't want the app pulling files from these places,
        # so we hide them. Note that /dev, /var, and /tmp are implicitly
        # hidden because Sandstorm itself provides them.
      )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = ["wordpress-read-only", "read-only-plugins"],
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.

bridgeConfig = (
  # Used for integrating permissions and roles into the Sandstorm shell
  # and for sandstorm-http-bridge to pass to your app.
  # Uncomment this block and adjust the permissions and roles to make
  # sense for your app.
  # For more information, see high-level documentation at
  # https://docs.sandstorm.io/en/latest/developing/auth/
  # and advanced details in the "BridgeConfig" section of
  # https://github.com/sandstorm-io/sandstorm/blob/master/src/sandstorm/package.capnp
  viewInfo = (
    # For details on the viewInfo field, consult "ViewInfo" in
    # https://github.com/sandstorm-io/sandstorm/blob/master/src/sandstorm/grain.capnp

   permissions = [
   # Permissions which a user may or may not possess.  A user's current
   # permissions are passed to the app as a comma-separated list of `name`
   # fields in the X-Sandstorm-Permissions header with each request.
   #
   # IMPORTANT: only ever append to this list!  Reordering or removing fields
   # will change behavior and permissions for existing grains!  To deprecate a
   # permission, or for more information, see "PermissionDef" in
   # https://github.com/sandstorm-io/sandstorm/blob/master/src/sandstorm/grain.capnp
     (
       name = "admin",
       # Name of the permission, used as an identifier for the permission in cases where string
       # names are preferred.  Used in sandstorm-http-bridge's X-Sandstorm-Permissions HTTP header.

       title = (defaultText = "admin"),
       # Display name of the permission, e.g. to display in a checklist of permissions
       # that may be assigned when sharing.

       description = (defaultText = "allows administrative actions"),
       # Prose describing what this role means, suitable for a tool tip or similar help text.
     ),
     (
       name = "editor",
       # Name of the permission, used as an identifier for the permission in cases where string
       # names are preferred.  Used in sandstorm-http-bridge's X-Sandstorm-Permissions HTTP header.

       title = (defaultText = "editor"),
       # Display name of the permission, e.g. to display in a checklist of permissions
       # that may be assigned when sharing.

       description = (defaultText = "allows publishing of posts of others"),
       # Prose describing what this role means, suitable for a tool tip or similar help text.
     ),
     (
       name = "author",
       # Name of the permission, used as an identifier for the permission in cases where string
       # names are preferred.  Used in sandstorm-http-bridge's X-Sandstorm-Permissions HTTP header.

       title = (defaultText = "author"),
       # Display name of the permission, e.g. to display in a checklist of permissions
       # that may be assigned when sharing.

       description = (defaultText = "allows publishing of own posts"),
       # Prose describing what this role means, suitable for a tool tip or similar help text.
     ),
     (
       name = "contributor",
       # Name of the permission, used as an identifier for the permission in cases where string
       # names are preferred.  Used in sandstorm-http-bridge's X-Sandstorm-Permissions HTTP header.

       title = (defaultText = "contributor"),
       # Display name of the permission, e.g. to display in a checklist of permissions
       # that may be assigned when sharing.

       description = (defaultText = "allows writing of posts"),
       # Prose describing what this role means, suitable for a tool tip or similar help text.
     ),
     (
       name = "subscriber",
       # Name of the permission, used as an identifier for the permission in cases where string
       # names are preferred.  Used in sandstorm-http-bridge's X-Sandstorm-Permissions HTTP header.

       title = (defaultText = "subscriber"),
       # Display name of the permission, e.g. to display in a checklist of permissions
       # that may be assigned when sharing.

       description = (defaultText = "allows profile customization"),
       # Prose describing what this role means, suitable for a tool tip or similar help text.
     ),
   ],
   roles = [
     # Roles are logical collections of permissions.  For instance, your app may have
     # a "viewer" role and an "editor" role
     (
       title = (defaultText = "admin"),
       # Name of the role.  Shown in the Sandstorm UI to indicate which users have which roles.

        permissions  = [true, true, true, true, true],
        # An array indicating which permissions this role carries.
        # It should be the same length as the permissions array in
        # viewInfo, and the order of the lists must match.

        verbPhrase = (defaultText = "can do anything"),
        # Brief explanatory text to show in the sharing UI indicating
        # what a user assigned this role will be able to do with the grain.

        description = (defaultText = "admins can do anything."),
        # Prose describing what this role means, suitable for a tool tip or similar help text.
      ),
      (
        title = (defaultText = "editor"),
        permissions  = [false, true, true, true, true],
        verbPhrase = (defaultText = "can publish posts of others"),
        description = (defaultText = "editors can publish posts of others."),
      ),
      (
        title = (defaultText = "author"),
        permissions  = [false, false, true, true, true],
        verbPhrase = (defaultText = "can publish own posts"),
        description = (defaultText = "authors can publish own posts."),
      ),
      (
        title = (defaultText = "contributor"),
        permissions  = [false, false, false, true, true],
        verbPhrase = (defaultText = "can write posts"),
        description = (defaultText = "contributors can write posts."),
        default = true,
      ),
      (
        title = (defaultText = "subscriber"),
        permissions  = [false, false, false, false, true],
        verbPhrase = (defaultText = "can customize profile"),
        description = (defaultText = "subscribers can customize profile."),
      ),
    ],
  ),
  #apiPath = "/api",
  # Apps can export an API to the world.  The API is to be used primarily by Javascript
  # code and native apps, so it can't serve out regular HTML to browsers.  If a request
  # comes in to your app's API, sandstorm-http-bridge will prefix the request's path with
  # this string, if specified.
),
);

const startCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "10000", "--", "/start.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "SANDSTORM", value = "1"),
    # Export SANDSTORM=1 into the environment, so that apps running within Sandstorm
    # can detect if $SANDSTORM="1" at runtime, switching UI and/or backend to use
    # the app's Sandstorm-specific integration code.
    (key = "POWERBOX_WEBSOCKET_PORT", value = "3000"),
    (key = "POWERBOX_PROXY_PORT", value = "4000"),
  ]
);

const continueCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "10000", "--", "/continue.sh"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "SANDSTORM", value = "1"),
    # Export SANDSTORM=1 into the environment, so that apps running within Sandstorm
    # can detect if $SANDSTORM="1" at runtime, switching UI and/or backend to use
    # the app's Sandstorm-specific integration code.
    (key = "POWERBOX_WEBSOCKET_PORT", value = "3000"),
    (key = "POWERBOX_PROXY_PORT", value = "4000"),
  ]
);
