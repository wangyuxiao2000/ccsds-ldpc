/*************************************************************/
//function: CCSDS-(8192,4096)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.1.24
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_8192_4096 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
localparam n = 8192;
localparam k = 4096;
localparam sub_size = 512;
localparam G1_1 = 512'h616DB583006DB99954780CD6DFC9908772D8260D390B1D462A8F62DE8809216194BE0531EE408AEAF27F50F3AD71865AC7910EEF8824A858CA7B13FC843DAFB1;
localparam G1_2 = 512'hBA3E0B010860D09066A8632E2B273DABDF90C26FCDD989C2831874EA7FBA23D940A294111C1B0C1CF62F56A376B94CF64FA594B987B19226E525704D7F2BC66E;
localparam G1_3 = 512'h226C671C22A59AC062490596EB1536C9F66AE799C2489FAD2C131E29ED64A25CB0ADC88D04C5EC8FECD7F78B3825E626858CFAA0DE77772CE8822C7AA39628A0;
localparam G1_4 = 512'h123B1C426E2A93366D067D26DE51362EA0BA916EBD1229521B1B044459B325785F3F3E24199B2460151E4CAA9FD26A5DC46BE0D6DA907EFAF38F413642F702F5;
localparam G1_5 = 512'h324AFD5D62F4CC251FF5C0FD95DE0FAB061F0C92CA5BC97F976118AD84E0663A3BF1B4F07D1CCCC2DF9E09D506B073DED87CC0653C944FC7D438223C0DF3EB67;
localparam G1_6 = 512'hE62AE13F8D4000D616E814045495F6E969C473B059386F5DDBCC25F4002EB132D73A98414D85346F55DEBFF875F7CB9D2466A412D180E0A1ADA18D281376A671;
localparam G1_7 = 512'h8EB0FB6BB7B9AD2A2132010511077F6BD424B6F5B578C11D0076B781930F755EBB72C41ED17519476C257C31C3159BF31FADA2755F1B8A23B22D6A428AA290E2;
localparam G1_8 = 512'h54CC73C7599AB67C6807C4286BECF8423F3216EF04E1B6DE61349DDB23E3A0EB0EF70C5BE1AD91D31B0BB532C1098DC619BF80F3853EEA357091C05D95170A7E;
localparam G2_1 = 512'h5E6381A718C0A817F8101ECDCDBF825E732E4356CEC42C222DBC476BD704837C382B7FBF282B739EDC22B5EEA2909F0EB3ACB9E41FE2AC791130A36A9CBFC1D9;
localparam G2_2 = 512'hD4F8DE28FA77F37E4A6B5A82A58CE917CA74C8397E9DB8EDCB2BF65DB91954457707FE876DFF812D4B99466DF479A00114F27E702249DB3E9311301E9CE98703;
localparam G2_3 = 512'h74FEAD0013FD861D67D7CE69D3635ECC6266E862D08B63077B45D3098306EA74159DAEA2263E58705EA5ABE58B7FD41862B9EC1D0F1BD47CD6CB42739C24F7FE;
localparam G2_4 = 512'h7ACFF6D64C8E8F94BEABE280CFDCFCFB26AC7330073C25E0313DCB75E6C5261F15D82AFA665F73A4B4DA4E5D1648EAB051EDEB9857C13C2F019FCBBA4F9DF2E1;
localparam G2_5 = 512'h9CEFF1147D792C14AA2E211C3B9B94B2C9F24F49B0B1ED6E200C88D743F5AC1EE283C3A0AC79B9F1F496BDE74A2AA591ACF2F526FB24413A58B495F91905F596;
localparam G2_6 = 512'hD8F1469BCA9CC5041C50F1FB479CF2680503AD85BA2C0C6D01D2D739F3129315E49A9F57236D9585CC0B8A9B4BFE9ADCD97BED9006C33976ACC00468693D56FA;
localparam G2_7 = 512'h1EE66371B0EA6C4E1E172C2C5D76806CB7376B8CDEAD96B14A1EC2B656298B9425EA2F0671082D70AA23C267D1F215C59239AEB40186DF0AB284625DC6BAF45E;
localparam G2_8 = 512'hFBFBE26BED98BB3B697764A6F82C94039CBF14CB538A7D87801ACBD3A444A858BB74F0A4707592EE6B7DC6D21B8F6B4A184B567C8AA4CD825EBF7F1EDCE015A5;
localparam G3_1 = 512'h25453670647D23C5E445A705953F3BF4A5AF02E7BC46C969C8141D8782F171C9CFF7EBB20945DE5D363AD36D3BD5A0BA081C079CDD04B6E5968187C8A665344A;
localparam G3_2 = 512'h23E9B1897A6FDF427B5E910AA8D71F9CC6351474BC4563C20FD38953295D3BA15E7D1010503B7BA1C148251DB8A88AC64E6AF8C1CC056E4EEF1C927FEC40C35D;
localparam G3_3 = 512'h57140969483D9E33429FAFD177D031A43B727CF832C8DFFE8D8960CB55BE4BE27B69CC26F2FB731B53250D6F8EE7DFDA98812B9AAE9C02AE2FEDEA598D6B6E2F;
localparam G3_4 = 512'h22B6CCA50541BD9F5D48565E551B310E10A0DFCB8035A5EC86EB9CD8C811CDCBCCCEC3732EF93EE8C9418E25CA5744E07C45F9B161E277BCECE388B9B84AAEC4;
localparam G3_5 = 512'hDA37FE277C72CB5CB1BE92AD373867403E46B3535159687ADC79C39DEF7005C1F11F1CBD5F8877DA66AAC156EF27BB893F5F1132336D52E8AEB60EACF9BEB3CF;
localparam G3_6 = 512'hD204D92DFA496DAF564272E3FEC51CE53C8F2DF6ACB191E60E14CDEA28FD5ED0EBE09672ED11A3F6466FE3A967A4EC8390303059AE00DD83102A9F33B2943E4E;
localparam G3_7 = 512'h6E56928E7FEE3333A36FF3EE7598744CF7C298FEF3EACC7CCC0F36DCBA6D87BDD441081163A65E27C958AF79C33A98B81814015E77F82EF5120FBDAB540893B4;
localparam G3_8 = 512'h7BEB68CC37F23835C91F5D36D6BA6F0A5E68FEBB6E6A2F247EB5CF57684D0770249460788DFDC4A1218652BF881B4BB06308EF86484E7070AACC72D3977CF5D0;
localparam G4_1 = 512'h6230DEF1ACD4425F7B155A2A285CB2A32CB9D46DA09B28167826E77AEBD85F0C416595E136184841451F5B3E1F17D02C3DB32C2AF50091D6376406D8CB78A9E3;
localparam G4_2 = 512'hD3B19911ACC450679EAE25B0F290FF372300F1A4BC91A43CB79DB270133D41DC4970F1420E71C0F816EF938C3C17F0FCBB6E920ED853EAF6D2DC6792BF87098A;
localparam G4_3 = 512'hB94C2E5DDE78C974AD6F423CD5ACA01EC9420AAF3FE83BEC31D47AACD3D62FA2476C38595BD66639368181E75B44BAA7ADBC2B42E1D82D7A59312BB9A16F7D35;
localparam G4_4 = 512'h0B13B44D828071E69DD90DCD9B713A05FD8C21AA5E6E6D8DA49A5C3B34F98A4E5E822513F0DA200235C65BFCA1DC2CE4AB21D146B778F6806680B8AC75285760;
localparam G4_5 = 512'hFEF66B861AA67C768A76D585DFADC8EB6556AD841DEA9F44ACB42B6016142B6B69F1833474FADEB0400CE4D9F3BD62AD96E57F3E93DD229180F2D4B5E77D098F;
localparam G4_6 = 512'hEEBE2DFA4D4D86ECB07EEE9565FB589855E1F53BA1B9784A8D195A0E3721551270089C535216636FBEB4D9E50A9EAC3DCB27891A7005A2AD87427E6B8326F6B3;
localparam G4_7 = 512'hCA225C7B2A9EABFFDDDBC130B5342917848B029917BA98FFD6EF2389006A6B417F678C61458EF625C96C0D3D07945ABB9836CF80823EB6244D86D114CC5DC2B1;
localparam G4_8 = 512'h94F5D55C398B16A71497C4CF102C2F1035C19D5DFC8A301B8DE33D41D909C15A3093B09E7489CE6AA14B331B70E76637FE6DDFFFA6DC4C510371CB0D2A6EA3DA;
localparam G5_1 = 512'hAC5F866DD75CD4C2D5959AC37DE4E1E870313A5B2902F234CD939FE39F31FEBF8B46DAC906E3EBA9C3A74DE46E7A9140D3716667BB1EC22A87D5F8D048BDC5BA;
localparam G5_2 = 512'h57B6024327CDDFF3296BE6508C48045B71FA519156F8C125F4E3B7356576F32C63BC588908C4E8B3F9F2D12A9E8F35B6FCF296C17FD8E8D076406FA11D16175F;
localparam G5_3 = 512'hCC45AE82D672979E8A0A359B2328C79AE61F87EBE04DAC9343030548659732000CE627417B3F8CFD4A992E7F2B680216AF773385B9337E1743D43FD965282CF5;
localparam G5_4 = 512'hAE71B0CAFEB4DA3E0B95F1341667C519FB9F89D7CEC711E57485F04A965CDC832CBEC0BE1B2A3E23B5EAF4C5DAD8767E054B2225A60B88BE1DB6A35E0BAEB237;
localparam G5_5 = 512'hA206BC721B252D52EA1F8E311203DFF0AE8D65BD1986055701A3C7FEB2DDEDD2D57C3BBA6A2BC56A9157677D7B48AD2907927176F6B22E8A92F6E9863C9E16D9;
localparam G5_6 = 512'h11B6209E06EFE6ACBBBA2214EF5AEAB9D76645476B2C16B8D14E1AE3F3A85188835922B914D3F32FE05B7987A2516B3D3C8983AE176DFD04349A45359B422E1E;
localparam G5_7 = 512'h01CC2266F2B68A4323F8931D7AA37B1CBD70DC2FEE91592327207AA6121795150A0DC918704A1A293778FE75A99FDCE77E820D0905EF7AC72A682F2487A6E0FE;
localparam G5_8 = 512'h03F42D94FDE1C13F958DF61112DB4A27A8A8EF35087FD089729F0864C2706CCB2B6CBD91A9A7B7B31E08EA3570A6E1BED495FC84FACD829F3234B1D1DC574B67;
localparam G6_1 = 512'h900AA496432959141795C615CBAEA98002440A0D447EF990435E452CC690203BDEBCBA3EEFC7A7CE71EB54B1728AEA9EDE70A7E6A1A8AE86168709A899738CCB;
localparam G6_2 = 512'hC5B7A094AEBEA8EC95A414A8DE5D3DBE6745CB0D330B78435AC2BB6666BB2D43A19EAD3B3D9536D0BB92DB949570981C22805E7DEA452FA649C84EDC4324A7FB;
localparam G6_3 = 512'hE6A9CAF4EE48400720B8F84CAC3A42483B7E571846E2A5F77A983EE311179CEC2D99878FF5AA06ACA0CBBA63B36985E0970761E7F837650BC46C9A2EB1AEFA95;
localparam G6_4 = 512'hAC4D8AA5C970BB55FDF3408356C9EB2683B6FEE593736B66B49C055BD6503EEF3C7CADD15C9B86DCA626E1ABF4B971D04C0A9A5AEF8305C3D0E4CC02C32FA91E;
localparam G6_5 = 512'hD8949EF8FEADF7DA39D395B52D2779A0B305C4FD10C33A434878967D9321B4835C035CA5802C37F6DC1E39AC30337253114176BBB26576317C72E9548F179A5A;
localparam G6_6 = 512'hA200FC35B6A0934D57543A60F6114B7B0D78D8DD8932538E545D806A1D9E47390F092501F4A470CF7B1F9144D0A8F1B0C3D607930A75E5A150233DCEEDB4C10B;
localparam G6_7 = 512'h217C8EB38D4D2A0EF12557321D504ECA670B41E496441FDE341F0232101D4E3F4158FF6F4EAECC073AA811DD450F528BC6095868B7BF953926056BD409E5FE36;
localparam G6_8 = 512'hB82831B150B80A736D6CF7B16660ADCD5E1F4DB96E36E33DCC2F1506C7B8B0F2A4EC362FB0CF7B8B3B08D6CD1AF7440729D4C3C02627AD8733A0C94B2EBAF526;
localparam G7_1 = 512'hFDB4463E6F8FBAF565B1C3320F5704A87309E529842378ECB733784F1CBD85F4F87FB0525C7C4D307061F74DE2FB3BDFBC77E04EAB75A64FFE51203AB925E807;
localparam G7_2 = 512'h1D1101A16A2C41DBDCA94C128560BEFDA4ECA6F22B44C6E5085A23F84106E4FD870FAA789E03FC37086E67B69FC8EB6421AA57FBA27866DFF712D5FEDA21FC51;
localparam G7_3 = 512'h76EE3CB2C4A8629C20FC646A7ADF2A4BE73DCEF53FC926067EB9964996BCEE403C5642CD2F8084E0C14D3627FAD9F0180DADF07331246C007F3AF95CC9B451CC;
localparam G7_4 = 512'h3638887EB493F5EE3361F07E00F115BC04AF404BE6BA3467322B37A8E6ABF47710D56C3BC751892CFD12F29CC4319D0562005562D05261D39FDF528A11E65BBE;
localparam G7_5 = 512'hA0BF07C52E9A9ED7AC3F0FB9196A450E162009509F20BEE74FCC6316BC4824D93CBAC25E470A7468A629EB520E980DE31F8C8873F4ED21B57AAEBF43A5754359;
localparam G7_6 = 512'hCD089ABE548975678C2123223CF3F345AE0CECF0A3726BFBB130E34169A874B6C4CDEFC0A05D7DA1EE475E5407F1535399086700874C13000E2EE21DF3EEFB65;
localparam G7_7 = 512'h4BEF6F2B4137DC6EF197D514E904B8F31BAD6C846D6BD7D7480F4818C3C57B4C7F53F168E48020273702071EE48EC53422C71C90AA0262982B82BB6FF3100D8A;
localparam G7_8 = 512'hEB3E8F033DA73FA82B3B93E50C60E5936A07D3218946588D0EFB39E1A55C0FB9DBA87DA50C4697EE2ED72B004301019E595B92A2F55F7F1B37C2030B79057F52;
localparam G8_1 = 512'h59CA13359E16B10A7F8778BBAF5D45E32C643B524022FE777A8F557C14141D638E84BC4DBB1CE5866CD0B89C1CC5C6F7BF7E25D2B4FC28A16E67CF8BFAC4F4BD;
localparam G8_2 = 512'hA612F30067700487B6584B1AD578659FC2B7443228B2B7B443882DABBF55739CB9660F530631A2CFDCBE94D21692CAC01DA9EB5048FFF17BC4FB5957E8C9DF1F;
localparam G8_3 = 512'h29E0573D85359FB7924AABBDDDCD26F5740FFA6824FCFCBD53BF1DFB587E0667641DD3F82962F5E6EA26461279B0F69479645462983DBBBCC544DA90255121EA;
localparam G8_4 = 512'hA97C7B71923F0382DF60C9E34D84CAC289B578899EBCF924F4304B80581C9887B1198F074143DCC4324D7DF301466AC97903E688DD2E9186EDD2D90C34202AA3;
localparam G8_5 = 512'h90815D489B715FF604788F335322DF5C8856FD85F753785A96F4B2561990F458C69D3F99A8ED1BE99C3F5A14B19B37AC729B3F35ABF52006E814B597145FA3FD;
localparam G8_6 = 512'h86A5A2038BB67CF8225BCCF7A587E0D09B47D26BC4DB017F6A77B6DEC5AF5B117E399D8A336358D4AABE9C8E7EAAF6447638F2DC66EF65C100D06EE202013042;
localparam G8_7 = 512'hAD845A43D23E66FBA72D9D56457D66C7E44D98ED1E5F1D063A5D01043930E9C2EDED8BA9DEE5F9DFF91CD887F097B9A2DF0099E278C253E0A549C7A2D81078C6;
localparam G8_8 = 512'h680566EA7A1E724A99B5D7099AED278A3065BBC64BED441154DCD346D38C9771648D55656B16CF012D0C6EC8F616D3B758089A8147D731AE077D557204256F93;
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
                                 sub_size*8-1 : g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
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