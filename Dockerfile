FROM ubuntu:23.04

LABEL maintainer="werockstar"

ARG JDK_VERSION=17

ENV COMMAND_TOOLS "9477386"
ENV ANDROID_SDK_ROOT "/android-sdk"
ENV ANDROID_HOME "${ANDROID_SDK_ROOT}"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN apt-get --quiet update --yes && apt-get --quiet install --yes -qqy --no-install-recommends bzip2 locales openjdk-${JDK_VERSION}-jdk curl unzip git-core make ruby-full build-essential
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_TOOLS}_latest.zip > /cmdline-tools.zip \
 && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
 && unzip /cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
 && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
 && rm -v /cmdline-tools.zip

RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses >/dev/null
RUN ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --update

ADD packages.txt /sdk
RUN ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --package_file=/sdk/packages.txt

RUN gem install bundler
RUN gem install fastlane