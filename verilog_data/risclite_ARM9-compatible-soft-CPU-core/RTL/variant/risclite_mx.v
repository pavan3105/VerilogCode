`timescale 1 ns/1 ns
`define DEL 2
module risclite_mx(
          clk,
          cpu_en,
          ram_rdata,
          rom_data,
          rst,

          ram_addr,
          ram_cen,
          ram_flag,
          ram_wdata,
          ram_wen,
          rom_addr,
          rom_en 
        ); 


input            clk;
input            cpu_en;
input  [31:0]    ram_rdata;
input  [31:0]    rom_data;
input            rst;


output [31:0]    ram_addr;
output           ram_cen;
output [3:0]     ram_flag;
output [31:0]    ram_wdata;
output           ram_wen;
output [31:0]    rom_addr;
output           rom_en;


/******************************************************/
//register definition area
/******************************************************/
reg              add_c;
reg    [1:0]     add_extra_num;
reg              adder_a_inv;
reg              adder_b_inv;
reg    [31:0]     cmd;
reg              cmd_flag;
reg              cmd_is_b;
reg              cmd_is_bx;
reg              cmd_is_dp;
reg              cmd_is_mrs;
reg              cmd_is_msr;
reg              cmd_is_swp;
reg              cmd_is_swpx;
reg    [4:0]     cmd_sum;
reg              code_cen;
reg              code_cha_flag;
reg              code_flag;
reg    [31:0]     code_rm;
reg    [31:0]     code_rs;
reg    [3:0]     code_rt_num;
reg              code_to_flag;
reg              cond_satisfy;
reg              cpsr_c;
reg              cpsr_c_in;
reg              cpsr_n;
reg              cpsr_n_in;
reg              cpsr_v;
reg              cpsr_v_in;
reg              cpsr_z;
reg              cpsr_z_in;
reg              dp0_rrx_shift;
reg              dp1_lsl_more;
reg              dp1_shift_zero;
reg    [31:0]     dp_ans;
reg    [31:0]     get_rn;
reg    [31:0]     go_data;
reg    [5:0]     go_fmt;
reg    [3:0]     cha_fmt;
reg    [3:0]     go_num;
reg              go_vld;
reg    [3:0]     ldm_num;
reg    [3:0]     ldm_sel;
reg              ldm_vld;
reg    [31:0]     r0;
reg    [31:0]     r1;
reg    [31:0]     r2;
reg    [31:0]     r3;
reg    [31:0]     r4;
reg    [31:0]     r5;
reg    [31:0]     r6;
reg    [31:0]     r7;
reg    [31:0]     r8;
reg    [31:0]     r9;
reg    [31:0]     ra;
reg    [3:0]     ram_flag;
reg    [31:0]     ram_wdata;
reg    [31:0]     rb;
reg    [31:0]     rc;
reg    [31:0]     rd;
reg    [31:0]     re;
reg    [31:0]     reg_rn;
reg    [31:0]     rf;
reg    [31:0]     rfx;
reg    [31:0]     rt;
reg    [31:0]     sec_operand;
reg              shift_bit;
reg    [6:0]     shift_num;
reg    [31:0]     shift_word;
reg    [31:0]     shifter_ans;
reg    [31:0]     shifter_high;
reg    [31:0]     shifter_low;
reg    [4:0]     shifter_rot_num;
reg    [4:0]     sum_m;
reg    [31:0]     to_data;
reg    [3:0]     to_num;


/******************************************************/


/******************************************************/
//wire definition area
/******************************************************/
wire   [31:0]     add_a;
wire   [31:0]     add_b;
wire             all_code;
wire   [31:0]     and_ans;
wire             bit_cy;
wire             bit_ov;
wire   [3:0]     cha_num;
wire             cha_rf_vld;
wire             cha_vld;
wire   [31:0]     cmd_addr;
wire             cmd_is_ldm;
wire             cmd_ok;
wire   [31:0]     code;
wire             code_is_b;
wire             code_is_bx;
wire             code_is_dp;
wire             code_is_dp0;
wire             code_is_dp1;
wire             code_is_dp2;
wire             code_is_ldm;
wire             code_is_ldr0;
wire             code_is_ldr1;
wire             code_is_ldrh0;
wire             code_is_ldrh1;
wire             code_is_ldrsb0;
wire             code_is_ldrsb1;
wire             code_is_ldrsh0;
wire             code_is_ldrsh1;
wire             code_is_mrs;
wire             code_is_msr0;
wire             code_is_msr1;
wire             code_is_mult;
wire             code_is_multl;
wire             code_is_swi;
wire             code_is_swp;
wire   [3:0]     code_rm_num;
wire             code_rm_vld;
wire   [3:0]     code_rn_num;
wire             code_rn_vld;
wire   [3:0]     code_rnhi_num;
wire             code_rnhi_vld;
wire   [3:0]     code_rs_num;
wire             code_rs_vld;
wire   [4:0]     code_sum;
wire   [31:0]     eor_ans;
wire   [3:0]     get_rn_num;
wire             go_rf_vld;
wire             high_bit;
wire   [1:0]     high_middle;
wire             hold_en;
wire   [31:0]     ldm_data;
wire             ldm_rf_vld;
wire   [31:0]     or_ans;
wire   [31:0]     ram_addr;
wire             ram_cen;
wire             ram_wen;
wire   [31:0]     rf_b;
wire   [31:0]     rom_addr;
wire             rom_en;
wire   [3:0]     rot_numa;
wire   [4:0]     rot_numb;
wire   [4:0]     rot_numc;
wire   [4:0]     rot_numd;
wire   [4:0]     rot_nume;
wire   [3:0]     rt_num;
wire   [63:0]     shifter_out;
wire   [31:0]     sum_middle;
wire   [31:0]     sum_rn_rm;
wire             to_rf_vld;
wire             to_vld;
wire             wait_en;

//ǰ�ԣ��������Ķ�ʱ����������ÿ���ֹ�������ÿ���������һ�����ܣ��൱�ڸ���ģ��


/******************************************************/
//code������
/******************************************************/
//��21��ָ�������е��������ϸ��壬���߿��Բ������еĽ���
//ͨ������һϵ�е�code_is_xxx������֪�������ݳش�����rom_data��������һ��ָ�

assign code =  rom_data;

