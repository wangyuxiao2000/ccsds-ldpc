/*************************************************************/
//function: CCSDS-(1536,1024)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.1.24
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_1536_1024 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
localparam n = 1536;
localparam k = 1024;
localparam sub_size = 64;
localparam G1_1 = 64'h51236781781D416A;
localparam G1_2 = 64'hB0C8419FA21559A8;
localparam G1_3 = 64'h5F14E1E4D88726F1;
localparam G1_4 = 64'h762F6ED6CF32F06D;
localparam G1_5 = 64'h8ABFD971E17A0BE9;
localparam G1_6 = 64'hA5D147741B698D14;
localparam G1_7 = 64'h2A58AB30E2BC32D3;
localparam G1_8 = 64'h9F251FBC5DB8C768;
localparam G2_1 = 64'hD73C205BBEB231CB;
localparam G2_2 = 64'hCAB5EFF5B2C76C71;
localparam G2_3 = 64'hFA70FAD48828355F;
localparam G2_4 = 64'h68C6138FA5524A61;
localparam G2_5 = 64'hBB20031D7AA8FE69;
localparam G2_6 = 64'h432ADE446F49CE27;
localparam G2_7 = 64'h5E5DB9CCCEBD1326;
localparam G2_8 = 64'hE8782B1B01F2ABA2;
localparam G3_1 = 64'h4748E9513B41147A;
localparam G3_2 = 64'h17B1FBB78B4F914C;
localparam G3_3 = 64'h281F5680BA56DE50;
localparam G3_4 = 64'h74B0FB0817E33E2B;
localparam G3_5 = 64'hDD166CFB774B5959;
localparam G3_6 = 64'hAC7FDCEA4FECB5BE;
localparam G3_7 = 64'hED747C81B540D66A;
localparam G3_8 = 64'hB2A6A2039A87967F;
localparam G4_1 = 64'h4780DCB2DC5CBFAE;
localparam G4_2 = 64'h55BC8FF84EC89440;
localparam G4_3 = 64'hE5D411223F09979F;
localparam G4_4 = 64'hDDDE9D940A15A801;
localparam G4_5 = 64'h194064639D254969;
localparam G4_6 = 64'h1BE32DDC829B0032;
localparam G4_7 = 64'h1326515A22EE88A2;
localparam G4_8 = 64'h0EC664DD2D701891;
localparam G5_1 = 64'h69748DFE6372F2EF;
localparam G5_2 = 64'h15F3B0D400ACD68A;
localparam G5_3 = 64'hCF4144CE1FE2581C;
localparam G5_4 = 64'h79B1A55BA59E54AE;
localparam G5_5 = 64'h65A2B47EEBAB0CF3;
localparam G5_6 = 64'h24DD87572CB0F71D;
localparam G5_7 = 64'hF24ABF15590F4DA6;
localparam G5_8 = 64'h9C3BAE51969C6502;
localparam G6_1 = 64'hD3A714B60B22789B;
localparam G6_2 = 64'h3DF5504D80F54C5A;
localparam G6_3 = 64'h9D75CF1465031211;
localparam G6_4 = 64'h09834A0C9F659C99;
localparam G6_5 = 64'hB9241BDF76EB3788;
localparam G6_6 = 64'h6F927251C86DECF1;
localparam G6_7 = 64'h390BE9F5BBB93D05;
localparam G6_8 = 64'hC6F435BFA1FF96B6;
localparam G7_1 = 64'h222461B658DC3E91;
localparam G7_2 = 64'hB01DF2A2EAD2DAA6;
localparam G7_3 = 64'h5572EE6278F6F63A;
localparam G7_4 = 64'h17B63CB2FDA3B97F;
localparam G7_5 = 64'hB233BB259F3D83F7;
localparam G7_6 = 64'hF64760C774989384;
localparam G7_7 = 64'h46F57E03F55B1C0B;
localparam G7_8 = 64'h5AC8A6CEA05466C1;
localparam G8_1 = 64'hAE8825521F85CA31;
localparam G8_2 = 64'h37BEED74B5303407;
localparam G8_3 = 64'h751FC9A15FCEE486;
localparam G8_4 = 64'h93F0F69BD04E72A4;
localparam G8_5 = 64'hC0EBFA3F49DF4DBB;
localparam G8_6 = 64'h03E52D815DC99A1D;
localparam G8_7 = 64'h98FE8BF01BB2CD6D;
localparam G8_8 = 64'h009C5290D81A18F6;
localparam G9_1 = 64'h4FFBAD88545CAA95;
localparam G9_2 = 64'h0C74659FA4828CA3;
localparam G9_3 = 64'h60CE56E32DA28B2E;
localparam G9_4 = 64'h299D4BF82FE54B81;
localparam G9_5 = 64'h51047BE3B3AE4F4B;
localparam G9_6 = 64'hF3AC9578B9477A4C;
localparam G9_7 = 64'h3730F81F92767E11;
localparam G9_8 = 64'h04E84EC3A3AD1F19;
localparam G10_1 = 64'h2D0E0CAB8EDD2185;
localparam G10_2 = 64'hCEFBE8F2F538522A;
localparam G10_3 = 64'h92DAEDC22C441893;
localparam G10_4 = 64'hBCB999157B35619D;
localparam G10_5 = 64'h069951BFB90A08E1;
localparam G10_6 = 64'h54C7E270CBA1656E;
localparam G10_7 = 64'h7FBBB806B6A06FB3;
localparam G10_8 = 64'h7224943B1C3A5723;
localparam G11_1 = 64'h1BAA14752EFCEBC0;
localparam G11_2 = 64'hCFF0894975557623;
localparam G11_3 = 64'hFA95908DC3F34D48;
localparam G11_4 = 64'hFECA650999A26E91;
localparam G11_5 = 64'h245433EBBE9CDA13;
localparam G11_6 = 64'h5771EAFF9B02D8FC;
localparam G11_7 = 64'hBCEBCA573D3775C8;
localparam G11_8 = 64'h1E46F2B951D0EAAB;
localparam G12_1 = 64'h32942F7F4743DDF4;
localparam G12_2 = 64'h8FA2F60AD62095EF;
localparam G12_3 = 64'h80E4A736B5E1A3A3;
localparam G12_4 = 64'h0119062872DAEDF4;
localparam G12_5 = 64'hE78006958CD99F95;
localparam G12_6 = 64'hD20625057C99C7A3;
localparam G12_7 = 64'hB569736DE2167610;
localparam G12_8 = 64'h0E1C6183ADF09FD0;
localparam G13_1 = 64'hE5C492DBB48B319A;
localparam G13_2 = 64'hE2D83ADEFEBBDEFE;
localparam G13_3 = 64'hAA944EEA53C77DB3;
localparam G13_4 = 64'h0FAA85D9C13B1F73;
localparam G13_5 = 64'h8ACED57F3BE4E807;
localparam G13_6 = 64'h33CB72627624F426;
localparam G13_7 = 64'hA0C6E669B5C74980;
localparam G13_8 = 64'hABBAEFEA2D3B69AA;
localparam G14_1 = 64'hF8366DDAE56A6DDC;
localparam G14_2 = 64'hFDED5582F4EA6525;
localparam G14_3 = 64'h4C9628278ED17036;
localparam G14_4 = 64'h6E711B6D20A67966;
localparam G14_5 = 64'h3B28BDF004C21B93;
localparam G14_6 = 64'h1BC37B730FFC1786;
localparam G14_7 = 64'h5D20C81D345FE4B9;
localparam G14_8 = 64'h1D14A5663D369A93;
localparam G15_1 = 64'h5EBD4BD39B2217D0;
localparam G15_2 = 64'h56833BE1CDDBA6BC;
localparam G15_3 = 64'hB288169B4E3BB726;
localparam G15_4 = 64'hC2ED28FBFC395D1F;
localparam G15_5 = 64'h035B30C68F9A6B6F;
localparam G15_6 = 64'h539836A6E56A7B16;
localparam G15_7 = 64'hCEB1525C6ADB65A5;
localparam G15_8 = 64'h5F71754AA458B11A;
localparam G16_1 = 64'h0DB9D180B21C0B13;
localparam G16_2 = 64'h417D86C59DF33E49;
localparam G16_3 = 64'h183A8F6C44DAFA24;
localparam G16_4 = 64'h4E224C180C1F0B45;
localparam G16_5 = 64'hC93CD9CA23658555;
localparam G16_6 = 64'h7DDEC5E9451AD519;
localparam G16_7 = 64'hB122C72A6177EE99;
localparam G16_8 = 64'h1290B4C6B007D973;
/***********************************************************************************************************/
input clk;                 /*系统时钟*/
input rst_n;               /*低电平异步复位信号*/

