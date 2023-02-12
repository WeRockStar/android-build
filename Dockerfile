FROM ubuntu:23.04

LABEL maintainer="werockstar"

ARG JDK_VERSION=17

ENV COMMAND_TOOLS "9477386"
ENV ANDROID_SDK_ROOT "/android-sdk"
ENV ANDROID_HOME "${ANDROID_SDK_ROOT}"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN apt-get --quiet update --yes && apt-get --quiet install --yes -qqy --no-install-recommends bzip2 locales openjdk-${JDK_VERSION}-jdk curl unzip git-core make ruby-full build-essential python3-pip
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_TOOLS}_latest.zip > /cmdline-tools.zip \
 && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
 && unzip /cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
 && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
 && rm -v /cmdline-tools.zip

RUN mkdir -p $ANDROID_SDK_ROOT/licenses/ \
 && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_SDK_ROOT/licenses/android-sdk-license \
 && echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_SDK_ROOT/licenses/android-sdk-preview-license \
 && yes | sdkmanager --licenses >/dev/null
RUN sdkmanager --update

ADD packages.txt /android-sdk
RUN sdkmanager --package_file=/android-sdk/packages.txt

RUN gem install bundler
RUN gem install fastlane
RUN pip3 install --upgrade mobsfscan