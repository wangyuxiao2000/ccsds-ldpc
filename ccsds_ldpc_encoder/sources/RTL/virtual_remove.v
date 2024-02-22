/*************************************************************/
//function: CCSDS-(8160,7136)LDPC编码器输出处理
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.2.21
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module virtual_remove (clk,rst_n,msg_axis_tdata,msg_axis_tvalid,msg_axis_tready,ck_axis_tdata,ck_axis_tvalid,ck_axis_tlast,ck_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************工作参数设置*************************/
parameter width=8; /*输入/输出位宽,支持8、16*/
/************************************************************/
input clk;                             /*系统时钟*/
input rst_n;                           /*低电平异步复位信号*/

input [width-1:0] msg_axis_tdata;      /*原始数据*/
input msg_axis_tvalid;                 /*原始数据有效标志,高电平有效*/
output reg msg_axis_tready;            /*向上游模块发送读请求或读确认信号,高电平有效*/
input [width-1:0] ck_axis_tdata;       /*校验位*/
input ck_axis_tvalid;                  /*校验位有效标志,高电平有效*/
input ck_axis_tlast;                   /*校验位结束标志位*/
output reg ck_axis_tready;             /*向上游模块发送读请求或读确认信号,高电平有效*/

output reg [width-1:0] m_axis_tdata;   /*输出数据*/
output reg m_axis_tvalid;              /*输出数据有效标志,高电平有效*/
output reg m_axis_tlast;               /*码块结束标志位，每完成一个LDPC码块的输出拉高一次*/
input m_axis_tready;                   /*下游模块传来的读请求或读确认信号,高电平有效*/



/*************************移除虚拟填充************************/
localparam STATE_msg_in=3'b100;    /*信息位输入*/
localparam STATE_ck_in=3'b010;     /*校验位输入*/
localparam STATE_data_out=3'b001;  /*输出数据*/

reg [2:0] state;                   /*状态机*/
reg [$clog2(8160):0] out_cnt;      /*输出计数器*/

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n)
    begin
      out_cnt<=0;
      msg_axis_tready<=0;
      ck_axis_tready<=0;
      m_axis_tdata<=0;
      m_axis_tvalid<=0;
      m_axis_tlast<=0;
      state<=STATE_msg_in;
    end
  else
    begin
      case(state)
        STATE_msg_in : begin
                         out_cnt<=out_cnt;
                         ck_axis_tready<=0;
                         m_axis_tlast<=0;
                         if(msg_axis_tready&&msg_axis_tvalid)
                           begin
                             msg_axis_tready<=0;
                             m_axis_tdata<=msg_axis_tdata;
                             m_axis_tvalid<=1;
                             state<=STATE_data_out;
                           end
                         else
                           begin
                             msg_axis_tready<=1;
                             m_axis_tdata<=m_axis_tdata;
                             m_axis_tvalid<=0;
                             state<=state;
                           end
                       end

        STATE_ck_in : begin
                        out_cnt<=out_cnt;
                        msg_axis_tready<=0;
                        m_axis_tlast<=ck_axis_tlast;
                        if(ck_axis_tready&&ck_axis_tvalid)
                          begin
                            ck_axis_tready<=0;
                            m_axis_tdata<=ck_axis_tdata;
                            m_axis_tvalid<=1;
                            state<=STATE_data_out;
                          end
                        else
                          begin
                            ck_axis_tready<=1;
                            m_axis_tdata<=m_axis_tdata;
                            m_axis_tvalid<=0;
                            state<=state;
                          end
                      end

        STATE_data_out : begin
                           if(m_axis_tready&&m_axis_tvalid)
                             begin
                               m_axis_tdata<=m_axis_tdata;
                               m_axis_tvalid<=0;
                               m_axis_tlast<=0;
                               if(out_cnt==8160-width)
                                 out_cnt<=0;
                               else
                                 out_cnt<=out_cnt+width;
                               if(out_cnt<7136-width || out_cnt==8160-width) /*输出信息位*/
                                 begin
                                   msg_axis_tready<=1;
                                   ck_axis_tready<=0;
                                   state<=STATE_msg_in;
                                 end
                               else /*输出校验位*/
                                 begin
                                   msg_axis_tready<=0;
                                   ck_axis_tready<=1;
                                   state<=STATE_ck_in;
                                 end
                             end
                           else
                             begin
                               out_cnt<=out_cnt;
                               msg_axis_tready<=msg_axis_tready;
                               ck_axis_tready<=ck_axis_tready;
                               m_axis_tdata<=m_axis_tdata;
                               m_axis_tvalid<=m_axis_tvalid;
                               m_axis_tlast<=m_axis_tlast;
                               state<=state;
                             end
                         end

        default : begin
                    out_cnt<=0;
                    msg_axis_tready<=0;
                    ck_axis_tready<=0;
                    m_axis_tdata<=0;
                    m_axis_tvalid<=0;
                    m_axis_tlast<=0;
                    state<=STATE_msg_in;
                  end
      endcase
    end
end
/************************************************************/

endmodule