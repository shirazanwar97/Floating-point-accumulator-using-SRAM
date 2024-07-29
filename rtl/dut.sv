
//---------------------------------------------------------------------------
// DUT 
//---------------------------------------------------------------------------
module MyDesign(
//---------------------------------------------------------------------------
//System signals
  input wire reset_n                      ,  
  input wire clk                          ,

//---------------------------------------------------------------------------
//Control signals
  input wire dut_valid                    , 
  output wire dut_ready                   ,

//---------------------------------------------------------------------------
//q_state_output SRAM interface
  output wire         sram_write_enable  ,
  output wire [15:0]  sram_write_address ,
  output wire [31:0]  sram_write_data    ,
  output wire [15:0]  sram_read_address  , 
  input  wire [31:0]  sram_read_data     

);

	//Parameters
	localparam S0  = 4'b0000;
	localparam S1  = 4'b0001;
	localparam S2  = 4'b0010;
	localparam S3  = 4'b0011;
	localparam S4  = 4'b0100;
	localparam S5  = 4'b0101;
	localparam S6  = 4'b0110;
	localparam S7  = 4'b0111;
	localparam S8  = 4'b1000;
	localparam S9  = 4'b1001;
	
//---------------------------------------------------------------------------
//q_state_output SRAM interface
  reg        sram_write_enable_r  ;
  reg [15:0] sram_write_address_r ;
  reg [31:0] sram_write_data_r    ;
  reg [15:0] sram_read_address_r  ; 
  reg compute_complete;

  reg [31:0] sizeCount ;
  reg [31:0] Ain;
  reg [31:0] Accumulator;
  reg [3:0]	current_state;	//FSM current state
  reg [3:0]	next_state;	//FSM next state
  reg [1:0] sizeCountSel;
  reg [1:0] readAddrSel;
  reg A_enable;
  reg dut_ready_r;
  reg [1:0] Accumulate_sel;
  wire writeSelect;
// This is test sub for the DW_fp_add, do not change any of the inputs to the
// param list for the DW_fp_add, you will only need one DW_fp_add

// synopsys translate_off
  shortreal test_val;
  assign test_val = $bitstoshortreal(sum_r); 
  // This is a helper val for seeing the 32bit flaot value, you can repicate 
  // this for any signal, but keep it between the translate_off and
  // translate_on 
// synopsys translate_on

  wire  [31:0] sum_w;
  reg   [31:0] sum_r;
  reg  [31:0] in;
  wire  [7:0] status;

  DW_fp_add  #(
    .sig_width        (23),
    .exp_width        (8),
    .ieee_compliance  (3)
  ) fp_add_mod (
    .a                (Ain), 
    .b                (Accumulator), 
    .rnd              (3'd0), 
    .z                (sum_w), 
    .status           (status));

always@(posedge clk or negedge reset_n)
  if (!reset_n)   current_state <= S0;
  else  current_state <= next_state;

assign dut_ready = dut_ready_r;
assign writeSelect = compute_complete;
assign sram_write_enable = sram_write_enable_r;
assign sram_write_address = sram_write_address_r;
assign sram_write_data    = sram_write_data_r;
assign sram_read_address   = sram_read_address_r;

always@(*)
	begin
		casex (current_state)
			S0 : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b10;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				if (dut_valid == 1'b1)
					next_state = S1;
				else
					next_state = S0;
			end
			S1 : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b00;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				next_state = S2;
			end
			S2 : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b01;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				next_state = S3;
			end
			S3 : begin
				sizeCountSel = 2'b00;
				readAddrSel = 2'b01;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				next_state = S4;
			end
			S4 : begin
				sizeCountSel = 2'b01;
				readAddrSel = 2'b01;
				A_enable = 1'b1;
				Accumulate_sel = 2'b00;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				next_state = S5;
			end
			S5 : begin
				sizeCountSel = 2'b01;
				readAddrSel = 2'b01;
				A_enable = 1'b1;
				Accumulate_sel = 2'b01;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				if(sizeCount == 32'b11)
					next_state = S6;
				else
					next_state = S5;
			end
			S6 : begin
				sizeCountSel = 2'b01;
				readAddrSel = 2'b10;
				A_enable = 1'b1;
				Accumulate_sel = 2'b01;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				if(sizeCount == 32'b01)
					next_state = S7;
				else
					next_state = S6;
			end
			S7 : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b10;
				A_enable = 1'b0;
				Accumulate_sel = 2'b01;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
				next_state 	= S8;
			end			
			S8 : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b10;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b0;
				compute_complete = 1'b1;
				next_state 	= S9;
			end
			S9 : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b10;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b1;
				compute_complete = 1'b0;
				next_state 	= S0;
			end
			default : begin
				sizeCountSel = 2'b10;
				readAddrSel = 2'b10;
				A_enable = 1'b0;
				Accumulate_sel = 2'b10;
				dut_ready_r = 1'b0;
				compute_complete = 1'b0;
			end
		endcase
	end
	
	//Data Path
	
	//Size count register
	always @(posedge clk) begin
		if (sizeCountSel == 2'b0)
			sizeCount <= sram_read_data;
		else if (sizeCountSel == 2'b01)
			sizeCount <= sizeCount - 32'b1;
		else if (sizeCountSel == 2'b10)
			sizeCount <= sizeCount;
	end	
	
	//A register
	always @(posedge clk) begin
		if (A_enable == 1'b0) begin
			Ain <= 4'b0;
		end
		else if (A_enable == 1'b1) begin
			Ain <= sram_read_data[31:0];
		end
	end
	
	//Accumulator register
	always @(posedge clk) begin
		if (Accumulate_sel == 2'b0)
			Accumulator <= 32'b0;
		else if (Accumulate_sel == 2'b01)
			Accumulator <= sum_w;
		else if (Accumulate_sel == 2'b10)
			Accumulator <= Accumulator;
	end
	
	//Read address register
	always @(posedge clk) begin
		if (readAddrSel == 2'b0)
			sram_read_address_r <= 32'b0;
		else if (readAddrSel == 2'b01)
			sram_read_address_r <= sram_read_address_r + 32'b1;
		else if (readAddrSel == 2'b10)
			sram_read_address_r <= sram_read_address_r;
	end

//Write_enable
	always @(posedge clk) begin
		if(writeSelect == 1'b0)
			sram_write_enable_r <= 0;
		else
			sram_write_enable_r <= 1;
	end

//Write_address			
	always @(posedge clk) begin
		if(writeSelect == 1'b0)
			sram_write_address_r <= 0;
		else
			sram_write_address_r <= sram_read_address_r + 32'b1;
	end

//Write_data
	always @(posedge clk) begin
		if(writeSelect == 1'b0)
			sram_write_data_r <= 0;
		else
			sram_write_data_r <= Accumulator;			
	end
endmodule
