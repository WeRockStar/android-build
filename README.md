# Docker image for Android (Experiment!)

The image contains the `Android SDK`, `Fastlane`, `mobsfscan`(Static analysis tools), and more utilities tools.

### Here is example for Gitlab CI `(.gitlab-ci.yml)`
```yaml
image: werockstar/android-build:0.0.1-alpha03

before_script:
  - export GRADLE_USER_HOME=$(pwd)/.gradle

stages:      
  - lint
  - test
  - build
  - deploy-dev

linter-android:   
  stage: lint
  script:
    - ./gradlew detekt

unit-test:   
  stage: test    
  script:
    - ./gradlew test

build-android:
  stage: build
  script:
    # - ./gradlew androidApp:assDe
    - fastlane build

deploy-dev:    
  stage: deploy-dev
  environment: dev
  script:
    - fastlane beta
```
