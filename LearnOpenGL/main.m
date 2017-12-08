//
//  main.m
//  LearnOpenGL
//
//  Created by lida on 2017/12/7.
//  Copyright © 2017年 rush. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

/*
 1. 下载 GLFW 源码：http://www.glfw.org/
 2. 安装 CMake：http://www.cmake.org/
 
 采用 dmg 的方式安装，需要安装完成后配置环境变量
    export CMAKE_ROOT=/Applications/CMake.app/Contents/bin/
    export PATH=$CMAKE_ROOT:$PATH
 
 3. 进入 GLFW 的源码目录
    cd xxx/glfw-3.2.1
    cmake .
    make install
 
 如果编译成功，会出现以下提示信息：
 
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
 
 4. 配置到 Xcode 项目
 
 Xcode -> Build Setting
    a. Other Linker Flags 添加 -lGLFW3
    b. Always Search User Paths 设置为 YES
    c. Header Search Path 添加 /usr/local/include
    d. Library Search Path 添加 /usr/local/lib
 
 Xcode -> Build Phases -> Link Binary With Libraries 添加
    a. libglfw3.a
    b. Cocoa Framework
    c. OpenGL Framework
    d. IOKit Framework
    e. CoreVideo Framework
 
 5. GLAD
 
 打开GLAD的在线服务，将语言(Language)设置为C/C++，在API选项中，选择3.3以上的OpenGL(gl)版本（我们的教程中将使用3.3版本，但更新的版本也能正常工作）。之后将模式(Profile)设置为Core。都选择完之后，点击生成(Generate)按钮来生成库文件。
 
 GLAD现在应该提供给你了一个zip压缩文件，包含两个头文件目录，和一个glad.c文件。将两个头文件目录（glad和KHR）复制到你的Include文件夹中（或者增加一个额外的项目指向这些目录），并添加glad.c文件到你的工程中。
 
 把 glad.h 拷贝到 /usr/local/include/glad 下
 把 khrplatform.h 拷贝到 /usr/local/include/KHR 下
 把 glad.c 添加到 Xcode 工程中
 
 在 main.m 中添加 #include <glad/glad.h>，如果编译成功，就没有问题了。
 
 ref: http://blog.csdn.net/u012733215/article/details/44751111
 */

void framebuffer_size_callback(GLFWwindow *window, int width, int height) {
    glViewport(0, 0, width, height);
}

void processInput(GLFWwindow *window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}

void createVertex(void) {
    // 以标准化坐标的形式定义顶点数组 VAO
    float vertices[] = {
        -0.5f, -0.5f, 0.0f,
        0.0f, 0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    
    // VBO 对象的 ID
    unsigned int VBO;
    // 生成 VBO 对象
    glGenBuffers(1, &VBO);
    // 绑定缓冲类型，然后就可以在 GL_ARRAY_BUFFER 相关的缓冲调用中用来配置 VBO
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    /*
     * 把顶点数据拷贝到 GL_ARRAY_BUFFER 绑定到缓冲对象上
     * 第四个参数指定了我们希望显卡如何管理给定的数据
     *  - GL_STATIC_DRAW 数据不会或几乎不会改变
     *  - GL_DYNAMIC_DRAW 数据会被改变很多
     *  - GL_STREAM_DRAW 数据每次绘制时都会改变
     * TODO: 举例说明？
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    /*
     * index : 顶点属性的位置
     * size : 顶点属性的大小，顶点属性是 vec3，由3个值组成，所以是3
     * type : 顶点数据类型
     * normalize : 是否希望数据被标准化
     * stride : 步长，顶点属性之间的间隔
     * pointer :
     */
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
}

unsigned int compileVertexShader(void) {
    /*
     * version 330 : GLSL 版本号需要喝 OpenGL 版本号匹配
     * core : 使用核心模式
     * layout :
     * location = 0 :
     * in : 声明所有的输入顶点属性
     * aPos :
     * gl_Position : 顶点着色器的输出 vec4 类型
     * vec4 : w 分量设为 1.0，为什么？
     */
    const GLchar *vertexShaderSource =
    "\
    #version 330 core\
    layout (location = 0) in vec3 aPos;\
    \
    void main() {\
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\
    }\
    ";
    
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    // 把着色器源码附加到着色器对象上
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    // 检测编译是否有错误
    int success;
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetShaderInfoLog(vertexShader, sizeof(infoLog), NULL, infoLog);
        printf("ERROR::SHADER::VERTEX::COMPILATION_FAILED %s\n", infoLog);
    }
    
    return vertexShader;
}

unsigned int compileFragmentShader(void) {
    /*
     * version 330 : GLSL 版本号需要喝 OpenGL 版本号匹配
     * core : 使用核心模式
     * out :
     * FragColor = 0 :
     */
    const GLchar *fragmentShaderSource =
    "\
    #version 330 core\
    out vec4 FragColor;\
    \
    void main() {\
        FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0);\
    }\
    ";
    
    // 编译片段着色器
    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    // 检测编译是否有错误
    int success;
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetShaderInfoLog(fragmentShader, sizeof(infoLog), NULL, infoLog);
        printf("ERROR::SHADER::FRAGMENT::COMPILATION_FAILED %s\n", infoLog);
    }
    
    return fragmentShader;
}

void createShaderProgram(void) {
    unsigned int vertexShader = compileVertexShader();
    unsigned int fragmentShader = compileFragmentShader();
    
    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    // 检测链接是否有错误
    int success;
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetProgramInfoLog(shaderProgram, sizeof(infoLog), NULL, infoLog);
        printf("ERROR::PROGRAM::SHADER::LINK_FAILED %s\n", infoLog);
    }
    
    // 调用 glUseProgram 之后，每个着色器调用和渲染调用都会使用这个程序对象
    glUseProgram(shaderProgram);
    
    // 着色器对象链接到程序之后，就不再需要了
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

void render(void) {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        glfwInit();
        // 所有 OpenGL 的更高的版本都是在3.3的基础上，引入了额外的功能，并没有改动核心架构
        // OpenGL 主版本号
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        // OpenGL 次版本号
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        // 核心模式 - 核心模式下移除了一些旧的特性（立即渲染模式），迫使我们使用现代的函数，现代函数的优势是更高的灵活性和效率，然而也更难于学习，但是可以更深入的理解图形编程。
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        // Mac OS X 需要添加下面这行代码
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        
        // 创建窗口并将其设置为当前线程的主上下文
        GLFWwindow *window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
        if (window == NULL) {
            printf("Failed to create GLFW window\n");
            glfwTerminate();
            return -1;
        }
        glfwMakeContextCurrent(window);
        
        // 初始化 GLAD，由于 OpenGL 需要在运行时确定大多数函数的地址，所以正常调用 OpenGL 函数的流程很繁琐。幸运的是，有些库能简化此过程，其中 GLAD 是目前最新，也是最流行的库。
        if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
            printf("Failed to initialize GLAD\n");
            return -1;
        }
        
        // 视口，告诉 OpenGL 渲染窗口的尺寸大小
        glViewport(0, 0, 800, 600);
        // 注册通知，监听窗口大小的改变
        glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
        
        while (!glfwWindowShouldClose(window)) {
            // 输入
            processInput(window);
            
            // 渲染
            render();
            
            // 交换颜色缓冲
            glfwSwapBuffers(window);
            // 检查事件触发
            glfwPollEvents();
        }
        
        glfwTerminate();
        return 0;
    }
    return 0;
}
