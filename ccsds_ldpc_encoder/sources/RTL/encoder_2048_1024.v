/*************************************************************/
//function: CCSDS-(2048,1024)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.1.24
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_2048_1024 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
parameter width = 8; /*支持1、2、4、8、16、32、64*/
localparam n = 2048;
localparam k = 1024;
localparam sub_size = 128;
localparam G1_1 = 128'hCFA794F49FA5A0D88BB31D8FCA7EA8BB;
localparam G1_2 = 128'hA7AE7EE8A68580E3E922F9E13359B284;
localparam G1_3 = 128'h91F72AE8F2D6BF7830A1F83B3CDBD463;
localparam G1_4 = 128'hCE95C0EC1F609370D7E791C870229C1E;
localparam G1_5 = 128'h71EF3FDF60E2878478934DB285DEC9DC;
localparam G1_6 = 128'h0E95C103008B6BCDD2DAF85CAE732210;
localparam G1_7 = 128'h8326EE83C1FBA56FDD15B2DDB31FE7F2;
localparam G1_8 = 128'h3BA0BB43F83C67BDA1F6AEE46AEF4E62;
localparam G2_1 = 128'h565083780CA89ACAA70CCFB4A888AE35;
localparam G2_2 = 128'h1210FAD0EC9602CC8C96B0A86D3996A3;
localparam G2_3 = 128'hC0B07FDDA73454C25295F72BD5004E80;
localparam G2_4 = 128'hACCF973FC30261C990525AA0CBA006BD;
localparam G2_5 = 128'h9F079F09A405F7F87AD98429096F2A7E;
localparam G2_6 = 128'hEB8C9B13B84C06E42843A47689A9C528;
localparam G2_7 = 128'hDAAA1A175F598DCFDBAD426CA43AD479;
localparam G2_8 = 128'h1BA78326E75F38EB6ED09A45303A6425;
localparam G3_1 = 128'h48F42033B7B9A05149DC839C90291E98;
localparam G3_2 = 128'h9B2CEBE50A7C2C264FC6E7D674063589;
localparam G3_3 = 128'hF5B6DEAEBF72106BA9E6676564C17134;
localparam G3_4 = 128'h6D5954558D23519150AAF88D7008E634;
localparam G3_5 = 128'h1FA962FBAB864A5F867C9D6CF4E087AA;
localparam G3_6 = 128'h5D7AA674BA4B1D8CD7AE9186F1D3B23B;
localparam G3_7 = 128'h047F112791EE97B63FB7B58FF3B94E95;
localparam G3_8 = 128'h93BE39A6365C66B877AD316965A72F5B;
localparam G4_1 = 128'h1B58F88E49C00DC6B35855BFF228A088;
localparam G4_2 = 128'h5C8ED47B61EEC66B5004FB6E65CBECF3;
localparam G4_3 = 128'h77789998FE80925E0237F570E04C5F5B;
localparam G4_4 = 128'hED677661EB7FC3825AB5D5D968C0808C;
localparam G4_5 = 128'h2BDB828B19593F41671B8D0D41DF136C;
localparam G4_6 = 128'hCB47553C9B3F0EA016CC1554C35E6A7D;
localparam G4_7 = 128'h97587FEA91D2098E126EA73CC78658A6;
localparam G4_8 = 128'hADE19711208186CA95C7417A15690C45;
localparam G5_1 = 128'hBE9C169D889339D9654C976A85CFD9F7;
localparam G5_2 = 128'h47C4148E3B4712DAA3BAD1AD71873D3A;
localparam G5_3 = 128'h1CD630C342C5EBB9183ADE9BEF294E8E;
localparam G5_4 = 128'h7014C077A5F96F75BE566C866964D01C;
localparam G5_5 = 128'hE72AC43A35AD216672EBB3259B77F9BB;
localparam G5_6 = 128'h18DA8B09194FA1F0E876A080C9D6A39F;
localparam G5_7 = 128'h809B168A3D88E8E93D995CE5232C2DC2;
localparam G5_8 = 128'hC7CFA44A363F628A668D46C398CAF96F;
localparam G6_1 = 128'hD57DBB24AE27ACA1716F8EA1B8AA1086;
localparam G6_2 = 128'h7B7796F4A86F1FD54C7576AD01C68953;
localparam G6_3 = 128'hE75BE799024482368F069658F7AAAFB0;
localparam G6_4 = 128'h975F3AF795E78D255871C71B4F4B77F6;
localparam G6_5 = 128'h65CD9C359BB2A82D5353E007166BDD41;
localparam G6_6 = 128'h2C5447314DB027B10B130071AD0398D1;
localparam G6_7 = 128'hDE19BC7A6BBCF6A0FF021AABF12920A5;
localparam G6_8 = 128'h58BAED484AF89E29D4DBC170CEF1D369;
localparam G7_1 = 128'h4C330B2D11E15B5CB3815E09605338A6;
localparam G7_2 = 128'h75E3D1A3541E0E284F6556D68D3C8A9E;
localparam G7_3 = 128'hE5BB3B297DB62CD2907F09996967A0F4;
localparam G7_4 = 128'hFF33AEEE2C8A4A52FCCF5C39D355C39C;
localparam G7_5 = 128'h5FE5F09ABA6BCCE02A73401E5F87EAC2;
localparam G7_6 = 128'hD75702F4F57670DFA70B1C002F523EEA;
localparam G7_7 = 128'h6CE1CE2E05D420CB867EC0166B8E53A9;
localparam G7_8 = 128'h9DF9801A1C33058DD116A0AE7278BBB9;
localparam G8_1 = 128'h4CF0B0C792DD8FDB3ECEAE6F2B7F663D;
localparam G8_2 = 128'h106A1C296E47C14C1498B045D57DEFB5;
localparam G8_3 = 128'h968F6D8C790263C353CF307EF90C1F21;
localparam G8_4 = 128'h66E6B632F6614E58267EF096C37718A3;
localparam G8_5 = 128'h3D46E5D10E993EB6DF81518F885EDA1B;
localparam G8_6 = 128'h6FF518FD48BB8E9DDBED4AC0F4F5EB89;
localparam G8_7 = 128'hBCC64D21A65DB379ABE2E4DC21F109FF;
localparam G8_8 = 128'h2EC0CE7B5D40973D13ECF713B01C6F10;
/***********************************************************************************************************/
input clk;                             /*系统时钟*/
input rst_n;                           /*低电平异步复位信号*/

