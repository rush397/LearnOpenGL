#version 330 core
out vec4 FragColor;
in vec3 color1;

void main() {
    FragColor = vec4(color1, 1.0);
}
