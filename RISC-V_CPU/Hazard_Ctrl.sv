module Hazard_Ctrl (
    input logic     [1:0]   branch_sel,
    input logic             EXE_read,
    input logic     [4:0] ID_rs1_addr,
    input logic     [4:0] ID_rs2_addr,
    input logic     [4:0] EXE_rd_addr,
    input logic             fix_signal_dynamic, // from dynamic branch
    input logic             Dy_by_Btype,
    // =======================9/26 update================== //
    input logic     [1:0]        branch_sel_Dy_reg_Haz,
    input logic                  true_branch_Haz,
    input logic                  B_branch_flag_Haz,
    // ======================9/26 update================== // 
    // ===================== 9/28 update==================//
    input logic                  correct_pc_BB_flag_haz,
    input logic     [1:0]        BB_counter_Haz,
    // ===================== 9/28 update =================//
    output reg              pc_write,
    output reg              instr_flush,
    output reg              IF_ID_reg_write,
    output reg              ctrl_sig_flush,
    output reg              fix_dy_pc,
    output wire             lw_use // CSR

    
);
// localparam [1:0] N_Branch = 2'b00,
//                  JAL_Branch = 2'b01, 
//                  B_Branch = 2'b10,
//                  J_Branch = 2'b11;

assign lw_use   =   EXE_read && ((EXE_rd_addr == ID_rs1_addr) || (EXE_rd_addr == ID_rs2_addr));

  always_comb begin
    // B_Branch jump but not jump , flush 114 don't flush 108,from exe get truth_branch
    if(true_branch_Haz == 1'b0 && branch_sel_Dy_reg_Haz == 2'b01 && Dy_by_Btype == 1'b1 )begin // 9/28  jump but not need flush ; jump and jump does't need flush
      pc_write        =   1'b1; 
      instr_flush     =   1'b1; 
      IF_ID_reg_write =   1'b1; 
      ctrl_sig_flush  =   1'b0; // any diff????
      fix_dy_pc       =   1'b0;
    end
   // B_Branch jump and jump , flush 108 
   else if(true_branch_Haz == 1'b1 && branch_sel_Dy_reg_Haz == 2'b01 && Dy_by_Btype == 1'b1 && BB_counter_Haz!=2'd2)begin
      pc_write        =   1'b1; 
      instr_flush     =   1'b0; 
      IF_ID_reg_write =   1'b1; 
      ctrl_sig_flush  =   1'b1; // any diff????
      fix_dy_pc       =   1'b0;
   end
   // B_Branch not jump but jump
    else if(true_branch_Haz == 1'b1 && branch_sel_Dy_reg_Haz == 2'b00 && Dy_by_Btype == 1'b1 )begin //&& BB_counter_Haz!=2'd2
      pc_write        =   1'b1; 
      instr_flush     =   1'b1; // flush 10c
      IF_ID_reg_write =   1'b1; 
      ctrl_sig_flush  =   1'b1; // flush 108
      fix_dy_pc       =   1'b0;
    end
   // B_Brancn not jump and not jump
    else if(true_branch_Haz == 1'b0 && branch_sel_Dy_reg_Haz == 2'b00 && Dy_by_Btype == 1'b1 )begin //&& BB_counter_Haz!=2'd2
      pc_write        =   1'b1; 
      instr_flush     =   1'b0; 
      IF_ID_reg_write =   1'b1; 
      ctrl_sig_flush  =   1'b0; 
      fix_dy_pc       =   1'b0;
    end
    //To fix
    // else if(fix_signal_dynamic)begin
    //     pc_write        =   1'b1; // 
    //     instr_flush     =   1'b0;
    //     IF_ID_reg_write =   1'b1;
    //     ctrl_sig_flush  =   1'b1;
    //     fix_dy_pc       =   1'b1;
    // end
    // j & jalr
    else if(branch_sel[1:0] == 2'b01 || branch_sel[1:0] == 2'b10)begin
        pc_write        =   1'b1; // 
        instr_flush     =   1'b1;
        IF_ID_reg_write =   1'b1;
        ctrl_sig_flush  =   1'b1;
        fix_dy_pc       =   1'b0;
    end
    
    else if(EXE_read && ((EXE_rd_addr == ID_rs1_addr) || (EXE_rd_addr == ID_rs2_addr)))begin // lw-use
        pc_write        =   1'b0; // stop the pc
        instr_flush     =   1'b0; 
        IF_ID_reg_write =   1'b0; //active low? no is active high
        ctrl_sig_flush  =   1'b1;
        fix_dy_pc       =   1'b0;
              
    end

    else begin
        pc_write        =   1'b1;
        instr_flush     =   1'b0;
        IF_ID_reg_write =   1'b1; // wrong
        ctrl_sig_flush  =   1'b0;
        fix_dy_pc       =   1'b0;
    end

  end  
endmodule