input [width-1:0] s_axis_tdata;        /*输入数据*/
input s_axis_tvalid;                   /*输入数据有效标志,高电平有效*/
output reg s_axis_tready;              /*向上游模块发送读请求或读确认信号,高电平有效*/

output reg [width-1:0] m_axis_tdata;   /*输出数据*/
output reg m_axis_tvalid;              /*输出数据有效标志,高电平有效*/
output reg m_axis_tlast;               /*码块结束标志位，每完成一个LDPC码块的输出拉高一次*/
input m_axis_tready;                   /*下游模块传来的读请求或读确认信号,高电平有效*/



/************************************************进行LDPC编码************************************************/
localparam STATE_waiting_data_in=3'b100;  /*等待输入*/
localparam STATE_data_out=3'b010;         /*输出信息位*/
localparam STATE_check_out=3'b001;        /*输出校验位*/

reg [2:0] state;               /*状态机*/
reg [$clog2(n):0] in_out_cnt;  /*输入/输出计数器*/
reg [n-k-1:0] g;               /*生成矩阵当前所在行*/
reg [n-k-1:0] check;           /*校验位*/

wire [n-k-1:0] check_sub [width-1:0];
wire [n-k-1:0] check_reg;

assign check_sub[width-1]=m_axis_tdata[width-1]?g:0;
genvar i;
generate
for(i=0;i<=width-2;i=i+1)
begin
  assign check_sub[i]=m_axis_tdata[i]?({{g[sub_size*7+width-1-i-1:sub_size*7],g[sub_size*8-1:sub_size*7+width-1-i]},
                                        {g[sub_size*6+width-1-i-1:sub_size*6],g[sub_size*7-1:sub_size*6+width-1-i]},
                                        {g[sub_size*5+width-1-i-1:sub_size*5],g[sub_size*6-1:sub_size*5+width-1-i]},
                                        {g[sub_size*4+width-1-i-1:sub_size*4],g[sub_size*5-1:sub_size*4+width-1-i]},
                                        {g[sub_size*3+width-1-i-1:sub_size*3],g[sub_size*4-1:sub_size*3+width-1-i]},
                                        {g[sub_size*2+width-1-i-1:sub_size*2],g[sub_size*3-1:sub_size*2+width-1-i]},
                                        {g[sub_size*1+width-1-i-1:sub_size*1],g[sub_size*2-1:sub_size*1+width-1-i]},
                                        {g[sub_size*0+width-1-i-1:sub_size*0],g[sub_size*1-1:sub_size*0+width-1-i]}}):0;
