/*************************************************************/
//function: CCSDS-(8160,7136)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2023.12.21
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_8160_7136 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/**************************************************参数设置**************************************************/
parameter width = 8; /*支持1、8、16*/
/***********************************************************************************************************/
input clk;                         /*系统时钟*/
input rst_n;                       /*低电平异步复位信号*/

input [width-1:0] s_axis_tdata;    /*输入数据*/
input s_axis_tvalid;               /*输入数据有效标志,高电平有效*/
output s_axis_tready;              /*向上游模块发送读请求或读确认信号,高电平有效*/

output [width-1:0] m_axis_tdata;   /*输出数据*/
output m_axis_tvalid;              /*输出数据有效标志,高电平有效*/
output m_axis_tlast;               /*码块结束标志位，每完成一个LDPC码块的输出拉高一次*/
input m_axis_tready;               /*下游模块传来的读请求或读确认信号,高电平有效*/



/************************************************进行LDPC编码************************************************/
generate
if(width==1)
begin
  encoder_8160_7136_s U1 (.clk(clk),
                          .rst_n(rst_n),
                          .s_axis_tdata(s_axis_tdata),
                          .s_axis_tvalid(s_axis_tvalid),
                          .s_axis_tready(s_axis_tready),
                          .m_axis_tdata(m_axis_tdata),
                          .m_axis_tvalid(m_axis_tvalid),
                          .m_axis_tlast(m_axis_tlast),
                          .m_axis_tready(m_axis_tready)
                         );
end

else
begin
  wire [width-1:0] s_tdata;
  wire s_tvalid;
  wire s_tready;
  wire [width-1:0] m_tdata;
  wire m_tvalid;
  wire m_tlast;
  wire m_tready;

  wire ready_u1;
  wire ready_u3;
  assign s_axis_tready=ready_u1&&ready_u3;

  virtual_fill #(.width(width)
                ) U1 (.clk(clk),
                      .rst_n(rst_n),
                      .s_axis_tdata(s_axis_tdata),
                      .s_axis_tvalid(s_axis_tvalid&&ready_u3),
                      .s_axis_tready(ready_u1),
                      .m_axis_tdata(s_tdata),
                      .m_axis_tvalid(s_tvalid),
                      .m_axis_tready(s_tready)
                     );

  encoder_8160_7136_p #(.width(width)
                       ) U2 (.clk(clk),
                             .rst_n(rst_n),
                             .s_axis_tdata(s_tdata),
                             .s_axis_tvalid(s_tvalid),
                             .s_axis_tready(s_tready),
                             .m_axis_tdata(m_tdata),
                             .m_axis_tvalid(m_tvalid),
                             .m_axis_tlast(m_tlast),
                             .m_axis_tready(m_tready)
                            );

  virtual_remove #(.width(width)
                  ) U3 (.clk(clk),
                        .rst_n(rst_n),
                        .msg_axis_tdata(s_axis_tdata),
                        .msg_axis_tvalid(s_axis_tvalid&&ready_u1),
                        .msg_axis_tready(ready_u3),
                        .ck_axis_tdata(m_tdata),
                        .ck_axis_tvalid(m_tvalid),
                        .ck_axis_tlast(m_tlast),
                        .ck_axis_tready(m_tready),
                        .m_axis_tdata(m_axis_tdata),
                        .m_axis_tvalid(m_axis_tvalid),
                        .m_axis_tlast(m_axis_tlast),
                        .m_axis_tready(m_axis_tready)
                       );
end
endgenerate
/***********************************************************************************************************/

endmodule