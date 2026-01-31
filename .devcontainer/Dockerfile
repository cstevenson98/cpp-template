# Use Ubuntu 24.04 as base for latest packages
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    ninja-build \
    git \
    wget \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    gdb \
    valgrind \
    ccache \
    doxygen \
    graphviz \
    vim \
    nano \
    zip \
    unzip \
    sudo \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Add LLVM repository for latest Clang (using proper gpg key handling)
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc && \
    echo "deb http://apt.llvm.org/noble/ llvm-toolchain-noble main" | tee /etc/apt/sources.list.d/llvm.list

# Dynamically find and install the latest Clang version
RUN apt-get update && \
    LATEST_CLANG=$(apt-cache search --names-only '^clang-[0-9]+$' | grep -oP 'clang-\K[0-9]+' | sort -n | tail -1) && \
    echo "Installing Clang version: ${LATEST_CLANG}" && \
    apt-get install -y \
    clang-${LATEST_CLANG} \
    clangd-${LATEST_CLANG} \
    clang-tidy-${LATEST_CLANG} \
    clang-format-${LATEST_CLANG} \
    libc++-${LATEST_CLANG}-dev \
    libc++abi-${LATEST_CLANG}-dev \
    lldb-${LATEST_CLANG} \
    lld-${LATEST_CLANG} \
    && rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LATEST_CLANG} 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LATEST_CLANG} 100 && \
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LATEST_CLANG} 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LATEST_CLANG} 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${LATEST_CLANG} 100 && \
    update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-${LATEST_CLANG} 100 && \
    update-alternatives --install /usr/bin/clang-scan-deps clang-scan-deps /usr/bin/clang-scan-deps-${LATEST_CLANG} 100

# Install CMake 4.x from Kitware repository
RUN wget -qO- https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user (reuse ubuntu user if UID/GID 1000 exists)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if id -u $USER_UID >/dev/null 2>&1; then \
    # User with this UID exists (ubuntu in Ubuntu 24.04), rename it
    existing_user=$(id -un $USER_UID) && \
    existing_group=$(id -gn $USER_UID) && \
    groupmod -n $USERNAME $existing_group && \
    usermod -l $USERNAME -d /home/$USERNAME -m -s /bin/zsh $existing_user; \
    else \
    # Create new user
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME; \
    fi && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Set up ccache directory
RUN mkdir -p /home/$USERNAME/.ccache && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME

# Set environment variables for C++23
# Use the update-alternatives symlinks so it always points to latest
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
ENV CXXFLAGS="-stdlib=libc++"
ENV LDFLAGS="-stdlib=libc++ -lc++abi"

# Add version info to zshrc
RUN echo 'echo "=== C++23 Development Environment ===" && \' >> /home/$USERNAME/.zshrc && \
    echo 'echo "Clang: $(clang++ --version 2>/dev/null | head -n1 || echo \"Not found\")" && \' >> /home/$USERNAME/.zshrc && \
    echo 'echo "CMake: $(cmake --version 2>/dev/null | head -n1 || echo \"Not found\")" && \' >> /home/$USERNAME/.zshrc && \
    echo 'echo "clang-tidy: $(clang-tidy --version 2>/dev/null | head -n1 || echo \"Not found\")" && \' >> /home/$USERNAME/.zshrc && \
    echo 'echo "====================================="' >> /home/$USERNAME/.zshrc

# Switch to non-root user
USER $USERNAME
WORKDIR /workspace

CMD ["/bin/zsh"]