end
endgenerate

generate
if(width==1)
  assign check_reg=check_sub[0];
else if(width==2)
  assign check_reg=check_sub[0]^check_sub[1];
else if(width==4)
  assign check_reg=check_sub[0]^check_sub[1]^check_sub[2]^check_sub[3];
else if(width==8)
  assign check_reg=check_sub[0]^check_sub[1]^check_sub[2]^check_sub[3]^check_sub[4]^check_sub[5]^check_sub[6]^check_sub[7];
else if(width==16)
  assign check_reg=check_sub[0]^check_sub[1]^check_sub[2]^check_sub[3]^check_sub[4]^check_sub[5]^check_sub[6]^check_sub[7]^check_sub[8]^check_sub[9]^check_sub[10]^check_sub[11]^check_sub[12]^check_sub[13]^check_sub[14]^check_sub[15];
else if(width==32)
  assign check_reg=check_sub[0]^check_sub[1]^check_sub[2]^check_sub[3]^check_sub[4]^check_sub[5]^check_sub[6]^check_sub[7]^check_sub[8]^check_sub[9]^check_sub[10]^check_sub[11]^check_sub[12]^check_sub[13]^check_sub[14]^check_sub[15]^check_sub[16]^check_sub[17]^check_sub[18]^check_sub[19]^check_sub[20]^check_sub[21]^check_sub[22]^check_sub[23]^check_sub[24]^check_sub[25]^check_sub[26]^check_sub[27]^check_sub[28]^check_sub[29]^check_sub[30]^check_sub[31];
else
  assign check_reg=check_sub[0]^check_sub[1]^check_sub[2]^check_sub[3]^check_sub[4]^check_sub[5]^check_sub[6]^check_sub[7]^check_sub[8]^check_sub[9]^check_sub[10]^check_sub[11]^check_sub[12]^check_sub[13]^check_sub[14]^check_sub[15]^check_sub[16]^check_sub[17]^check_sub[18]^check_sub[19]^check_sub[20]^check_sub[21]^check_sub[22]^check_sub[23]^check_sub[24]^check_sub[25]^check_sub[26]^check_sub[27]^check_sub[28]^check_sub[29]^check_sub[30]^check_sub[31]^check_sub[32]^check_sub[33]^check_sub[34]^check_sub[35]^check_sub[36]^check_sub[37]^check_sub[38]^check_sub[39]^check_sub[40]^check_sub[41]^check_sub[42]^check_sub[43]^check_sub[44]^check_sub[45]^check_sub[46]^check_sub[47]^check_sub[48]^check_sub[49]^check_sub[50]^check_sub[51]^check_sub[52]^check_sub[53]^check_sub[54]^check_sub[55]^check_sub[56]^check_sub[57]^check_sub[58]^check_sub[59]^check_sub[60]^check_sub[61]^check_sub[62]^check_sub[63];
