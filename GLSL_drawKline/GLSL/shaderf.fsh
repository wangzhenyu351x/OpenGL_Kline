precision highp float;
//varying lowp vec2 varyTextCoord;
//uniform sampler2D colorMap;
varying lowp vec4 varyColor;

void main(){
    
    //gl_FragColor = texture2D(colorMap, (0,0));
    gl_FragColor = varyColor;
}
