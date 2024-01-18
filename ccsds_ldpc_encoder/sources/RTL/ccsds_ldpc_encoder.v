/*************************************************************/
//function: CCSDS-LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2023.12.21
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module ccsds_ldpc_encoder (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
parameter stander = "8160,7136"; /* 设定码长,对于近地应用可选"8176,7154"、"8160,7136"*/
/***********************************************************************************************************/
input clk;             /*系统时钟*/
input rst_n;           /*低电平异步复位信号*/

input s_axis_tdata;    /*输入数据*/
input s_axis_tvalid;   /*输入数据有效标志,高电平有效*/
output s_axis_tready;  /*向上游模块发送读请求或读确认信号,高电平有效*/

output m_axis_tdata;   /*输出数据*/
output m_axis_tvalid;  /*输出数据有效标志,高电平有效*/
output m_axis_tlast;   /*码块结束标志位，每完成一个LDPC码块的输出拉高一次*/
input m_axis_tready;   /*下游模块传来的读请求或读确认信号,高电平有效*/



/************************************************进行LDPC编码************************************************/
generate
if(stander == "8176,7154")
begin
  encoder_8176_7154 U1(.clk(clk),
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

else if(stander == "8160,7136")
begin
  encoder_8160_7136 U1(.clk(clk),
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
  
end
endgenerate
/***********************************************************************************************************/

endmodule