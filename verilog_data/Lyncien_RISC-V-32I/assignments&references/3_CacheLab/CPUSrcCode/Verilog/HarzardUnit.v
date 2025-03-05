/*  
 *  HarzardUnit�����������ˮ�ߵ�������ء�����������⣬���stall��flush��forward�ź� 
 *  Author: Haojun Xia  
 *  Email: xhjustc@mail.ustc.edu.cn
 *  Time: 2019.2.22
 */

/* Stall��Flush�źŵ�ʹ�ó��� *///////////////////////////////////////////////////////
//  1.Load-Use�ͣ�ǰһ��ָ��load��x�żĴ����������ŵ�ָ���õ���x�żĴ�����Ϊ������
//  ��load����EX�׶Σ�Use����ID�׶�ʱ��StallF=1 StallD=1 FLushE=1
//  IF      ID      EX   |     MM      WB                           [Load]
//          IF      ID   | ID��������  EX     MM      WB            [Use]       
//  �����жϣ���MemToRegE==1�� && ��RdE==Rs1D||RdE==Rs2D)
//  �ź������ StallF=1 StallD=1 FLushE=1
//
//  2.JAL��������ת
// ��JAL����ID�׶�ʱ��FlushD=1
//  IF      ID   |     EX        MM      WB                          [JAL]
//          IF   |   IFȡ�µ�ַ  ID      EX     MM      WB           [Any]
//  �����жϣ�JalD==1
//  �ź������FlushD=1
//
//  3.JALR��������ת
//  ��JALR����ID�׶�ʱ��StallF=1��FlushD=1
//  IF      ID   |    EX                                              [JALR]
//          IF   |   IFȡ��ͬ��ַ                                     [Any]
//  �����жϣ�JalrD==1
//  �ź������StallF=1 FlushD=1
//  ��JALR����EX�׶�ʱ��FLushD=1
//  IF      ID      EX       |    MM       WB                         [JALR]
//          IF  IFȡ��ͬ��ַ | IFȡ�µ�ַ  ID     EX     MM     WB    [Any]
//  �����жϣ�JalrE==1
//  �ź������FlushD=1
//
//  4.Branch������֧
//  ��Br����ID�׶�ʱ��StallF=1��FlushD=1
//  IF      ID   |    EX                                              [Br]
//          IF   |   IFȡ��ͬ��ַ                                     [Any]
//  �����жϣ�BranchD==1
//  �ź������StallF=1��FlushD=1
//  ��Br����EX�׶�ʱ
//  ���BranchE=1������֧��������ʱ����FlushD=1
//  IF      ID      EX       |    MM       WB                         [JALR]
//          IF  IFȡ��ͬ��ַ | IFȡ�µ�ַ  ID     EX     MM     WB    [Any]
//  �����жϣ�BranchE==1
//  �ź������FlushD=1
//  ���BranchE=0�������������⴦��
//  IF      ID      EX       |    MM       WB                         [JALR]
//          IF  IFȡ��ͬ��ַ |    ID       EX     MM     WB           [Any]
//  �����жϣ�BranchE==0
//  �ź�����������������⴦��
//////////////////////////////////////////////////////////////////////////////////////
/* Stall��Flush�źŵ�ʹ�ó��� *///////////////////////////////////////////////////////
//  1.EX�׶���Ҫ�õ� ���� ��ָ��load��ֵ����ALU������
//  �����жϣ�RegWriteW==1 && (RdW==Rs1E||RdW==Rs2E)
//  �ź������Forward1E=2'b01 Forward2E=2'b01
//  2.EX�׶���Ҫ�õ� �� ��ָ���ALU������
//  �����жϣ�RegWriteM==1 && (RdM==Rs1E||RdM==Rs2E)
//  �ź������Forward1E=2'b10 Forward2E=2'b10
//////////////////////////////////////////////////////////////////////////////////////  

//����˳��  ���ȴ���EX�ε���� �ٿ���ID��
//ֵ��ע����ǣ����EX����Branch��Jal����Jalr����ʱID��Ϊ�գ�����������϶����������
//���EX��load��������load-use���⣬��ô���ȴ���EX�εĳ�ͻ��������load-use���⴦������ʹID������תָ�Ҳ���Ҳ���ȡ��ʩ

module HarzardUnit(
    input wire BranchD, BranchE,
    input wire JalrD, JalrE, JalD,
    input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
    input wire MemToRegE,
    input wire [2:0] RegWriteE, RegWriteM, RegWriteW,
    input wire [4:0] RdE, RdM, RdW,
    input wire ICacheMiss, DCacheMiss ,
    output reg StallF, FlushD, StallD, FlushE, StallE, StallM, StallW,
    output wire Forward1D, Forward2D,
    output reg [1:0] Forward1E, Forward2E
    );
    //
    assign Forward1D=1'b0;
    assign Forward2D=1'b0;
    //Stall and Flush signals generate
    always @ (*)
    begin
        if(DCacheMiss | ICacheMiss)
        begin
            StallF<=1'b1;
            StallD<=1'b1;
            FlushD<=1'b0;
            FlushE<=1'b0;
            StallE<=1'b1;
            StallM<=1'b1;
            StallW<=1'b1;
        end
        else if(BranchE)
        begin
            StallF<=1'b0;
            StallD<=1'b0;
            FlushD<=1'b1;
            FlushE<=1'b0;
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;
        end
        else if(JalrE)
            begin
            StallF<=1'b0;
            StallD<=1'b0;
            FlushD<=1'b1;
            FlushE<=1'b0;
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;
        end
        else if(MemToRegE & ((RdE==Rs1D)||(RdE==Rs2D)) )
            begin
            StallF<=1'b1;
            StallD<=1'b1;
            FlushD<=1'b0;
            FlushE<=1'b1;
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;
        end
        else if(JalrD)
        begin
            StallF<=1'b1;
            StallD<=1'b0;
            FlushD<=1'b1;
            FlushE<=1'b0;
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;
        end
        else if(JalD)
        begin
            StallF<=1'b0;
            StallD<=1'b0;
            FlushD<=1'b1;
            FlushE<=1'b0;        
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;   
        end
        else if(BranchD)
        begin
            StallF<=1'b1;
            StallD<=1'b0;
            FlushD<=1'b1;
            FlushE<=1'b0;
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;
            end
        else
        begin
            StallF<=1'b0;
            StallD<=1'b0;
            FlushD<=1'b0;
            FlushE<=1'b0;
            StallE<=1'b0;
            StallM<=1'b0;
            StallW<=1'b0;
        end
    end
    //Forward�źŵ�ʹ�ó���
    always@(*)
    begin
        if( (RegWriteM!=3'b0) && (RdM==Rs1E) &&(RdM!=5'b0) )
            Forward1E<=2'b10;
        else if( (RegWriteW!=3'b0) && (RdW==Rs1E) &&(RdW!=5'b0) )
            Forward1E<=2'b01;
        else
            Forward1E<=2'b00;
    end
    always@(*)
    begin
        if( (RegWriteM!=3'b0) && (RdM==Rs2E) &&(RdM!=5'b0) )
            Forward2E<=2'b10;
        else if( (RegWriteW!=3'b0) && (RdW==Rs2E) &&(RdW!=5'b0) )
            Forward2E<=2'b01;
        else
            Forward2E<=2'b00;
    end      
endmodule