endgenerate

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n)
    begin
      in_out_cnt<=0;
      g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
      check<=0;
      s_axis_tready<=0;
      m_axis_tdata<=0;
      m_axis_tvalid<=0;
      m_axis_tlast<=0;
      state<=STATE_waiting_data_in;
    end
  else
    begin
      case(state)
        STATE_waiting_data_in : begin
                                  in_out_cnt<=in_out_cnt;
                                  g<=g;
                                  m_axis_tlast<=0;
                                  if(s_axis_tready&&s_axis_tvalid)
                                    begin
                                      s_axis_tready<=0;
                                      m_axis_tdata<=s_axis_tdata;
                                      m_axis_tvalid<=1;
                                      state<=STATE_data_out;
                                    end
                                  else
                                    begin
                                      s_axis_tready<=1;
                                      m_axis_tdata<=m_axis_tdata;
                                      m_axis_tvalid<=m_axis_tvalid;
                                      state<=state;
                                    end
                                end

        STATE_data_out : begin
                           m_axis_tdata<=m_axis_tdata;
                           m_axis_tlast<=0;
                           if(m_axis_tready&&m_axis_tvalid)
                             begin
                               m_axis_tvalid<=0;
                               check<=check^check_reg;  
                               if(in_out_cnt==k-width)
                                 begin
                                   in_out_cnt<=0;
                                   s_axis_tready<=0;
                                   state<=STATE_check_out;
                                 end
                               else
                                 begin
                                   in_out_cnt<=in_out_cnt+width;
                                   s_axis_tready<=1;
                                   state<=STATE_waiting_data_in;                     
                                 end
                               case(in_out_cnt)
                                 sub_size*1-width : g<={G2_1,G2_2,G2_3,G2_4,G2_5,G2_6,G2_7,G2_8};
                                 sub_size*2-width : g<={G3_1,G3_2,G3_3,G3_4,G3_5,G3_6,G3_7,G3_8};
                                 sub_size*3-width : g<={G4_1,G4_2,G4_3,G4_4,G4_5,G4_6,G4_7,G4_8};
                                 sub_size*4-width : g<={G5_1,G5_2,G5_3,G5_4,G5_5,G5_6,G5_7,G5_8};
                                 sub_size*5-width : g<={G6_1,G6_2,G6_3,G6_4,G6_5,G6_6,G6_7,G6_8};
                                 sub_size*6-width : g<={G7_1,G7_2,G7_3,G7_4,G7_5,G7_6,G7_7,G7_8};
                                 sub_size*7-width : g<={G8_1,G8_2,G8_3,G8_4,G8_5,G8_6,G8_7,G8_8};
                                 sub_size*8-width : g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
                                 default : g<={{g[sub_size*7+width-1:sub_size*7],g[sub_size*8-1:sub_size*7+width]},
                                               {g[sub_size*6+width-1:sub_size*6],g[sub_size*7-1:sub_size*6+width]},
                                               {g[sub_size*5+width-1:sub_size*5],g[sub_size*6-1:sub_size*5+width]},
                                               {g[sub_size*4+width-1:sub_size*4],g[sub_size*5-1:sub_size*4+width]},
                                               {g[sub_size*3+width-1:sub_size*3],g[sub_size*4-1:sub_size*3+width]},
                                               {g[sub_size*2+width-1:sub_size*2],g[sub_size*3-1:sub_size*2+width]},
                                               {g[sub_size*1+width-1:sub_size*1],g[sub_size*2-1:sub_size*1+width]},
                                               {g[sub_size*0+width-1:sub_size*0],g[sub_size*1-1:sub_size*0+width]}
                                              };
                               endcase
                             end
                           else
                             begin
                               in_out_cnt<=in_out_cnt;
                               g<=g;
                               s_axis_tready<=0;
                               m_axis_tvalid<=m_axis_tvalid;
                               state<=state;
                             end
                         end

        STATE_check_out : begin
                            g<=g;
                            if(!m_axis_tvalid)
                              begin
                                in_out_cnt<=in_out_cnt;
                                check<=check;
                                s_axis_tready<=0;
                                m_axis_tdata<=check[n-k-1:n-k-width];
                                m_axis_tvalid<=1;
                                m_axis_tlast<=0;
                                state<=state;
                              end
                            else if(m_axis_tready&&m_axis_tvalid)
                              begin
                                if(in_out_cnt==n-k-width)
                                  begin
                                    in_out_cnt<=0;
                                    check<=0;
                                    s_axis_tready<=1;
                                    m_axis_tdata<=m_axis_tdata;
                                    m_axis_tvalid<=0;
                                    m_axis_tlast<=0;
                                    state<=STATE_waiting_data_in;
                                  end
                                else if(in_out_cnt==n-k-2*width)
                                  begin
                                    in_out_cnt<=in_out_cnt+width;
                                    check<=check;
                                    s_axis_tready<=0;
                                    m_axis_tdata<=check[(n-k-1-in_out_cnt-width*2+1) +: width];
                                    m_axis_tvalid<=1;
                                    m_axis_tlast<=1;
                                    state<=state;
                                  end
                                else
                                  begin
                                    in_out_cnt<=in_out_cnt+width;
                                    check<=check;
                                    s_axis_tready<=0;
                                    m_axis_tdata<=check[(n-k-1-in_out_cnt-width*2+1) +: width];
                                    m_axis_tvalid<=1;
                                    m_axis_tlast<=0;
                                    state<=state;
                                  end
                              end
                            else
                              begin
                                in_out_cnt<=in_out_cnt;
                                check<=check;
                                s_axis_tready<=0;
                                m_axis_tdata<=m_axis_tdata;
                                m_axis_tvalid<=m_axis_tvalid;
                                m_axis_tlast<=m_axis_tlast;
                                state<=state;
                              end
                          end
                          
        default : begin
                    in_out_cnt<=0;
                    g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
                    check<=0;
                    s_axis_tready<=0;
                    m_axis_tdata<=0;
                    m_axis_tvalid<=0;
                    m_axis_tlast<=0;
                    state<=STATE_waiting_data_in;            
                  end
      endcase
    end
end
/***********************************************************************************************************/

endmodule