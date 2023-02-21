## 1.1.2+2
- Fix: Disabling duplicated route preffix when both controller and module has the same name
## 1.1.2+1
- Fix: QueryParam checking
## 1.1.2
- Added: Query params
## 1.1.1+2
- Added: Allowing modules' preffix to be null
## 1.1.1+1
- Added: Injectable to App Module
## 1.1.1
- Added: InjectionManager's replace function
## 1.1.0+1
- Fixed: Modules' init function type

## 1.1.0
- Added: dynamic body parsing
- Added: url variables getters
- Added: Modules' init method
- Chore: Improved automatic server error handling

## 1.0.4+1

- Doc: Deploy and build info

## 1.0.4

- Fixed: Modules allowing preffix to start with '/'
- Doc: Providing dart documentation to public exported classes

## 1.0.3

- Fixed: Adding const keyword to HttpVerbs annotations

## 1.0.2

- Fixed: Custom Object inside Maps responses were not being parsed

## 1.0.1

- Fixed: Global middlewares were not being applied to AppModule's routes
- Fixed: Http response could receive a non-int value. Now it is parsed if needed

## 1.0.0

- Initial version.
