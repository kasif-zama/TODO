# Flutter (https://flutter.io) Developement Environment for Linux
# ===============================================================
#
# This environment passes all Linux Flutter Doctor checks and is sufficient
# for building Android applications and running Flutter tests.
#
# To build iOS applications, a Mac development environment is necessary.
#
# This includes applications and sdks that are needed only by the CI system
# for performing pushes to production, and so this image is quite a bit larger
# than strictly needed for just building Flutter apps.

FROM debian:stretch

#RUN apt-get update -y
RUN apt-get upgrade -y
#RUN apt-get install expect -y 
RUN apt-get update -y
# Install basics
RUN apt-get install -y --no-install-recommends \
  coreutils \
  git \
  wget \
  curl \
  unzip \
  ca-certificates \
  gnupg \
  dirmngr \
  expect \
  procps

# Add nodejs repository to apt sources and install it.
ENV NODEJS_INSTALL="/opt/nodejs_install"
RUN mkdir -p "${NODEJS_INSTALL}"
RUN wget -q https://deb.nodesource.com/setup_10.x -O "${NODEJS_INSTALL}/nodejs_install.sh"
RUN bash "${NODEJS_INSTALL}/nodejs_install.sh"

# Install the rest of the dependencies.
RUN apt-get install -y --no-install-recommends \
  locales \
  python \
  python-pip \
  python-setuptools \
  ruby-full \
  nodejs \
  lib32stdc++6 \
  libstdc++6 \
  libglu1-mesa \
  build-essential \
  default-jdk-headless

RUN pip install wheel
#RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
#RUN curl -sSL https://get.rvm.io | bash -s stable
#ENV PATH="/usr/local/rvm/bin:${PATH}"
#RUN usermod -a -G rvm root
#RUN rvm install 2.4.3

# Install the Android SDK Dependency.
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_TOOLS_ROOT="/opt/android_sdk"
RUN mkdir -p "${ANDROID_TOOLS_ROOT}"
RUN mkdir -p ~/.android
# Silence warning.
RUN touch ~/.android/repositories.cfg
ENV ANDROID_SDK_ARCHIVE="${ANDROID_TOOLS_ROOT}/archive"
RUN wget --progress=dot:giga "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_TOOLS_ROOT}" "${ANDROID_SDK_ARCHIVE}"
# Suppressing output of sdkmanager to keep log size down
# (it prints install progress WAY too often).
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "tools" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "build-tools;28.0.3" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "platforms;android-28" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "platform-tools" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "extras;android;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "extras;google;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "patcher;v4" > /dev/null
RUN rm "${ANDROID_SDK_ARCHIVE}"
ENV PATH="${ANDROID_TOOLS_ROOT}/tools/bin:${ANDROID_TOOLS_ROOT}/tools:${PATH}"
# Silence warnings when accepting android licenses.
RUN mkdir -p ~/.android
RUN touch ~/.android/repositories.cfg

# Setup gradle
ENV GRADLE_ROOT="/opt/gradle"
RUN mkdir -p "${GRADLE_ROOT}"
ENV GRADLE_ARCHIVE="${GRADLE_ROOT}/gradle.zip"
ENV GRADLE_URL="http://services.gradle.org/distributions/gradle-4.4-bin.zip"
RUN wget --progress=dot:giga "$GRADLE_URL" -O "${GRADLE_ARCHIVE}"
RUN unzip -q -d "${GRADLE_ROOT}" "${GRADLE_ARCHIVE}"
ENV PATH="$GRADLE_ROOT/bin:$PATH"

# Add npm to path.
ENV PATH="/usr/bin:${PATH}"
RUN dpkg-query -L nodejs
# Install Firebase tools.
RUN npm install --global firebase-tools@4.0.3

# Set locale to en_US.UTF-8
RUN dpkg-reconfigure locales
RUN locale-gen "en_US" "en_US.UTF-8" "C.UTF-8" && /usr/sbin/update-locale LANG="C.UTF-8"
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LC_ALL="C.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

# Install the bundler so we can install Ruby bundles.
#RUN gem install bundler

# Installing Ruby bundles.
#ENV BUNDLE_ROOT="/opt/bundler"
#ENV BUNDLE_GEMFILE="$BUNDLE_ROOT/Gemfile"
#RUN mkdir --parents "$BUNDLE_ROOT"
#ADD Gemfile "$BUNDLE_GEMFILE"
#ADD Gemfile.lock "$BUNDLE_GEMFILE.lock"
#RUN (cd "$BUNDLE_ROOT" && bundle install --system)

# Download Google OAuth Tool
#RUN pip install --user google-oauth2l --upgrade

# Set the pub cache so it's not in the home directory for root.
ENV PUB_CACHE="/opt/pub-cache"
ENV FLUTTER_ROOT="/opt/flutter"
RUN git clone -b stable https://github.com/flutter/flutter/ "${FLUTTER_ROOT}"
ENV PATH="$FLUTTER_ROOT/bin/cache/dart-sdk/bin:$FLUTTER_ROOT/bin:${PATH}"
ENV ANDROID_HOME="${ANDROID_TOOLS_ROOT}"

# Perform an artifact precache so that no extra assets need to be downloaded on demand.
RUN flutter precache

# Accept licenses.
RUN yes "y" | flutter doctor --android-licenses

# Change the flutter working directory to stable branch.
RUN flutter channel dev

# Perform a doctor run.
RUN flutter doctor -v

# Perform a flutter upgrade
RUN flutter upgrade

#ENTRYPOINT [ "flutter" ]
