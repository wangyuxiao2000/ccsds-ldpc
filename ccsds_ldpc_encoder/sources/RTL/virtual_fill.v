/*************************************************************/
//function: CCSDS-(8160,7136)LDPC编码器输入预处理
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.2.13
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module virtual_fill (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tready);
/************************工作参数设置*************************/
parameter width=8; /*输入/输出位宽,支持8、16*/
/************************************************************/
input clk;                             /*系统时钟*/
input rst_n;                           /*低电平异步复位信号*/

input [width-1:0] s_axis_tdata;        /*输入数据*/
input s_axis_tvalid;                   /*输入数据有效标志,高电平有效*/
output reg s_axis_tready;              /*向上游模块发送读请求或读确认信号,高电平有效*/

output reg [width-1:0] m_axis_tdata;   /*输出数据*/
output reg m_axis_tvalid;              /*输出数据有效标志,高电平有效*/
input m_axis_tready;                   /*下游模块传来的读请求或读确认信号,高电平有效*/



/*************************进行虚拟填充************************/
localparam STATE_zero_out=3'b100;  /*输出0*/
localparam STATE_data_in=3'b010;   /*接收输入*/
localparam STATE_data_out=3'b001;  /*输出数据*/

reg [2:0] state;                      /*状态机*/
reg [$clog2(7136+18+14-1):0] out_cnt; /*输入/输出计数器*/
reg [width-1:0] data_in_reg;
reg [width-1:0] data_out_reg;

