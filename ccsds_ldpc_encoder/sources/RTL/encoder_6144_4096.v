/*************************************************************/
//function: CCSDS-(6144,4096)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.1.24
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_6144_4096 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
parameter width = 8; /*支持1、2、4、8、16、32、64*/
localparam n = 6144;
localparam k = 4096;
localparam sub_size = 256;
localparam G1_1 = 256'h80924F648C014F2C73889C8B87D0491FA9FA060D2902D7ACC8B679CF61EEB5D9;
localparam G1_2 = 256'h6BB9E90F5C157AA1BF03EF756245D9179063F2CD999EF1E7F7925B3FB7AC7B2D;
localparam G1_3 = 256'h6CD39516B201F491E2BDCA4E34542B5AF3703B3C8EE753FBE998E87323F0B228;
localparam G1_4 = 256'hD1F551B2D7E7822F201E24066584D63CAA00E8DB909EB41C4157EBA0F5C76A50;
localparam G1_5 = 256'hF7C5731746C6DAC260A345189009C0B23372F1E9E0C5A079D00B09158E164B22;
localparam G1_6 = 256'h33D5F8A268041CAB66317898CD0024E3106EED5C2171B3F6276B8EA59AA981E0;
localparam G1_7 = 256'h010BFF3F52A49ED9A6FA7F151FCC72B2AF3BD932065043F7447B4D0FC4A2B93B;
localparam G1_8 = 256'hF8D345E6D2B0008D1B363BFE296B55AF38E3E16EC5856A122E4931CB3F2424B1;
localparam G2_1 = 256'hA099B776C642FF1D84B0DB797098E17E75FE9BB5CF7FA8739711A89660DAF24D;
localparam G2_2 = 256'h3CA8DE5500F68DB449BFF74251B24E4691EAF386C81014C91AC700298E095F0B;
localparam G2_3 = 256'h12CEE8B5F6B93C11AD628CB6CB81F76BE095C2C994A8BDDB4E2C48C942B4D481;
localparam G2_4 = 256'h1F7E191B30E8FFD6D4A7E9BEF81BBB0AE6608F647B1AED9CCA7FEC5498C03F0F;
localparam G2_5 = 256'h1132E816BDFA0C3450C3993911E10EB1097CD7A1F32C54C8B009654E56B25A2D;
localparam G2_6 = 256'h5FD58EEAED460CEFC18E2FBAD2954467E32118F01D05456DEA2926A1E761DF76;
localparam G2_7 = 256'h4C6C7BF3A2245C1B4630775DC59EA74A14EBCD8B5D72E343BC6F7FEA452F2CC2;
localparam G2_8 = 256'hC09CE802B35EBF46D1F3069957DF1D152377F45ADF614CC0F5DAB8FCF394CCD0;
localparam G3_1 = 256'hFEFBA8CE169FD3775B2280EF3BD870FDDF7CB95F2943D0EEA84529FF0D1B1C19;
localparam G3_2 = 256'h0CA5DB06A87541C81BEF913D5145F20EFAD861F673B32028B4713377C056CE97;
localparam G3_3 = 256'hCA3F213365EE380F7E90466945BDE9F44087C8C73A7CC5F9DE71B7683D018D86;
localparam G3_4 = 256'hA6CDFD8D8117748A4B41C3F5A66765495711EDC02F9581F3E7C2E0FD9004B03B;
localparam G3_5 = 256'h77D0EF5DE2ACACA2A4371A5B111B877D0EDDF83C3341A5AA51261FA4B5A0D7EA;
localparam G3_6 = 256'h7C563512A6B73B3B43F8D1D113D751D6B2CABBC350FF0F8C29361DCE5EB87C8F;
localparam G3_7 = 256'hF6DFA5C672C2517931371ACB6462A596D41419CD4F0F84EFF98DCBBE610AE03E;
localparam G3_8 = 256'h05FF840FB320DD5C3FB4FE4A5858510914A5161B2AD3C3E7FD02358505190F0F;
localparam G4_1 = 256'h5B6D534EDE13068A2459CB07007121B0F07B08B8227047C1A629DCA5A4E30D28;
localparam G4_2 = 256'h5D00E72E5B6AD57A9F0F9E0608702BDE8BDBFA371C06D96BFE0E603775A875CB;
localparam G4_3 = 256'h692EB7DA76BD0D4AFE92FCB5B5184BAA3EEE37900144CA03B7A22EADE2F061FF;
localparam G4_4 = 256'hB3CDE2464AF1212979A99380340974A9F85478E5A2E8B907E74EEFA4CB7625E5;
localparam G4_5 = 256'h41AF736E0AA1416EA676E43CF5DFF372CFFC30D6C0A58A333268136A3020033F;
localparam G4_6 = 256'hF50111382FEBA594C255896AB59C06638406956F19B67F80A3A7276060D4E7F6;
localparam G4_7 = 256'hDCB75287BE9A2620A1F594570B269097A51A32548BAA6DD9B429B8AAF992C8C0;
localparam G4_8 = 256'h6210A36B63DE9C732339DC1AFA94CAB475574A6D1C4D0C17F148B8AD12816B47;
localparam G5_1 = 256'hE24D7C17BCC46297EDC41AA9B5C9D93689843027C6A78449F8D151E1F42BE98F;
localparam G5_2 = 256'h4544BD9E6975DDD4BC9B3EFAD50AFC582CAE269677B130FED2C39D5EBDEE56B8;
localparam G5_3 = 256'h6A13BB53C03B0C8A4E0D1697322A1A3055054229A69B6CCB7E1FB0B885B90CD2;
localparam G5_4 = 256'hBE5C66B252E5C51D7D9E9E25922566C18F0234F2A330041AEC6A4F2729A2A30B;
localparam G5_5 = 256'h1E04A65CF0BA05C62B15FEF9967ECD975EC43C035DE4EE6422237F56834AC746;
localparam G5_6 = 256'h4FD0C1AF8A61F56686326F93EF63E2C114D55726A5F74BFD99AE7713DF2DE6CF;
localparam G5_7 = 256'hA9CC4B50995A682C6F6F12C80929FF208C72007D6A253FD36DE363E8EBF2B614;
localparam G5_8 = 256'h95F6F59DA4CE4BA4D6D4D371A2484F16EFA33CD34F71B81702F0E99C031B089D;
localparam G6_1 = 256'hE16A7B75AB838252D1840EF2935AA1CCA5C8470F98202BABA93EEACE43EE56E1;
localparam G6_2 = 256'hB2D767F35B0F34FCE855B53B6B8DB8DD08BCF47684E904FA47965D72107897D1;
localparam G6_3 = 256'h3D38403A0D2696A767679C6F9CC37537A93A125CE7041EC4F39AD7452597ED13;
localparam G6_4 = 256'hA0CCD841B7CA93DB6F7039B929A820F55A95AA3786C96E0434DA46A084653B1A;
localparam G6_5 = 256'h08A907831A27892D0DD5B6C9FCB5229C0C03663794A4E94E3FB22E4068ED0EE8;
localparam G6_6 = 256'h53BCBD15AA8DEC3451CEF53541B04056E4DCA0393836E9B6DFCF9B01E901D933;
localparam G6_7 = 256'hBD160166307B70BE5618C6E0B4ADEBA46F65C69080D4C3FAADF1AA22911C2C69;
localparam G6_8 = 256'h42FB1575074655ABD1EFF5784CBE7FA0B110981C8A0BDF01C650189C2DC9FC74;
localparam G7_1 = 256'hB403563011DDE16F92630CF312B3F7F495E74B3B582DFB9401F509A35BD2528C;
localparam G7_2 = 256'hA81600F6437FBD00FCF0E4AD41DE3598434EE3903CD1A17CF618E8E2A47EBC4C;
localparam G7_3 = 256'hA1D7816AE33BA46E3A9D5B3CBDACF93D538802ED0FCCEFF193DB9D6B79C7E508;
localparam G7_4 = 256'h54B42DDFAA7DE9B5299F4C1B5DA05487562D20349282F7061E3159E4EAB09D03;
localparam G7_5 = 256'hE15D45F2D1694FF3FF1AA1FC1E58E3FBD6875B71B982AD57AC96CD3B7BE8ACC6;
localparam G7_6 = 256'h90CADDAD41374E4BCA29AAB22CAD61989158C474E0725B4C4C5442D6A12D94D8;
localparam G7_7 = 256'h2827752CE49CB9C385AD35C1291109892EF85A7A6C043BD8E3BA4AC3D5146FB7;
localparam G7_8 = 256'h87002794AC4020B7D229EAE70E01E72F1772B0DA401ABE2C2D487EF60724DC83;
localparam G8_1 = 256'h413A0F58974C76AB4C17AB24F37CB1055FC1827A1DDB0456CCAA7F9477CA64FC;
localparam G8_2 = 256'h904E1D9338D0795C6844F79ED8B26A9D306F66975CE704A925E72EC95509188B;
localparam G8_3 = 256'h2B5EC3212ADF35954F1CDA9CB6CCC28E422F23AF81659F6E4AFDD03EFB8AD730;
localparam G8_4 = 256'h84D1CCA3B5036F031EEDE0F1121E6F62D232DFB74A0582EB3303D1E98810A6C9;
localparam G8_5 = 256'h221F0EFCA2C81259B57F8E6943D0CD36088A64DA7FE2E6E7E0F63EAF873B8A79;
localparam G8_6 = 256'h57E9B39245C6173088B024F34ED7B64F8784413FF95E476474FECDAE7BD62E5A;
localparam G8_7 = 256'h807A807832F6AC83BC7CA7F754BBC7DE72CCC85425068F50ED52419643561832;
localparam G8_8 = 256'h1B9CF54C055FB01B40740A0D469855292AE8A0C58756BDD3C6DABE268551FD5F;
localparam G9_1 = 256'hDD8CE660B7403DC8672EA620E65301B0865A23FE568C173669EE1D7F7A1BD748;
localparam G9_2 = 256'h3CCFAC84AB188D906D70525D092C3E2B46C6675C1CF4B30AB346022E43DA20B8;
localparam G9_3 = 256'hA01DC1159652EA260B411971B0E3D0393C1E75AB0EA462E1D07D0847EFA9CFBA;
localparam G9_4 = 256'h4153E6B4F4687D434414BAA200FA38CE46B28D3B4055C633AAD0ED2FACD6B415;
localparam G9_5 = 256'h5234FA7B72F478A193EC14698C611F3CB70BF72C15E0DCE9CC048A526AC1F46A;
localparam G9_6 = 256'h969C10820390DF8D90AD0138202A32182398B70405520538D08C1F799FBC0755;
localparam G9_7 = 256'h53D8304A8B5213FF88DD1620B1A5125AF1CC9A07F95C61C5C6C625F64FFCDBE6;
localparam G9_8 = 256'hED1E06EC959FF323FD3E8AF3553D90BD529D699B08B873F164F59B1CD522AC0F;
localparam G10_1 = 256'hA5C8A02849509DECECFADD4C89C03A78E1564A548D89DECD90DDBCAC7964E9F0;
localparam G10_2 = 256'h545B207877BBAFB5DED6AEAD3967CA72272E128C97B06868FD3BB85996640432;
localparam G10_3 = 256'h2995ED49B525D47CE868EFD6FDBB0BB6975DC82C8580D00ABCB9FFC6F532A0CB;
localparam G10_4 = 256'h9F0B1EC3BC16C2E7C94F5149D03677AD039452180B24DA434F5BBAA0BCEE64ED;
localparam G10_5 = 256'h910009CE6C11178F5BC794754EBA72003E9A53CDA988B33CE2D0A0965DAACA23;
localparam G10_6 = 256'hBF8A7AE5330F4813AE7F8E4F25666EAB3F0351BD34ABBFA8874D88D5FC4E9385;
localparam G10_7 = 256'h45A0C20F7DFD392872ABDCB19E4F6F097044266B9EA6F0B318A5011D0E51E735;
localparam G10_8 = 256'hEE58F5FC44AE859564B64F3D173C58FAE938AFB934CBB97245F7B1A1DDD4C559;
localparam G11_1 = 256'hC7DF1E821B249BE35E6CAB842F3DFCD0141E428141C28BDCF54B0985329F6E2A;
localparam G11_2 = 256'hD8C083075232BDEADEA797B6C9E15606A72B8B48502B1C044BA89A8DBC54EB6E;
localparam G11_3 = 256'h718EF66E726EA72E631B9B22E193F012F3FB2D112468B0DB89F0C3C8A143E9B1;
localparam G11_4 = 256'h7D6BE8EA6A522A10F46EC5A56E3F572586884547536AFFAD0C82A42D88AAA64B;
localparam G11_5 = 256'h0B740E17EEF10A800DE1916C291C1535845114313E908D313B58018EB77DED61;
localparam G11_6 = 256'h9A5F7429731308EFAB68D1725D8F9501234F9035869415A62262095D77A9613A;
localparam G11_7 = 256'h9BDCBC26ABDE4672BE5F130E1089BE8BF5CA0ED3FCD9F28B75CC07E9822AA2EF;
localparam G11_8 = 256'h6AC735D6621C86CEA203E9E1FC993207EDC164396C7C8FF227F92979A313914D;
localparam G12_1 = 256'h8E1D4E308C03F66D73D76A715F859BEDBC8D709D4BEFC1558D74B49860A90ABA;
localparam G12_2 = 256'hB67C75041BFB3A61BBBB73DE2B3D7BB5CB254F10257495E3185C71C3559D9CD0;
localparam G12_3 = 256'hACB7A163EB1E088624F946909B29B2C7373C5CF4F6B1F3A75DC49B1574B3AAB8;
localparam G12_4 = 256'h327C55142CE3D1382EA917A7C6730E01BA6BA43767D53E84FFB7D61D6EAD24AD;
localparam G12_5 = 256'hCFAAC26024A1D642C795400B8646533A435A4FE899704FAFAE2BF452BD9AF093;
localparam G12_6 = 256'h53759538B5F4A8614F1AB4840CFC1EFD8CAFCB067C991FDF2658ABA23F8B0B93;
localparam G12_7 = 256'h6B3A35CDECD26C58B9F1318AF46F13767758FC0F74B7DD050A9B1A1C7F98B930;
localparam G12_8 = 256'h4B4C20D040F3A8C746453ECE10C0A1F4F74BDDB1A8FCFE1DE2C19148A5E88F1C;
localparam G13_1 = 256'hA98B4DE68DDB2434893BEF8F2CF8DB584CEE8F0E39D30CD4C87017E7EE6886F8;
localparam G13_2 = 256'h23024E83F777D7DF0D7E46A8B5F9B1331D0BC2F79BF5559C3241D5BDC7E7A665;
localparam G13_3 = 256'h9E1DD50373C16CC97A5E390921B471EF5B39731CCC2CBDD08876080680F9D974;
localparam G13_4 = 256'h9DF22EE3AB758F85FD490012FCFF20B3329A5648D25859036C0586C65F46236C;
localparam G13_5 = 256'hB009BA2650ABAFC45653D61D2BFA255DE767D0B25AC7736E8E5200D21EE3E28F;
localparam G13_6 = 256'hFD96F63D0A22CD574ED61899ECDEB4BEB333F994AC7791FF89EC600B857D4DDD;
localparam G13_7 = 256'hC2773C7DCE36709F70180CFFAE22AD44A4A20211224F8ECFB336A54A681A1F59;
localparam G13_8 = 256'h5C00C419C78A79ADA49562EFB784ECE44BAF45C1E75BD84DE7C1C69100F8B93A;
localparam G14_1 = 256'hDAB0C7C65F0D096351BF8A0EE9CEF5F7756A9A47B4EE80420DEFA16B0E74CF18;
localparam G14_2 = 256'h0FAB86E762595261852E38F9D797D4F796DA18169AFAC99E8235D4DD6C2BB887;
localparam G14_3 = 256'h15D0F65E9ADB2C67A887E5D8EF4E1080AC968F4C0D673CA7A74759A7F1B4E383;
localparam G14_4 = 256'h1B5641CE5FADE005EB947BE5E20E7DDAF6372655825B3516F2EC5B36D687895F;
localparam G14_5 = 256'h2C0BB35E3C3EDA32C19BFF6F3A2397A8E25C646059359D90A1372FCAEE250A43;
localparam G14_6 = 256'h8AABBF162C4499F2FECFA27F8D7582FB607B88D04F4A6100A3D2F8A88A2E5E80;
localparam G14_7 = 256'hD9C26C2A023943BC62F3C18658A0F5C64130BFF0D74BBB85EBFFFE197C94C6EC;
localparam G14_8 = 256'h0AED385393F69FA9F7E69DDC061B85E4E77D0BE2013061E94A0DB8AC2995096F;
localparam G15_1 = 256'h775369B59AA940DA96B47429C339536B51ECC59C60BAD762FA275A6A8F90885A;
localparam G15_2 = 256'h922A84AE2B06B4003C0A7BE22FB211365376C3FBFC03EB0DEA264F6769B57EE2;
localparam G15_3 = 256'hE518ED3DD8553DC8815E57F23DADC1A3E99030AA02A3529604EE4BD66D770F8E;
localparam G15_4 = 256'h8AB3C94077F85772647897A76CFE4EC56FCAA7A28968065CC73BDD88ADA4D60C;
localparam G15_5 = 256'h9430F05CFEF8ACBBA73038463A9AD3BDE5BA4E94FDA81C6C51AB3C69201906E1;
localparam G15_6 = 256'h2613EFCF235670383ED865C6161C8A8958DC09289EA03658376277BE6E4E62AA;
localparam G15_7 = 256'h3C90B273B9870A069FE0F5164AA8F837B9905EEE7D3AEB794BA2F4CAA4F1EB01;
localparam G15_8 = 256'h01C2973BD37D564B7D21243A206BD8A7B435428BA8DD3DB7045541BCCE000F5F;
localparam G16_1 = 256'hCEA89305914BEB1BE84B59A4A18CC1AEB5CC96326ADC69F3B4957198C60BB6E7;
localparam G16_2 = 256'hDB38C42E2947EFC39D2BBFA07C18C320A22C7B9C6CBFB72E6909BDC131B2E15E;
localparam G16_3 = 256'hABECA69DD1395554C852ED7EE6817A6152B39B42F6D7D56B781D1803B8307C79;
localparam G16_4 = 256'h386FFC16B79E309255E7D5933870D116DE3828C68348493D8E288C8A3FBF741F;
localparam G16_5 = 256'h0936252D32CDEC49ACFE91F2BA885044E0A9ADFEA526F53641F97B86668C5972;
localparam G16_6 = 256'hF9D8560A97AFA4282DBCC4250B75A871276434FFA80959F04D3400D81937617D;
localparam G16_7 = 256'h799C3EDF3F1345908B306D8372A740E96707761FCCA9B861402134AE9488387F;
localparam G16_8 = 256'hF2DA86FE2BAA7E675DFDED45499AF1B40AE292B1DE6B7A7D4799C3B88177704D;
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
                                 sub_size*16-width: g<={G1_1,G1_2,G1_3,G1_4,G1_5,G1_6,G1_7,G1_8};
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