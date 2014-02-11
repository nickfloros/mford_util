### Utilities for building polymer apps.

Definition of UI polymer componenents that incorporate
- Google Maps
- Google Charts
- Bootstrap based components for modal control, navigation bar & tabs ; why not have another implementation

Weather app 
- Weather information models
- Integration with Google AppEngine Endpoints to retrieve weather station site details, and readings (server sidehttps://github.com/nickfloros/mford-gae)

Deployment of the contents of the build directory follows simple step
- Run 'Build Polymer App' step
- Copy contnets of the build directory to `<appengineProject>/src/main/java/webapp`
- Change to `<appengineProject>` and run `mvn appengine:update`   