FROM ubuntu:latest

ENV UID=1000
ENV GID=1000
ENV USER="developer"

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update \
  && apt install --yes --no-install-recommends openjdk-17-jdk curl unzip sed git bash xz-utils libglvnd0 ssh xauth x11-xserver-utils libpulse0 libxcomposite1 libgl1-mesa-glx usbutils sudo \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN apt install --yes android-sdk


RUN groupadd --gid $GID $USER \
  && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
  && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER && chmod 775 -R /lib/android-sdk && sudo chown -R $USER /lib/android-sdk


USER $USER
WORKDIR /home/$USER

RUN mkdir -p /lib/android-sdk/cmdline-tools/ \
    && curl -o android_tools.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip \
    && unzip -qq -d /lib/android-sdk/cmdline-tools/ android_tools.zip \
    && mv /lib/android-sdk/cmdline-tools/cmdline-tools /lib/android-sdk/cmdline-tools/latest \
    && rm android_tools.zip \
    && sudo ln -s /lib/android-sdk/cmdline-tools/latest/bin/sdkmanager /usr/bin/sdkmanager \
    && yes "y" | sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.4-stable.tar.xz \
    && sudo tar xf flutter.tar.xz -C /usr/share/ \
    && rm flutter.tar.xz \
    && sudo ln -s /usr/share/flutter/bin/flutter /usr/bin/flutter

RUN flutter config --no-analytics \
    && flutter precache \
    && yes "y" | flutter doctor --android-licenses \
    && flutter config --no-enable-linux-desktop

ENV PATH="${PATH}:/usr/share/flutter/bin"

WORKDIR /project