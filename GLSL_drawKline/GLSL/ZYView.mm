//
//  ZYView.m
//  GLSL
//
//  Created by zhenyu on 2022/3/25.
//

#import "ZYView.h"
#import <OpenGLES/ES2/gl.h>

typedef struct {
    float r;
    float g;
    float b;
} ColorSpace;

@interface ZYView ()
@property (nonatomic) CAEAGLLayer *eaglLayer;
@property (nonatomic) EAGLContext *context;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint frameBuffer;
@property (nonatomic) GLuint program;
@end

@implementation ZYView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayer];
        [self setupContext];
        [self deleteBuffer];
        [self setupBuffer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self renderLayer];
}

CGPoint transferToGLPointFrom(CGPoint point,CGRect rect) {
    CGPoint pointOri = point;
    point.x = point.x*2/rect.size.width - 1;
    point.y = 1 - point.y*2/rect.size.height;
    return point;
}

static void drawRect(const CGRect bounds ,GLuint const position,GLuint const positionColor, ColorSpace color, const CGRect rect, BOOL isFill) {
    drawTriangles(bounds, position,positionColor, color, @[
        [NSValue valueWithCGPoint:rect.origin],
        [NSValue valueWithCGPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y)],
        [NSValue valueWithCGPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height)],
        [NSValue valueWithCGPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height)],
    ], isFill? GL_TRIANGLE_FAN : GL_LINE_LOOP);
}

static void drawLine(const CGRect bounds ,GLuint const position,GLuint const positionColor,ColorSpace color, CGPoint from, CGPoint to) {
    drawTriangles(bounds, position,positionColor,color, @[[NSValue valueWithCGPoint:from],[NSValue valueWithCGPoint:to]], GL_LINES);
}

static void drawTriangles(const CGRect bounds ,GLuint const position,GLuint const positionColor,ColorSpace color,NSArray<NSValue *> *pointValueArr, GLint glDrawType) {
    
    const int pointCount = (int)pointValueArr.count;
    const int eachLineLength = 6;
    const int cFloatSize = pointCount * eachLineLength;
    
    GLfloat *attrArr = new GLfloat[cFloatSize];
    for (int i=0; i<pointCount; i++) {
        NSValue *value = pointValueArr[i];
        CGPoint point = value.CGPointValue;
        CGPoint pointGL = transferToGLPointFrom(point, bounds);
        attrArr[i*eachLineLength] = pointGL.x;
        attrArr[i*eachLineLength+1] = pointGL.y;
        attrArr[i*eachLineLength+2] = 0.0f;
        
        attrArr[i*eachLineLength+3] = color.r;
        attrArr[i*eachLineLength+4] = color.g;
        attrArr[i*eachLineLength+5] = color.b;
    }
    
    static GLuint attrBuffer;
    if (attrBuffer == 0) {
        glGenBuffers(1, &attrBuffer);
    }
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*eachLineLength*pointCount, attrArr, GL_DYNAMIC_DRAW);
    delete [] attrArr;
    
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * eachLineLength, NULL);
    glVertexAttribPointer(positionColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * eachLineLength, (GLfloat *)NULL +3);
    
    glDrawArrays(glDrawType, 0, pointCount);
    
}

- (void)renderLayer {
    
    glClearColor(1.0, 1.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0,0 , self.frame.size.width, self.frame.size.height);

    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"shaderv" ofType:@"vsh"];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"shaderf" ofType:@"fsh"];

    if (!self.program) {
        self.program = [self loadShaders:vertFile Withfrag:fragFile];
    }

    glLinkProgram(self.program);

    GLint linkStatus;
    glGetProgramiv(self.program, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        GLchar message[512];
        glGetProgramInfoLog(self.program, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"%@",messageString);
        return;
    }
    glUseProgram(self.program);
    
    GLuint const position = glGetAttribLocation(self.program, "position");
    glEnableVertexAttribArray(position);
    
    GLuint const positionColor = glGetAttribLocation(self.program, "positionColor");
    glEnableVertexAttribArray(positionColor);
    
    CGRect const bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    ColorSpace color = {0.5,0.5,1.0};
//    drawRect(bounds, position, positionColor, {1.0,1.0,1.0}, self.bounds,true);
    drawRect(bounds, position, positionColor, color, CGRectMake(110, 110, 100, 100),false);
    drawRect(bounds, position, positionColor, {0.9,0.1,0.5}, CGRectMake(10, 10, 100, 100),true);

    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar *source = (GLchar *)[content UTF8String];
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
}

- (GLuint)loadShaders:(NSString *)vert Withfrag:(NSString *)frag {
    GLuint verShader = 0, fragShader = 0;
    GLint program = glCreateProgram();

    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];

    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    return program;
}

- (void)deleteBuffer {
    glDeleteBuffers(1, &_renderBuffer);
    _renderBuffer = 0;
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
}

- (void)setupBuffer {
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, self.renderBuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.eaglLayer];

    glGenBuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, self.frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.renderBuffer);
}

- (void)setupContext {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!context) {
        NSLog(@"创建context 失败");
        return;
    }
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"设置context失败");
        return;
    }
    self.context = context;
}

- (void)setupLayer {
    self.eaglLayer = [CAEAGLLayer layer];//  (CAEAGLLayer *)self.layer;
    [self.layer addSublayer:self.eaglLayer];
    self.eaglLayer.bounds = self.bounds;
    self.eaglLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.eaglLayer.drawableProperties = @{
        kEAGLDrawablePropertyRetainedBacking : @false,
        kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
    };
}

@end
