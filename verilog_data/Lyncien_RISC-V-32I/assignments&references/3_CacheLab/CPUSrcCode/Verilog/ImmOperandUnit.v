//ImmOperandUnit����32bitָ����˲������������еı��أ�ͬʱ�������Կ��Ƶ�Ԫ��Type�źţ������ͬ���͵�������
//Type��Ϊ���ࣺISBUJ
module ImmOperandUnit(
input wire [31:7] In,
input wire [2:0] Type,
output reg [31:0] Out
    );
    //
`include "Parameters.v"
    //
    always@(*)
    begin
        case(Type)
            ITYPE:     //I
                Out<={ {21{In[31]}}, In[30:20] };
            STYPE:      //S
                Out<={ {21{In[31]}}, In[30:25], In[11:7] };
            BTYPE:      //B
                Out<={ {20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0 };
            UTYPE:      //U
                Out<={ In[31:12], 12'b0 };
            JTYPE:      //J
                Out<={ {12{In[31]}}, In[19:12], In[20], In[30:21], 1'b0 };
            default:   //���� ����32'b0
                Out<=32'b0;
        endcase
    end
    
endmodule