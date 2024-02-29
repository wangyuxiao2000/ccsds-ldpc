/*************************************************************/
//function: CCSDS-(5120,4096)LDPC编码器
//Author  : WangYuxiao
//Email   : wyxee2000@163.com
//Data    : 2024.1.24
//Version : V 1.0
/*************************************************************/
`timescale 1 ns / 1 ps

module encoder_5120_4096 (clk,rst_n,s_axis_tdata,s_axis_tvalid,s_axis_tready,m_axis_tdata,m_axis_tvalid,m_axis_tlast,m_axis_tready);
/************************************************生成矩阵设置************************************************/
parameter width = 8; /*支持1、2、4、8、16、32、64*/
localparam n = 5120;
localparam k = 4096;
localparam sub_size = 128;
localparam G1_1 = 128'h473BC533A12C3596F642673D0DBF1142;
localparam G1_2 = 128'h079A3868E1A6F556F0DF3DCA4493AE54;
localparam G1_3 = 128'hAE4C50F12AEF6EEDEA9BB30605F4A24C;
localparam G1_4 = 128'hB0B2B4B9035331ABF53DE4752E7EDABF;
localparam G1_5 = 128'hE7E08EF3E22EE7EFE645E9E59507A206;
localparam G1_6 = 128'h52E4A2C06270B2D1A418134BC0D58678;
localparam G1_7 = 128'h0A84E53303F4092DB47056AD3C0847AD;
localparam G1_8 = 128'h2DEF73813B17101E79A3A58A7E91C4E2;
localparam G2_1 = 128'h667AA815610234DBA0FFA951CABB8BA7;
localparam G2_2 = 128'hA3271642E4BCDD24F8D89BD783317ABB;
localparam G2_3 = 128'hCC64FA95F06AE45C7E38935D78BF5F80;
localparam G2_4 = 128'h510CE9ABC6156F008B317C79E0122B09;
localparam G2_5 = 128'h3CB09E20016A5F93E207C144E889F3B9;
localparam G2_6 = 128'hAE6185E4345C5971E03AD499EF850D33;
localparam G2_7 = 128'hFA8B392CE78B5712290CB2F518F3E0CC;
localparam G2_8 = 128'h429C39F0915EB60CA0545B6AB2967149;
localparam G3_1 = 128'hFE9FF6C26898CB926F9BCD129AA52083;
localparam G3_2 = 128'h3FC159DB58B64D39CB27847434F177E2;
localparam G3_3 = 128'hE040D71365D96A1D54FD20051D3A50E7;
localparam G3_4 = 128'hE8AC736B6D2BB5468FBF68DDF5789C2F;
localparam G3_5 = 128'h4954E4153CFF0F52F8F8F5B243A03E2B;
localparam G3_6 = 128'h99A1DDD23204D103E323158E0FEE7673;
localparam G3_7 = 128'h43C2A07046BA1B4307BA6CEC7D740CFE;
localparam G3_8 = 128'hCB4E113F94C6CAA4652EFD867B43D199;
localparam G4_1 = 128'h081E779BF01F34C97337A3ABC8698644;
localparam G4_2 = 128'h9C9E794155E27547283C1AB2706A388D;
localparam G4_3 = 128'hFB9DFD194731EC2AE99EA6B641B309A2;
localparam G4_4 = 128'h258D45A1BBEAFFC787E61289A54A2473;
localparam G4_5 = 128'hFDF3E96C7679E979911C4BE65A333250;
localparam G4_6 = 128'h178259F846AA95577C2EC448EE709423;
localparam G4_7 = 128'hA61BE7CCED0342965CA234AF02914916;
localparam G4_8 = 128'hE045B3C585714F272D40C8085AE5E8F4;
localparam G5_1 = 128'h7FB352B26E544BDC18D76B323C3CE1BB;
localparam G5_2 = 128'h8421967EE08A6F719B675F06F13FF05B;
localparam G5_3 = 128'h672C29DC5B80E18E2F4C42D0F6D5D6D4;
localparam G5_4 = 128'h7DE072F73A8015862A275B2CEA2FFC1C;
localparam G5_5 = 128'h284B87ABA22362D98952442BBDFBF4A3;
localparam G5_6 = 128'h2B798BCD5D8C0B02BBE5DE4A96569F99;
localparam G5_7 = 128'h409E72F4138595F8B3C14074BD8E33E0;
localparam G5_8 = 128'h3B07838358BBAE631C8258D6B07D2E1C;
localparam G6_1 = 128'h403149A1C88E4D4893FE719B2638B7FF;
localparam G6_2 = 128'h9886F3E90FC018699F3B39183F2219DC;
localparam G6_3 = 128'hF5B0D3AA451225867913FF8FF979BBE0;
localparam G6_4 = 128'h795DFCBCC98210C028FD21380EBDDABF;
localparam G6_5 = 128'h0BBE0D91FA504DC4DC8848AEA001577F;
localparam G6_6 = 128'h51653E755F6CB4F75ACE347EC899304D;
localparam G6_7 = 128'h1D0EE239D8A6C2E2EA13D4CFB3394FCA;
localparam G6_8 = 128'hBF707E3ACD882B91FDDD44A7EA0D1F3D;
localparam G7_1 = 128'h14EB386A5A4524983682993353F8D76E;
localparam G7_2 = 128'hF9850534D2FB4F19F787897435C5EB0F;
localparam G7_3 = 128'hB680840F8D34A0995BA0A94E309A9194;
localparam G7_4 = 128'h6C66CAA0567BFFD609B6484BCD477702;
localparam G7_5 = 128'hB62A4053A6916719693D50608EC1D717;
localparam G7_6 = 128'h23C38E6F64963EE836ADC6BBF39F4CD1;
localparam G7_7 = 128'hA40947C16AEAD43F621457BDB766A157;
localparam G7_8 = 128'hDD6118ACF503356D0B3479828C296016;
localparam G8_1 = 128'hAAB1061EC9FA6BA21E81D7E22D3A7ED2;
localparam G8_2 = 128'hF902B6C336258F5B6B54628AC96116DE;
localparam G8_3 = 128'h5968E3167BB1E221714B0F4B3B9D7E0A;
localparam G8_4 = 128'hF12374361559D0F0E0C7FCC959B1A9D8;
localparam G8_5 = 128'hC103B779B3A769AA8D955160E4B9F9B7;
localparam G8_6 = 128'h231B28E0B7490C8EB883F29AF6CC4F12;
localparam G8_7 = 128'hA7D1FA32F82AAF128FBC6AC53532AB89;
localparam G8_8 = 128'h17AC06392CDAC681817D2F5475016296;
localparam G9_1 = 128'h434D8612F27169A49ED244393B87DB5E;
localparam G9_2 = 128'hB66D806A5A9ADF46D83C7DCFDB4B72CA;
localparam G9_3 = 128'hA78E0C64307885C6E67C870BD21EC431;
localparam G9_4 = 128'h11B79B0BB0B977D9792535C16AA7D982;
localparam G9_5 = 128'hB597FD60982B8C42D019390EFA14B3D5;
localparam G9_6 = 128'hC57FF5CFA1C438AC576782A5B48B78AA;
localparam G9_7 = 128'hAE278E95DA048F720B7DB5FB6488287B;
localparam G9_8 = 128'h893C7E7E8DCB6E5ED5DB819D8901B32C;
localparam G10_1 = 128'hB7BA8906FC3AEADE22254872ECA99117;
localparam G10_2 = 128'h74F39404FA2779F4C55D649E5A6AA628;
localparam G10_3 = 128'h4A1F8910EBF76F2F4E3EF686266CEBB8;
localparam G10_4 = 128'h8363A57CF1377C68419BEFE6C848FEDA;
localparam G10_5 = 128'h8F141154BFA88D31446EF367ED965F98;
localparam G10_6 = 128'h1242B3F840426E98010B84A957090390;
localparam G10_7 = 128'h9CE9E0B619E61C4A481F1DD44360BCAC;
localparam G10_8 = 128'h0938AE511B2B47A42F5F59FBF547D991;
localparam G11_1 = 128'h85B68FFC07A32A495D9A708FAECD2C41;
localparam G11_2 = 128'h69CFDFFD21D6B2CF3F91CF5820823B83;
localparam G11_3 = 128'h7D62406050908C82C21CF32B862166F2;
localparam G11_4 = 128'h82AF2DF8E6CADB5D043FBF863ACE6599;
localparam G11_5 = 128'h700097EE5FDDD825468C544985C983CE;
localparam G11_6 = 128'h69EE0178288A8E1A12009EBF2E4382DE;
localparam G11_7 = 128'h2B8D59DE631991AE1B67C70786B43BE2;
localparam G11_8 = 128'h860FC3354C9FE4253EBF307D1C643E22;
localparam G12_1 = 128'h905330D76B16340120BB399A08061CBE;
localparam G12_2 = 128'h9D5765CE993D7092A8150DE46D6CA810;
localparam G12_3 = 128'hE03534D4DA2B66A0BF2AEF3B833E18DF;
localparam G12_4 = 128'h6C1C0D9EAB1E26FD2481F6BB6AB674C6;
localparam G12_5 = 128'hD98BD8D3FC0E0557352CF52EEA654A92;
localparam G12_6 = 128'h0DF8D4B0FD41AD3EE547119C2446F840;
localparam G12_7 = 128'h4C1F458D1E2F4B70D9023F0DFC06EFE9;
localparam G12_8 = 128'h24349C5D9DE2B048DC74D3E888043526;
localparam G13_1 = 128'hE864E5EE002EB3B4C31A8D3B3E22D2C6;
localparam G13_2 = 128'hB3C4136542237F8E3C75AA228AB1B2F5;
localparam G13_3 = 128'h43DF20DF407EAC80CAF22FDDADD586C9;
localparam G13_4 = 128'h9414219FF80742652531AC5CC0E52866;
localparam G13_5 = 128'h1A68E6BC5CA7FCA386396D0F56A2E7A3;
localparam G13_6 = 128'hD9EC25B8DEA08EDB6A9E6CFFEC7B15C1;
localparam G13_7 = 128'hCD48176480B2E0FED349142BE9888043;
localparam G13_8 = 128'h9A70BAD89B53A4461301DF6C1763EB67;
localparam G14_1 = 128'h5C9B0F852875D4B06EFA7FF418710592;
localparam G14_2 = 128'h6F7C0712083341F6A97F398A275243DC;
localparam G14_3 = 128'h3D046D9B0B0B6AB3FEB99F72A70BAF35;
localparam G14_4 = 128'h50F7B484C2530BEF63537B68EBDCF01C;
localparam G14_5 = 128'h672E8B1DD956431036302F8557CBB4E0;
localparam G14_6 = 128'hC9CAD206AB0AD88C655E0F52C70AEEA1;
localparam G14_7 = 128'hFF7EC97F9439C9D4CD71487F10065DE0;
localparam G14_8 = 128'h532339617D706AEFA50A23B90B57978C;
localparam G15_1 = 128'hB7E0C9A5F3EF66B9ABA49150144FCBEF;
localparam G15_2 = 128'h2C9E63DC18BE8ADDA0FD7E7E8F7FC5FE;
localparam G15_3 = 128'h5C55C60E14C3D7AC4D00D9F6C827E1EC;
localparam G15_4 = 128'h4E40D57E1740089DB1248707D195C038;
localparam G15_5 = 128'h4500AD976DD321E6133113D244711330;
localparam G15_6 = 128'h0260379D0A20D10A899019157631007D;
localparam G15_7 = 128'h4DF741A808694A9956E493B4668B67FD;
localparam G15_8 = 128'hF89442CABAA2262C398171D62E938504;
localparam G16_1 = 128'hCCF8A4E13D655D5591DC40D2C6607CEF;
localparam G16_2 = 128'h353E539A020B0C608F843A855BA9B7AE;
localparam G16_3 = 128'hCD31CCCB9388FECDEBEE1CCF42943E77;
localparam G16_4 = 128'h9CA39E64D8AC9E23F15A0CB4C73ACB80;
localparam G16_5 = 128'h3BF0F0DA9576923D95089979081ACA77;
localparam G16_6 = 128'h359B090725B62278F00D0222CAD4C0FF;
localparam G16_7 = 128'h4ABA29056D55C5AAD990AA10A9A1A9B2;
localparam G16_8 = 128'h27A09750826682C157BD7CD2178FDC96;
localparam G17_1 = 128'hAFC3076AF8AFB82B45FE8F2628F489F1;
localparam G17_2 = 128'h2CFA95663A96A30FB3831F756D9E666A;
localparam G17_3 = 128'h011EE24F6C5EE283C3EE09A1D5FAF1B9;
localparam G17_4 = 128'h7B49CB7B94EDEB207221A9436E1FFDF5;
localparam G17_5 = 128'h5D36302EEBDD74AD27158F4D9DF0FA6E;
localparam G17_6 = 128'h497015959B333E79885FBE22B9B72707;
localparam G17_7 = 128'hE330EEAD520B31BAD1A5DC55EF54193A;
localparam G17_8 = 128'hD6C112F89677E27A26F1DC62E08DF49C;
localparam G18_1 = 128'h2DF5B0291E619A18D802502086037C46;
localparam G18_2 = 128'h730D20AE9364A6AD090B789D8AA6C6CC;
localparam G18_3 = 128'hEA476A585503E90BCAAD943DD30E1BCC;
localparam G18_4 = 128'h1D5C236ED01E9E5C8E94E96FA7252ABF;
localparam G18_5 = 128'h3EB2DB84FB4837EA5153CA825D11F86B;
localparam G18_6 = 128'h574E63C92DD0E75AD8DDFF2B37CC97C9;
localparam G18_7 = 128'h5E83299E60C44293BF0824C62EB7980C;
localparam G18_8 = 128'h5678B852002834EB2D630EAC536FFB78;
localparam G19_1 = 128'h9A41F048C1C68187734BFB916EC3BFAF;
localparam G19_2 = 128'h4B23BDA1162B30CB7AEA9F03BEBCF597;
localparam G19_3 = 128'hC65460BFAF9C8913608F9888E738F4A1;
localparam G19_4 = 128'h017AEE470FCA60F9711E9BE5EB98E7C9;
localparam G19_5 = 128'h4EE8869A59EDF8BDD52C5B5388B35249;
localparam G19_6 = 128'h8EB0D25B439273CA6545E82E69D8677C;
localparam G19_7 = 128'h5B23991A53041EA4B276405C156A9DE5;
localparam G19_8 = 128'hA90889BC74530A5F87CCF024E591E18F;
localparam G20_1 = 128'h22735E1E720A8B3C29A80F3696D6F157;
localparam G20_2 = 128'hF68ED2F2389D5D2CDC59D706495D815F;
localparam G20_3 = 128'hD0EE25B73218D5717572387BFA03A7C2;
localparam G20_4 = 128'hA0717B27763FE223BDA3EB0DAFBEF276;
localparam G20_5 = 128'h9DBB8235D11298BEE28B39772ED91A35;
localparam G20_6 = 128'h92DE6FED2F6766E01DBA188153DEA205;
localparam G20_7 = 128'h48930E9A21873E62863CA15D6DB058D9;
localparam G20_8 = 128'h61A29088FE3983D0E1699EF0AAFA5FD1;
localparam G21_1 = 128'hA73005690098889382252873E627D6FB;
localparam G21_2 = 128'h7862DE8A3D0F1A9387963F38A82E4703;
localparam G21_3 = 128'h78BAB9252EE72FB0C798C7C684B6E789;
localparam G21_4 = 128'hB7480D9712BFA72D122F243674AD887F;
localparam G21_5 = 128'hEC1851EB80A37133B68F0F709DB32E05;
localparam G21_6 = 128'hA809CB3638414FD6E156821BDAC256E0;
localparam G21_7 = 128'hB75342B6CFF7ED428521AB48A4C55D66;
localparam G21_8 = 128'hC9AB047D79A484289C820E8FADD87251;
localparam G22_1 = 128'hA69C02525644F41D03197EF26112D606;
localparam G22_2 = 128'h3DF71AD0410035AE1AE7B0AB310B6967;
localparam G22_3 = 128'hC4F82E31B4D9B491EF8E4992FDBA61B0;
localparam G22_4 = 128'hB6B367CDE8DE0CAE22875F641288E733;
localparam G22_5 = 128'h5C142A9C7C2E259BD38D66117E9E861C;
localparam G22_6 = 128'hD27BF85E8EEE1920B57D0C62B512E2D6;
localparam G22_7 = 128'h68B4500340B7B92EDD05A44D36AC1651;
localparam G22_8 = 128'h4E77C4ABE92FE174B5D9F79070685288;
localparam G23_1 = 128'hA22B2A6C9A75D7A6EEA5A0DF8A4950E2;
localparam G23_2 = 128'h24C4830123FAE1EB6EB0AC9C2D8C508E;
localparam G23_3 = 128'h1BB99D6785EBCCDD9CD6A50CF53CCA00;
localparam G23_4 = 128'h0624E36FD0817F2E198340098E60DFBF;
localparam G23_5 = 128'hA4EB92DD48085594C6F755C563F35020;
localparam G23_6 = 128'h04BDFF9A2309C6E673CE08D94A45BBC4;
localparam G23_7 = 128'h8B8EC43906C28869AD4E41FB147A7696;
localparam G23_8 = 128'h8AB66E9B68FA00BEF90D3E078D0C6FFC;
localparam G24_1 = 128'h89A79E9CF0BE90A3D86305B6491A49B9;
localparam G24_2 = 128'h222A27A68236765AB32D41B1E0616C83;
localparam G24_3 = 128'h99931668E57EB6378C8F4ED1C27BEDD3;
localparam G24_4 = 128'h35166846D0C673B9A8D2184C1901433A;
localparam G24_5 = 128'h4D768A5E0109B5CBC198869334D81C43;
localparam G24_6 = 128'h2C6A48CC47FD21F9608107FF80FE37AA;
localparam G24_7 = 128'h4DD3A7395630BE4B64F776C5FC6B2C31;
localparam G24_8 = 128'h4DC16B1E2B2A7F6E0E9FDAE3B60F8FAA;
localparam G25_1 = 128'hCFA794F49FA5A0D88BB31D8FCA7EA8BB;
localparam G25_2 = 128'hA7AE7EE8A68580E3E922F9E13359B284;
localparam G25_3 = 128'h91F72AE8F2D6BF7830A1F83B3CDBD463;
localparam G25_4 = 128'hCE95C0EC1F609370D7E791C870229C1E;
localparam G25_5 = 128'h71EF3FDF60E2878478934DB285DEC9DC;
localparam G25_6 = 128'h0E95C103008B6BCDD2DAF85CAE732210;
localparam G25_7 = 128'h8326EE83C1FBA56FDD15B2DDB31FE7F2;
localparam G25_8 = 128'h3BA0BB43F83C67BDA1F6AEE46AEF4E62;
localparam G26_1 = 128'h565083780CA89ACAA70CCFB4A888AE35;
localparam G26_2 = 128'h1210FAD0EC9602CC8C96B0A86D3996A3;
localparam G26_3 = 128'hC0B07FDDA73454C25295F72BD5004E80;
localparam G26_4 = 128'hACCF973FC30261C990525AA0CBA006BD;
localparam G26_5 = 128'h9F079F09A405F7F87AD98429096F2A7E;
localparam G26_6 = 128'hEB8C9B13B84C06E42843A47689A9C528;
localparam G26_7 = 128'hDAAA1A175F598DCFDBAD426CA43AD479;
localparam G26_8 = 128'h1BA78326E75F38EB6ED09A45303A6425;
localparam G27_1 = 128'h48F42033B7B9A05149DC839C90291E98;
localparam G27_2 = 128'h9B2CEBE50A7C2C264FC6E7D674063589;
localparam G27_3 = 128'hF5B6DEAEBF72106BA9E6676564C17134;
localparam G27_4 = 128'h6D5954558D23519150AAF88D7008E634;
localparam G27_5 = 128'h1FA962FBAB864A5F867C9D6CF4E087AA;
localparam G27_6 = 128'h5D7AA674BA4B1D8CD7AE9186F1D3B23B;
localparam G27_7 = 128'h047F112791EE97B63FB7B58FF3B94E95;
localparam G27_8 = 128'h93BE39A6365C66B877AD316965A72F5B;
localparam G28_1 = 128'h1B58F88E49C00DC6B35855BFF228A088;
localparam G28_2 = 128'h5C8ED47B61EEC66B5004FB6E65CBECF3;
localparam G28_3 = 128'h77789998FE80925E0237F570E04C5F5B;
localparam G28_4 = 128'hED677661EB7FC3825AB5D5D968C0808C;
localparam G28_5 = 128'h2BDB828B19593F41671B8D0D41DF136C;
localparam G28_6 = 128'hCB47553C9B3F0EA016CC1554C35E6A7D;
localparam G28_7 = 128'h97587FEA91D2098E126EA73CC78658A6;
localparam G28_8 = 128'hADE19711208186CA95C7417A15690C45;
localparam G29_1 = 128'hBE9C169D889339D9654C976A85CFD9F7;
localparam G29_2 = 128'h47C4148E3B4712DAA3BAD1AD71873D3A;
localparam G29_3 = 128'h1CD630C342C5EBB9183ADE9BEF294E8E;
localparam G29_4 = 128'h7014C077A5F96F75BE566C866964D01C;
localparam G29_5 = 128'hE72AC43A35AD216672EBB3259B77F9BB;
localparam G29_6 = 128'h18DA8B09194FA1F0E876A080C9D6A39F;
localparam G29_7 = 128'h809B168A3D88E8E93D995CE5232C2DC2;
localparam G29_8 = 128'hC7CFA44A363F628A668D46C398CAF96F;
localparam G30_1 = 128'hD57DBB24AE27ACA1716F8EA1B8AA1086;
localparam G30_2 = 128'h7B7796F4A86F1FD54C7576AD01C68953;
localparam G30_3 = 128'hE75BE799024482368F069658F7AAAFB0;
localparam G30_4 = 128'h975F3AF795E78D255871C71B4F4B77F6;
localparam G30_5 = 128'h65CD9C359BB2A82D5353E007166BDD41;
localparam G30_6 = 128'h2C5447314DB027B10B130071AD0398D1;
localparam G30_7 = 128'hDE19BC7A6BBCF6A0FF021AABF12920A5;
localparam G30_8 = 128'h58BAED484AF89E29D4DBC170CEF1D369;
localparam G31_1 = 128'h4C330B2D11E15B5CB3815E09605338A6;
localparam G31_2 = 128'h75E3D1A3541E0E284F6556D68D3C8A9E;
localparam G31_3 = 128'hE5BB3B297DB62CD2907F09996967A0F4;
localparam G31_4 = 128'hFF33AEEE2C8A4A52FCCF5C39D355C39C;
localparam G31_5 = 128'h5FE5F09ABA6BCCE02A73401E5F87EAC2;
localparam G31_6 = 128'hD75702F4F57670DFA70B1C002F523EEA;
localparam G31_7 = 128'h6CE1CE2E05D420CB867EC0166B8E53A9;
localparam G31_8 = 128'h9DF9801A1C33058DD116A0AE7278BBB9;
localparam G32_1 = 128'h4CF0B0C792DD8FDB3ECEAE6F2B7F663D;
localparam G32_2 = 128'h106A1C296E47C14C1498B045D57DEFB5;
localparam G32_3 = 128'h968F6D8C790263C353CF307EF90C1F21;
localparam G32_4 = 128'h66E6B632F6614E58267EF096C37718A3;
localparam G32_5 = 128'h3D46E5D10E993EB6DF81518F885EDA1B;
localparam G32_6 = 128'h6FF518FD48BB8E9DDBED4AC0F4F5EB89;
localparam G32_7 = 128'hBCC64D21A65DB379ABE2E4DC21F109FF;
localparam G32_8 = 128'h2EC0CE7B5D40973D13ECF713B01C6F10;
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
localparam STATE_waiting_valid=4'b1000;  /*等待valid信号*/
localparam STATE_data_out=4'b0100;       /*输出信息位*/
localparam STATE_waiting_ready=4'b0010;  /*等待ready信号*/
localparam STATE_check_out=4'b0001;      /*输出校验位*/

reg [3:0] state;               /*状态机*/
reg [$clog2(n):0] in_out_cnt;  /*输入/输出计数器*/
reg [n-k-1:0] g;               /*生成矩阵当前所在行*/
reg [n-k-1:0] check;           /*校验位*/
reg [width-1:0] s_tdata_reg;   /*输入寄存器*/
reg reg_flag;                  /*指示输入寄存器内是否有数据*/

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
      s_tdata_reg<=0;
      reg_flag<=0;
      m_axis_tdata<=0;
      m_axis_tvalid<=0;
      m_axis_tlast<=0;
      state<=STATE_waiting_valid;
    end
  else
    begin
      case(state)
        STATE_waiting_valid : begin
                                s_axis_tready<=1;
                                if(s_axis_tready&&s_axis_tvalid) /*等待valid信号输入*/
                                  begin
                                    m_axis_tdata<=s_axis_tdata;
                                    m_axis_tvalid<=1;
                                    state<=STATE_data_out;
                                  end
                              end

        STATE_data_out : begin
                           if(m_axis_tready&&m_axis_tvalid)
                             begin
                               check<=check^check_reg; /*计算校验位*/
                               if(in_out_cnt==k-width) /*本码块的信息位输出完成*/
                                 begin
                                   in_out_cnt<=0;
                                   s_axis_tready<=0;
                                   m_axis_tdata<=m_axis_tdata;
                                   m_axis_tvalid<=0;
                                   state<=STATE_check_out;
                                   if(s_axis_tready&&s_axis_tvalid) /*输出本次信息位后,需继续输出校验位;若输入端具备有效数据,则将有效数据寄存*/
                                     begin
                                       s_tdata_reg<=s_axis_tdata;
                                       reg_flag<=1;
                                     end
                                 end
                               else
                                 begin
                                   in_out_cnt<=in_out_cnt+width;
                                   if(s_axis_tready&&s_axis_tvalid) /*输出本次信息位后,若输入端具备有效数据,则将有效数据输出*/
                                     begin
                                       m_axis_tdata<=s_axis_tdata;
                                       m_axis_tvalid<=1;
                                       state<=STATE_data_out;
                                     end
                                   else
                                     begin
                                       m_axis_tdata<=m_axis_tdata;
                                       m_axis_tvalid<=0;
                                       state<=STATE_waiting_valid;
                                     end
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
                           else /*后级模块不能接受数据,本次信息位输出未被后级模块取走*/
                             begin
                               s_axis_tready<=0;
                               state<=STATE_waiting_ready;
                               if(s_axis_tready&&s_axis_tvalid) /*本次输出未被取走,即使输入端具备有效数据,也不能将其更新至输出,只能寄存*/
                                 begin
                                   s_tdata_reg<=s_axis_tdata;
                                   reg_flag<=1;
                                 end
                             end
                         end
      
        STATE_waiting_ready : begin
                                if(m_axis_tready&&m_axis_tvalid)
                                  begin
                                    check<=check^check_reg;
                                    if(in_out_cnt==k-width)
                                      begin
                                        in_out_cnt<=0;
                                        m_axis_tdata<=m_axis_tdata;
                                        m_axis_tvalid<=0;
                                        state<=STATE_check_out;
                                      end
                                    else
                                      begin
                                        in_out_cnt<=in_out_cnt+width;
                                        s_axis_tready<=1;
                                        if(reg_flag==0)
                                          begin
                                            m_axis_tdata<=m_axis_tdata;
                                            m_axis_tvalid<=0;
                                            state<=STATE_waiting_valid;
                                          end
                                        else
                                          begin
                                            reg_flag<=0;
                                            m_axis_tdata<=s_tdata_reg;
                                            m_axis_tvalid<=1;
                                            state<=STATE_data_out;
                                          end
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
                              end

        STATE_check_out : begin
                            if(!m_axis_tvalid)
                              begin
                                in_out_cnt<=0;
                                m_axis_tdata<=check[n-k-1:n-k-width];
                                m_axis_tvalid<=1;
                              end
                            else if(m_axis_tready&&m_axis_tvalid)
                              begin
                                if(in_out_cnt==n-k-width)
                                  begin
                                    in_out_cnt<=0;
                                    check<=0;
                                    s_axis_tready<=1;
                                    m_axis_tlast<=0;
                                    if(reg_flag)
                                      begin
                                        m_axis_tdata<=s_tdata_reg;
                                        reg_flag<=0;
                                        state<=STATE_data_out;
                                      end
                                    else
                                      begin
                                        m_axis_tdata<=m_axis_tdata;
                                        m_axis_tvalid<=0;
                                        state<=STATE_waiting_valid;
                                      end
                                  end
                                else if(in_out_cnt==n-k-2*width)
                                  begin
                                    in_out_cnt<=in_out_cnt+width;
                                    m_axis_tdata<=check[(n-k-1-in_out_cnt-width*2+1) +: width];
                                    m_axis_tlast<=1;
                                  end
                                else
                                  begin
                                    in_out_cnt<=in_out_cnt+width;
                                    m_axis_tdata<=check[(n-k-1-in_out_cnt-width*2+1) +: width];
                                  end
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
                    state<=STATE_waiting_valid;            
                  end
      endcase
    end
end
/***********************************************************************************************************/

endmodule