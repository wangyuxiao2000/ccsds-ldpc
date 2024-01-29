/*************************************************************/
//function: CCSDS-LDPC编码器测试激励
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2023.12.21
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ns       /*定义 仿真时间单位/精度*/
`define Period 20            /*定义 时钟周期*/

`define stimulus_path "../sources/TB/stimulus.txt" /*定义 激励文件路径*/
`define response_path "../sources/TB/response.txt" /*定义 响应文件路径*/
`define result_path   "../sources/TB/result.txt"   /*定义 输出文件路径*/

`define stimulus_width  1   /*定义 激励数据位宽*/
`define response_width  1   /*定义 响应数据位宽*/

module ccsds_ldpc_encoder_tb();
/**************************信号定义**************************/
reg clk;
reg rst_n;

reg [`stimulus_width-1:0] s_tdata;
reg s_tvalid;
wire s_tready;

wire [`response_width-1:0] m_tdata;
wire m_tvalid;
wire m_tlast;
reg m_tready;
/************************************************************/



/************************例化待测模块************************/
ccsds_ldpc_encoder #(.stander("8160,7136")
                    ) i1 (.clk(clk),
                          .rst_n(rst_n),
                          .s_axis_tdata(s_tdata),
                          .s_axis_tvalid(s_tvalid),
                          .s_axis_tready(s_tready),
                          .m_axis_tdata(m_tdata),
                          .m_axis_tvalid(m_tvalid),
                          .m_axis_tlast(m_tlast),
                          .m_axis_tready(m_tready)
                         );
/************************************************************/



/*************************时钟及复位*************************/
initial
begin
  clk=0;
  forever
    #(`Period/2) clk=~clk;  
end

initial
begin
  rst_n=0;
  #(`Period*10.75) rst_n=1;
end
/************************************************************/



/**************************施加激励**************************/
integer file_stimulus;
integer stimulus_num=0;
time time_data_in;
reg stimulus_en;

initial
begin
  file_stimulus=$fopen(`stimulus_path,"r");
  s_tdata=0;
  s_tvalid=0;
  stimulus_en=1;
  @(posedge rst_n)/*复位结束后经过两个时钟周期允许施加激励*/
  begin
    @(posedge clk);
    @(posedge clk);
    s_tvalid=1;/*将输入有效标志信号拉高*/
    while(stimulus_en)
      begin
        @(negedge clk)
        begin
          if(s_tready)
            begin
              $fscanf(file_stimulus,"%b",s_tdata); /*数据进制需根据实际stimulus.txt文件设置*/
              if($feof(file_stimulus))
                begin
                  s_tdata=0; /*txt文件中的数据读空后,清零数据输入总线,并将输入有效标志信号拉低*/
                  s_tvalid=0;
                  stimulus_en=0;
                  stimulus_num=stimulus_num;
                  $display("time=%t, Data inputs finish,a total of %d inputs",$time,stimulus_num); 
                end
              else
                begin
                  s_tdata=s_tdata;
                  s_tvalid=1;
                  stimulus_en=1;
                  if(stimulus_num==0)
                    begin
                      $display("time=%t, Data inputs start",$time);
                      time_data_in=$time+`Period/2;
                      stimulus_num=stimulus_num+1;
                    end
                  else
                    stimulus_num=stimulus_num+1;
                end
            end
        end
      end
  end

  $fclose(file_stimulus);
end
/************************************************************/



/****************************对比****************************/
integer file_response;
integer file_result;
integer response_num=0;
time time_data_out;
reg response_en;
reg [`response_width-1:0] response;

initial
begin
  response_en=1;
  m_tready=1;
  file_response=$fopen(`response_path,"r");
  file_result=$fopen(`result_path,"w");
  @(posedge m_tvalid) /*触发条件为复位结束或产生有效输出数据;此处规定产生有效输出数据后开始采集输出数据*/
  begin
    $fscanf(file_response,"%b",response); /*数据进制需根据实际response.txt文件设置*/
    time_data_out=$time;
    while(response_en)
      begin
        @(posedge clk)
        begin
          if($feof(file_response))
            begin
              response=0;
              response_en=0;
              response_num=response_num;
              $display("time=%t, Data outputs finish,a total of %d outputs",$time,response_num);
            end
          else if(m_tvalid)
            begin
              response=response;
              response_en=1;
              $fwrite(file_result,"%b\n",m_tdata); /*数据进制需根据实际result.txt文件设置*/
              if(response_num==0)
                begin
                  $display("time=%t, Data outputs start, the output is delayed by %d clock cycles relative to the input",$time,(time_data_out-time_data_in)/`Period); 
                  response_num=response_num+1;
                end
              else
                response_num=response_num+1;

              if(m_tdata==response)
                $display("time=%t,response_num=%d,rst_n=%b,m_tdata=%b",$time,response_num,rst_n,m_tdata); /*数据进制需根据实际response.txt文件设置*/
              else
                begin
                  $display("TEST FALLED : time=%t,response_num=%d,rst_n=%b,m_tdata is %b but should be %b",$time,response_num,rst_n,m_tdata,response); /*数据进制需根据实际response.txt文件设置*/
                  $finish; /*若遇到测试失败的测试向量后需立即停止测试,则此处需要finish;若遇到测试失败的测试向量后仍继续测试,此处需注释掉finish*/
                end
              $fscanf(file_response,"%b",response); /*数据进制需根据实际response.txt文件设置*/
            end
        end
      end
  end
  $fclose(file_response);
  $fclose(file_result);
  $display("TEST PASSED");
  $finish;
end
/************************************************************/

endmodule