assign code_is_mrs =  ({code[27:23],code[21:16],code[11:0]}==23'b00010_001111_000000000000);

assign code_is_msr0 =  ({code[27:23],code[21:20],code[18:17],code[15:4]}==21'b00010_10_00_111100000000);

assign code_is_dp0 =  ({code[27:25],code[4]}==4'b0000)&((code[24:23]!=2'b10)|code[20]);

assign code_is_bx =  (code[27:4]==24'b0001_0010_1111_1111_1111_0001);

assign code_is_dp1 =  ({code[27:25],code[7],code[4]}==5'b00001) & ((code[24:23]!=2'b10)|code[20]);	

assign code_is_mult =  ({code[27:22],code[7:4]}==10'b000000_1001);

assign code_is_multl =  ({code[27:23],code[7:4]}==9'b00001_1001);	

assign code_is_swp =  ({code[27:23],code[21:20],code[11:4]}==15'b00010_00_00001001);	

assign code_is_ldrh0 =  ({code[27:25],code[22],code[11:4]}==12'b000_0_00001011);

assign code_is_ldrh1 =  ({code[27:25],code[22],code[7:4]}==8'b000_1_1011);	

assign code_is_ldrsb0 =  ({code[27:25],code[22],code[20],code[11:4]}==13'b000_0_1_00001101);

assign code_is_ldrsb1 =  ({code[27:25],code[22],code[20],code[7:4]}==9'b000_1_1_1101);		

assign code_is_ldrsh0 =  ({code[27:25],code[22],code[20],code[11:4]}==13'b000_0_1_00001111);

assign code_is_ldrsh1 =  ({code[27:25],code[22],code[20],code[7:4]}==9'b000_1_1_1111);	

assign code_is_msr1 =  ({code[27:23],code[21:20],code[18:17],code[15:12]}==13'b00110_10_00_1111);

assign code_is_dp2 =  (code[27:25]==3'b001)&((code[24:23]!=2'b10)|code[20]);

assign code_is_ldr0 =  (code[27:25]==3'b010);

assign code_is_ldr1 =  ({code[27:25],code[4]}==4'b0110);

assign code_is_ldm =  (code[27:25]==3'b100);

assign code_is_b =  (code[27:25]==3'b101);

assign code_is_swi =  (code[27:24]==4'b1111);

assign all_code =  code_is_mrs|code_is_msr0|code_is_bx|code_is_mult|code_is_multl|code_is_swp|code_is_ldrh0|code_is_ldrh1|code_is_ldrsb0|code_is_ldrsb1|code_is_ldrsh0|code_is_ldrsh1|code_is_msr1|code_is_dp0|code_is_dp1|code_is_dp2|code_is_ldr0|code_is_ldr1|code_is_ldm|code_is_b|code_is_swi;


/******************************************************/
//Rm��Rs��λ��
//�ڵڶ���ʱ�����Rm<<Rs����λ�������γɵڶ���������ԭ��
/******************************************************/
//�ڵڶ��������Ǳ������Rm��λ�Ĳ�������Ҫ��λ��ָ����Ҫ��dp0,dp1,dp2,����msr1,ldr0������ָ�
//���ܶ���������Rm����Ҫ��λ�����ǻ��ǰ�������shift_high�ϣ�������λ0���Ա㴫���ڶ�������

//Rm��������ڼĴ�����һ������code[3:0]�����ģ�����ͨ��������ȡRm
always @ ( * )
case ( code[3:0] )
4'h0 : code_rm =  r0;
4'h1 : code_rm =  r1;	
4'h2 : code_rm =  r2;
4'h3 : code_rm =  r3;
4'h4 : code_rm =  r4;
4'h5 : code_rm =  r5;	
4'h6 : code_rm =  r6;
4'h7 : code_rm =  r7;	
4'h8 : code_rm =  r8;
4'h9 : code_rm =  r9;	
4'ha : code_rm =  ra;
4'hb : code_rm =  rb;
4'hc : code_rm =  rc;
4'hd : code_rm =  rd;	
4'he : code_rm =  re;
4'hf : code_rm =  rfx;
 endcase	

 //Rsһ����code[11:8]ָ��
always @ ( * )
case ( code[11:8] )
4'h0 : code_rs =  r0;
4'h1 : code_rs =  r1;	
4'h2 : code_rs =  r2;
4'h3 : code_rs =  r3;
4'h4 : code_rs =  r4;
4'h5 : code_rs =  r5;	
4'h6 : code_rs =  r6;
4'h7 : code_rs =  r7;	
4'h8 : code_rs =  r8;
4'h9 : code_rs =  r9;	
4'ha : code_rs =  ra;
4'hb : code_rs =  rb;
4'hc : code_rs =  rc;
4'hd : code_rs =  rd;	
4'he : code_rs =  re;
4'hf : code_rs =  32'b0;
endcase

//��RmΪ�����������λ�Ĵ����ĸ�32λ��
//��λ�ķ�ʽ��{shifter_high,shifter_low}<<shifter_rot_num
//��һ���汾���ó˷�����������ʹ���߼����ƣ����Դ����ʡ��Դ
//���Ҫ�����λ����ô���Ǳ�����֯shifter_high,shifter_low�Լ�shifter_rot_num

//shifter_high��Ϊ��λ�ĸ߰벿�֣�����λ��������塣���Ǹ���ָ��Ĳ�ͬ��ȷ��
//MSR1��DP2ָ��ǰ�code[7:0]ѭ������{code[11:8],1'b0}
//LDR0ָ�������λ��ֻ��Ҫcode[11:0]�����shifter_highֱ��ʹ��code[11:0]
//Bָ�ͬ�������������������涨shifter_rot_num==0
//code[4],code[7]������1����ʾLDRH,LDRSB,LDRSHָ��
//��������£�Ҳ����dp0��dp1�ˣ���ʱ������λ��ʽcode[6:5]������shifter_high
// 00ʱ���߼����ƣ�����������Ψһ����λ�����������ƣ�����shifter_high=Rm, shifter_low=0����ô{Rm,0}<<num�ĸ�32λ�������ǵ���λ���
// 01ʱ���߼����ƣ�shifter_high=0, shifter_low = Rm����ô{0,Rm}<<num�ĸ�32λ���������߼����ƵĽ������Ȼnum����ȡ����һ
// 10ʱ���������ƣ�shifter_high=����λ��shifter_low= Rm����ô{����λ,Rm}<<num�ĸ�32λ���������������ƵĽ����numҲҪȡ����һ
// 11ʱ��ѭ�����ƣ�shifter_high=Rm, shifter_low = Rm����ô{Rm,Rm}<<num�ĸ�32λ��������ѭ�����ƵĽ����numҲҪȡ����һ

always @ ( * )
if ( code_is_msr1|code_is_dp2 )
   shifter_high =  code[7:0];
else if ( code_is_ldr0 )
    shifter_high =  code[11:0];
else if ( code_is_b )
    shifter_high =  {{6{code[23]}},code[23:0],2'b0};
else if ( code[4] & code[7] )
    shifter_high =  code[22] ? {code[11:8],code[3:0]} : code_rm;
else 
    case( code[6:5] )
	2'h0 : shifter_high =  code_rm;
	2'h1 : shifter_high =  32'b0;
	2'h2 : shifter_high =  {32{code_rm[31]}};
	2'h3 : shifter_high =  code_rm;
	endcase

	
//shifter_low�ڽ�shifter_highʱ�Ѿ�������ֻ��������λ��ʱ�򣬲���Ҫshifter_low��
//������λ��ָ�������msr1,dp2��������������ѭ�����ƣ�,Ȼ����dp0��dp1
//��������shifter_low�����潲���ˡ�
	
always @ ( * )
if ( code_is_msr1|code_is_dp2 )
    shifter_low =  code[7:0];
else if ( code[6:5]==2'b0 )
    shifter_low =  32'b0;
else 
    shifter_low =  code_rm;

//���ǰ�����ȡ����һ��������ʾ����	

assign rot_numa =  ~code[11:8] + 1'b1;

assign rot_numb =  ~code[11:7] + 1'b1;

assign rot_numc =  ~code_rs[4:0] + 1'b1;	
	
//�����B��LDR0ָ������趨��λ��ĿΪ0
//�����ָ��MSR1��DP2��������λ��Ŀ��{code[11:8],1'b0}���������ȡ����һ
//���������DP0(code[4]==0)����ô����(code[6:5]==0��ʱʹ��ԭֵ��������Ҫȡ����һ
//���code[4]��code[7]������1����ʾ��mult/multl/ldrh/ldrsb/ldrsh��ָ���ʱ��λ��Ŀ�������0
//��������£����ǹ���DP1ָ������ѭ����λ����ô��λ��Ŀȡ����һ
//�����λ������32λ(Rs[7:5]��һ������1������ô��λ��Ŀ����0��
//���������DP0���� 
	
always @ ( * )
if (code_is_b|code_is_ldr0)
    shifter_rot_num =  5'b0;
else if ( code_is_msr1|code_is_dp2 )
    shifter_rot_num =  {rot_numa,1'b0};
else if ( ~code[4] )
    shifter_rot_num =  (code[6:5]==2'b0) ? code[11:7] : rot_numb;
else if ( code[7] )
    shifter_rot_num =  5'b0;
else if ( code[6:5]==2'b11 )
    shifter_rot_num =  rot_numc;
else if ( |code_rs[7:5] )
    shifter_rot_num =  5'b0;	
else  
    shifter_rot_num =  (code[6:5]==2'b0) ? code_rs[4:0] : rot_numc;

//�Ѿ���֯��high,low��rot_num����ô���Ľ��һ�㶼��shifter_out[63:32]�����������������
//����������������ֱ�Ӹı�ڶ�������	

assign shifter_out =  {shifter_high,shifter_low}<<shifter_rot_num;

/******************************************************/
//�õ�Rn�͵ڶ�������sec_operand
/******************************************************/	

//������׼��Rn�������Bָ�ǿ�Ƶ���R15��������[19:16]������	
assign get_rn_num =  (code_is_b)?4'hf:code[19:16];

//�ӼĴ���������ȡ��Rn
always @ ( * )
case ( get_rn_num )
4'h0 : get_rn =  r0;
4'h1 : get_rn =  r1;	
4'h2 : get_rn =  r2;
4'h3 : get_rn =  r3;
4'h4 : get_rn =  r4;
4'h5 : get_rn =  r5;	
4'h6 : get_rn =  r6;
4'h7 : get_rn =  r7;	
4'h8 : get_rn =  r8;
4'h9 : get_rn =  r9;	
4'ha : get_rn =  ra;
4'hb : get_rn =  rb;
4'hc : get_rn =  rc;
4'hd : get_rn =  rd;	
4'he : get_rn =  re;
4'hf : get_rn =  rfx;
endcase

assign code_is_dp =  code_is_dp0|code_is_dp1|code_is_dp2;

//reg_rn��Rn�Ĵ����Ĵ��������Ǻ����ӷ�����һ��������
//reg_rn��Rn�Ĵ�żĴ���������Ĳ������õ�Rn��
//�����DP��mov��mvn��������ʱ��ѵڶ���������ȡ������Rd�ڣ���ô�������Ҫʹ�üӷ����Ľ�����ͱ���ǿ��Rn=0.
//��ˣ�����������£�Rn�������0

always @ ( posedge clk or posedge rst )
if ( rst )
    reg_rn <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    if ( code_is_dp & ((code[24:21]==4'b1101)|(code[24:21]==4'b1111)) )
		    reg_rn <= #`DEL  32'b0;
		else
	        reg_rn <= #`DEL  get_rn;
	else;
else;

//������֯�ڶ�������shifter_ans��reg_rn��sec_operand(shifter_ans)�Ǽӷ���������������
//ldm��ָ������ᣬ��Ҫ���ļ���shifter_ans����ָ���ִ�в��ϱ仯�����γ�code[15:0]ÿ��1bit��Ӧ��ͬ�ĵ�ַ

//�����ǰ�code[15:0]�ۼ�����������LDMָ����Ҫִ�ж��ٸ�����
assign code_sum =  (code[0]+code[1]+code[2]+code[3]+code[4]+code[5]+code[6]+code[7]+code[8]+code[9]+code[10]+code[11]+code[12]+code[13]+code[14]+code[15]);	

assign cmd_is_ldm =  (cmd[27:25]==3'b100);

//��code_sumʹ�üĴ��������������Ա�ʹ��
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_sum <= #`DEL 5'd0;
else if ( cpu_en & ~hold_en )
    cmd_sum <= #`DEL  code_sum;
else;

//sum_m�䵱������ָ��Ķ����ڱ�־�����᲻�ϵݼ������ݼ���0ʱ��������Ҳ�ͽ���
always @ ( posedge clk or posedge rst )
if ( rst )
    sum_m <= #`DEL 5'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    sum_m <= #`DEL  code_sum;
	else
	    sum_m <= #`DEL  sum_m - 1'b1;
else;

//shifter_ans��sec_operand��ԭ�ͣ�һ�㶼������
//��ȷ�����ĳ�ʼֵʱ�������LDM�����������
//�����LDM������code[24:23]����ȷ�����ݳص�ַ�ĳ�ֵ������͵�����λ���
//��LDMָ��ִ�еĹ�����(hold_en & cmd_is_ldm)�����ǻ᲻�϶Է���ĳ�ֵ���еݼ���ݼ�
//�ڿ�ݼ���0(Ҳ����sum_m==1����һ��)ʱ���ѱ����code[15:0]���ܺͷ���shifter_ans����ô��sum_m=0ʱ����Rn���е�ַ��д

always @ ( posedge clk or posedge rst )
if ( rst )
    shifter_ans <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ~hold_en )
        if ( code_is_ldm )
            case( code[24:23] )
            2'h0 : shifter_ans <= #`DEL  {(code_sum - 1'b1),2'b0};
            2'h1 : shifter_ans <= #`DEL  0;
            2'h2 : shifter_ans <= #`DEL  {code_sum,2'b0};
            2'h3 : shifter_ans <= #`DEL  3'b100;
            endcase
        else   
	        shifter_ans <= #`DEL  shifter_out[63:32];
	else if ( cmd_is_ldm )
	    if ( sum_m==5'b1 )
	        shifter_ans[6:2] <= #`DEL cmd_sum;	
	    else if ( cmd[23] )
	        shifter_ans[6:2] <= #`DEL shifter_ans[6:2] + 1'b1;
	    else
	        shifter_ans[6:2] <= #`DEL shifter_ans[6:2] - 1'b1;
	else;
else;

//dp1�ǼĴ���Rsָʾ��λ��Ŀ�������Ƴ���32λ(code_rs[7:5]!=0)ʱ����Ҫָʾ��������ʱsec_operandǿ��Ϊ0����shifter_ans�����ŵ�ȴ��Rm
always @ ( posedge clk or posedge rst )
if ( rst )
    dp1_lsl_more <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    dp1_lsl_more <= #`DEL  code_is_dp1 & (code[6:5]==2'b00) & (|code_rs[7:5]);
	else
	    dp1_lsl_more <= #`DEL  1'b0;
else;

//dp0�������RRX��λ��Ҳ����ѭ�����ƣ�����������Ŀ����0ʱ����ʱcpsr_c��������ڵڶ���������
always @ ( posedge clk or posedge rst )
if ( rst )
    dp0_rrx_shift <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    dp0_rrx_shift <= #`DEL  code_is_dp0 & (code[11:5]==7'b00000_11);
	else
	    dp0_rrx_shift <= #`DEL  1'b0;
else;

//dp1��λ��Ŀ����0ʱ(Rs[7:0]����0)����ʱ�ĵڶ�������Ӧ�ñ��ֲ���.
//shifter_ans�������{Rm,0,����λ,Rm}����Ӧ�����������ֱ��ʹ���������ʡ�
//�Һ�shift_word���Ǳ��ֲ����Rm����ʱǿ����ڶ�����������Rm��
always @ ( posedge clk or posedge rst )
if ( rst )
    dp1_shift_zero <= #`DEL 1'b0;
else if ( cpu_en )
    if ( ~hold_en )
        dp1_shift_zero <= #`DEL code_is_dp1 & (code_rs[7:0]==8'd0);
    else
	    dp1_shift_zero <= #`DEL 1'b0;
else;

//�����������оٵ��������֯�ڶ�������
always @ ( * )
if ( dp1_lsl_more )
    sec_operand =  32'b0;
else if ( dp1_shift_zero )
    sec_operand = shift_word;
else if ( dp0_rrx_shift )
    sec_operand =  { cpsr_c,shifter_ans[31:1]};
else
    sec_operand =  shifter_ans;

/******************************************************/
//ALU��Ԫ�������ӷ�������һ����߼�����
//reg_rn��Ϊ�ӷ�����һ��������sec_operand��Ϊ�ڶ�����
//�ӷ�����A[31:0]+B[31:0]+c[0]����ͳһ�ļӷ����������ɼ��������趨~B��C[0]=1
/******************************************************/		


//��dpָ���3��7���ʱ��reg_rn��Ҫȡ����ȡ���������DPָ��ģ�RSB��RSC
always @ ( posedge clk or posedge rst )
if ( rst )
    adder_a_inv <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    adder_a_inv <= #`DEL  code_is_dp & ((code[24:21]==4'b0011)|(code[24:21]==4'b0111));
	else;
else;

assign add_a =  adder_a_inv ? ~reg_rn : reg_rn;	


//�ڶ�������sec_operand��Ҫȡ�������
//DPȡ��������ǣ�SUB��SBC��CMP��MVN��֮����������BIC������Ϊ����Rn & add_b��������sec_operand��
always @ ( posedge clk or posedge rst )
if ( rst )
    adder_b_inv <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    if ( code_is_b )
		    adder_b_inv <= #`DEL  1'b0;
	    else if ( code_is_dp )
		    adder_b_inv <= #`DEL  ((code[24:21]==4'b0010)|(code[24:21]==4'b0110)|(code[24:21]==4'b1010)|(code[24:21]==4'b1111)|(code[24:21]==4'b1110));
		else
		    adder_b_inv <= #`DEL  ~code[23];
	else;
else;

assign add_b =  adder_b_inv ? ~sec_operand : sec_operand;

//�ӷ����Ľ�λ���趨������Ϊ������: ���[1]��Ч����ʾʹ��cpsr_c�������λʹ��[0]��
always @ ( posedge clk or posedge rst )
if ( rst )
    add_extra_num <= #`DEL 2'd0;
else if ( cpu_en )
    if ( ~hold_en )
		if ( code_is_b )
		    add_extra_num <= #`DEL  2'b0;
	    else if ( code_is_dp )
            if ( (code[24:21]==4'b0101)|(code[24:21]==4'b0110)|(code[24:21]==4'b0111) )    
                add_extra_num <= #`DEL  2'b10;
	        else if ( (code[24:21]==4'b0010)|(code[24:21]==4'b0011)|(code[24:21]==4'b1010) )
	            add_extra_num <= #`DEL  2'b1;
	        else
	            add_extra_num <= #`DEL  2'b0;
		else
		    add_extra_num <= #`DEL  code[23] ? 2'b0 : 2'b1;
	else;
else;

always @ ( * )
if ( add_extra_num[1] )
    add_c =  cpsr_c;
else
    add_c =  add_extra_num[0];

assign sum_middle =  add_a[30:0] + add_b[30:0] + add_c;

assign high_middle =  add_a[31] + add_b[31] + sum_middle[31];

//�ӷ����Ľ�λbit
assign bit_cy =  high_middle[1];

assign high_bit =  high_middle[0];

//�ӷ������v��־
assign bit_ov =  high_middle[1] ^ sum_middle[31];

//�ӷ������������������˱�DPָ��ʹ���⣬�������ݳص�ָ��ĵ�ַ��������sum_rn_rm����
assign sum_rn_rm =  {high_bit,sum_middle[30:0]};

//�����������& �� &~ ����
assign and_ans =  reg_rn & add_b;

assign eor_ans =  reg_rn ^ sec_operand;

assign or_ans =  reg_rn | sec_operand;

//ALU��������
always @ ( * )
case ( cmd[24:21] )
4'h0 : dp_ans =  and_ans;
4'h1 : dp_ans =  eor_ans;
4'h2 : dp_ans =  sum_rn_rm;
4'h3 : dp_ans =  sum_rn_rm;
4'h4 : dp_ans =  sum_rn_rm;
4'h5 : dp_ans =  sum_rn_rm;
4'h6 : dp_ans =  sum_rn_rm;
4'h7 : dp_ans =  sum_rn_rm;
4'h8 : dp_ans =  and_ans;
4'h9 : dp_ans =  eor_ans;
4'ha : dp_ans =  sum_rn_rm;
4'hb : dp_ans =  sum_rn_rm;
4'hc : dp_ans =  or_ans;
4'hd : dp_ans =  sum_rn_rm;
4'he : dp_ans =  and_ans;
4'hf : dp_ans =  sum_rn_rm;
endcase

/******************************************************/
//to_vld/to_num/to_data����֯�����ǼĴ���ָ��ԼĴ������и�д��ͨ��
/******************************************************/

//����һ�治ͬ��ֻ��code��һ����ָ����н�������cmd��һ������ʹ��code�Ľ����code_to_flag��ʾ��λto_vld�ı�־
always @ ( posedge clk or posedge rst )
if ( rst )
    code_to_flag <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    code_to_flag <= #`DEL  (code_is_mrs|(code_is_dp&(code[24:23]!=2'b10))|((code_is_ldrh0|code_is_ldrh1|code_is_ldrsb0|code_is_ldrsb1|code_is_ldrsh0|code_is_ldrsh1|code_is_ldr0|code_is_ldr1)&( code[21]| ~code[24])));
	else;
else;

//cmd_ok��ʾָ����Ч��������������
//code_to_flag��ʾ��Ҫ��д�Ĵ�����
//(cmd_is_ldm&cmd[21]&(sum_m==5'b0))--��ʾldmָ�������һ������(sum_m��һ���ݼ�������������0 ��ʾ���һ�����ڣ�ʱ����Rn��������
assign to_vld =  cmd_ok & (code_to_flag|(cmd_is_ldm&cmd[21]&(sum_m==5'b0)));

//to_num[3:0]ָʾto_vld��Ҫ��д��һ���Ĵ���������ָ��Ĳ�ͬ��һ����[15:12]��[19:16]
always @ ( posedge clk or posedge rst )
if ( rst )
    to_num <= #`DEL 4'd0;
else if ( cpu_en )
    if ( ~hold_en )
        if ( code_is_mrs|code_is_dp )
            to_num <= #`DEL  code[15:12];
        else
            to_num <= #`DEL  code[19:16];
	else;
else;

//�����MRSָ���ôto_data��Ҫ������֯
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_mrs <= #`DEL 1'd0;
else if ( cpu_en & ~hold_en )
    cmd_is_mrs <= #`DEL  code_is_mrs;
else;

//DP��ָ�to_dataӦ����dp_ans
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_dp <= #`DEL 1'd0;
else if ( cpu_en & ~hold_en )
    cmd_is_dp <= #`DEL  code_is_dp;
else;

//�����DPָ�dp_ans��Ϊto_data������Ļ���sum_rn_rm��Ϊ���ݳ�ָ���Rn�������
always @ ( * )
if ( cmd_is_mrs )
    to_data =  {cpsr_n,cpsr_z,cpsr_c,cpsr_v,28'b0};//cmd[22] ? {spsr[10:7],20'b0,spsr[6:5],1'b0,spsr[4:0]} : {cpsr[10:7],20'b0,cpsr[6:5],1'b0,cpsr[4:0]};
else if ( cmd_is_dp )
    to_data =  dp_ans;
else
    to_data =  sum_rn_rm; 
	
/******************************************************/
//cha_vld/cha_num: ����ʾ�����ݳصĶ�����(������LDM�����Ķ�����ָ��)
/******************************************************/

//code_cha_flag��ʾ��ָ�������swp��ǰһ�����ڶ�������swp�ĺ�һ��������д��������ˣ���hold_en����1ʱ��code_cha_flag�������0��
always @ ( posedge clk or posedge rst )
if ( rst )
    code_cha_flag <= #`DEL 1'd0;
else if ( cpu_en) 
    if ( ~hold_en )
        code_cha_flag <= #`DEL  (( code_is_ldrh0|code_is_ldrh1|code_is_ldrsb0|code_is_ldrsb1|code_is_ldrsh0|code_is_ldrsh1|code_is_ldr0|code_is_ldr1 ) & code[20])|code_is_swp;
    else
	    code_cha_flag <= #`DEL 1'b0;
else;	

assign cha_vld =  cmd_ok & code_cha_flag;

assign cha_num =  cmd[15:12];	

//һ���漰����R15�Ķ�ָ����������ˮ��
assign cha_rf_vld =  cha_vld & ( cha_num==4'hf );

//��������д�Ĵ�������ʽ��[3]��ʾ��/�ֽڲ�����[2]��ʾ���ֲ���;[1]��ʾ�з����ֽ�; [0]��ʾ�з��Ű��ֲ���
always @ ( posedge clk or posedge rst )
if ( rst )
    cha_fmt <= #`DEL 4'd0;
else if ( cpu_en & ~hold_en )
    cha_fmt <= #`DEL  {(code_is_ldr0|code_is_ldr1|code_is_swp),(code_is_ldrh0|code_is_ldrh1),(code_is_ldrsb0|code_is_ldrsb1),(code_is_ldrsh0|code_is_ldrsh1)};
else;

/******************************************************/
//go_vld/go_num: ����ʾ�����ݳصĶ�����(������LDM�����Ķ�����ָ��)�ĺ�����д�Ĵ�������
/******************************************************/	
always @ ( posedge clk or posedge rst )
if ( rst )
    go_vld <= #`DEL 1'd0;
else if ( cpu_en )
    go_vld <= #`DEL  cha_vld;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    go_num <= #`DEL 4'd0;
else if ( cpu_en )
    go_num <= #`DEL  cha_num;
else;

assign go_rf_vld =  go_vld & (go_num==4'hf);

//����������һ���ĸ�ʽ��[5]��ʾ�ֲ�����[4]��ʾ���ֲ�����[3]��ʾ�ֽڲ�����[2]��ʾ�Ƿ��з��ţ�[1:0]������ַ�ĺ���bit���ڰ���/�ֽڲ���ʱ�����ο�	
always @ ( posedge clk or posedge rst )
if ( rst )
    go_fmt <= #`DEL 6'd0;
else if ( cpu_en )
   if ( cha_fmt[3] )
        go_fmt <= #`DEL  cmd[22] ?{4'b0010,cmd_addr[1:0]}: {4'b1000,cmd_addr[1:0]};
    else if ( cha_fmt[2] )
        go_fmt <= #`DEL  {4'b0100,cmd_addr[1:0]};
	else if ( cha_fmt[1] )
	    go_fmt <= #`DEL  {4'b0011,cmd_addr[1:0]};
	else if ( cha_fmt[0] )
        go_fmt <= #`DEL  {4'b0101,cmd_addr[1:0]};
    else
	    go_fmt <= #`DEL  {4'b1000,cmd_addr[1:0]};
else;	

//����go_fmt�ĸ�ʽ����ram_rdata������֯���õ�go_data��������д��Ĵ�������������ݸ�ʽ
always @ ( * )
if ( go_fmt[5] )
    go_data =  ram_rdata;
else if ( go_fmt[4] )
    if ( go_fmt[1] )
	    go_data =  {{16{go_fmt[2]&ram_rdata[31]}},ram_rdata[31:16]};
	else
	    go_data =  {{16{go_fmt[2]&ram_rdata[15]}},ram_rdata[15:0]};
else// if ( go_fmt[3] )
    case(go_fmt[1:0])
    2'b00 : go_data =  { {24{go_fmt[2]&ram_rdata[7]}}, ram_rdata[7:0] };
    2'b01 : go_data =  { {24{go_fmt[2]&ram_rdata[15]}}, ram_rdata[15:8] };	
    2'b10 : go_data =  { {24{go_fmt[2]&ram_rdata[23]}}, ram_rdata[23:16] };	
    2'b11 : go_data =  { {24{go_fmt[2]&ram_rdata[31]}}, ram_rdata[31:24] };	
    endcase	

/******************************************************/
//ldm_vld/ldm_num��ldmָ��ԼĴ����ĸ�дͨ��
/******************************************************/

//��ָ����LDM����sum_m������0ʱ����ʾͨ��LDMָ�����ʽ�������ݳ�ָ�����ʽ�����˼Ĵ�����
//ldm_vld��ͬ��go_vld�����߶�Ӧ��ͬ��ָ�����λ��ͬ
always @ ( posedge clk or posedge rst )
if ( rst )
    ldm_vld <= #`DEL 1'd0;
else if ( cpu_en )
    ldm_vld <= #`DEL  cmd_ok & cmd_is_ldm & cmd[20] & (sum_m!=5'b0);
else;

//��ldmָ��ִ��ʱ��cmd[15:0]���ϵݼ����ӵ͵��߲��ϱ�Ϊ0�������ͨ��ldm_sel�õ���ǰָ��ļĴ�������һ��
always @ ( * )
if ( cmd[0] )
    ldm_sel =  4'h0;
else if ( cmd[1] )
    ldm_sel =  4'h1; 
else if ( cmd[2] )
    ldm_sel =  4'h2; 
else if ( cmd[3] )
    ldm_sel =  4'h3; 
else if ( cmd[4] )
    ldm_sel =  4'h4; 
else if ( cmd[5] )
    ldm_sel =  4'h5; 
else if ( cmd[6] )
    ldm_sel =  4'h6; 
else if ( cmd[7] )
    ldm_sel =  4'h7; 
else if ( cmd[8] )
    ldm_sel =  4'h8; 
else if ( cmd[9] )
    ldm_sel =  4'h9; 
else if ( cmd[10] )
    ldm_sel =  4'ha; 
else if ( cmd[11] )
    ldm_sel =  4'hb; 
else if ( cmd[12] )
    ldm_sel =  4'hc; 
else if ( cmd[13] )
    ldm_sel =  4'hd; 
else if ( cmd[14] )
    ldm_sel =  4'he; 
else if ( cmd[15] )
    ldm_sel =  4'hf; 
else 
    ldm_sel =  4'h0;

//ldm_num��ͬ��go_num
always @ ( posedge clk or posedge rst )
if ( rst )
    ldm_num <= #`DEL 4'd0;
else if ( cpu_en )
    ldm_num <= #`DEL  ldm_sel;
else;

assign ldm_rf_vld =  (ldm_vld & ( ldm_num==4'hf )) ;	

//ldm_data����go_data�����ǰ�ram_rdataд�뵽�Ĵ�����
assign ldm_data =  go_data;

/******************************************************/
//���ݳض˵Ľӿ��źţ�ram_cen/ram_wen/ram_flag/ram_addr/ram_wdata)
/******************************************************/

always @ ( posedge clk or posedge rst )
if ( rst )
    code_cen <= #`DEL 1'd0;
else if ( cpu_en & ~hold_en )
    code_cen <= #`DEL  (code_is_ldrh0|code_is_ldrh1|code_is_ldrsb0|code_is_ldrsb1|code_is_ldrsh0|code_is_ldrsh1|code_is_ldr0|code_is_ldr1|code_is_swp);
else;

//cen��Ϊ���ݳض˿ڵĿ����źţ�����һ��Ķ�дָ���LDM����ָ����ɣ�һ��ָ����Ч����ôram_cen���д�
assign ram_cen =  cpu_en & cmd_ok & (code_cen|(cmd_is_ldm &(sum_m!=5'b0)));

//ram_wen��cmd[20]������һ��������swpָ���ǰһ������ǿ�ƶ���������һ����д����
assign ram_wen =  cmd_is_swp ? 1'b0 : ~cmd[20];	

//SWP��ǰ������������cmd_is_swp��cmd_is_swpx��ʾ
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_swp <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    cmd_is_swp <= #`DEL  code_is_swp;
	else
	    cmd_is_swp <= #`DEL  1'b0;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_swpx <= #`DEL 1'd0;
else if ( cpu_en )
    cmd_is_swpx <= #`DEL  cmd_is_swp;
else;

//ram_flag��ʾ�����ݳز������ֲ��������ֲ��������ֽڲ����������cha_fmt���ɵõ�
always @ ( * )
if ( cha_fmt[3] )
    ram_flag =  cmd[22]? (1'b1<<cmd_addr[1:0]):4'b1111;
else if ( cha_fmt[2]|cha_fmt[0] )
    ram_flag =  cmd_addr[1] ? 4'b1100 : 4'b0011;
else if ( cha_fmt[1] ) 
    ram_flag =  1'b1<<cmd_addr[1:0];
else
    ram_flag =  4'b1111;

//ram_addr�����Ǽӷ��Ľ����Ҳ������Rn������cmd[24]��������
//�����LDMָ���ǿ��ʹ�üӷ������������ΪLDM�ĵ�ַ�ǵ�����ݼ���
//SWPָ��ǿ��ʹ��Rn	
assign cmd_addr =  ( (cmd[24]|cmd_is_ldm)& ~cmd_is_swp & ~cmd_is_swpx ) ? sum_rn_rm : reg_rn;

//ram_addr�����2 bitǿ�Ƶ���0��ram_flag����ʾ�ֽ�/����/�ֲ����ľ��庬��
assign ram_addr =  {cmd_addr[31:2],2'b0};

//Rt��д����ram_wdata��Դͷ������ͨ��code_rt_num�õ�Rt�����
//Rt����д�����ã�����ָ��ͬ��ʹ�õ���	
always @ ( posedge clk or posedge rst )
if ( rst )
    code_rt_num <= #`DEL 4'd0;
else if ( cpu_en & ~hold_en )
	code_rt_num <= #`DEL  code_is_swp ? code[3:0] : code[15:12];
else;

//�����LDMָ�ldm_sel��Ϊд���ݵļĴ������	
assign rt_num =  cmd_is_ldm ? ldm_sel : code_rt_num;

always @ ( * )
case ( rt_num )
4'h0 : rt =  r0;
4'h1 : rt =  r1;	
4'h2 : rt =  r2;
4'h3 : rt =  r3;
4'h4 : rt =  r4;
4'h5 : rt =  r5;	
4'h6 : rt =  r6;
4'h7 : rt =  r7;	
4'h8 : rt =  r8;
4'h9 : rt =  r9;	
4'ha : rt =  ra;
4'hb : rt =  rb;
4'hc : rt =  rc;
4'hd : rt =  rd;	
4'he : rt =  re;
4'hf : rt =  rf;
endcase

//д����ͬ��������/����/�ֽڵ����⣬��cha_fmt������
always @ ( * )
if ( cha_fmt[3] )
    if ( cmd[22] )
	    ram_wdata =  { rt[7:0],rt[7:0],rt[7:0],rt[7:0]};
    else
        ram_wdata =  rt;	
else if ( cha_fmt[2] )
    ram_wdata =  {rt[15:0],rt[15:0]};
else
    ram_wdata =  rt;

/******************************************************/
//�Ĵ����������
/******************************************************/

//����to_vld/go_vld/ldm_vld����ͨ����ָ���ͨ��������ͨ���������и�д
always @ ( posedge clk or posedge rst )
if ( rst )
    r0 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h0 ) )
	    r0 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h0 ) )
	    r0 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h0 ) )
	    r0 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r1 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h1 ) )
	    r1 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h1 ) )
	    r1 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h1 ) )
	    r1 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r2 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h2 ) )
	    r2 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h2 ) )
	    r2 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h2 ) )
	    r2 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r3 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num==4'h3 ) )
	    r3 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h3 ) )
	    r3 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h3 ) )
	    r3 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r4 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h4 ) )
	    r4 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h4 ) )
	    r4 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h4 ) )
	    r4 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r5 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h5 ) )
	    r5 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h5 ) )
	    r5 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h5 ) )
	    r5 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r6 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h6 ) )
	    r6 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h6 ) )
	    r6 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h6 ) )
	    r6 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r7 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num == 4'h7 ) )
	    r7 <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num == 4'h7 ) )
	    r7 <= #`DEL  go_data;
	else if ( to_vld & ( to_num == 4'h7 ) )
	    r7 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r8 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num==4'h8 ) )
	    r8 <= #`DEL  ldm_data;		
	else if ( go_vld & ( go_num==4'h8 ) )
	    r8 <= #`DEL  go_data;
	else if ( to_vld & ( to_num==4'h8 ) )
	    r8 <= #`DEL  to_data;
	else;
else;

always @ ( posedge clk or posedge rst )
if ( rst )
    r9 <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num==4'h9 )  )
	    r9 <= #`DEL  ldm_data;
	else if ( go_vld & (go_num==4'h9) )
	    r9 <= #`DEL  go_data;
	else if ( to_vld & (to_num==4'h9) )
	    r9 <= #`DEL  to_data;
	else;
else; 


always @ ( posedge clk or posedge rst )
if ( rst )
    ra <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num==4'ha )  )
	    ra <= #`DEL  ldm_data;
	else if ( go_vld & (go_num==4'ha) )
	    ra <= #`DEL  go_data;
	else if ( to_vld & (to_num==4'ha) )
	    ra <= #`DEL  to_data;
	else;
else; 

always @ ( posedge clk or posedge rst )
if ( rst )
    rb <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num==4'hb )  )
	    rb <= #`DEL  ldm_data;
	else if ( go_vld & (go_num==4'hb) )
	    rb <= #`DEL  go_data;
	else if ( to_vld & (to_num==4'hb) )
	    rb <= #`DEL  to_data;
	else;
else;  

always @ ( posedge clk or posedge rst )
if ( rst )
    rc <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & ( ldm_num==4'hc )  )
	    rc <= #`DEL  ldm_data;
	else if ( go_vld & (go_num==4'hc) )
	    rc <= #`DEL  go_data;
	else if ( to_vld & (to_num==4'hc) )
	    rc <= #`DEL  to_data;
	else;
else;


always @ ( posedge clk or posedge rst )
if ( rst )
    rd <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & (ldm_num==4'hd) )
	    rd <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num==4'hd ) )
	    rd <= #`DEL  go_data;
	else if ( to_vld & ( to_num==4'hd ) )
	    rd <= #`DEL  to_data;
	else;
else;


always @ ( posedge clk or posedge rst )
if ( rst )
    re <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & (ldm_num==4'he) )
	    re <= #`DEL  ldm_data;
	else if ( go_vld & ( go_num==4'he ) )
	    re <= #`DEL  go_data;
	else if ( cmd_ok & cmd_is_b & cmd[24] )
	    re <= #`DEL  rf_b;
	else if ( to_vld & ( to_num==4'he ) )
	    re <= #`DEL  to_data;
	else;
else;

/******************************************************/
//PSR�Ĵ���֮n,z,c,v
/******************************************************/

//cpsr_n
//MSRָ��
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_msr <= #`DEL 1'd0;
else if ( cpu_en & ~hold_en )
    cmd_is_msr <= #`DEL  code_is_msr0|code_is_msr1;
else;

//cpsr_n�Ĵ�����DPָ�ldmָ�MSRָ��ʱ��Ҫ�ı�
always @ ( * )
if ( cmd_ok & cmd_is_dp & cmd[20] )
    cpsr_n_in =  dp_ans[31];
else if ( cmd_ok & cmd_is_msr & ~cmd[22] & cmd[19] )
    cpsr_n_in =  sec_operand[31];
else
    cpsr_n_in =  cpsr_n;

always @ ( posedge clk or posedge rst )
if ( rst )
    cpsr_n <= #`DEL 1'd0;
else if ( cpu_en )
    cpsr_n <= #`DEL  cpsr_n_in;
else;

//cpsr_z
always @ ( * )
if ( cmd_ok & cmd_is_dp & cmd[20] )
    cpsr_z_in =  (dp_ans==32'b0);	
else if ( cmd_ok & cmd_is_msr & ~cmd[22] & cmd[19] )
    cpsr_z_in =  sec_operand[30];
else
    cpsr_z_in =  cpsr_z;

always @ ( posedge clk or posedge rst )
if ( rst )
    cpsr_z <= #`DEL 1'd0;
else if ( cpu_en )
    cpsr_z <= #`DEL  cpsr_z_in;
else;

//cpsr_c
//cpsr_c��n,z���ƣ���������dp��λʱ����λ��λshift_bit
always @ ( * )
if ( cmd_ok & cmd_is_dp & cmd[20] )
    if ( (cmd[24:21]==4'b1011)|(cmd[24:21]==4'b0100)|(cmd[24:21]==4'b0101)|(cmd[24:21]==4'b0011)|(cmd[24:21]==4'b0111)|(cmd[24:21]==4'b1010)|(cmd[24:21]==4'b0010)|(cmd[24:21]==4'b0110) )
	    cpsr_c_in =  bit_cy;	
    else
        cpsr_c_in =  shift_bit;
else if ( cmd_ok & cmd_is_msr & ~cmd[22] & cmd[19] )
    cpsr_c_in =  sec_operand[29];
else
    cpsr_c_in =  cpsr_c;	

always @ ( posedge clk or posedge rst )
if ( rst )
    cpsr_c <= #`DEL 1'd0;
else if ( cpu_en )
    cpsr_c <= #`DEL  cpsr_c_in;
else;

//���潲��εõ�shift_bit
//���ǰѵõ���λ��λ����λ�����ֿ�����Ϊ�˼ӿ��ٶȡ�����ֻ��֪��Rm->shift_word��Ȼ���ҵ��ý�λbit���ڵ�λ�ã�shift_num
//��ôshift_word[shift_num]��Ϊ��λbit
always @ ( posedge clk or posedge rst )
if ( rst )
    shift_word <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    if ( code[27:25]==3'b001 )
		    shift_word <= #`DEL  code[7:0];
		else 
            shift_word <= #`DEL  code_rm;
    else;
else;	

assign rot_numd =  code[11:7] - 1'b1;

assign rot_nume =  code_rs[4:0] - 1'b1;

//shift_num[4:0]��ʾshift_word�ĵ�nλ����λ��λ��shift_num[6:5]�������⺬�壬������shift_bit��ʵ��	
always @ ( posedge clk or posedge rst )
if ( rst )
    shift_num <= #`DEL 7'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    if ( code_is_dp2 )
		    shift_num <= #`DEL  (code[11:8]==4'h0) ? 7'b10_00000 : {2'b0,rot_numa,1'b0};
		else if ( code_is_dp0 )
		    case( code[6:5] )
			2'h0 : shift_num <= #`DEL  (code[11:7]==5'b0) ? 7'b10_00000 : rot_numb;
			2'h1 : shift_num <= #`DEL   rot_numd;
			2'h2 : shift_num <= #`DEL   rot_numd;
			2'h3 : shift_num <= #`DEL  (code[11:7]==5'b0) ? 7'b0 : rot_numd;
			endcase
		else //if ( code_is_dp1 )
		    if ( code_rs[7:0] == 8'b0 )
			    shift_num <= #`DEL  7'b10_00000;
			else
   			    case( code[6:5] )
			    2'h0 : shift_num <= #`DEL  ( code_rs[7:0]>8'd32 ) ? 7'b01_00000 : rot_numc;
				2'h1 : shift_num <= #`DEL  ( code_rs[7:0]>8'd32 ) ? 7'b01_00000 : rot_nume;
                2'h2 : shift_num <= #`DEL  ( code_rs[7:0]>8'd32 ) ? 7'b00_11111 : rot_nume;	
                2'h3 : shift_num <= #`DEL  ( code_rs[7:0]==8'd32 )? 7'b10_00000 : rot_nume;
                endcase				
	else;
else;

always @ ( * )
if ( shift_num[6] )
    shift_bit =  cpsr_c;
else if ( shift_num[5] )
    shift_bit =  1'b0;
else
    shift_bit =  shift_word[shift_num[4:0]];	

//cpsr_v
always @ ( * )
if ( cmd_ok & cmd_is_dp & cmd[20] )
    if ( (cmd[24:21]==4'd2)|(cmd[24:21]==4'd3)|(cmd[24:21]==4'd4)|(cmd[24:21]==4'd5)|(cmd[24:21]==4'd6)|(cmd[24:21]==4'd7)|(cmd[24:21]==4'd10)|(cmd[24:21]==4'd11) )
	    cpsr_v_in =  bit_ov;	
    else
        cpsr_v_in =  cpsr_v;
else if ( cmd_ok & cmd_is_msr & ~cmd[22] & cmd[19] )
    cpsr_v_in =  sec_operand[28];
else
    cpsr_v_in =  cpsr_v;	


always @ ( posedge clk or posedge rst )
if ( rst )
    cpsr_v <= #`DEL 1'd0;
else if ( cpu_en )
    cpsr_v <= #`DEL  cpsr_v_in;
else;



/******************************************************/
//ָ�����Ŀ��ƣ�code_flag, cmd_flag, cmd��
/******************************************************/

//һ�������жϻ��PC����Ч�ı䣬code_flag�������㣬����һ�ĵ�codeʧЧ	
always @ ( posedge clk or posedge rst )
if ( rst )
    code_flag <= #`DEL 1'd0;
else if ( cpu_en )
    if (  to_rf_vld | cha_rf_vld | go_rf_vld | ldm_rf_vld )
	    code_flag <= #`DEL  0;
	else
	    code_flag <= #`DEL  1;
else;

//cmd_flag�Ǳ�ʾ������cmd��״̬��һ����˵�����̳���code_flag����Ҳ�б仯
//��hold_en��Ҳ���Ƕ�����ָ��ʱ��cmd_flag���ֲ���
//��wait_en��Ҳ�������ݳ�ͻʱ��cmd_flag�������㣬����һ��������
//��PC(rf)�����κθı�ʱ��cmd_flag���㣬��ʾ��ǰ��ˮ�����	
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_flag <= #`DEL 1'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    if ( wait_en | to_rf_vld | cha_rf_vld | go_rf_vld | ldm_rf_vld )
		    cmd_flag <= #`DEL  0;
		else
		    cmd_flag <= #`DEL  code_flag;
	else;
else;	
	
//cmd��Ϊ��ǰִ��ָ��ı�ʾ��������ʾldmָ���ִ��״̬
//ldmָ�����ÿִ�н���1bit�󣬼����1bit����cmd[15:0]Ϊȫ0ʱ��ldmָ��ִ����ϡ�	
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ~hold_en )
	    cmd <= #`DEL  code;
    else if ( cmd_is_ldm ) begin
	    cmd[0] <= #`DEL 1'b0;
		cmd[1] <= #`DEL cmd[0] ? cmd[1] : 1'b0;
		cmd[2] <= #`DEL (|(cmd[1:0])) ? cmd[2] : 1'b0;
		cmd[3] <= #`DEL (|(cmd[2:0])) ? cmd[3] : 1'b0;		
		cmd[4] <= #`DEL (|(cmd[3:0])) ? cmd[4] : 1'b0;
		cmd[5] <= #`DEL (|(cmd[4:0])) ? cmd[5] : 1'b0;	
		cmd[6] <= #`DEL (|(cmd[5:0])) ? cmd[6] : 1'b0;
		cmd[7] <= #`DEL (|(cmd[6:0])) ? cmd[7] : 1'b0;		
		cmd[8] <= #`DEL (|(cmd[7:0])) ? cmd[8] : 1'b0;
		cmd[9] <= #`DEL (|(cmd[8:0])) ? cmd[9] : 1'b0;	
		cmd[10] <= #`DEL (|(cmd[9:0])) ? cmd[10] : 1'b0;	
		cmd[11] <= #`DEL (|(cmd[10:0])) ? cmd[11] : 1'b0;	    
		cmd[12] <= #`DEL (|(cmd[11:0])) ? cmd[12] : 1'b0;	 
		cmd[13] <= #`DEL (|(cmd[12:0])) ? cmd[13] : 1'b0;	
		cmd[14] <= #`DEL (|(cmd[13:0])) ? cmd[14] : 1'b0;	 
		cmd[15] <= #`DEL (|(cmd[14:0])) ? cmd[15] : 1'b0;	 		
        end	
	else;
else;

//���������ݳ�ͻwait_en
//�ڶ���ָ��code������

assign code_rm_vld =  code_is_msr0|code_is_dp0|code_is_bx|code_is_dp1|code_is_mult|code_is_multl|code_is_swp|code_is_ldrh0|code_is_ldrsb0|code_is_ldrsh0|code_is_ldr1;

assign code_rm_num =  code[3:0];

assign code_rs_vld =  code_is_dp1|code_is_mult|code_is_multl;

assign code_rs_num =  code[11:8];

assign code_rn_vld =  code_is_dp0|code_is_dp1|code_is_swp|code_is_ldrh0|code_is_ldrh1|code_is_ldrsb0|code_is_ldrsb1|code_is_ldrsh0|code_is_ldrsh1|code_is_dp2|code_is_ldr0|code_is_ldr1|code_is_ldm;

assign code_rn_num =  code[19:16];

assign code_rnhi_vld =  ((code_is_ldrh0|code_is_ldrh1|code_is_ldr0|code_is_ldr1|code_is_ldm)& ~code[20]);

reg [3:0] code_ldm_num;
integer i;
always @* begin
code_ldm_num = 0;
for (i=0;i<15;i=i+1)
if (code[14-i])  code_ldm_num = 14-i;
end
		
assign code_rnhi_num =  code_is_ldm ? code_ldm_num : code[15:12];		

//�ڶ���ָ�������͵�����ָ��������cha_vld/go_vld/to_vld�����ص��������ж����ݳ�ͻ��
//cha_vld: cha_num���벻����rm, rs, rn, rnhi�κ�һ����ȣ����򣬱���ȴ�һ�����ڣ��ڲ�������ں�cha_vld��Ϊ0����ͻ��ʧ
//go_vld: rm,rs,rn���ڵڶ����ӼĴ�����ȡ��ʹ�ã�����go_vld�����������ϵ����rnhi,Ҳ����rt�����ڵ������ӼĴ�����ȡ��ʹ�ã������ڳ�ͻ
//to_vld����go_vld����
//ldm_vld: ��go_vld����
//cpsr_m��m_afterһ������ȣ���ʱ�ӼĴ�����ȡ�������ǲ����ʵģ���ʱǿ�Ʋ���һ�������ڣ���banked�Ĵ������и���
assign wait_en =  code_flag&( (cha_vld&( (code_rm_vld&(cha_num==code_rm_num))|(code_rs_vld&(cha_num==code_rs_num))|(code_rn_vld&(cha_num==code_rn_num))|(code_rnhi_vld&(cha_num==code_rnhi_num)) )) | (go_vld&( (code_rm_vld&(go_num==code_rm_num))|(code_rs_vld&(go_num==code_rs_num))|(code_rn_vld&(go_num==code_rn_num)) )) | (to_vld&( (code_rm_vld&(to_num==code_rm_num))|(code_rs_vld&(to_num==code_rs_num))|(code_rn_vld&(to_num==code_rn_num)) )) | (ldm_vld & (sum_m==5'b0)&( (code_rm_vld&(ldm_num==code_rm_num))|(code_rs_vld&(ldm_num==code_rs_num))|(code_rn_vld&(ldm_num==code_rn_num)) )) );

//����ִ�е������ж����
always @ ( * )
case ( cmd[31:28] )
4'h0 : cond_satisfy =  ( cpsr_z==1'b1 );
4'h1 : cond_satisfy =  ( cpsr_z==1'b0 );
4'h2 : cond_satisfy =  ( cpsr_c==1'b1 );
4'h3 : cond_satisfy =  ( cpsr_c==1'b0 );
4'h4 : cond_satisfy =  ( cpsr_n==1'b1 );
4'h5 : cond_satisfy =  ( cpsr_n==1'b0 );
4'h6 : cond_satisfy =  ( cpsr_v==1'b1 );
4'h7 : cond_satisfy =  ( cpsr_v==1'b0 );
4'h8 : cond_satisfy =  ( cpsr_c==1'b1 )&(cpsr_z==1'b0);
4'h9 : cond_satisfy =  ( cpsr_c==1'b0 )|(cpsr_z==1'b1);
4'ha : cond_satisfy =  ( cpsr_n==cpsr_v);
4'hb : cond_satisfy =  ( cpsr_n!=cpsr_v);
4'hc : cond_satisfy =  ( cpsr_z==1'b0)&(cpsr_n==cpsr_v);
4'hd : cond_satisfy =  ( cpsr_z==1'b1)|(cpsr_n!=cpsr_v);
4'he : cond_satisfy =  1'b1;
4'hf : cond_satisfy =  1'b0;
endcase

//hold_en��ʾ������ָ��ִ�У�swp����һ�����ڵ�hold_en��ldm�����sum_m�ĵݼ��������	
assign hold_en =  cmd_ok & ( cmd_is_swp | ( cmd_is_ldm & (sum_m !=5'b0) ) );	

//cmd_ok��ʾ��ǰִ�м���ָ���Ƿ���ȷ����������ǰû���жϷ�����cmd_flag��Ч������ִ������
assign cmd_ok =  cmd_flag & cond_satisfy;	
	
/******************************************************/
//PC��rom_en/rom_addr
/******************************************************/	
	
always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_b <= #`DEL 1'd0;
else if ( cpu_en & ~hold_en )
    cmd_is_b <= #`DEL  code_is_b;
else;	

always @ ( posedge clk or posedge rst )
if ( rst )
    cmd_is_bx <= #`DEL 1'd0;
else if ( cpu_en & ~hold_en )
    cmd_is_bx <= #`DEL  code_is_bx;
else;	
	
always @ ( posedge clk or posedge rst )
if ( rst )
    rf <= #`DEL 32'd0;
else if ( cpu_en )
    if ( ldm_vld & (ldm_num==4'hf ) )
        rf <= #`DEL  ldm_data;	
	else if ( go_vld & (go_num==4'hf) )
        rf <= #`DEL  go_data;
    else if ( cmd_ok & cmd_is_dp & ( cmd[24:23]!=2'b10 ) & ( cmd[15:12]==4'hf ) )
	    rf <= #`DEL  dp_ans;	
	else if ( cmd_ok & cmd_is_b )
	    rf <= #`DEL  sum_rn_rm;
	else if ( cmd_ok & cmd_is_bx )
	    rf <= #`DEL  shift_word;
    else if ( ~hold_en & ~wait_en )
        rf <= #`DEL  rf + 3'd4;
    else;
else;	
	
//rfx�ǵ�ǰPC+4��������Rm��Rn�漰��PCʱ��������ǰʹ��	
always @ ( posedge clk or posedge rst )
if ( rst )
    rfx <= #`DEL 32'd0;
else if ( cpu_en & ~hold_en & ~wait_en )
    rfx <= #`DEL  rf + 4'd8;
else;
	
//��һ��ָ��ĵ�ַ������BLָ���ϻ��ж�ʱ����PC	
assign rf_b =  rf - 3'd4;		
	
assign to_rf_vld =  cmd_ok & ( ( (cmd[15:12]==4'hf) & ( cmd_is_dp & ( cmd[24:23]!=2'b10 ) ) ) |  cmd_is_b | cmd_is_bx ); 	

//һ�������쳣��������ȡ��ָ��
assign rom_en =  cpu_en & ( ~( to_rf_vld | cha_rf_vld | go_rf_vld | ldm_rf_vld | wait_en | hold_en ) );

assign rom_addr =  rf;	


endmodule
