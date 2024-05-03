# uwo_athlete_surveyor

Provides means for intercollegiate faculty to better keep in touch with the strain on students, with a future plans to allow for analytics

# Contents
- [Code Standards](#code-standards)
- [Project Structure](#project-structure)
- [Navigation](#navigation)

# Code Standards 

## Commit Message Guidelines (ft Angular)

### Type

Must be one of the following:

    build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
    ci: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
    docs: Documentation only changes
    feat: A new feature
    fix: A bug fix
    perf: A code change that improves performance
    refactor: A code change that neither fixes a bug nor adds a feature
    style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
    test: Adding missing tests or correcting existing test
### Revert

If the commit reverts a previous commit, it should begin with revert: , followed by the header of the reverted commit. In the body it should say: This reverts commit \<hash\>, where the hash is the SHA of the commit being reverted.

## Responsibilities
When in doubt... use SOLID principles / rely on the following<br>
Credit to [VerygoodVentures](https://verygood.ventures/blog/very-good-flutter-architecture) 
- **Data layer**: This layer interacts directly with an API (REST API or a device API).
- **Domain layer**: This layer transforms or manipulates the data that the API provides.
- **Presentation layer**: This layer presents the app content and triggers events that modify the application state

# Project Structure
`assets` - contains non-code entities, like images or videos<br>
`widgets` - holds widget structure info, does NOT store theme!<br>
`views` - holds "pages" which use widgets to **present** to the user<br>
`test` - stores tests that enforce business logic constraints<br>
`services` - non-renderable func. such as interacting with an API

## Navigation
> NOTE: This is the first leg of the developmental milestone we're embarking on.  Changes will be frequent, and may be jarring at times.

Initially, we'll be drafting mockup screens with dummy data, and in order to keep up with individual developers' academic obligations, we'll opt for either a `TabBarView` or (less likely) a `Navigator` to jump between these early-stage prototypes.

In *future phases*, a `Navigator` or something more robust may be worthwhile since data flow between pages will play a key role in the desired functionality.
