`timescale 1ns/1ps

// ============================================================
// TOP MODULE
// ============================================================

module dual_address_rom_system #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,

    input  [ADDR_WIDTH-1:0] addr_a,
    input  [ADDR_WIDTH-1:0] addr_b,

    output [DATA_WIDTH-1:0] out_a,
    output [DATA_WIDTH-1:0] out_b
);

wire [DATA_WIDTH-1:0] rom_data_a;
wire [DATA_WIDTH-1:0] rom_data_b;

wire [DATA_WIDTH-1:0] pipe_data_a;
wire [DATA_WIDTH-1:0] pipe_data_b;

wire [ADDR_WIDTH-1:0] pipe_addr_a;
wire [ADDR_WIDTH-1:0] pipe_addr_b;


// ============================================================
// ROM
// ============================================================

dual_port_rom #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) rom_inst (
    .clk(clk),

    .addr_a(addr_a),
    .addr_b(addr_b),

    .data_a(rom_data_a),
    .data_b(rom_data_b)
);


// ============================================================
// PIPELINE STAGE
// ============================================================

pipeline_registers #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) pipe_inst (

    .clk(clk),
    .rst(rst),

    .addr_a_in(addr_a),
    .addr_b_in(addr_b),

    .data_a_in(rom_data_a),
    .data_b_in(rom_data_b),

    .addr_a_out(pipe_addr_a),
    .addr_b_out(pipe_addr_b),

    .data_a_out(pipe_data_a),
    .data_b_out(pipe_data_b)
);


// ============================================================
// ARBITRATION
// ============================================================

data_arbitration #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) arb_inst (

    .addr_a(pipe_addr_a),
    .addr_b(pipe_addr_b),

    .data_a(pipe_data_a),
    .data_b(pipe_data_b),

    .out_a(out_a),
    .out_b(out_b)
);

endmodule



// ============================================================
// DUAL PORT ROM
// ============================================================

module dual_port_rom #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8
)(
    input clk,

    input  [ADDR_WIDTH-1:0] addr_a,
    input  [ADDR_WIDTH-1:0] addr_b,

    output reg [DATA_WIDTH-1:0] data_a,
    output reg [DATA_WIDTH-1:0] data_b
);

reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

initial begin

    $readmemh("rom_project.memh", mem);

    $display("ROM MEMORY LOADED");

    $display("mem[0] = %h", mem[0]);
    $display("mem[1] = %h", mem[1]);
    $display("mem[2] = %h", mem[2]);

end


always @(posedge clk) begin

    data_a <= mem[addr_a];
    data_b <= mem[addr_b];

end

endmodule



// ============================================================
// PIPELINE REGISTERS
// ============================================================

module pipeline_registers #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,

    input  [ADDR_WIDTH-1:0] addr_a_in,
    input  [ADDR_WIDTH-1:0] addr_b_in,

    input  [DATA_WIDTH-1:0] data_a_in,
    input  [DATA_WIDTH-1:0] data_b_in,

    output reg [ADDR_WIDTH-1:0] addr_a_out,
    output reg [ADDR_WIDTH-1:0] addr_b_out,

    output reg [DATA_WIDTH-1:0] data_a_out,
    output reg [DATA_WIDTH-1:0] data_b_out
);

always @(posedge clk or posedge rst) begin

    if (rst) begin

        addr_a_out <= 0;
        addr_b_out <= 0;

        data_a_out <= 0;
        data_b_out <= 0;

    end

    else begin

        addr_a_out <= addr_a_in;
        addr_b_out <= addr_b_in;

        data_a_out <= data_a_in;
        data_b_out <= data_b_in;

    end

end

endmodule



// ============================================================
// DATA ARBITRATION
// ============================================================

module data_arbitration #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8
)(
    input [ADDR_WIDTH-1:0] addr_a,
    input [ADDR_WIDTH-1:0] addr_b,

    input [DATA_WIDTH-1:0] data_a,
    input [DATA_WIDTH-1:0] data_b,

    output reg [DATA_WIDTH-1:0] out_a,
    output reg [DATA_WIDTH-1:0] out_b
);

always @(*) begin

    // SAME ADDRESS ACCESS
    if (addr_a == addr_b) begin

        out_a = data_a;
        out_b = data_a;

    end

    // DIFFERENT ADDRESS ACCESS
    else begin

        out_a = data_a;
        out_b = data_b;

    end

end

endmodule