generate
if(width==8)
begin
  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      begin
        out_cnt<=0;
        data_in_reg<=0;
        s_axis_tready<=0;
        m_axis_tdata<=0;
        m_axis_tvalid<=0;
        state<=STATE_zero_out;
      end
    else
      begin
        case(state)
          STATE_zero_out : begin
                             if(m_axis_tready&&m_axis_tvalid)
                               begin
                                 out_cnt<=out_cnt+8;
                                 if(out_cnt==8)
                                   begin
                                     if(s_axis_tvalid)
                                       begin
                                         data_in_reg<=s_axis_tdata;
                                         s_axis_tready<=0;
                                         m_axis_tdata<={2'b0,s_axis_tdata[7:2]};
                                         m_axis_tvalid<=1;
                                         state<=STATE_data_out;
                                       end
                                     else
                                       begin
                                         data_in_reg<=data_in_reg;
                                         s_axis_tready<=1;
                                         m_axis_tdata<=m_axis_tdata;
                                         m_axis_tvalid<=0;
                                         state<=STATE_data_in;
                                       end
                                   end
                                 else
                                   begin
                                     data_in_reg<=data_in_reg;
                                     s_axis_tready<=1;
                                     m_axis_tdata<=0;
                                     m_axis_tvalid<=1;
                                     state<=state;
                                   end
                               end
                             else
                               begin
                                 out_cnt<=out_cnt;
                                 data_in_reg<=data_in_reg;
                                 s_axis_tready<=0;
                                 m_axis_tdata<=m_axis_tdata;
                                 m_axis_tvalid<=1;
                                 state<=state;
                               end
                           end
  
          STATE_data_in : begin
                            out_cnt<=out_cnt;
                            if(s_axis_tready&&s_axis_tvalid)
                              begin
                                data_in_reg<=s_axis_tdata;
                                s_axis_tready<=0;
                                m_axis_tdata<=data_out_reg;
                                m_axis_tvalid<=1;
                                state<=STATE_data_out;
                              end
                            else
                              begin
                                data_in_reg<=data_in_reg;
                                s_axis_tready<=s_axis_tready;
                                m_axis_tdata<=m_axis_tdata;
                                m_axis_tvalid<=m_axis_tvalid;
                                state<=state;
                              end
                          end
  
          STATE_data_out : begin
                             data_in_reg<=data_in_reg;
                             if(m_axis_tready&&m_axis_tvalid)
                               begin
                                 if(out_cnt==7160)
                                   begin
                                     out_cnt<=0;
                                     s_axis_tready<=0;
                                     m_axis_tdata<=0;
                                     m_axis_tvalid<=1;
                                     state<=STATE_zero_out;
                                   end
                                 else if(out_cnt==3056 || out_cnt==7152)
                                   begin
                                     out_cnt<=out_cnt+8;
                                     s_axis_tready<=0;
                                     m_axis_tdata<={data_in_reg[6:0],1'b0};
                                     m_axis_tvalid<=1;
                                     state<=state;
                                   end
                                 else
                                   begin
                                     out_cnt<=out_cnt+8;
                                     s_axis_tready<=1;
                                     m_axis_tdata<=m_axis_tdata;
                                     m_axis_tvalid<=0;
                                     state<=STATE_data_in;
                                   end
                               end
                             else
                               begin
                                 out_cnt<=out_cnt;
                                 s_axis_tready<=s_axis_tready;
                                 m_axis_tdata<=m_axis_tdata;
                                 m_axis_tvalid<=m_axis_tvalid;
                                 state<=state;
                               end
                           end
  
          default : begin
                      out_cnt<=0;
                      data_in_reg<=0;
                      s_axis_tready<=0;
                      m_axis_tdata<=0;
                      m_axis_tvalid<=0;
                      state<=STATE_zero_out;
                    end
        endcase
      end
  end
  
  always@(*)
  begin
    if(!rst_n)
      data_out_reg=0;
    else
      begin
        case(out_cnt)
          16 : begin
                 data_out_reg={2'b0,s_axis_tdata[7:2]};
               end
          24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,256,264,272,280,288,296,304,312,320,328,336,344,352,360,368,376,384,392,400,408,416,424,432,440,448,456,464,472,480,488,496,
          4096,4104,4112,4120,4128,4136,4144,4152,4160,4168,4176,4184,4192,4200,4208,4216,4224,4232,4240,4248,4256,4264,4272,4280,4288,4296,4304,4312,4320,4328,4336,4344,4352,4360,4368,4376,4384,4392,4400,4408,4416,4424,4432,4440,4448,4456,4464,4472,4480,4488,4496,4504,4512,4520,4528,4536,4544,4552,4560,4568,4576,4584,4592 :
               begin
                 data_out_reg={data_in_reg[1:0],s_axis_tdata[7:2]};
               end
          504,4600 :
               begin
                 data_out_reg={data_in_reg[1:0],s_axis_tdata[7:3],1'b0};
               end
          512,520,528,536,544,552,560,568,576,584,592,600,608,616,624,632,640,648,656,664,672,680,688,696,704,712,720,728,736,744,752,760,768,776,784,792,800,808,816,824,832,840,848,856,864,872,880,888,896,904,912,920,928,936,944,952,960,968,976,984,992,1000,1008,
          4608,4616,4624,4632,4640,4648,4656,4664,4672,4680,4688,4696,4704,4712,4720,4728,4736,4744,4752,4760,4768,4776,4784,4792,4800,4808,4816,4824,4832,4840,4848,4856,4864,4872,4880,4888,4896,4904,4912,4920,4928,4936,4944,4952,4960,4968,4976,4984,4992,5000,5008,5016,5024,5032,5040,5048,5056,5064,5072,5080,5088,5096,5104 :
               begin
                 data_out_reg={data_in_reg[2:0],s_axis_tdata[7:3]};
               end
          1016,5112 :
               begin
                 data_out_reg={data_in_reg[2:0],s_axis_tdata[7:4],1'b0};
               end
          1024,1032,1040,1048,1056,1064,1072,1080,1088,1096,1104,1112,1120,1128,1136,1144,1152,1160,1168,1176,1184,1192,1200,1208,1216,1224,1232,1240,1248,1256,1264,1272,1280,1288,1296,1304,1312,1320,1328,1336,1344,1352,1360,1368,1376,1384,1392,1400,1408,1416,1424,1432,1440,1448,1456,1464,1472,1480,1488,1496,1504,1512,1520,
          5120,5128,5136,5144,5152,5160,5168,5176,5184,5192,5200,5208,5216,5224,5232,5240,5248,5256,5264,5272,5280,5288,5296,5304,5312,5320,5328,5336,5344,5352,5360,5368,5376,5384,5392,5400,5408,5416,5424,5432,5440,5448,5456,5464,5472,5480,5488,5496,5504,5512,5520,5528,5536,5544,5552,5560,5568,5576,5584,5592,5600,5608,5616 :
               begin
                 data_out_reg={data_in_reg[3:0],s_axis_tdata[7:4]};
               end
          1528,5624 :
               begin
                 data_out_reg={data_in_reg[3:0],s_axis_tdata[7:5],1'b0};
               end
          1536,1544,1552,1560,1568,1576,1584,1592,1600,1608,1616,1624,1632,1640,1648,1656,1664,1672,1680,1688,1696,1704,1712,1720,1728,1736,1744,1752,1760,1768,1776,1784,1792,1800,1808,1816,1824,1832,1840,1848,1856,1864,1872,1880,1888,1896,1904,1912,1920,1928,1936,1944,1952,1960,1968,1976,1984,1992,2000,2008,2016,2024,2032,
          5632,5640,5648,5656,5664,5672,5680,5688,5696,5704,5712,5720,5728,5736,5744,5752,5760,5768,5776,5784,5792,5800,5808,5816,5824,5832,5840,5848,5856,5864,5872,5880,5888,5896,5904,5912,5920,5928,5936,5944,5952,5960,5968,5976,5984,5992,6000,6008,6016,6024,6032,6040,6048,6056,6064,6072,6080,6088,6096,6104,6112,6120,6128 :
               begin
                 data_out_reg={data_in_reg[4:0],s_axis_tdata[7:5]};
               end
          2040,6136 :
               begin
                 data_out_reg={data_in_reg[4:0],s_axis_tdata[7:6],1'b0};
               end
          2048,2056,2064,2072,2080,2088,2096,2104,2112,2120,2128,2136,2144,2152,2160,2168,2176,2184,2192,2200,2208,2216,2224,2232,2240,2248,2256,2264,2272,2280,2288,2296,2304,2312,2320,2328,2336,2344,2352,2360,2368,2376,2384,2392,2400,2408,2416,2424,2432,2440,2448,2456,2464,2472,2480,2488,2496,2504,2512,2520,2528,2536,2544,
          6144,6152,6160,6168,6176,6184,6192,6200,6208,6216,6224,6232,6240,6248,6256,6264,6272,6280,6288,6296,6304,6312,6320,6328,6336,6344,6352,6360,6368,6376,6384,6392,6400,6408,6416,6424,6432,6440,6448,6456,6464,6472,6480,6488,6496,6504,6512,6520,6528,6536,6544,6552,6560,6568,6576,6584,6592,6600,6608,6616,6624,6632,6640 :
               begin
                 data_out_reg={data_in_reg[5:0],s_axis_tdata[7:6]};
               end
          2552,6648 :
               begin
                 data_out_reg={data_in_reg[5:0],s_axis_tdata[7],1'b0};
               end
          2560,2568,2576,2584,2592,2600,2608,2616,2624,2632,2640,2648,2656,2664,2672,2680,2688,2696,2704,2712,2720,2728,2736,2744,2752,2760,2768,2776,2784,2792,2800,2808,2816,2824,2832,2840,2848,2856,2864,2872,2880,2888,2896,2904,2912,2920,2928,2936,2944,2952,2960,2968,2976,2984,2992,3000,3008,3016,3024,3032,3040,3048,3056,
          6656,6664,6672,6680,6688,6696,6704,6712,6720,6728,6736,6744,6752,6760,6768,6776,6784,6792,6800,6808,6816,6824,6832,6840,6848,6856,6864,6872,6880,6888,6896,6904,6912,6920,6928,6936,6944,6952,6960,6968,6976,6984,6992,7000,7008,7016,7024,7032,7040,7048,7056,7064,7072,7080,7088,7096,7104,7112,7120,7128,7136,7144,7152 :
               begin
                 data_out_reg={data_in_reg[6:0],s_axis_tdata[7]};
               end
          3064,7160 :
               begin
                 data_out_reg={data_in_reg[6:0],1'b0};
               end
          3072,3080,3088,3096,3104,3112,3120,3128,3136,3144,3152,3160,3168,3176,3184,3192,3200,3208,3216,3224,3232,3240,3248,3256,3264,3272,3280,3288,3296,3304,3312,3320,3328,3336,3344,3352,3360,3368,3376,3384,3392,3400,3408,3416,3424,3432,3440,3448,3456,3464,3472,3480,3488,3496,3504,3512,3520,3528,3536,3544,3552,3560,3568 :
               begin
                 data_out_reg=s_axis_tdata;
               end
          3576:begin
                 data_out_reg={s_axis_tdata[7:1],1'b0};
               end
          3584,3592,3600,3608,3616,3624,3632,3640,3648,3656,3664,3672,3680,3688,3696,3704,3712,3720,3728,3736,3744,3752,3760,3768,3776,3784,3792,3800,3808,3816,3824,3832,3840,3848,3856,3864,3872,3880,3888,3896,3904,3912,3920,3928,3936,3944,3952,3960,3968,3976,3984,3992,4000,4008,4016,4024,4032,4040,4048,4056,4064,4072,4080 :
               begin
                 data_out_reg={data_in_reg[0],s_axis_tdata[7:1]};
               end
          4088:begin
                 data_out_reg={data_in_reg[0],s_axis_tdata[7:2],1'b0};
               end
          default:data_out_reg=0;
        endcase
      end
  end
end

else if(width==16)
begin
  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      begin
        out_cnt<=0;
        data_in_reg<=0;
        s_axis_tready<=0;
        m_axis_tdata<=0;
        m_axis_tvalid<=0;
        state<=STATE_zero_out;
      end
    else
      begin
        case(state)
          STATE_zero_out : begin
                             data_in_reg<=data_in_reg;
                             m_axis_tdata<=m_axis_tdata;
                             if(m_axis_tready&&m_axis_tvalid)
                               begin
                                 out_cnt<=out_cnt+16;
                                 s_axis_tready<=1;
                                 m_axis_tvalid<=0;
                                 state<=STATE_data_in;
                               end
                             else
                               begin
                                 out_cnt<=out_cnt;
                                 s_axis_tready<=0;
                                 m_axis_tvalid<=1;
                                 state<=state;
                               end
                           end
  
          STATE_data_in : begin
                            out_cnt<=out_cnt;
                            if(s_axis_tready&&s_axis_tvalid)
                              begin
                                data_in_reg<=s_axis_tdata;
                                s_axis_tready<=0;
                                m_axis_tdata<=data_out_reg;
                                m_axis_tvalid<=1;
                                state<=STATE_data_out;
                              end
                            else
                              begin
                                data_in_reg<=data_in_reg;
                                s_axis_tready<=s_axis_tready;
                                m_axis_tdata<=m_axis_tdata;
                                m_axis_tvalid<=m_axis_tvalid;
                                state<=state;
                              end
                          end
  
          STATE_data_out : begin
                             data_in_reg<=data_in_reg;
                             if(m_axis_tready&&m_axis_tvalid)
                               begin
                                 if(out_cnt==7152)
                                   begin
                                     out_cnt<=0;
                                     s_axis_tready<=0;
                                     m_axis_tdata<=0;
                                     m_axis_tvalid<=1;
                                     state<=STATE_zero_out;
                                   end
                                 else if(out_cnt==7136)
                                   begin
                                     out_cnt<=out_cnt+16;
                                     s_axis_tready<=0;
                                     m_axis_tdata<={data_in_reg[14:0],1'b0};
                                     m_axis_tvalid<=1;
                                     state<=state;
                                   end
                                 else
                                   begin
                                     out_cnt<=out_cnt+16;
                                     s_axis_tready<=1;
                                     m_axis_tdata<=m_axis_tdata;
                                     m_axis_tvalid<=0;
                                     state<=STATE_data_in;
                                   end
                               end
                             else
                               begin
                                 out_cnt<=out_cnt;
                                 s_axis_tready<=s_axis_tready;
                                 m_axis_tdata<=m_axis_tdata;
                                 m_axis_tvalid<=m_axis_tvalid;
                                 state<=state;
                               end
                           end
  
          default : begin
                      out_cnt<=0;
                      data_in_reg<=0;
                      s_axis_tready<=0;
                      m_axis_tdata<=0;
                      m_axis_tvalid<=0;
                      state<=STATE_zero_out;
                    end
        endcase
      end
  end

  always@(*)
  begin
    if(!rst_n)
      data_out_reg=0;
    else
      begin
        case(out_cnt)
          16 : begin
                 data_out_reg={2'b0,s_axis_tdata[15:2]};
               end
          32,48,64,80,96,112,128,144,160,176,192,208,224,240,256,272,288,304,320,336,352,368,384,400,416,432,448,464,480 :
               begin
                 data_out_reg={data_in_reg[1:0],s_axis_tdata[15:2]};
               end
          496 :begin
                 data_out_reg={data_in_reg[1:0],s_axis_tdata[15:3],1'b0};
               end
          512,528,544,560,576,592,608,624,640,656,672,688,704,720,736,752,768,784,800,816,832,848,864,880,896,912,928,944,960,976,992 :
               begin
                 data_out_reg={data_in_reg[2:0],s_axis_tdata[15:3]};
               end
          1008:begin
                 data_out_reg={data_in_reg[2:0],s_axis_tdata[15:4],1'b0};
               end
          1024,1040,1056,1072,1088,1104,1120,1136,1152,1168,1184,1200,1216,1232,1248,1264,1280,1296,1312,1328,1344,1360,1376,1392,1408,1424,1440,1456,1472,1488,1504 :
               begin
                 data_out_reg={data_in_reg[3:0],s_axis_tdata[15:4]};
               end
          1520:begin
                 data_out_reg={data_in_reg[3:0],s_axis_tdata[15:5],1'b0};
               end
          1536,1552,1568,1584,1600,1616,1632,1648,1664,1680,1696,1712,1728,1744,1760,1776,1792,1808,1824,1840,1856,1872,1888,1904,1920,1936,1952,1968,1984,2000,2016 :
               begin
                 data_out_reg={data_in_reg[4:0],s_axis_tdata[15:5]};
               end
          2032:begin
                 data_out_reg={data_in_reg[4:0],s_axis_tdata[15:6],1'b0};
               end
          2048,2064,2080,2096,2112,2128,2144,2160,2176,2192,2208,2224,2240,2256,2272,2288,2304,2320,2336,2352,2368,2384,2400,2416,2432,2448,2464,2480,2496,2512,2528 :
               begin
                 data_out_reg={data_in_reg[5:0],s_axis_tdata[15:6]};
               end
          2544:begin
                 data_out_reg={data_in_reg[5:0],s_axis_tdata[15:7],1'b0};
               end
          2560,2576,2592,2608,2624,2640,2656,2672,2688,2704,2720,2736,2752,2768,2784,2800,2816,2832,2848,2864,2880,2896,2912,2928,2944,2960,2976,2992,3008,3024,3040 :
               begin
                 data_out_reg={data_in_reg[6:0],s_axis_tdata[15:7]};
               end
          3056:begin
                 data_out_reg={data_in_reg[6:0],s_axis_tdata[15:8],1'b0};
               end
          3072,3088,3104,3120,3136,3152,3168,3184,3200,3216,3232,3248,3264,3280,3296,3312,3328,3344,3360,3376,3392,3408,3424,3440,3456,3472,3488,3504,3520,3536,3552 :
               begin
                 data_out_reg={data_in_reg[7:0],s_axis_tdata[15:8]};
               end
          3568:begin
                 data_out_reg={data_in_reg[7:0],s_axis_tdata[15:9],1'b0};
               end
          3584,3600,3616,3632,3648,3664,3680,3696,3712,3728,3744,3760,3776,3792,3808,3824,3840,3856,3872,3888,3904,3920,3936,3952,3968,3984,4000,4016,4032,4048,4064 :
               begin
                 data_out_reg={data_in_reg[8:0],s_axis_tdata[15:9]};
               end
          4080:begin
                 data_out_reg={data_in_reg[8:0],s_axis_tdata[15:10],1'b0};
               end
          4096,4112,4128,4144,4160,4176,4192,4208,4224,4240,4256,4272,4288,4304,4320,4336,4352,4368,4384,4400,4416,4432,4448,4464,4480,4496,4512,4528,4544,4560,4576 :
               begin
                 data_out_reg={data_in_reg[9:0],s_axis_tdata[15:10]};
               end
          4592:begin
                 data_out_reg={data_in_reg[9:0],s_axis_tdata[15:11],1'b0};
               end
          4608,4624,4640,4656,4672,4688,4704,4720,4736,4752,4768,4784,4800,4816,4832,4848,4864,4880,4896,4912,4928,4944,4960,4976,4992,5008,5024,5040,5056,5072,5088 :
               begin
                 data_out_reg={data_in_reg[10:0],s_axis_tdata[15:11]};
               end
          5104:begin
                 data_out_reg={data_in_reg[10:0],s_axis_tdata[15:12],1'b0};
               end
          5120,5136,5152,5168,5184,5200,5216,5232,5248,5264,5280,5296,5312,5328,5344,5360,5376,5392,5408,5424,5440,5456,5472,5488,5504,5520,5536,5552,5568,5584,5600 :
               begin
                 data_out_reg={data_in_reg[11:0],s_axis_tdata[15:12]};
               end
          5616:begin
                 data_out_reg={data_in_reg[11:0],s_axis_tdata[15:13],1'b0};
               end
          5632,5648,5664,5680,5696,5712,5728,5744,5760,5776,5792,5808,5824,5840,5856,5872,5888,5904,5920,5936,5952,5968,5984,6000,6016,6032,6048,6064,6080,6096,6112 :
               begin
                 data_out_reg={data_in_reg[12:0],s_axis_tdata[15:13]};
               end
          6128:begin
                 data_out_reg={data_in_reg[12:0],s_axis_tdata[15:14],1'b0};
               end
          6144,6160,6176,6192,6208,6224,6240,6256,6272,6288,6304,6320,6336,6352,6368,6384,6400,6416,6432,6448,6464,6480,6496,6512,6528,6544,6560,6576,6592,6608,6624 :
               begin
                 data_out_reg={data_in_reg[13:0],s_axis_tdata[15:14]};
               end
          6640:begin
                 data_out_reg={data_in_reg[13:0],s_axis_tdata[15],1'b0};
               end
          6656,6672,6688,6704,6720,6736,6752,6768,6784,6800,6816,6832,6848,6864,6880,6896,6912,6928,6944,6960,6976,6992,7008,7024,7040,7056,7072,7088,7104,7120,7136 :
               begin
                 data_out_reg={data_in_reg[14:0],s_axis_tdata[15]};
               end
          7152:begin
                 data_out_reg={data_in_reg[14:0],1'b0};
               end
          default:data_out_reg=0;
        endcase
      end
  end
end

else
begin
  
end
endgenerate
/************************************************************/

endmodule