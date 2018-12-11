# HardwareIntegratedDesign
### v0.1 使用宏定义
1、在实验4的基础上加入defines.vh头文件，引入宏定义，修改alu.v、aludec.v、maindec.v等模块的代码以搭配宏定义。<br>

### v0.2 实现逻辑运算指令
1、添加zeroext模块以搭配I型逻辑运算指令，仿照signext的连线连接zeroext。<br>
2、微改datapath，将相应使用到的mux2改为mux3（增加了零扩展立即数）<br>
3、将alusrc更改为2位，以满足3个srcb来源。<br>

### v0.3 实现移位指令
1、修改部分alu、aludec、maindec等模块的代码，以实现移位指令。<br>

### v0.4 实现数据移动指令
1、增加hiloreg寄存器。<br>
2、更改部分datapath连线，添加各个阶段的hiloreg控制信号与输入输出，并传至触发器。<br>
3、修改部分alu、aludec、maindec等模块的代码，以用来判断具体的数据移动指令。<br>