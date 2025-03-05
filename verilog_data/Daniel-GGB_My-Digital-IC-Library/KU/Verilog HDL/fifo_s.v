/******************************************************
�ο��ԣ�https://blog.csdn.net/buzhiquxiang/article/details/103287220
����ߣ�����
fifo���ͣ�ͬ��fifo
�ص㣺1����ʱ����дʱ��Ϊͬһʱ�ӣ���ʱ�������ز�ͬʱ������д��������д˳��Ϊ����д�������
      2��fifo�ڱ�д������Լ���д�룬�Ӷ�����ԭ�����ݣ���д��ʱ����д�����棻
	  3��fifo��ȡ��ɺ�ɼ������ж��������ڶ�ȡ���ʱ�������꾯�棬��ȡ��ͷ��ʼ��
	  4��full=1��ʾд����full=0��ʾд�룬empty=1��ʾ��ȡ��empty=0��ʾ���ꣻ
BUG��1������0���ж�Ϊ�գ���δ�޸���
*******************************************************/

module fifo_s #(parameter WIDTH=8,DEPTH=8,ADDR=3)    //����Ϊ8,���Ϊ2^7=128 
(clk,reset_n,wen,ren,data_in,full,empty,data_out);

input wire clk,reset_n;
input wire wen,ren;                    //дʹ�ܣ���ʹ��
input wire [WIDTH-1:0] data_in;
output reg full,empty;                 //������
output reg [WIDTH-1:0] data_out; 

reg [WIDTH-1:0] memery [DEPTH-1:0];    //�ڴ�����Ϊ:8
reg [ADDR-1:0] waddr,raddr;            //д��ַָ�룬����ַָ��

always@(posedge clk,negedge reset_n) begin   
if(reset_n == 0) waddr = 0;
else if(wen == 1) begin
    if((data_in != 0)&&(full != 1)) begin
        memery[waddr] = data_in;                  //д�Ĵ���
		waddr = waddr + 1;
	end
    else waddr = waddr;
end
else waddr = waddr;
end

always@(posedge clk,negedge reset_n) begin    
if(reset_n == 0) raddr = 0;
else if(ren == 1) begin
    if((memery[raddr] != 0)&&(empty != 0)) begin
      data_out = memery[raddr];                //���Ĵ���
		raddr = raddr + 1;
    end
    else raddr = raddr;
end
else raddr = raddr;
end

always@(posedge clk,negedge reset_n) begin    //�ж��Ƿ�д��
if(reset_n == 0) full = 0;
else if(waddr == DEPTH) begin
    full = 1;
    waddr = 0;
end
else full = 0;
end

always@(posedge clk,negedge reset_n) begin    //�ж��Ƿ����
if(reset_n == 0) empty = 1;
else if(raddr==DEPTH) begin
    empty = 0;
    raddr = 0;
end
else empty = 1;
end

endmodule