input s_axis_tdata;        /*输入数据*/
input s_axis_tvalid;       /*输入数据有效标志,高电平有效*/
output reg s_axis_tready;  /*向上游模块发送读请求或读确认信号,高电平有效*/

output reg m_axis_tdata;   /*输出数据*/
output reg m_axis_tvalid;  /*输出数据有效标志,高电平有效*/
output reg m_axis_tlast;   /*码块结束标志位，每完成一个LDPC码块的输出拉高一次*/
input m_axis_tready;       /*下游模块传来的读请求或读确认信号,高电平有效*/



/************************************************进行LDPC编码************************************************/
localparam STATE_waiting_data_in=3'b100;  /*等待输入*/
localparam STATE_data_out=3'b010;         /*输出信息位*/
localparam STATE_check_out=3'b001;        /*输出校验位*/

reg [2:0] state;               /*状态机*/
reg [$clog2(n):0] in_out_cnt;  /*输入/输出计数器*/
reg [n-k-1:0] g;               /*生成矩阵当前所在行*/
reg [n-k-1:0] check;           /*校验位*/

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
                                  check<=check;
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
                               check<=check^(m_axis_tdata?g:0);
                               if(in_out_cnt==k-1)
                                 begin
                                   in_out_cnt<=0;
                                   s_axis_tready<=0;
                                   state<=STATE_check_out;
                                 end
                               else
                                 begin
                                   in_out_cnt<=in_out_cnt+1;
                                   s_axis_tready<=1;
                                   state<=STATE_waiting_data_in;                     
                                 end
                               case(in_out_cnt)
                                 sub_size*1-1 : g<={G2_1,G2_2,G2_3,G2_4,G2_5,G2_6,G2_7,G2_8};
                                 sub_size*2-1 : g<={G3_1,G3_2,G3_3,G3_4,G3_5,G3_6,G3_7,G3_8};
                                 sub_size*3-1 : g<={G4_1,G4_2,G4_3,G4_4,G4_5,G4_6,G4_7,G4_8};
                                 sub_size*4-1 : g<={G5_1,G5_2,G5_3,G5_4,G5_5,G5_6,G5_7,G5_8};
                                 sub_size*5-1 : g<={G6_1,G6_2,G6_3,G6_4,G6_5,G6_6,G6_7,G6_8};
                                 sub_size*6-1 : g<={G7_1,G7_2,G7_3,G7_4,G7_5,G7_6,G7_7,G7_8};
                                 sub_size*7-1 : g<={G8_1,G8_2,G8_3,G8_4,G8_5,G8_6,G8_7,G8_8};
                                 sub_size*8-1 : g<={G9_1,G9_2,G9_3,G9_4,G9_5,G9_6,G9_7,G9_8};
                                 sub_size*9-1 : g<={G10_1,G10_2,G10_3,G10_4,G10_5,G10_6,G10_7,G10_8};
                                 sub_size*10-1 :g<={G11_1,G11_2,G11_3,G11_4,G11_5,G11_6,G11_7,G11_8};
                                 sub_size*11-1 :g<={G12_1,G12_2,G12_3,G12_4,G12_5,G12_6,G12_7,G12_8};
                                 sub_size*12-1 :g<={G13_1,G13_2,G13_3,G13_4,G13_5,G13_6,G13_7,G13_8};
                                 sub_size*13-1 :g<={G14_1,G14_2,G14_3,G14_4,G14_5,G14_6,G14_7,G14_8};
                                 sub_size*14-1 :g<={G15_1,G15_2,G15_3,G15_4,G15_5,G15_6,G15_7,G15_8};
                                 sub_size*15-1 :g<={G16_1,G16_2,G16_3,G16_4,G16_5,G16_6,G16_7,G16_8};
                                 sub_size*16-1 :g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
                                 default : g<={{g[sub_size*7],g[sub_size*8-1:sub_size*7+1]},
                                               {g[sub_size*6],g[sub_size*7-1:sub_size*6+1]},
                                               {g[sub_size*5],g[sub_size*6-1:sub_size*5+1]},
                                               {g[sub_size*4],g[sub_size*5-1:sub_size*4+1]},
                                               {g[sub_size*3],g[sub_size*4-1:sub_size*3+1]},
                                               {g[sub_size*2],g[sub_size*3-1:sub_size*2+1]},
                                               {g[sub_size*1],g[sub_size*2-1:sub_size*1+1]},
                                               {g[sub_size*0],g[sub_size*1-1:sub_size*0+1]}
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
                                m_axis_tdata<=check[n-k-1];
                                m_axis_tvalid<=1;
                                m_axis_tlast<=0;
                                state<=state;
                              end
                            else if(m_axis_tready&&m_axis_tvalid)
                              begin
                                if(in_out_cnt==n-k-1)
                                  begin
                                    in_out_cnt<=0;
                                    check<=0;
                                    s_axis_tready<=1;
                                    m_axis_tdata<=m_axis_tdata;
                                    m_axis_tvalid<=0;
                                    m_axis_tlast<=0;
                                    state<=STATE_waiting_data_in;
                                  end
                                else if(in_out_cnt==n-k-2)
                                  begin
                                    in_out_cnt<=in_out_cnt+1;
                                    check<=check;
                                    s_axis_tready<=0;
                                    m_axis_tdata<=check[n-k-1-in_out_cnt-1];
                                    m_axis_tvalid<=1;
                                    m_axis_tlast<=1;
                                    state<=state;
                                  end
                                else
                                  begin
                                    in_out_cnt<=in_out_cnt+1;
                                    check<=check;
                                    s_axis_tready<=0;
                                    m_axis_tdata<=check[n-k-1-in_out_cnt-1];
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