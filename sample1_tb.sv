module sample1_tb ();
    
    parameter N = 32;
    logic clk;
    logic rst_n;
    logic in_valid;
    logic in_ready;
    logic [N-1:0] in_data;
    logic out_valid;
    logic out_ready;
    logic [N-1:0] out_data;

    sample1 uut(
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        in_valid = 0;
        in_ready = 0;
        in_data = 0;

        #20 rst_n = 1;

        // Case 1
        #10 in_valid = 1;
        #10 in_ready = 1;
        #10 in_data = 32'hABCDEF00;
        #10 in_valid = 0;

        #20;

        // Case 2
        #10 in_valid = 1;
        in_data = 32'h01234567;
        #10 in_data = 32'h76543210;
        #10 in_valid = 0;

        #20;

        $finish;
    end

    initial begin
        $monitor("Time: %0t , in_valid: %b , in_ready: %b , in_data: %h , out_valid: %b , out_ready: %b , out_data: %h",  $time, in_valid, in_ready, in_data, out_valid, out_ready, out_data);
    end
endmodule