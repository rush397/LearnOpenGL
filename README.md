# LearnOpenGL

1. 下载 GLFW 源码：http://www.glfw.org/
2. 安装 CMake：http://www.cmake.org/

采用 dmg 的方式安装，需要安装完成后配置环境变量

```
export CMAKE_ROOT=/Applications/CMake.app/Contents/bin/
export PATH=$CMAKE_ROOT:$PATH
```

3. 进入 GLFW 的源码目录

```
cd xxx/glfw-3.2.1
cmake .
make install
```

如果编译成功，会出现以下提示信息：

```
Install the project...
-- Install configuration: ""
-- Installing: /usr/local/include/GLFW
-- Installing: /usr/local/include/GLFW/glfw3.h
-- Installing: /usr/local/include/GLFW/glfw3native.h
-- Installing: /usr/local/lib/cmake/glfw3/glfw3Config.cmake
-- Installing: /usr/local/lib/cmake/glfw3/glfw3ConfigVersion.cmake
-- Installing: /usr/local/lib/cmake/glfw3/glfw3Targets.cmake
-- Installing: /usr/local/lib/cmake/glfw3/glfw3Targets-noconfig.cmake
-- Installing: /usr/local/lib/pkgconfig/glfw3.pc
-- Installing: /usr/local/lib/libglfw3.a
```

4. 配置到 Xcode 项目

```
Xcode -> Build Setting
a. Other Linker Flags 添加 -lGLFW3
b. Always Search User Paths 设置为 YES
c. Header Search Path 添加 /usr/local/include、$(PROJECT_DIR)/LearnOpenGL/glad
d. Library Search Path 添加 /usr/local/lib
```

Xcode -> Build Phases -> Link Binary With Libraries 添加

```
a. libglfw3.a
b. Cocoa Framework
c. OpenGL Framework
d. IOKit Framework
e. CoreVideo Framework
```

5. GLAD

打开GLAD的在线服务，将语言(Language)设置为C/C++，在API选项中，选择3.3以上的OpenGL(gl)版本（我们的教程中将使用3.3版本，但更新的版本也能正常工作）。之后将模式(Profile)设置为Core。都选择完之后，点击生成(Generate)按钮来生成库文件。

GLAD现在应该提供给你了一个zip压缩文件，包含两个头文件目录，和一个glad.c文件。将两个头文件目录（glad和KHR）复制到你的Include文件夹中（或者增加一个额外的项目指向这些目录），并添加glad.c文件到你的工程中。

将 GLAD 以如下结构添加到工程中，和 main.m 同级
```
    -- glad
        -- glad/glad.c
        -- KHR/khrplatform.h
        -- src/glad.c
```

然后在 Build Setting 的 Header Search Path 添加 $(PROJECT_DIR)/LearnOpenGL/glad

在 main.m 中添加 #include <glad/glad.h>，如果编译成功，就没有问题了。

ref: http://blog.csdn.net/u012733215/article/details/44751111
