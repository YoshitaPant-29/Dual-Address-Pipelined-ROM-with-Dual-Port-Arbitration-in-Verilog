`timescale 1ns/1ps

module tb_dual_address_rom;

parameter ADDR_WIDTH = 6;
parameter DATA_WIDTH = 8;

reg clk;
reg rst;

reg [ADDR_WIDTH-1:0] addr_a;
reg [ADDR_WIDTH-1:0] addr_b;

wire [DATA_WIDTH-1:0] out_a;
wire [DATA_WIDTH-1:0] out_b;

integer i;


// ============================================================
// DUT
// ============================================================

dual_address_rom_system #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) dut (

    .clk(clk),
    .rst(rst),

    .addr_a(addr_a),
    .addr_b(addr_b),

    .out_a(out_a),
    .out_b(out_b)
);


// ============================================================
// CLOCK
// ============================================================

always #5 clk = ~clk;


// ============================================================
// TEST
// ============================================================

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, tb_dual_address_rom);

    clk = 0;
    rst = 1;

    addr_a = 0;
    addr_b = 0;

    #20;
    rst = 0;


    // ========================================================
    // SAME ADDRESS ACCESS
    // ========================================================

    $display("\n========== SAME ADDRESS ACCESS ==========\n");

    for (i = 0; i < 10; i = i + 1) begin

        @(posedge clk);

        addr_a = i;
        addr_b = i;

        @(posedge clk);

        $display("TIME=%0t ADDR_A=%0d DATA_A=%h(%c) | ADDR_B=%0d DATA_B=%h(%c)",
                 $time,
                 addr_a, out_a, out_a,
                 addr_b, out_b, out_b);

    end


    // ========================================================
    // DIFFERENT ADDRESS ACCESS
    // ========================================================

    $display("\n========== DIFFERENT ADDRESS ACCESS ==========\n");

    for (i = 0; i < 20; i = i + 1) begin

        @(posedge clk);

        addr_a = i;
        addr_b = i + 1;

        @(posedge clk);

        $display("TIME=%0t ADDR_A=%0d DATA_A=%h(%c) | ADDR_B=%0d DATA_B=%h(%c)",
                 $time,
                 addr_a, out_a, out_a,
                 addr_b, out_b, out_b);

    end


    // ========================================================
    // FORWARD / BACKWARD ACCESS
    // ========================================================

    $display("\n========== FORWARD / BACKWARD ACCESS ==========\n");

    for (i = 0; i < 20; i = i + 1) begin

        @(posedge clk);

        addr_a = i;
        addr_b = 63 - i;

        @(posedge clk);

        $display("TIME=%0t ADDR_A=%0d DATA_A=%h(%c) | ADDR_B=%0d DATA_B=%h(%c)",
                 $time,
                 addr_a, out_a, out_a,
                 addr_b, out_b, out_b);

    end

    #20;
    $finish;

end

endmodule
