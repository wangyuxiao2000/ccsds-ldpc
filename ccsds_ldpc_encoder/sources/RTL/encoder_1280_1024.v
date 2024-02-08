/*************************************************************/
//function: CCSDS-(1280,1024)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.1.24
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_1280_1024 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
parameter width = 8; /*支持1、2、4、8、16*/
localparam n = 1280;
localparam k = 1024;
localparam sub_size = 32;
localparam G1_1 = 32'h678ECB51;
localparam G1_2 = 32'hFE821D5C;
localparam G1_3 = 32'hFA5F424B;
localparam G1_4 = 32'hF55927AA;
localparam G1_5 = 32'h3E826913;
localparam G1_6 = 32'h32E04B0C;
localparam G1_7 = 32'h4F88862B;
localparam G1_8 = 32'h803432EF;
localparam G2_1 = 32'h42B27625;
localparam G2_2 = 32'h9F8DA1E1;
localparam G2_3 = 32'hF8472D1B;
localparam G2_4 = 32'hD943D394;
localparam G2_5 = 32'h29261575;
localparam G2_6 = 32'hBA434C68;
localparam G2_7 = 32'h18EF349A;
localparam G2_8 = 32'h27CA1CC4;
localparam G3_1 = 32'hEC900397;
localparam G3_2 = 32'h64A4A063;
localparam G3_3 = 32'h9BCEC4A6;
localparam G3_4 = 32'hD05BA70F;
localparam G3_5 = 32'hE7155BE1;
localparam G3_6 = 32'h7FF09CC1;
localparam G3_7 = 32'h6E2E2059;
localparam G3_8 = 32'h7F1567E5;
localparam G4_1 = 32'h5616101C;
localparam G4_2 = 32'hEA060E2B;
localparam G4_3 = 32'hB673068B;
localparam G4_4 = 32'h923BDF8B;
localparam G4_5 = 32'hB9B9343D;
localparam G4_6 = 32'h049C63A8;
localparam G4_7 = 32'h333E9CFE;
localparam G4_8 = 32'h809B362D;
localparam G5_1 = 32'h9D41634C;
localparam G5_2 = 32'h404E17DA;
localparam G5_3 = 32'h3B4161F2;
localparam G5_4 = 32'h5235992E;
localparam G5_5 = 32'hEA4B4B8B;
localparam G5_6 = 32'h4690BCE1;
localparam G5_7 = 32'hF9DA36A1;
localparam G5_8 = 32'h16439BB1;
localparam G6_1 = 32'h5D7254B5;
localparam G6_2 = 32'h15B4978B;
localparam G6_3 = 32'h00D05224;
localparam G6_4 = 32'h107BD904;
localparam G6_5 = 32'hC85D7E58;
localparam G6_6 = 32'h0451F1A5;
localparam G6_7 = 32'hEE9D1897;
localparam G6_8 = 32'h913DA6F9;
localparam G7_1 = 32'h42819F61;
localparam G7_2 = 32'h343773CA;
localparam G7_3 = 32'h11A6492A;
localparam G7_4 = 32'h4832F43F;
localparam G7_5 = 32'h849C11ED;
localparam G7_6 = 32'hF0FE864F;
localparam G7_7 = 32'hCC270400;
localparam G7_8 = 32'h9726D66E;
localparam G8_1 = 32'h89EE2A44;
localparam G8_2 = 32'h685C1F67;
localparam G8_3 = 32'h1DF6E416;
localparam G8_4 = 32'h507BF2EF;
localparam G8_5 = 32'h8759C2FB;
localparam G8_6 = 32'h52162ABF;
localparam G8_7 = 32'h2B61D3FB;
localparam G8_8 = 32'h988708C4;
localparam G9_1 = 32'h4A8FEA09;
localparam G9_2 = 32'h53452354;
localparam G9_3 = 32'hA33E2E73;
localparam G9_4 = 32'h271E8211;
localparam G9_5 = 32'h16DF62E5;
localparam G9_6 = 32'h03DF81F4;
localparam G9_7 = 32'h8848BD0F;
localparam G9_8 = 32'hF95DF357;
localparam G10_1 = 32'h9BE0A7B3;
localparam G10_2 = 32'h617256EB;
localparam G10_3 = 32'h9A4D0BB4;
localparam G10_4 = 32'hFE3A3A19;
localparam G10_5 = 32'hFAA63D9E;
localparam G10_6 = 32'h65328918;
localparam G10_7 = 32'hD699BA35;
localparam G10_8 = 32'h4CDE6FE0;
localparam G11_1 = 32'h848B1FE5;
localparam G11_2 = 32'h0AB58A6F;
localparam G11_3 = 32'h341707F1;
localparam G11_4 = 32'hEF36474B;
localparam G11_5 = 32'hF623A7A5;
localparam G11_6 = 32'hA35EC9BA;
localparam G11_7 = 32'h24909B6E;
localparam G11_8 = 32'h64A7A898;
localparam G12_1 = 32'hBDDF3BAE;
localparam G12_2 = 32'h7202FA26;
localparam G12_3 = 32'h86F90C57;
localparam G12_4 = 32'hA0399F20;
localparam G12_5 = 32'h972B9A31;
localparam G12_6 = 32'h87B245AE;
localparam G12_7 = 32'hE0C5A338;
localparam G12_8 = 32'h4959AAD9;
localparam G13_1 = 32'hCF726C27;
localparam G13_2 = 32'h7B38429A;
localparam G13_3 = 32'hBA37C244;
localparam G13_4 = 32'hEE7717DB;
localparam G13_5 = 32'hE45C99CA;
localparam G13_6 = 32'h7E3E013B;
localparam G13_7 = 32'h7B800CA4;
localparam G13_8 = 32'h6527F2E7;
localparam G14_1 = 32'h75C63782;
localparam G14_2 = 32'h1CC40137;
localparam G14_3 = 32'h51E69F16;
localparam G14_4 = 32'h414B155F;
localparam G14_5 = 32'hDF1964DE;
localparam G14_6 = 32'hF13C71F7;
localparam G14_7 = 32'h6E9E8044;
localparam G14_8 = 32'h6C5CEC86;
localparam G15_1 = 32'h6F2A6DF8;
localparam G15_2 = 32'h9FF2BF82;
localparam G15_3 = 32'hD3625355;
localparam G15_4 = 32'h24466981;
localparam G15_5 = 32'hD5F14AC1;
localparam G15_6 = 32'hE1C24AEA;
localparam G15_7 = 32'hA8850D83;
localparam G15_8 = 32'h7A3C5120;
localparam G16_1 = 32'hBAABADC3;
localparam G16_2 = 32'h1ECF066D;
localparam G16_3 = 32'h76538348;
localparam G16_4 = 32'hFC5D4D54;
localparam G16_5 = 32'h43AD46CF;
localparam G16_6 = 32'h3342012C;
localparam G16_7 = 32'h63EBE2DC;
localparam G16_8 = 32'hD832EF8E;
localparam G17_1 = 32'hE6EC82F1;
localparam G17_2 = 32'h4AAFE782;
localparam G17_3 = 32'h14D89E38;
localparam G17_4 = 32'h23C83402;
localparam G17_5 = 32'h8B48D6BF;
localparam G17_6 = 32'hC823B89A;
localparam G17_7 = 32'h68A35626;
localparam G17_8 = 32'hE89FE121;
localparam G18_1 = 32'h4BBAA331;
localparam G18_2 = 32'h20EC16C9;
localparam G18_3 = 32'h6ADABE06;
localparam G18_4 = 32'hD803DA6D;
localparam G18_5 = 32'hFCC89D41;
localparam G18_6 = 32'hE57B10E8;
localparam G18_7 = 32'hCC3FF014;
localparam G18_8 = 32'h4DB74206;
localparam G19_1 = 32'h503FD586;
localparam G19_2 = 32'h52F68B91;
localparam G19_3 = 32'h97D69DF3;
localparam G19_4 = 32'h129C764E;
localparam G19_5 = 32'h8B2143F7;
localparam G19_6 = 32'hA36EF3BA;
localparam G19_7 = 32'h7C27896C;
localparam G19_8 = 32'h560F67B5;
localparam G20_1 = 32'hD70390E6;
localparam G20_2 = 32'h98B337EA;
localparam G20_3 = 32'h89568363;
localparam G20_4 = 32'h2A1681DF;
localparam G20_5 = 32'h4B4E928C;
localparam G20_6 = 32'h41EC3D9C;
localparam G20_7 = 32'hDFD92EB2;
localparam G20_8 = 32'hA5D5C85C;
localparam G21_1 = 32'h2A5088BD;
localparam G21_2 = 32'h76CB6810;
localparam G21_3 = 32'hCB693D21;
localparam G21_4 = 32'hC0E9EFD5;
localparam G21_5 = 32'hF992506E;
localparam G21_6 = 32'h299CE082;
localparam G21_7 = 32'h901155A6;
localparam G21_8 = 32'h0B93AA16;
localparam G22_1 = 32'h18FEFECE;
localparam G22_2 = 32'hB0063536;
localparam G22_3 = 32'h95487089;
localparam G22_4 = 32'h4BB31BB9;
localparam G22_5 = 32'h66F3FD97;
localparam G22_6 = 32'hE32B58A0;
localparam G22_7 = 32'h2A39427A;
localparam G22_8 = 32'h5CD8DE9F;
localparam G23_1 = 32'h1A8F8616;
localparam G23_2 = 32'hC5F7D2B2;
localparam G23_3 = 32'h5AD2BC4E;
localparam G23_4 = 32'hBF1E86DB;
localparam G23_5 = 32'hACF7BFFA;
localparam G23_6 = 32'hF3589597;
localparam G23_7 = 32'hA777654C;
localparam G23_8 = 32'h12DD1364;
localparam G24_1 = 32'hFFC03A59;
localparam G24_2 = 32'hDC450527;
localparam G24_3 = 32'h33B4C871;
localparam G24_4 = 32'hBAA2EA33;
localparam G24_5 = 32'h93A751A6;
localparam G24_6 = 32'hF9D72E4D;
localparam G24_7 = 32'h69B50C7F;
localparam G24_8 = 32'hF74151F9;
localparam G25_1 = 32'h7BE8519D;
localparam G25_2 = 32'hAF6FFAFA;
localparam G25_3 = 32'h268DBA73;
localparam G25_4 = 32'hA356128C;
localparam G25_5 = 32'h0418BE2C;
localparam G25_6 = 32'h1A43465A;
localparam G25_7 = 32'h60C6DF65;
localparam G25_8 = 32'h0E2438A0;
localparam G26_1 = 32'hEC25DC05;
localparam G26_2 = 32'h66AEE4A8;
localparam G26_3 = 32'hA72A030A;
localparam G26_4 = 32'hB11FB610;
localparam G26_5 = 32'hDD74DAF7;
localparam G26_6 = 32'h62F6D565;
localparam G26_7 = 32'h554EAEB7;
localparam G26_8 = 32'h15F7AE6C;
localparam G27_1 = 32'h5147F90A;
localparam G27_2 = 32'hFF0EEC01;
localparam G27_3 = 32'h12A9966C;
localparam G27_4 = 32'h871705B1;
localparam G27_5 = 32'hE935FF30;
localparam G27_6 = 32'h46E32957;
localparam G27_7 = 32'h546D69FC;
localparam G27_8 = 32'hB8A1BD06;
localparam G28_1 = 32'h6A80EA6F;
localparam G28_2 = 32'h71A29506;
localparam G28_3 = 32'hEF78AACF;
localparam G28_4 = 32'h8D52B5ED;
localparam G28_5 = 32'h9F0A4966;
localparam G28_6 = 32'h61B3B68E;
localparam G28_7 = 32'h4B17AF96;
localparam G28_8 = 32'h5B282C2E;
localparam G29_1 = 32'h75582272;
localparam G29_2 = 32'h16E54299;
localparam G29_3 = 32'h7D070B9C;
localparam G29_4 = 32'hAB130157;
localparam G29_5 = 32'h76C619D2;
localparam G29_6 = 32'h5500E2D5;
localparam G29_7 = 32'h1F980459;
localparam G29_8 = 32'h5D9C7F83;
localparam G30_1 = 32'h6A0DDA1D;
localparam G30_2 = 32'hF6E8B610;
localparam G30_3 = 32'h25D0E0A1;
localparam G30_4 = 32'h242749E0;
localparam G30_5 = 32'hFEDA4A06;
localparam G30_6 = 32'h072D69D6;
localparam G30_7 = 32'h03C7DA79;
localparam G30_8 = 32'h51AA3355;
localparam G31_1 = 32'h6E9FEFF0;
localparam G31_2 = 32'h0797CBF1;
localparam G31_3 = 32'hE936C824;
localparam G31_4 = 32'hC9C1EAF5;
localparam G31_5 = 32'hD4607E46;
localparam G31_6 = 32'h88ED7B0E;
localparam G31_7 = 32'h92E160AD;
localparam G31_8 = 32'h731140AD;
localparam G32_1 = 32'h32FEFCAF;
localparam G32_2 = 32'h70863B75;
localparam G32_3 = 32'h3846F110;
localparam G32_4 = 32'hC4E23DFF;
localparam G32_5 = 32'h79D3F753;
localparam G32_6 = 32'h064648FA;
localparam G32_7 = 32'h830452F5;
localparam G32_8 = 32'hB9ED8445;
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
else
  assign check_reg=check_sub[0]^check_sub[1]^check_sub[2]^check_sub[3]^check_sub[4]^check_sub[5]^check_sub[6]^check_sub[7]^check_sub[8]^check_sub[9]^check_sub[10]^check_sub[11]^check_sub[12]^check_sub[13]^check_sub[14]^check_sub[15];
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
                                 sub_size*8-width : g<={G9_1,G9_2,G9_3,G9_4,G9_5,G9_6,G9_7,G9_8};
                                 sub_size*9-width : g<={G10_1,G10_2,G10_3,G10_4,G10_5,G10_6,G10_7,G10_8};
                                 sub_size*10-width: g<={G11_1,G11_2,G11_3,G11_4,G11_5,G11_6,G11_7,G11_8};
                                 sub_size*11-width: g<={G12_1,G12_2,G12_3,G12_4,G12_5,G12_6,G12_7,G12_8};
                                 sub_size*12-width: g<={G13_1,G13_2,G13_3,G13_4,G13_5,G13_6,G13_7,G13_8};
                                 sub_size*13-width: g<={G14_1,G14_2,G14_3,G14_4,G14_5,G14_6,G14_7,G14_8};
                                 sub_size*14-width: g<={G15_1,G15_2,G15_3,G15_4,G15_5,G15_6,G15_7,G15_8};
                                 sub_size*15-width: g<={G16_1,G16_2,G16_3,G16_4,G16_5,G16_6,G16_7,G16_8};
                                 sub_size*16-width: g<={G17_1,G17_2,G17_3,G17_4,G17_5,G17_6,G17_7,G17_8};
                                 sub_size*17-width: g<={G18_1,G18_2,G18_3,G18_4,G18_5,G18_6,G18_7,G18_8};
                                 sub_size*18-width: g<={G19_1,G19_2,G19_3,G19_4,G19_5,G19_6,G19_7,G19_8};
                                 sub_size*19-width: g<={G20_1,G20_2,G20_3,G20_4,G20_5,G20_6,G20_7,G20_8};
                                 sub_size*20-width: g<={G21_1,G21_2,G21_3,G21_4,G21_5,G21_6,G21_7,G21_8};
                                 sub_size*21-width: g<={G22_1,G22_2,G22_3,G22_4,G22_5,G22_6,G22_7,G22_8};
                                 sub_size*22-width: g<={G23_1,G23_2,G23_3,G23_4,G23_5,G23_6,G23_7,G23_8};
                                 sub_size*23-width: g<={G24_1,G24_2,G24_3,G24_4,G24_5,G24_6,G24_7,G24_8};
                                 sub_size*24-width: g<={G25_1,G25_2,G25_3,G25_4,G25_5,G25_6,G25_7,G25_8};
                                 sub_size*25-width: g<={G26_1,G26_2,G26_3,G26_4,G26_5,G26_6,G26_7,G26_8};
                                 sub_size*26-width: g<={G27_1,G27_2,G27_3,G27_4,G27_5,G27_6,G27_7,G27_8};
                                 sub_size*27-width: g<={G28_1,G28_2,G28_3,G28_4,G28_5,G28_6,G28_7,G28_8};
                                 sub_size*28-width: g<={G29_1,G29_2,G29_3,G29_4,G29_5,G29_6,G29_7,G29_8};
                                 sub_size*29-width: g<={G30_1,G30_2,G30_3,G30_4,G30_5,G30_6,G30_7,G30_8};
                                 sub_size*30-width: g<={G31_1,G31_2,G31_3,G31_4,G31_5,G31_6,G31_7,G31_8};
                                 sub_size*31-width: g<={G32_1,G32_2,G32_3,G32_4,G32_5,G32_6,G32_7,G32_8};
                                 sub_size*32-width: g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
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
                               check<=check;
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