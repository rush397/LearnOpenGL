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

#include "shader_s.hpp"

void framebuffer_size_callback(GLFWwindow *window, int width, int height) {
    // 视口，告诉 OpenGL 渲染窗口的尺寸大小
    glViewport(0, 0, width, height);
}

void processInput(GLFWwindow *window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}

unsigned int createVAO(void) {
    // OpenGL 核心模式要求必须使用 VAO
    unsigned int VAO;
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    return VAO;
}

unsigned int createRectangleVertex(void) {
    float vertices[] = {
        0.0f, 0.5f, 0.0f, // left bottom
        0.0f, -0.5f, 0.0f,   // left top
        1.0f, 0.5f, 0.0f,  // right bottom
        1.0f, -0.5f, 0.0f,  // right top
    };
    
    unsigned int indices[] = {
        0, 1, 2,
        1, 2, 3,
    };
    
    unsigned int VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //
    unsigned int EBO;
    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
  
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    return VBO;
}

unsigned int createTriangleVertex(void) {
    // 以标准化坐标的形式定义顶点数组
    float vertices[] = {
        -1.0f, -0.5f, 0.0f,    0.0f, 1.0f, 0.0f,    // left
        -0.5f, 0.5f, 0.0f,     0.0f, 0.0f, 1.0f,    // top
        0.0f, -0.5f, 0.0f,     1.0f, 0.0f, 0.0f,    // right
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    
    return VBO;
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
        // 注册通知，监听窗口大小的改变
        glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
        
        // 初始化 GLAD，由于 OpenGL 需要在运行时确定大多数函数的地址，所以正常调用 OpenGL 函数的流程很繁琐。幸运的是，有些库能简化此过程，其中 GLAD 是目前最新，也是最流行的库。
        if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
            printf("Failed to initialize GLAD\n");
            return -1;
        }
        
        // Retina 屏需的尺寸要 * 2
        glViewport(0, 0, 800 * 2, 600 * 2);
        
        unsigned int VAO1 = createVAO();
        unsigned int VBO1 = createTriangleVertex();
        
        unsigned int VAO2 = createVAO();
        unsigned int VBO2 = createRectangleVertex();
//        NSURL *url = [[NSFileManager defaultManager] homeDirectoryForCurrentUser];
//        NSString *path = [NSString stringWithFormat:@"%@Projects/OpenGL/LearnOpenGL/LearnOpenGL/", [url absoluteString]];
        
//        NSString *vs = [path stringByAppendingString:@"triangle.vs"];
//        NSString *fs = [path stringByAppendingString:@"triangle.fs"];
        Shader shader("/Users/yaoqi/Projects/OpenGL/LearnOpenGL/LearnOpenGL/triangle.vs", "/Users/yaoqi/Projects/OpenGL/LearnOpenGL/LearnOpenGL/triangle.fs");
        
        // 线框模式，默认为 GL_FILL
//        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        
        while (!glfwWindowShouldClose(window)) {
            // 输入
            processInput(window);
            
            // 渲染
            glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);
            
            shader.use();
            // 调用 glUseProgram 之后，每个着色器调用和渲染调用都会使用这个程序对象
            glBindVertexArray(VAO1);
            /*
            float timeValue = glfwGetTime();
            float greenValue = sin(timeValue) / 2.0f + 0.5f;
            int vertexColorLocation = glGetUniformLocation(shaderProgram, "ourColor");
            glUniform4f(vertexColorLocation, 0.0f, greenValue, 0.0f, 1.0);
             */
            glDrawArrays(GL_TRIANGLES, 0, 3);
            
            glBindVertexArray(VAO2);
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
            
            // 交换颜色缓冲
            glfwSwapBuffers(window);
            // 检查事件触发
            glfwPollEvents();
        }
        
        glDeleteVertexArrays(1, &VAO1);
        glDeleteVertexArrays(1, &VAO2);
        glDeleteBuffers(1, &VBO1);
        glDeleteBuffers(1, &VBO2);
        
        glfwTerminate();
        return 0;
    }
    return 0;
}
