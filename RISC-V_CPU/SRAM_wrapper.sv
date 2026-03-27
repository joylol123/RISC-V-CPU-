module SRAM_wrapper (
    input   CLK,
    input   RST, 
    input   WEB,
    input   CEB,
    input   [31:0]  BWEB,
    input   [13:0]  A,
    input   [31:0]  DI,
    output  [31:0]  DO
);
    
//TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
    .SLP(1'b0),
    .DSLP(1'b0),
    .SD(1'b0),
    .PUDELAY(),
    .CLK(CLK),
	  .CEB(CEB),
	  .WEB(WEB),
    .A(A),
	  .D(DI),
    .BWEB(BWEB),
    .RTSEL(2'b01),
    .WTSEL(2'b01),
    .Q(DO)
);
    // //.SLP(),
    // //.DSLP(),
    // //.SD(),
    // //.PUDELAY(),
    // .CLK(CLK),
    // .CEB(CEB),
    // .WEB(WEB),
    // .A(A),
    // .D(DI), // DI ??
    // .BWEB(BWEB),
    // //.RTSEL(),
    // //.WTSEL(),
    // .Q(DO) // 簡報上的接線是看括號裡面的，port name是tsmc那邊自己設的

endmodule


