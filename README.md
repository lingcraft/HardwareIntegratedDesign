# HardwareIntegratedDesign
### v0.1
1、在实验4的基础上加入defines.vh头文件，引入宏定义，修改alu.v、aludec.v、maindec.v等文件以搭配宏定义。<br>

### v0.2
1、实现了基本的逻辑运算指令。<br>
2、添加zeroext模块以搭配I型逻辑运算指令，仿照signext的连线连接zeroext。<br>
3、微改datapath，将相应使用到的mux2改为mux3（增加了零扩展立即数）<br>
4、将alusrc更改为2位，以满足3个srcb来源。<br>

### v0.3
1、实现了基本的移位指令。
